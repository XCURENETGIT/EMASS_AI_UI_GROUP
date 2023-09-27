package com.xcurenet.admin.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.ADMIN_MGMT)
public class AdminController {

	@Resource(name = "adminService")
	public AdminService adminService;
	@Resource(name = "auditService")
	public AuditService auditService;
	@RequestMapping(value = "/getAdminList.xcn")
	@Description("운용자 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAdminList(final HttpServletRequest request, final AdminVO adminVo) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String searchUseYn = Common.nvl(request.getParameter("searchUseYn"));

		String log = Common.nvl(request.getParameter("log"));

		List<AdminVO> result = adminService.getAdminList(adminVo);
		if( Common.isNotEmpty(log)){
			String information = "";
			String searchUseYnStr = "";
			if(Common.isEquals(searchUseYn,"")) searchUseYnStr = Prop.propFormat("common.msg.all");
			else if(Common.isEquals(searchUseYn,"Y")) searchUseYnStr = Prop.propFormat("common.msg.use");
			else if(Common.isEquals(searchUseYn,"N")) searchUseYnStr = Prop.propFormat("common.msg.unuse");

			information += "["+Prop.propFormat("common.msg.search", request)+"]";
			if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str", request)+": " + searchStr;
			if(Common.isNotEmpty(searchUseYn)) information += "┌"+Prop.propFormat("common.msg.useyn", request)+": " + searchUseYnStr;
			AdminVO admin = Common.getAdmin(request);
			AuditVO auditVo = new AuditVO();
			auditVo.setAdminId(admin.getAdminId());
			auditVo.setAdminName(admin.getAdminName());
			auditVo.setAdminIp(admin.getLoginIp());
			auditVo.setPMenuId(ParentMenu.OPERATION_MGMT.getParentMenuId());
			auditVo.setMenuId(Menu.ADMIN_MGMT.getMenuId());
			auditVo.setOperation(Operation.SEARCH.getOperation());
			auditVo.setInformation(information);
			auditService.insertAudit(auditVo);
		}
		return new XcnResponseVO(XcnRspCode.OK,result );
	}

	@RequestMapping(value = "/insertAdmin.xcn")
	@Description("운용자 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAdmin(final HttpServletRequest request, final AdminVO admin) throws Exception {
		if( adminService.isAdminIdExist(admin) ) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.account", request, admin.getAdminId()));
		else return new XcnResponseVO(XcnRspCode.OK, adminService.insertAdmin(admin));
	}

	@RequestMapping(value = "/updateAdmin.xcn")
	@Description("운용자 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateAdmin(final HttpServletRequest request, final AdminVO admin) throws Exception {
		admin.setAdminType(admin.getAdminTypeInfo());
		admin.setFirstAdminYn(Common.getAdmin(request).getFirstAdminYn());
		return new XcnResponseVO(XcnRspCode.OK, adminService.updateAdmin(admin));
	}

	@RequestMapping(value = "/updateAdminPassword.xcn")
	@Description("운용자 비밀번호 수정")
	@ResponseBody
	public XcnResponseVO updateAdminPassword(final HttpServletRequest request, final AdminVO admin) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, adminService.updateAdminPassword(admin));
	}


	@RequestMapping(value = "/updateAdminStatusOK.xcn")
	@Description("운용자 로그인 가능하도록 상태 업데이트")
	@ResponseBody
	public XcnResponseVO updateAdminStatusOK(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		String adminId = Common.nvl(param.get("adminId"));
		return new XcnResponseVO(XcnRspCode.OK, adminService.updateAdminStatusOK(adminId));
	}

//	@RequestMapping(value = "/restartTomcat.xcn")
//	@Description("최고관리자 최초접속시 운용자정보 및 DB정보 변경 후 edc 및 tomcat 재시작")
//	@ResponseBody
//	public void restratTomcat() throws Exception {
//		DbmsConf db = new DbmsConf();
//		db.restartTomcat();
//	}
	
	@RequestMapping(value = "/insertSystemIpMac.xcn")
	@Description("SYSTEM IP 등록")
	@ResponseBody
	public XcnResponseVO insertSystemIpMac(final HttpServletRequest request) throws Exception {
		String systemIp1 = Common.nvl(request.getParameter("systemIp1"));
		String systemIp2 = Common.nvl(request.getParameter("systemIp2"));
		return new XcnResponseVO(XcnRspCode.OK, adminService.insertSystemIpMac(systemIp1, systemIp2));
	}

	@RequestMapping(value = "/otpReset.xcn")
	@Description("운용자 구글 OTP 초기화")
	@ResponseBody
	public XcnResponseVO otpReset(final HttpServletRequest request, final AdminVO admin) throws Exception{
		adminService.deleteAdminGenerate(admin.getAdminId());
		return new XcnResponseVO(XcnRspCode.OK);

	}
}
