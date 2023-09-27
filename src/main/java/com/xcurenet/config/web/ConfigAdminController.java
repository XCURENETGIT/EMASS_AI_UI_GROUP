package com.xcurenet.config.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.DEV_INFO)
public class ConfigAdminController {

	@Resource(name = "configAdminService")
	public ConfigAdminService configAdminService;

	@RequestMapping(value = "/getAdminConfList.xcn")
	@Description("운용자 환경 설정 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAdminConfList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		return new XcnResponseVO(XcnRspCode.OK, configAdminService.getAdminConfList(adminId));
	}

	@RequestMapping(value = "/getConfAdmin.xcn")
	@Description("운용자 환경 설정 리스트 조회")
	@ResponseBody
	public XcnResponseVO getConfAdmin(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String confId = Common.nvl(Common.getParam(request).get("confId"));
		return new XcnResponseVO(XcnRspCode.OK, configAdminService.getConfAdmin(confId, adminId));
	}

	@RequestMapping(value = "/setConfAdmin.xcn")
	@Description("운용자 환경 설정 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO setConfAdmin(ConfigAdminVO conf, final HttpServletRequest request) throws Exception {
		String adminId = Common.getAdminId(request);
		conf.setAdminId(adminId);
		return new XcnResponseVO(XcnRspCode.OK, configAdminService.setConfAdmin(conf));
	}
	
	@RequestMapping(value = "/getConfAdminOption.xcn")
	@Description("운용자 환경 설정 리스트 조회")
	@ResponseBody
	public XcnResponseVO getConfAdminOption(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		return new XcnResponseVO(XcnRspCode.OK, configAdminService.getConfAdminOption(adminId));
	}
	
	@RequestMapping(value = "/setConfAdminOption.xcn")
	@Description("운용자 환경 설정 리스트 조회")
	@ResponseBody
	public XcnResponseVO setConfAdminOption(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String confId = Common.nvl(Common.getParam(request).get("confId"));
		String val = Common.nvl(Common.getParam(request).get("val"));
		return new XcnResponseVO(XcnRspCode.OK, configAdminService.setConfAdminOption(confId, val, adminId));
	}
}
