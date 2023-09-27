package com.xcurenet.interestUser.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.user.service.UserVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class InterestUserControllerLog {

	@Autowired
	private AuditService auditService;
	
	public void getInterestList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userType = Common.nvl(param.get("userType"));
		String searchType = Common.nvl(param.get("searchType"));
		String searchStr = Common.nvl(param.get("searchStr"));
		//String log = Common.nvl(param.get("log"));
		
		//if( Common.isNotEmpty(log)){
			if(Common.isEquals(userType,"")) userType = Prop.propFormat("common.msg.all");
			else if(Common.isEquals(userType,"E")) userType = Prop.propFormat("interest.user.exist");
			else if(Common.isEquals(userType,"I")) userType = Prop.propFormat("interest.registered.admin");
			if(Common.isEquals(searchType,"all")) searchType = Prop.propFormat("common.msg.all");
			else if(Common.isEquals(searchType,"userNm")) searchType = Prop.propFormat("common.msg.name");
			else if(Common.isEquals(searchType,"userId")) searchType = Prop.propFormat("common.msg.id");
			String information = "";
	
			information += "["+Prop.propFormat("common.msg.search")+"]";
			
			if(Common.isNotEmpty(userType)) information += "┌"+Prop.propFormat("interest.type.user")+": " + userType;
			if(Common.isNotEmpty(searchType)) information += "┌"+Prop.propFormat("condition.field.search")+": " + searchType;
			if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
	
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		//}
	}
	public void insertInterestMultiUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONArray userList = Common.toJSONArray( request.getParameter("userList"));
		String userType = request.getParameter("userType");
		
		for (int i = 0; i < userList.size(); i++) {
		
			UserVO vo = (UserVO) JSONObject.toBean(userList.getJSONObject(i), UserVO.class);
			
			if(Common.isEquals(userType,"E")) userType = Prop.propFormat("interest.user.exist");
			else if(Common.isEquals(userType,"I")) userType = Prop.propFormat("interest.registered.admin");
			String userId = Common.nvl(vo.getUserId());
			String userNm = Common.nvl(vo.getUserNm());
			String userIp = Common.nvl(vo.getUserIp());
			String userEmail = Common.nvl(vo.getUserEmail());
			String comment = Common.nvl(Prop.propFormat("common.org.dept") + ":" + vo.getDeptNm() + ", " + Prop.propFormat("common.org.jikgub") + ":" + vo.getJikgubNm());
			
			String information = "";

			information += "["+Prop.propFormat("common.msg.add")+"]";
			information += "┌"+Prop.propFormat("interest.type.user")+": " + userType;
			if(Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
			information += "┌"+Prop.propFormat("common.msg.name")+": " + userNm;
			information += "┌IP: " + userIp;
			information += "┌E-Mail: " + userEmail;
			if(Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.comment")+": " + comment;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void insertInterestUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userType = Common.nvl(param.get("userType"));
		if(Common.isEquals(userType,"E")) userType = Prop.propFormat("interest.user.exist");
		else if(Common.isEquals(userType,"I")) userType = Prop.propFormat("interest.registered.admin");
		String userId = Common.nvl(param.get("userId"));
		String userNm = Common.nvl(param.get("userNm"));
		String userIp = Common.nvl(param.get("userIp"));
		String userEmail = Common.nvl(param.get("userEmail"));
		String comment = Common.nvl(param.get("comment"));
		
		String information = "";

		information += "["+Prop.propFormat("common.msg.add")+"]";
		information += "┌"+Prop.propFormat("interest.type.user")+": " + userType;
		if(Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
		information += "┌"+Prop.propFormat("common.msg.name")+": " + userNm;
		information += "┌IP: " + userIp;
		information += "┌E-Mail: " + userEmail;
		if(Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.comment")+": " + comment;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateInterestUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String userType = Common.nvl(param.get("userType"));
		if(Common.isEquals(userType,"E")) userType = Prop.propFormat("interest.user.exist");
		else if(Common.isEquals(userType,"I")) userType = Prop.propFormat("interest.registered.admin");
		String userId = Common.nvl(param.get("userId"));
		String userNm = Common.nvl(param.get("userNm"));
		String userIp = Common.nvl(param.get("userIp"));
		String userEmail = Common.nvl(param.get("userEmail"));
		String comment = Common.nvl(param.get("comment"));
		
		String information = "";

		information += "["+Prop.propFormat("common.msg.modify")+"]";
		information += "┌"+Prop.propFormat("interest.type.user")+": " + userType;
		if(Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
		information += "┌"+Prop.propFormat("common.msg.name")+": " + userNm;
		information += "┌IP: " + userIp;
		information += "┌E-Mail: " + userEmail;
		if(Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.comment")+": " + comment;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
		
	}
	
	public void deleteInterestUser(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			String userType = Common.nvl(obj.get("userType"));
			if(Common.isEquals(userType,"E")) userType = Prop.propFormat("interest.user.exist");
			else if(Common.isEquals(userType,"I")) userType = Prop.propFormat("interest.registered.admin");
			String userId = Common.nvl(obj.get("userId"));
			String userNm = Common.nvl(obj.get("userNm"));
			String userIp = Common.nvl(obj.get("userIp"));
			String userEmail = Common.nvl(obj.get("userEmail"));
			String comment = Common.nvl(obj.get("comment"));
			
			String information = "";

			information += "["+Prop.propFormat("common.msg.delete")+"]";
			information += "┌"+Prop.propFormat("interest.type.user")+": " + userType;
			if(Common.isNotEmpty(userId)) information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
			information += "┌"+Prop.propFormat("common.msg.name")+": " + userNm;
			information += "┌IP: " + userIp;
			information += "┌E-Mail: " + userEmail;
			if(Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.comment")+": " + comment;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
}
