package com.xcurenet.user.log;


import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class UserControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	
	public void getUserList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String logYn = Common.nvl(param.get("logYn"));
		
		if(Common.isNotEquals(logYn, "N")) {
			String userTypeNm = Common.nvl(param.get("userTypeNm"));
			String searchTypeNm = Common.nvl(param.get("searchTypeNm"));
			String searchStr = Common.nvl(param.get("searchStr"));
			String information = "["+Prop.propFormat("common.msg.search")+"]";
			information += "";
			if(Common.isNotEmpty(userTypeNm)) information += "┌"+Prop.propFormat("interest.type.user")+": " + userTypeNm;
			if(Common.isNotEmpty(searchTypeNm)) information += "┌"+Prop.propFormat("java.log.type.search")+": " + searchTypeNm;
			if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	public void insertUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userId = Common.nvl(param.get("userId"));
		String userNm = Common.nvl(param.get("userNm"));
		String coNm = Common.nvl(param.get("coNm"));
		String generalNm = Common.nvl(param.get("generalNm"));
		String busiNm = Common.nvl(param.get("busiNm"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String jikgubNm = Common.nvl(param.get("jikgubNm"));
		String jikinNm = Common.nvl(param.get("jikinNm"));
		String ceoNm = Common.nvl(param.get("ceoNm"));
		String userIp = Common.nvl(param.get("userIp"));
		String userEmail = Common.nvl(param.get("userEmail"));
		String AllLog ="┌"+Prop.propFormat("common.msg.id")+": "+userId +"┌"+Prop.propFormat("common.msg.name")+": "+userNm +"┌"+Prop.propFormat("common.org.conm")+": "+coNm+"┌"+Prop.propFormat("common.org.generalnm")+": "+generalNm+"┌"+Prop.propFormat("common.org.businm")+": "+busiNm+"┌"+Prop.propFormat("common.org.deptnm")+": "+deptNm+"┌"+Prop.propFormat("common.org.jikgubnm")+": "+jikgubNm+"┌"+Prop.propFormat("common.org.jikinnm")+": "+jikinNm+"┌"+Prop.propFormat("java.log.type.user")+": "+ceoNm+"┌IP: "+userIp+"┌E-Mail: "+userEmail;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userId = Common.nvl(param.get("userId"));
		String userNm = Common.nvl(param.get("userNm"));
		String coNm = Common.nvl(param.get("coNm"));
		String generalNm = Common.nvl(param.get("generalNm"));
		String busiNm = Common.nvl(param.get("busiNm"));
		String deptNm = Common.nvl(param.get("deptNm"));
		String jikgubNm = Common.nvl(param.get("jikgubNm"));
		String jikinNm = Common.nvl(param.get("jikinNm"));
		String ceoNm = Common.nvl(param.get("ceoNm"));
		String userIp = Common.nvl(param.get("userIp"));
		String userEmail = Common.nvl(param.get("userEmail"));
		String AllLog ="┌"+Prop.propFormat("common.msg.id")+": "+userId +"┌"+Prop.propFormat("common.msg.name")+": "+userNm +"┌"+Prop.propFormat("common.org.conm")+": "+coNm+"┌"+Prop.propFormat("common.org.generalnm")+": "+generalNm+"┌"+Prop.propFormat("common.org.businm")+": "+busiNm+"┌"+Prop.propFormat("common.org.deptnm")+": "+deptNm+"┌"+Prop.propFormat("common.org.jikgubnm")+": "+jikgubNm+"┌"+Prop.propFormat("common.org.jikinnm")+": "+jikinNm+"┌"+Prop.propFormat("java.log.type.user")+": "+ceoNm+"┌IP: "+userIp+"┌E-Mail: "+userEmail;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userId = Common.nvl(param.get("userId"));
		String userNm = Common.nvl(param.get("userNm"));
		String AllLog ="┌"+Prop.propFormat("common.msg.name")+": "+userNm +"┌"+Prop.propFormat("common.msg.id")+": "+userId;
		auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
		
	}
}
