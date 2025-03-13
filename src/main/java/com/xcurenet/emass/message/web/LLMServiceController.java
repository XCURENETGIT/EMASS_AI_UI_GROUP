package com.xcurenet.emass.message.web;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.service.LLMService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Log4j2
@Controller
@RequiredArgsConstructor
public class LLMServiceController {

	private final LLMService llmService;

	@RequestMapping(value = "/getHostDescription.xcn")
	@Description("LLM 기반 URL 카테고리 및 설명")
	@ResponseBody
	public XcnResponseVO getHostDescription(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, llmService.getHostDescription(Common.nvl(request.getParameter("host"))));
	}

	@RequestMapping(value = "/getLLMAnalysis.xcn")
	@Description("LLM 내용 분석, 요약, 번역 등...")
	@ResponseBody
	public XcnResponseVO getLLMAnalysis(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		JSONObject param = Common.getParam(request);
		String chat = Common.nvl(param.get("chat"));
		String type = Common.nvl(param.get("type"));
		return new XcnResponseVO(XcnRspCode.OK, llmService.getLLMAnalysis(chat, type));
	}


}
