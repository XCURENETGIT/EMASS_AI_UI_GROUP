package com.xcurenet.interestUser.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import com.xcurenet.interestUser.service.AdminUserGroupVO;
import com.xcurenet.user.service.UserService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("adminUserGroupService")
public class AdminUserGroupServiceImpl extends XcnAbstractDAO implements AdminUserGroupService {
	
	@Autowired
	private UserService userService;

	@Override
	public List<AdminUserGroupVO> getAdminUserGroupList(final String searchStr, final String adminId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("adminId", adminId);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.getAdminUserGroupList", param);
	}

	@Override
	public boolean isAdminUserGroupExist(final AdminUserGroupVO userGroup) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.isAdminUserGroupExist", userGroup) > 0) return true;
		return false;
	}

	@Override
	public int insertAdminUserGroup(final AdminUserGroupVO userGroup) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.insertAdminUserGroup", userGroup);
	}

	@Override
	public int updateAdminUserGroup(final AdminUserGroupVO userGroup) {
		return update("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.updateAdminUserGroup", userGroup);
	}

	@Override
	public int deleteAdminUserGroup(HttpServletRequest request) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			JSONArray delData = Common.toJSONArray(request.getParameter("delData"));
			for (int i = 0; i < delData.size(); i++) {
				AdminUserGroupVO delGroup = (AdminUserGroupVO) JSONObject.toBean(delData.getJSONObject(i), AdminUserGroupVO.class);

				delete("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.deleteAdminUserGroupItem", delGroup);
				delete("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.deleteAdminUserGroup", delGroup);
				result++;
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public List<AdminUserGroupVO> getAdminUserGroupItemList(final String groupSeq, final String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", groupSeq);
		param.put("searchStr", searchStr);
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.getAdminUserGroupItemList", param);
	}
	
	@Override
	public List<AdminUserGroupVO> getAdminUserGroupSimpleList(final String groupSeq) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", groupSeq);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.getAdminUserGroupSimpleList", param);
	}
	
	@Override
	public List<AdminUserGroupVO> getAdminUserGroupSimpleAdminList(final String adminId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.getAdminUserGroupSimpleAdminList", param);
	}

	@Override
	public String isAdminUserGroupItemExist(HttpServletRequest request) {
		String rtnStr = "";
		JSONArray addList = Common.toJSONArray(request.getParameter("addData"));
		for (int i = 0; i < addList.size(); i++) {
			AdminUserGroupVO addUser = (AdminUserGroupVO) JSONObject.toBean(addList.getJSONObject(i), AdminUserGroupVO.class);
			addUser.setGroupSeq(request.getParameter("groupSeq"));
			if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.isAdminUserGroupItemExist", addUser) > 0) {
				if (rtnStr.equals("")) {
					rtnStr = addUser.getUserNm() + "(" + addUser.getUserId() + ")";
				} else {
					rtnStr = rtnStr + " ," + addUser.getUserNm() + "(" + addUser.getUserId() + ")";
				}
			}
		}
		return rtnStr;
	}

	public int insertAdminUserGroupItem(HttpServletRequest request) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			String groupSeq = request.getParameter("groupSeq");
			tx.start();
			JSONArray addList = Common.toJSONArray(request.getParameter("addData"));
			for (int i = 0; i < addList.size(); i++) {
				JSONObject item = addList.getJSONObject(i);
				
				AdminUserGroupVO addUser = new AdminUserGroupVO();
				addUser.setGroupSeq(groupSeq);
				addUser.setUserId(Common.nvl(item.get("userId")));
				
				if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.isAdminUserGroupItemExist", addUser) > 0) continue;
				if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.isAdminUserGroupItemReal", addUser) < 1) continue;
				
				insert("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.insertAdminUserGroupItem", addUser);
				result++;
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteAdminUserGroupItem(HttpServletRequest request) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			JSONArray delData = Common.toJSONArray(request.getParameter("delData"));
			for (int i = 0; i < delData.size(); i++) {
				JSONObject item = delData.getJSONObject(i);
				
				AdminUserGroupVO delGroup = new AdminUserGroupVO();
				delGroup.setGroupSeq(Common.nvl(item.get("groupSeq")));
				delGroup.setUserId(Common.nvl(item.get("userId")));
				delete("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.deleteAdminUserGroupItem", delGroup);
				result++;
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public JSONObject importAdminGroupUser(final String adminId, final String groupSeq, List<String> list) {
		for (int i = list.size()-1; i >= 0; i--) {
			if (list.get(i).trim().isEmpty()) list.remove(i);
		}
		
		JSONObject item = new JSONObject();
		if(list.size()==0) {
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.nocontent"));
			return item;
		}
		if(list.size() > 1000) {
			item.put("success", false);
			item.put("message", Prop.propFormat("userGroup.msg.user.max"));
			return item;
		}

		AdminVO admin = userService.getAdminAuthCoBusi(adminId);
		Map<String, Object> hmap = new HashMap<>();
		hmap.put("dbList", list);
		hmap.put("groupSeq", groupSeq);
		hmap.put("adminId", adminId);
		hmap.put("authCocd", admin.getAuthCocd());
		hmap.put("authBusi", admin.getAuthBusi());
		List<AdminUserGroupVO> users = selectList("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.getImportAuthUsers", hmap);
		if(users.size()==0) {
			item.put("success", false);
			item.put("message", Prop.propFormat("keyword.upload.nocontent"));
			return item;
		}
		
		AdminUserGroupVO vo = new AdminUserGroupVO();
		vo.setGroupSeq(groupSeq);
		int oldCnt = (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.isAdminUserGroupItemExist", vo);
		if (users.size() > 1000 || oldCnt + users.size() > 1000) {
			item.put("success", false);
			item.put("message", Prop.propFormat("userGroup.msg.user.max"));
			return item;
		}

		for (AdminUserGroupVO user : users) {
			user.setAdminId(adminId);
			user.setGroupSeq(groupSeq);
			update("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.replaceAdminUserGroupItem", user);
		}
		item.put("success", true);
		return item;
	}
	
	@Override
	public List<AdminUserGroupVO> getConAdminUserGroupList(final String itemList, final String adminId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("itemList", itemList);
		param.put("adminId", adminId);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminUserGroup.getConAdminUserGroupList", param);
	}
}






































