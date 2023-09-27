package com.xcurenet.emass.consent.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class ConsentControllerLog {

	@Autowired
	private AuditService auditService;

	public void getConsentList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String typeStr = Common.nvl(param.get("typeStr"));
		String consentStatusStr = Common.nvl(param.get("consentStatusStr"));
		String information = "";

		information += "["+Prop.propFormat("common.msg.search")+"]";
		if (Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		if (Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		if (Common.isNotEmpty(typeStr)) information += "┌"+Prop.propFormat("consent.type.consent")+": " + typeStr;
		if (Common.isNotEmpty(consentStatusStr)) information += "┌"+Prop.propFormat("consent.status.approved")+": " + consentStatusStr;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertConsent(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String no = Common.nvl(param.get("no"));
		String purpose = Common.nvl(param.get("purpose"));
		String createId = Common.nvl(param.get("createId"));
		String name = Common.nvl(param.get("name"));
		String userIp = Common.nvl(param.get("userIp"));
		String createNm = Common.nvl(param.get("createNm"));
		String attach = Common.nvl(param.get("attach"));
		String type = Common.nvl(param.get("type"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String userId = Common.nvl(param.get("userId"));
		String edate = Common.nvl(param.get("edate"));
		if(Common.isEquals(type, "B")) type = Prop.propFormat("consent.informed.consent");
		else if(Common.isEquals(type, "A")) type = Prop.propFormat("consent.post.consent");
		else if(Common.isEquals(type, "M")) type = Prop.propFormat("consent.monitoring.consent");
		else if(Common.isEquals(type, "E")) type = Prop.propFormat("consent.retire.consent");
		String information = "";

		information += "["+Prop.propFormat("common.msg.add")+"]";
		if (Common.isNotEmpty(no)) information += "┌"+Prop.propFormat("consent.number.consent")+": " + no;
		if (Common.isNotEmpty(type)) information += "┌"+Prop.propFormat("consent.type.consent")+": " + type;
		if (Common.isNotEmpty(name)) information += "┌"+Prop.propFormat("consent.user")+": " + name;
		if (Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
		if (Common.isNotEmpty(deptNm)) information += "┌"+Prop.propFormat("common.org.deptnm")+": " + deptNm;
		if (Common.isNotEmpty(edate)) information += "┌"+Prop.propFormat("consent.expiration.date")+": " + edate;
		if (Common.isNotEmpty(userIp)) information += "┌IP: " + userIp;
		if (Common.isNotEmpty(attach)) information += "┌"+Prop.propFormat("consent.attach")+": " + attach;
		if (Common.isNotEmpty(createId)) information += "┌"+Prop.propFormat("consent.registrant")+"ID: " + createId;
		if (Common.isNotEmpty(createNm)) information += "┌"+Prop.propFormat("consent.registrant.name")+": " + createNm;
		if (Common.isNotEmpty(purpose)) information += "┌"+Prop.propFormat("consent.purpose.search")+": " + purpose;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateConsent(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String no = Common.nvl(param.get("no"));
		String purpose = Common.nvl(param.get("purpose"));
		String createId = Common.nvl(param.get("createId"));
		String name = Common.nvl(param.get("name"));
		String userIp = Common.nvl(param.get("userIp"));
		String createNm = Common.nvl(param.get("createNm"));
		String attach = Common.nvl(param.get("attach"));
		String type = Common.nvl(param.get("type"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String userId = Common.nvl(param.get("userId"));
		String edate = Common.nvl(param.get("edate"));
		if(Common.isEquals(type, "B")) type = Prop.propFormat("consent.informed.consent");
		else if(Common.isEquals(type, "A")) type = Prop.propFormat("consent.post.consent");
		else if(Common.isEquals(type, "M")) type = Prop.propFormat("consent.monitoring.consent");
		else if(Common.isEquals(type, "E")) type = Prop.propFormat("consent.retire.consent");
		String information = "";

		information += "["+Prop.propFormat("common.msg.modify")+"]";
		if (Common.isNotEmpty(no)) information += "┌"+Prop.propFormat("consent.number.consent")+": " + no;
		if (Common.isNotEmpty(type)) information += "┌"+Prop.propFormat("consent.type.consent")+": " + type;
		if (Common.isNotEmpty(name)) information += "┌"+Prop.propFormat("consent.user")+": " + name;
		if (Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
		if (Common.isNotEmpty(deptNm)) information += "┌"+Prop.propFormat("common.org.deptnm")+": " + deptNm;
		if (Common.isNotEmpty(edate)) information += "┌"+Prop.propFormat("consent.expiration.date")+": " + edate;
		if (Common.isNotEmpty(userIp)) information += "┌IP: " + userIp;
		if (Common.isNotEmpty(attach)) information += "┌"+Prop.propFormat("consent.attach")+": " + attach;
		if (Common.isNotEmpty(createId)) information += "┌"+Prop.propFormat("consent.registrant")+"ID: " + createId;
		if (Common.isNotEmpty(createNm)) information += "┌"+Prop.propFormat("consent.registrant.name")+": " + createNm;
		if (Common.isNotEmpty(purpose)) information += "┌"+Prop.propFormat("consent.purpose.search")+": " + purpose;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteConsent(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			String no = Common.nvl(obj.get("no"));
			String purpose = Common.nvl(obj.get("purpose"));
			String createId = Common.nvl(obj.get("createId"));
			String name = Common.nvl(obj.get("name"));
			String userIp = Common.nvl(obj.get("userIp"));
			String createNm = Common.nvl(obj.get("createNm"));
			String attach = Common.nvl(obj.get("attach"));
			String type = Common.nvl(obj.get("type"));
			String deptNm = Common.nvl(obj.get("deptNm"));
			String userId = Common.nvl(obj.get("userId"));
			String edate = Common.nvl(obj.get("edate"));
			if(Common.isEquals(type, "B")) type = Prop.propFormat("consent.informed.consent");
			else if(Common.isEquals(type, "A")) type = Prop.propFormat("consent.post.consent");
			else if(Common.isEquals(type, "M")) type = Prop.propFormat("consent.monitoring.consent");
			else if(Common.isEquals(type, "E")) type = Prop.propFormat("consent.retire.consent");
			String information = "";

			information += "["+Prop.propFormat("common.msg.delete")+"]";
			if (Common.isNotEmpty(no)) information += "┌"+Prop.propFormat("consent.number.consent")+": " + no;
			if (Common.isNotEmpty(type)) information += "┌"+Prop.propFormat("consent.type.consent")+": " + type;
			if (Common.isNotEmpty(name)) information += "┌"+Prop.propFormat("consent.user")+": " + name;
			if (Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
			if (Common.isNotEmpty(deptNm)) information += "┌"+Prop.propFormat("common.org.deptnm")+": " + deptNm;
			if (Common.isNotEmpty(edate)) information += "┌"+Prop.propFormat("consent.expiration.date")+": " + edate;
			if (Common.isNotEmpty(userIp)) information += "┌IP: " + userIp;
			if (Common.isNotEmpty(attach)) information += "┌"+Prop.propFormat("consent.attach")+": " + attach;
			if (Common.isNotEmpty(createId)) information += "┌"+Prop.propFormat("consent.registrant")+"ID: " + createId;
			if (Common.isNotEmpty(createNm)) information += "┌"+Prop.propFormat("consent.registrant.name")+": " + createNm;
			if (Common.isNotEmpty(purpose)) information += "┌"+Prop.propFormat("consent.purpose.search")+": " + purpose;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void updateApproval(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String no = Common.nvl(param.get("no"));
		String appCd = Common.nvl(param.get("appCd"));
		String information = "";
		
		if( Common.isEquals(appCd, "A") ) {
			auditVo.setOperation(Operation.APPROVE.getOperation());
			information += "["+Prop.propFormat("consent.approved")+"]";
		} else if ( Common.isEquals(appCd, "R") ) {
			auditVo.setOperation(Operation.RETURN.getOperation());
			information += "["+Prop.propFormat("consent.rejected")+"]";
		}
		else if( Common.isEquals(appCd, "C") ) {
			auditVo.setOperation(Operation.CANCEL.getOperation());
			information += "["+Prop.propFormat("consent.approved.canceled")+"]";
		}
		information += "┌"+Prop.propFormat("consent.number.consent")+": " + no;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
