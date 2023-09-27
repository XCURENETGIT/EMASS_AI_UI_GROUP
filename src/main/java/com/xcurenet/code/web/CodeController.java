package com.xcurenet.code.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.code.service.CodeService;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
public class CodeController {

	@Resource(name = "codeService")
	public CodeService codeService;

	@RequestMapping(value = "/getCodeList.xcn")
	@Description("코드 리스트 조회")
	@ResponseBody
	public XcnResponseVO getCodeList(final HttpServletRequest request, CodeVO code) throws Exception {
		code.setAdminId(Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, codeService.getCodeList(code));
	}
	
	@RequestMapping(value = "/getCodeListAll.xcn")
	@Description("코드 리스트 조회")
	@ResponseBody
	public XcnResponseVO getCodeListAll(final HttpServletRequest request, CodeVO code) throws Exception {
		code.setAdminId(Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, codeService.getCodeListAll(code));
	}

	@RequestMapping(value = "/getAdminCodeList.xcn")
	@Description("운용자 코드 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAdminCodeList(final HttpServletRequest request, CodeVO code) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, codeService.getAdminCodeList(code));
	}

}
