package com.xcurenet.audit.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.AuditVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AuditController {

	@Resource(name = "auditService")
	public AuditService auditService;

	@Autowired
	private MongoTemplate mongoTemplate;

	@RequestMapping(value = "/getAuditList.xcn")
	@Description("감사로그 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAuditList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, auditService.getAuditList(Common.getParamMap(request)));
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
