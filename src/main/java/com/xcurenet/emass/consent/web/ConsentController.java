package com.xcurenet.emass.consent.web;

import java.beans.PropertyEditorSupport;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.consent.service.ConsentAlarm;
import com.xcurenet.emass.consent.service.ConsentSeqVO;
import com.xcurenet.emass.consent.service.ConsentService;
import com.xcurenet.emass.consent.service.ConsentVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@Slf4j
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.CONSENT_MGMT)
public class ConsentController {

	@Resource(name = "consentService")
	public ConsentService consentService;
	
	@Autowired
	public ConsentFileDownload consentFileDownload;
	
	@Autowired
	private ConsentAlarm consentAlarm;

	@RequestMapping(value = "/getConsentSeq.xcn")
	@Description("동의서 SEQ 조회")
	@ResponseBody
	public XcnResponseVO getConsentSeq(final HttpServletRequest request, final HttpSession session) throws Exception {
		ConsentSeqVO vo = consentService.getConsentSeq();
		consentService.insertConsentSeq(vo);

		return new XcnResponseVO(XcnRspCode.OK, vo);
	}
	
	@RequestMapping(value = "/getApprobator.xcn")
	@Description("승인권자 여부 조회")
	@ResponseBody
	public XcnResponseVO getApprobator(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		return new XcnResponseVO(XcnRspCode.OK, consentService.getApprobator(adminId));
	}

	@RequestMapping(value = "/deleteConsentSeq.xcn")
	@Description("동의서 SEQ 삭제")
	@ResponseBody
	public XcnResponseVO deleteConsentSeq(final HttpServletRequest request) throws Exception {
		String consentNo = Common.nvl(request.getParameter("consentNo"));
		String date = Common.nvl(consentNo.substring(0, 8));
		int no = Common.nvz(consentNo.substring(9, consentNo.length()));

		if (consentService.deleteConsentSeq(date, no) == 1) return new XcnResponseVO(XcnRspCode.OK);
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
	}

	@RequestMapping(value = "/getConsentList.xcn")
	@Description("동의서 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getConsentList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String type = Common.nvl(request.getParameter("type"));
		String consentStatus = Common.nvl(request.getParameter("consentStatus"));
		String createNm = Common.nvl(request.getParameter("createNm"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, consentService.getConsentList(startDate, endDate, type, consentStatus, createNm, searchStr, offset, limit));
	}
	
	@RequestMapping(value = "/getConsentSearchList.xcn")
	@Description("동의서 리스트 조회")
	@ResponseBody
	public XcnResponseVO getConsentSearchList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String type = Common.nvl(request.getParameter("type"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, consentService.getConsentSearchList(type, searchStr));
	}

	@InitBinder
	public void initBinder(WebDataBinder binder) throws Exception {
		binder.registerCustomEditor(MultipartFile.class, new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				log.info("initBinder MultipartFile.class: {}; set null;", text);
				setValue(null);
			}

		});
	}

	@RequestMapping(value = "/insertConsent.xcn", method = RequestMethod.POST)
	@Description("동의서 등록")
	@AuditOperation(Operation.INSERT)
	public void insertConsent(ConsentVO consent, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Content-Type", "application/json");
		JSONObject item = new JSONObject();
		PrintWriter pw = null;
		try {
			pw = new PrintWriter(response.getWriter());
			consentService.insertConsent(consent);
			item.put("success", true);
			if(Common.isEquals(consent.getAlarmYn(),"Y")) consentAlarm.sendConsentAlarm(consent,"I");
		} catch (Exception e) {
			e.printStackTrace();
			item.put("success", false);
			item.put("message", e.getMessage());
		} finally {
			pw.print(item);
			pw.flush();
			IOUtils.closeQuietly(pw);
		}
	}

	@RequestMapping(value = "/updateConsent.xcn")
	@Description("동의서 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateConsent(ConsentVO consent) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, consentService.updateConsent(consent));
	}

	@RequestMapping(value = "/deleteConsent.xcn")
	@Description("동의서 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteConsent(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<ConsentVO> consents = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			ConsentVO consent = (ConsentVO) JSONObject.toBean(data.getJSONObject(i), ConsentVO.class);
			consents.add(consent);
		}
		if (consentService.deleteConsent(consents) == 1) return new XcnResponseVO(XcnRspCode.OK);
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
	}

	@RequestMapping(value = "/updateApproval.xcn")
	@Description("승인처리")
	@AuditOperation(Operation.APPROVE)
	@ResponseBody
	public XcnResponseVO updateApproval(ConsentVO consent) throws Exception {
		if(Common.isEquals(consent.getAlarmYn(),"Y")) consentAlarm.sendConsentAlarm(consent, "A");
		return new XcnResponseVO(XcnRspCode.OK, consentService.updateApproval(consent));
	}

	@RequestMapping(value = "/downloadConsentFile.do")
	@Description("동의서 파일 다운로드 페이지")
	public void downloadConsentFile(final ConsentVO consent, final HttpServletResponse response) throws Exception {
		ConsentVO fileInfo = consentService.getConsentFileInfo(consent);
		ConsentFileVO attach = new ConsentFileVO();
		if (fileInfo != null) {
			attach.setFileName(fileInfo.getFileName());
			attach.setFilePath(fileInfo.getFilePath());
		}
		consentFileDownload.download(attach, response);
	}
}
