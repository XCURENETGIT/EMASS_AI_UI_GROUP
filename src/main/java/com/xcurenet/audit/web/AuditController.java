package com.xcurenet.audit.web;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.*;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import lombok.extern.log4j.Log4j2;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Log4j2
@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.AUDIT_LOG)
public class AuditController {

	@Resource(name = "auditService")
	public AuditService auditService;

	@RequestMapping(value = "/getAuditList.xcn")
	@Description("감사로그 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getAuditList(final HttpServletRequest request, final HttpSession session) throws Exception {
		List<AuditVO> result = auditService.getAuditList(Common.getParamMap(request));
		long count = auditService.getAuditListCount(Common.getParamMap(request));
		return new XcnResponseVO(XcnRspCode.OK, result, count);
	}

	@RequestMapping(value = "/insertAudit.xcn")
	@Description("감사로그 등록")
	@ResponseBody
	public XcnResponseVO insertAudit(final HttpServletRequest request, AuditVO audit) throws Exception {
		if( Common.isEmpty(audit.getAdminId()) ){
			AdminVO admin = Common.getAdmin(request);
			audit.setAdminId(admin.getAdminId());
			audit.setAdminName(admin.getAdminName());
			audit.setAdminIp(admin.getLoginIp());
		}
		return new XcnResponseVO(XcnRspCode.OK, auditService.insertAudit(audit));
	}

	@RequestMapping(value = "/insertAuditListPrint.xcn")
	@Description("인쇄용 감사로그")
	@ResponseBody
	public XcnResponseVO insertAuditListPrint(final HttpServletRequest request, AuditRequestVO auditVo) throws Exception {
		auditVo.setOperation("PRINT");
		auditVo.setInformation(Prop.propFormat("common.msg.print", request));
		return new XcnResponseVO(XcnRspCode.OK, auditService.insertAudit(request, auditVo));
	}

	public static String splitStrReduce(String str){
		return Common.splitStrReduce(str, ",", 3);
	}
}
