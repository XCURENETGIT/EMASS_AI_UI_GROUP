package com.xcurenet.admin.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.web.AuditController;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class AdminControllerLog {

	@Autowired
	private AuditService auditService;

	public void insertAdmin(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String adminId = Common.nvl(param.get("adminId"));
		String adminName = Common.nvl(param.get("adminName"));
		String adminEmail = Common.nvl(param.get("adminEmail"));
		String adminHp = Common.nvl(param.get("adminHp"));
		String comment = Common.nvl(param.get("comment"));
		String adminTypeNm = Common.nvl(param.get("adminTypeNm"));
		String useYnNm = Common.nvl(param.get("useYnNm"));
		String workStatusNm = Common.nvl(param.get("workStatusNm"));
		String coText = Common.nvl(param.get("coText"));
		String busiText = Common.nvl(param.get("busiText"));
		String serviceText = Common.nvl(param.get("serviceText"));
		String regexpText = Common.nvl(param.get("regexpText"));
		String information = "["+Prop.propFormat("common.msg.add")+"]";
		information += "┌"+Prop.propFormat("common.msg.id")+": " + adminId;
		information += "┌"+Prop.propFormat("common.msg.name")+": " + adminName;
		information += "┌E-mail: " + adminEmail;
		information += "┌HP: " + adminHp;
		if (Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.use_purpose")+": " + comment;
		if (Common.isNotEmpty(adminTypeNm)) information += "┌"+Prop.propFormat("common.msg.type")+": " + adminTypeNm;
		information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYnNm;
		if (Common.isNotEmpty(workStatusNm)) information += "┌"+Prop.propFormat("common.msg.retirement")+"/"+Prop.propFormat("common.msg.leave")+": " + workStatusNm;
		if (Common.isNotEmpty(coText)) information += "┌"+Prop.propFormat("common.org.co")+": " + AuditController.splitStrReduce(coText);
		if (Common.isNotEmpty(busiText)) information += "┌"+Prop.propFormat("common.org.busi")+": " + AuditController.splitStrReduce(busiText);
		if (Common.isNotEmpty(serviceText)) information += "┌"+Prop.propFormat("filterInfo.servicetype")+": " + AuditController.splitStrReduce(serviceText);
		if (Common.isNotEmpty(regexpText)) information += "┌"+Prop.propFormat("common.msg.regexp")+": " + AuditController.splitStrReduce(regexpText);
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	public void updateAdmin(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String adminId = Common.nvl(param.get("adminId"));
		String adminName = Common.nvl(param.get("adminName"));
		String adminEmail = Common.nvl(param.get("adminEmail"));
		String adminHp = Common.nvl(param.get("adminHp"));
		String comment = Common.nvl(param.get("comment"));
		String adminTypeNm = Common.nvl(param.get("adminTypeNm"));
		String useYnNm = Common.nvl(param.get("useYnNm"));
		String workStatusNm = Common.nvl(param.get("workStatusNm"));
		String coText = Common.nvl(param.get("coText"));
		String busiText = Common.nvl(param.get("busiText"));
		String serviceText = Common.nvl(param.get("serviceText"));
		String regexpText = Common.nvl(param.get("regexpText"));
		String information = "["+Prop.propFormat("common.msg.modify")+"]";
		information += "┌"+Prop.propFormat("common.msg.id")+": " + adminId;
		information += "┌"+Prop.propFormat("common.msg.name")+": " + adminName;
		information += "┌E-mail: " + adminEmail;
		information += "┌HP: " + adminHp;
		if (Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.use_purpose")+": " + comment;
		if (Common.isNotEmpty(adminTypeNm)) information += "┌"+Prop.propFormat("common.msg.type")+": " + adminTypeNm;
		information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYnNm;
		if (Common.isNotEmpty(workStatusNm)) information += "┌"+Prop.propFormat("common.msg.retirement")+"/"+Prop.propFormat("common.msg.leave")+": " + workStatusNm;
		if (Common.isNotEmpty(coText)) information += "┌"+Prop.propFormat("common.org.co")+": " + AuditController.splitStrReduce(coText);
		if (Common.isNotEmpty(busiText)) information += "┌"+Prop.propFormat("common.org.busi")+": " + AuditController.splitStrReduce(busiText);
		if (Common.isNotEmpty(serviceText)) information += "┌"+Prop.propFormat("filterInfo.servicetype")+": " + AuditController.splitStrReduce(serviceText);
		if (Common.isNotEmpty(regexpText)) information += "┌"+Prop.propFormat("common.msg.regexp")+": " + AuditController.splitStrReduce(regexpText);
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
