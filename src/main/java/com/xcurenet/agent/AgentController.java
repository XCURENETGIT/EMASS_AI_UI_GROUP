package com.xcurenet.agent;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.mail.MailSend;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Description;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
@RequiredArgsConstructor
public class AgentController {
	private final AgentService service;
	private final SimpMessagingTemplate template;

	@Value("${agent.install.html.path:/users/emassai/conf/agent_install.html}")
	private String agentInstallHtmlPath;

	@Value("${agent.install.file.path:/users/emassai/conf/XCNAgent.zip}")
	private String agentInstallFilePath;


	@Scheduled(fixedDelay = 30000, initialDelay = 2000)
	private void scheduleScan() {
		if (Config.getBoolean("agent.mode")) {
			List<StatusInfo> offLines = service.getOffLineAgent();
			if (!offLines.isEmpty()) template.convertAndSend("/topic/agentOff", offLines);

			service.statusChange();
		}
	}

	@GetMapping(value = "/agent/agentService.do")
	@Description("Agent 모니터링 대상 설정")
	public String agentConsumer() {
		return "/agent/agentService";
	}

	@RequestMapping(value = "/agent/agentStatus.do", method = RequestMethod.GET)
	@Description("Agent 상태 조회")
	public String agentStatus() {
		return "/agent/agentStatus";
	}

	@GetMapping(value = "/agent/agentConfig.do")
	@Description("Agent 설정")
	public String agentConfig() {
		return "/agent/agentConfig";
	}

	/**
	 * Agent 인증 정보(Email)로 UI_USER_EMAIL 사용자 정보 탐색
	 *
	 * @param info 인증 정보
	 * @return UserID
	 */
	private String getAgentUserByEmail(final AuthInfo info) {
		if (info.getAuthEmail() == null || info.getAgentId() == null) return null;
		return service.getUserIdByEmail(info);
	}

	@GetMapping(value = "/agent/authentication")
	@Description("Agent 호출 > Agent 최초 인증")
	public ResponseEntity<Object> authentication(final HttpServletRequest request, @RequestHeader(value = "Auth-Email", required = false) String authEmail, @RequestHeader(value = "AgentId", required = false) String agentId) {
		if (authEmail == null || agentId == null) return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();

		AuthInfo info = new AuthInfo();
		info.setAgentId(agentId);
		info.setAuthEmail(authEmail);
		info.setUserId(getAgentUserByEmail(info));
		if (info.getUserId() == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

		final StatusInfo statusInfo = getStatusInfo(request, info);
		service.updateAgentStatus(statusInfo);
		return ResponseEntity.ok().build();
	}

	@RequestMapping(value = "/agent/status")
	@Description("Agent 호출 > Agent 상태 확인")
	@ResponseBody
	public ResponseEntity<Object> status(final HttpServletRequest request, @RequestHeader(value = "AgentId", required = false) String agentId) {
		if (agentId == null) return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
		AuthInfo info = getAuthInfo(agentId);
		if (info.getUserId() == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

		final StatusInfo statusInfo = getStatusInfo(request, info);
		service.updateAgentStatus(statusInfo);
		return ResponseEntity.ok().build();
	}

	@GetMapping(value = "/agent/{agentId}/xcurenet.pac", produces = "text/javascript")
	@Description("Agent 호출 > Agent PAC 파일 조회")
	public ResponseEntity<String> getPac(@PathVariable String agentId) {
		Map<String, Object> proxyURL = service.getProxyURL();
		if (proxyURL == null) return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "text/javascript").body(defaultPac());

		final String proxyHost = proxyURL.get("host").toString() + ":" + proxyURL.get("port").toString();
		StringBuilder pac = new StringBuilder();
		header(pac, proxyHost);
		List<String> hosts = service.getProxyHosts();
		for (String host : hosts) {
			appendRule(pac, host);
		}
		tail(pac);
		return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "text/javascript").body(pac.toString());
	}

	@GetMapping(path = "/agent/policy", produces = MediaType.APPLICATION_JSON_VALUE)
	@Description("Agent 호출 > Agent 정책 설정 내용 조회")
	public ResponseEntity<ObjectNode> getClientPolicy(@RequestHeader(value = "AgentId", required = false) String agentId) {
		if (agentId == null) return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
		AuthInfo info = getAuthInfo(agentId);

		if (info.getUserId() == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		return ResponseEntity.ok(service.convertPolicyListToJson(service.getPolicyList(agentId)));
	}

	@RequestMapping(value = "/sendInstallMail.xcn")
	@Description("Agent 설치 요청 메일")
	@ResponseBody
	public XcnResponseVO sendInstallMail(final HttpServletRequest request) throws Exception {
		final String email = Common.nvl(Common.getParam(request).get("email"));
		MailInfo info = new MailInfo();
		info.setFromName("XCURENET");
		info.setFrom(Config.getString("system.mail.addr"));
		info.setTo(new String[]{email});
		info.setSubject("\uD83D\uDD10 보안 Agent 설치 요청 – 지금 설치하고 내부 위협을 차단하세요!");
		info.setBody(getBodyMessage());
		info.setAttachPath(new String[]{agentInstallFilePath});
		new MailSend(info).send();
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/agentDownload.xcn")
	@Description("Agent 실행 파일 다운 로드")
	public void agentDownload(final HttpServletResponse response) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");
		response.setHeader("Content-Disposition", "attachment; filename=XCNAgent.zip");
		try (FileInputStream in = new FileInputStream(agentInstallFilePath)) {
			IOUtils.copyLarge(in, response.getOutputStream());
			response.flushBuffer();
		}
		response.setStatus(HttpServletResponse.SC_OK);
	}

	@RequestMapping(value = "/getAgentStatusSummary.xcn")
	@Description("Agent 상태 요약 정보")
	@ResponseBody
	public XcnResponseVO getAgentStatusSummary() {
		return new XcnResponseVO(XcnRspCode.OK, service.getAgentStatusSummary());
	}

	@RequestMapping(value = "/getAgentStatus.xcn")
	@Description("Agent 상태 목록")
	@ResponseBody
	public XcnResponseVO getAgentStatus(final StatusInfo info) {
		return new XcnResponseVO(XcnRspCode.OK, service.getAgentStatus(info));
	}

	@RequestMapping(value = "/saveAgentConfig.xcn")
	@Description("Agent 설정 저장")
	@ResponseBody
	public XcnResponseVO saveAgentConfig(final HttpServletRequest request) {
		final String agentId = Common.nvl(Common.getParam(request).get("agentId"));
		final String logLevel = Common.nvl(Common.getParam(request).get("logLevel"));
		final String clipboardEnabled = Common.nvl(Common.getParam(request).get("clipboardEnabled"));
		final String clipboardMode = Common.nvl(Common.getParam(request).get("clipboardMode"));
		final String usbEnabled = Common.nvl(Common.getParam(request).get("usbEnabled"));
		final String usbAllowedDevices = Common.nvl(Common.getParam(request).get("usbAllowedDevices"));
		service.updatePolicy(new PolicyInfo(agentId, "agent.logLevel", logLevel));
		service.updatePolicy(new PolicyInfo(agentId, "clipboard.enabled", clipboardEnabled));
		service.updatePolicy(new PolicyInfo(agentId, "clipboard.mode", clipboardMode));
		service.updatePolicy(new PolicyInfo(agentId, "usb.enabled", usbEnabled));
		service.updatePolicy(new PolicyInfo(agentId, "usb.allowedDevices", usbAllowedDevices));
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/saveAgentDefaultConfig.xcn")
	@Description("Agent 설정 저장")
	@ResponseBody
	public XcnResponseVO saveAgentDefaultConfig(final PolicyInfo policyInfo) {
		service.updatePolicy(policyInfo);
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/getAgentService.xcn")
	@Description("Agent 데이터 로깅 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getAgentService(final HttpServletRequest request) {
		return new XcnResponseVO(XcnRspCode.OK, service.getAgentService(Common.getParam(request)));
	}

	@RequestMapping(value = "/applyAgentService.xcn")
	@Description("Agent 데이터 로깅 서비스 적용")
	@ResponseBody
	public XcnResponseVO applyAgentService(final HttpServletRequest request) {
		JSONObject param = Common.getParam(request);
		JSONArray serviceLogging = Common.toJSONArray(param.get("serviceLogging"));
		for (int i = 0; i < serviceLogging.size(); i++) {
			service.applyAgentService(serviceLogging.getJSONObject(i));
		}
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/initAgentDefaultPolicy.xcn")
	@Description("Agent 데이터 로깅 서비스 적용")
	@ResponseBody
	public XcnResponseVO initAgentDefaultPolicy() {
		service.initAgentDefaultPolicy();
		return new XcnResponseVO(XcnRspCode.OK);
	}


	@RequestMapping(value = "/getPolicyList.xcn")
	@Description("Agent 개별 설정 정보 조회")
	@ResponseBody
	public XcnResponseVO getPolicyList(final HttpServletRequest request) {
		final String agentId = Common.nvl(Common.getParam(request).get("agentId"));
		return new XcnResponseVO(XcnRspCode.OK, service.getPolicyList(agentId));
	}

	@RequestMapping(value = "/getDefaultPolicy.xcn")
	@Description("Agent 기본 설정 정보 조회")
	@ResponseBody
	public XcnResponseVO getDefaultPolicy(final HttpServletRequest request) {
		final String searchStr = Common.nvl(Common.getParam(request).get("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, service.getDefaultPolicy(searchStr));
	}

	@NotNull
	private AuthInfo getAuthInfo(String agentId) {
		AuthInfo info = new AuthInfo();
		info.setAgentId(agentId);
		info.setUserId(service.getUserIdByAgentId(info));
		return info;
	}

	@NotNull
	private StatusInfo getStatusInfo(HttpServletRequest request, AuthInfo info) {
		final StatusInfo statusInfo = new StatusInfo();
		statusInfo.setAgentId(info.getAgentId());
		statusInfo.setClientIp(request.getRemoteAddr());
		statusInfo.setUserId(info.getUserId());
		return statusInfo;
	}

	public String getBodyMessage() {
		try {
			return FileUtils.readFileToString(new File(agentInstallHtmlPath), StandardCharsets.UTF_8);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}


	private String defaultPac() {
		return "function FindProxyForURL(url, host) { return \"DIRECT\";} ";
	}

	private static void header(final StringBuilder pac, String proxyUrl) {
		pac.append("function FindProxyForURL(url, host) {").append("\n");
		pac.append("\tlet proxy = \"PROXY ").append(proxyUrl).append("; DIRECT\";").append("\n");
	}

	private static void appendRule(final StringBuilder pac, final String host) {
		pac.append("\tif(shExpMatch(host, \"").append(host).append("\")) return proxy;").append("\n");
	}

	private static void tail(final StringBuilder pac) {
		pac.append("\treturn \"DIRECT\";").append("\n");
		pac.append("}").append("\n");
	}
}
