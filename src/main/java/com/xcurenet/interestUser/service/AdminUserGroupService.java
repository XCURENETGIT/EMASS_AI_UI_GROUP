package com.xcurenet.interestUser.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

public interface AdminUserGroupService {

	public List<AdminUserGroupVO> getAdminUserGroupList(final String searchStr, final String adminId);

	public boolean isAdminUserGroupExist(final AdminUserGroupVO userGroup);

	public int insertAdminUserGroup(final AdminUserGroupVO userGroup);

	public int updateAdminUserGroup(final AdminUserGroupVO userGroup);

	public int deleteAdminUserGroup(HttpServletRequest request);

	public List<AdminUserGroupVO> getAdminUserGroupItemList(final String groupSeq, final String searchStr);
	
	public List<AdminUserGroupVO> getAdminUserGroupSimpleList(final String groupSeq);
	
	public List<AdminUserGroupVO> getAdminUserGroupSimpleAdminList(final String adminId);

	public String isAdminUserGroupItemExist(HttpServletRequest request);

	public int insertAdminUserGroupItem(HttpServletRequest request);

	public int deleteAdminUserGroupItem(HttpServletRequest request);
	
	public JSONObject importAdminGroupUser(final String adminId, final String groupSeq, List<String> list);
	
	public List<AdminUserGroupVO> getConAdminUserGroupList(final String itemList, final String adminId);
	
}
