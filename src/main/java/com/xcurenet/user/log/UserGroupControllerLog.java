package com.xcurenet.user.log;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.user.service.UserGroupVO;
import com.xcurenet.user.service.UserService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class UserGroupControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	@Resource(name = "userService")
	public UserService userService;
	
	public void getUserGroupList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String logYn = Common.nvl(param.get("logYn"));
		if(Common.isEquals(logYn, "Y")) return;
		
		String information = "[" + Prop.propFormat("userGroup.navi.title2") + " " + Prop.propFormat("common.msg.search")+"]";
		information += "";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertUserGroup(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String groupCode = Common.nvl(param.get("groupCode"));
		String groupName = Common.nvl(param.get("groupName"));
		
		String information = "";
		
		UserGroupVO group = new UserGroupVO();
		group.setGroupName(groupCode);
		if (!userService.isUserGroupExist(group)) {
			information += "[" + Prop.propFormat("userGroup.navi.title2") + " " + Prop.propFormat("common.msg.add")+"]";
			information += "┌"+Prop.propFormat("userGroup.groupcode")+": " + groupCode;
			information += "┌"+Prop.propFormat("userGroup.groupname")+": " + groupName;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void updateUserGroup(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String groupCode = Common.nvl(param.get("groupCode"));
		String groupName = Common.nvl(param.get("groupName"));
		
		String information = "[" + Prop.propFormat("userGroup.navi.title2") + " " + Prop.propFormat("common.msg.modify")+"]";
		
		information += "┌"+Prop.propFormat("userGroup.groupcode")+": " + groupCode;
		information += "┌"+Prop.propFormat("userGroup.groupname")+": " + groupName;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteUserGroup(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONArray delData = Common.toJSONArray( request.getParameter("delData"));
		
		for (int i = 0; i < delData.size(); i++) {
			UserGroupVO delGroup = (UserGroupVO) JSONObject.toBean(delData.getJSONObject(i), UserGroupVO.class);
			String information = "[" + Prop.propFormat("userGroup.navi.title2") + " " + Prop.propFormat("common.msg.delete")+"]";
			information += "┌"+Prop.propFormat("userGroup.groupcode")+": " + delGroup.getGroupCode();
			information += "┌"+Prop.propFormat("userGroup.groupname")+": " + delGroup.getGroupName();
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
	
	public void getUserGroupItemList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String groupCode = Common.nvl(param.get("groupCode"));
		String searchStr = Common.nvl(param.get("searchStr"));
		
		String information = "[" + Prop.propFormat("userGroup.user") + " " + Prop.propFormat("common.msg.search")+"]";
		information += "";
		information += "┌"+Prop.propFormat("userGroup.groupcode")+": " + groupCode;
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}	
	
	public void insertUserGroupItem(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONArray addList = Common.toJSONArray( request.getParameter("addData"));
		for (int i = 0; i < addList.size(); i++) {
			UserGroupVO addUser = (UserGroupVO) JSONObject.toBean(addList.getJSONObject(i), UserGroupVO.class);
			
			String userId = Common.nvl(addUser.getUserId());
			String userNm = Common.nvl(addUser.getUserNm());
			String userIp = Common.nvl(addUser.getUserIp());
			String userEmail = Common.nvl(addUser.getUserEmail());
			String comment = Common.nvl(Prop.propFormat("common.org.dept") + ":" + addUser.getDeptNm() + ", " + Prop.propFormat("common.org.jikgub") + ":" + addUser.getJikgubNm());
			
			String information = "";

			information += "[" + Prop.propFormat("userGroup.user") + " " + Prop.propFormat("common.msg.add")+"]";
			information += "┌"+Prop.propFormat("userGroup.groupcode")+": " + request.getParameter("groupCode");
			information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
			information += "┌"+Prop.propFormat("common.msg.name")+": " + userNm;
			information += "┌IP: " + userIp;
			information += "┌E-Mail: " + userEmail;
			if(Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.comment")+": " + comment;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}	
	
	public void deleteUserGroupItem(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONArray delData = Common.toJSONArray( request.getParameter("delData"));
		for (int i = 0; i < delData.size(); i++) {
			UserGroupVO delGroup = (UserGroupVO) JSONObject.toBean(delData.getJSONObject(i), UserGroupVO.class);
			
			String groupCode = Common.nvl(delGroup.getGroupCode());
			String userId = Common.nvl(delGroup.getUserId());
			String userNm = Common.nvl(delGroup.getUserNm());
			String userIp = Common.nvl(delGroup.getUserIp());
			String userEmail = Common.nvl(delGroup.getUserEmail());
			String comment = Common.nvl(Prop.propFormat("common.org.dept") + ":" + delGroup.getDeptNm() + ", " + Prop.propFormat("common.org.jikgub") + ":" + delGroup.getJikgubNm());
			
			String information = "[" + Prop.propFormat("userGroup.user") + " " + Prop.propFormat("common.msg.delete")+"]";
			information += "┌"+Prop.propFormat("userGroup.groupcode")+": " + groupCode;
			information += "┌"+Prop.propFormat("common.msg.id")+": " + userId;
			information += "┌"+Prop.propFormat("common.msg.name")+": " + userNm;
			information += "┌IP: " + userIp;
			information += "┌E-Mail: " + userEmail;
			if(Common.isNotEmpty(comment)) information += "┌"+Prop.propFormat("common.msg.comment")+": " + comment;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
}
