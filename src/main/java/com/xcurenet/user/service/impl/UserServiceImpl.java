package com.xcurenet.user.service.impl;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.code.service.*;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.user.service.UserGroupVO;
import com.xcurenet.user.service.UserService;
import com.xcurenet.user.service.UserVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.snmp4j.User;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service("userService")
public class UserServiceImpl extends XcnAbstractDAO implements UserService {

	@Override
	public List<Map<String, String>> getUserIds() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserIds", param);
	}

	@Override
	public List<Map<String, String>> getUserNames() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserNames", param);
	}
	
	@Override
	public List<Map<String, String>> getUserCoNms() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserCoNms", param);
	}

	@Override
	public List<Map<String, String>> getUserBusiNms() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserBusiNms", param);
	}

	@Override
	public List<Map<String, String>> getUserDepts() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserDepts", param);
	}
	
	@Override
	public List<Map<String, String>> getUserJikgubs() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserJikgubs", param);
	}
	
	@Override
	public List<Map<String, String>> getUserEmails() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserEmails", param);
	}
	
	@Override
	public List<Map<String, String>> getUserNamebyEmail() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserNamebyEmail", param);
	}
	
	@Override
	public AdminVO getAdminAuthCoBusi(final String adminId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		//return (AdminVO) selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminAuthCoBusiDept", param);
		return (AdminVO) selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminAuthCoBusi", param);
	}

	@Override
	public List<UserVO> getAllUserList(final String adminId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		param.put("adminId", adminId);
		
		AdminVO admin = getAdminAuthCoBusi(adminId);
		param.put("authCocd", admin.getAuthCocd());
		param.put("authBusi", admin.getAuthBusi());
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserList", param);
	}

	@Override
	public List<UserVO> getUserList(final String adminId, final String userType, final String searchType, final String searchStr, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userType", userType);
		param.put("searchType", searchType);
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		param.put("adminId", adminId);
		
		AdminVO admin = getAdminAuthCoBusi(adminId);
		param.put("authCocd", admin.getAuthCocd());
		param.put("authBusi", admin.getAuthBusi());
		//param.put("authDept", admin.getAuthDept()); // 부서 조회권한
		
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}

		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserList", param);
	}

	@Override
	public int updateUser(final UserVO user) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			deleteUserEmail(user);
			deleteUserIp(user);
			insertUserEmail(user);
			insertUserIp(user);
			result = update("com.xcurenet.sqlmap.mappers.mysql.user.updateUser", user);
			if(user.getCeo().equals("Y")) result = insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUserCeo", user);
			else delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserCeo", user);

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int insertUser(final UserVO user) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			deleteUserEmail(user);
			deleteUserIp(user);
			insertUserEmail(user);
			insertUserIp(user);
			result = insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUser", user);
			if(user.getCeo().equals("Y")) result = insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUserCeo", user);

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public boolean isUserIdExist(final UserVO user) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.user.isUserIdExist", user) > 0) return true;
		return false;
	}

	@Override
	public int insertUserIp(final UserVO user) {
		int result = 0;
		final String userId = user.getUserId();
		final String[] userIps = Common.trimAll(Common.nvl(user.getUserIp())).split(",");
		for (String userIp : userIps) {
			if (Common.isEmpty(userIp.trim())) continue;
			UserVO vo = new UserVO();
			vo.setUserId(userId);
			vo.setUserIp(userIp);
			result += insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUserIp", vo);
		}
		return result;
	}

	@Override
	public int insertUserEmail(final UserVO user) {
		int result = 0;
		final String userId = user.getUserId();
		final String[] userEmails = Common.trimAll(Common.nvl(user.getUserEmail())).split(",");
		
		String encryptUserYN = Config.getString("private.encrypt.useYN");
		String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
		String encryptSize = Config.getString("private.encrypt.size");
		String encryptKey = Config.getString("private.encrypt.key");
		
		for (String userEmail : userEmails) {
			if (Common.isEmpty(userEmail.trim())) continue;
			UserVO vo = new UserVO();
			vo.setUserId(userId);
			vo.setUserEmail(userEmail);
			
			if(Common.isEquals(encryptUserYN, "Y")){
				vo.setEncryptUseYN(encryptUserYN);
				vo.setEncryptAlgorithm(encryptAlgorithm);
				vo.setEncryptSize(encryptSize);
				vo.setEncryptKey(encryptKey);
			}
			
			result += insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUserEmail", vo);
		}
		return result;
	}

	@Override
	public int deleteUserGroupWithDelUser(final UserVO user) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserGroupWithDelUser", user);
	}
	
	@Override
	public int updateAdminUserGroupList( ) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.user.updateAdminUserGroupList", "");
	}
	
	@Override
	public int deleteUserIp(final UserVO user) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserIp", user);
	}

	@Override
	public int deleteUserEmail(final UserVO user) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserEmail", user);
	}

	@Override
	public int updateUserCo(CoVO co) {
		return update("com.xcurenet.sqlmap.mappers.mysql.user.updateUserCo", co);
	}

	@Override
	public int deleteUser(final UserVO user) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			deleteUserEmail(user);
			deleteUserIp(user);
			result = delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUser", user);
			result = delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserCeo", user);
			deleteUserGroupWithDelUser(user);
			updateAdminUserGroupList();

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public boolean scheduleUser(List<UserVO> users, List<CoVO> cos, List<GeneralVO> generals, List<BusiVO> busis, List<DeptVO> depts, List<JikgubVO> jikgubs, List<JikinVO> jikins) {
		boolean result = false;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			TimeUtil.start();
			delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteAllUserEmails", null);
			delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteAllUserIps", null);
			delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteAllUsers", null);
			log.info("[USER INSA LOAD] delete all user info time:{}", TimeUtil.print());

			TimeUtil.start();
			for (CoVO vo : cos) {
				insert("com.xcurenet.sqlmap.mappers.mysql.code.insertCo", vo);
			}
			log.info("[USER INSA LOAD] insert coCd time:{}", TimeUtil.print());

			TimeUtil.start();
			for (GeneralVO vo : generals) {
				insert("com.xcurenet.sqlmap.mappers.mysql.code.insertGeneral", vo);
			}
			log.info("[USER INSA LOAD] insert generals time:{}", TimeUtil.print());

			TimeUtil.start();
			for (BusiVO vo : busis) {
				insert("com.xcurenet.sqlmap.mappers.mysql.code.insertBusi", vo);
			}
			log.info("[USER INSA LOAD] insert busis time:{}", TimeUtil.print());

			TimeUtil.start();
			for (DeptVO vo : depts) {
				insert("com.xcurenet.sqlmap.mappers.mysql.code.insertDept", vo);
			}
			log.info("[USER INSA LOAD] insert depts time:{}", TimeUtil.print());

			TimeUtil.start();
			for (JikgubVO vo : jikgubs) {
				insert("com.xcurenet.sqlmap.mappers.mysql.code.insertJikgub", vo);
			}
			log.info("[USER INSA LOAD] insert jikgubs time:{}", TimeUtil.print());

			TimeUtil.start();
			for (JikinVO vo : jikins) {
				insert("com.xcurenet.sqlmap.mappers.mysql.code.insertJikin", vo);
			}
			log.info("[USER INSA LOAD] insert jikins time:{}", TimeUtil.print());

			TimeUtil.start();
			for (UserVO user : users) {
				insertUserEmail(user);
				insertUserIp(user);
				insert("com.xcurenet.sqlmap.mappers.mysql.user.replaceUser", user);
			}
			tx.commit();
			log.info("[USER INSA LOAD] insert user time:{}", TimeUtil.print());

			result = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserGroupByInsaAuto", null);
			tx.end();
		}
		return result;
	}
	
	public List<UserGroupVO> getUserGroupList(final String searchStr, final String adminId, final String adminType) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		if(Common.isEquals("C", adminType)) {
			param.put("ceoReadAuth", adminId);
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserGroupList", param);
	}
	
	@Override
	public boolean isUserGroupExist(final UserGroupVO userGroup) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.user.isUserGroupExist", userGroup) > 0) return true;
		return false;
	}
	
	@Override
	public int insertUserGroup(final UserGroupVO userGroup) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUserGroup", userGroup);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public int updateUserGroup(final UserGroupVO userGroup) {
		return update("com.xcurenet.sqlmap.mappers.mysql.user.updateUserGroup", userGroup);
	}
	
	@Override
	public int deleteUserGroup(HttpServletRequest request) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			JSONArray delData = Common.toJSONArray( request.getParameter("delData"));
			for (int i = 0; i < delData.size(); i++) {
				UserGroupVO delGroup = (UserGroupVO) JSONObject.toBean(delData.getJSONObject(i), UserGroupVO.class);
				
				delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserGroupItem", delGroup);
				delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserGroup", delGroup);
				result++;
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	public List<UserGroupVO> getUserGroupItemList(final String groupCode, final String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupCode", groupCode);
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserGroupItemList", param);
	}
	public List<UserGroupVO> getUserGroupUserList(final String groupCodes) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupCodes", groupCodes);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getUserGroupUserList", param);
	}
	
	@Override
	public String isUserGroupItemExist(HttpServletRequest request) {
		String rtnStr = "";
		
		JSONArray addList = Common.toJSONArray( request.getParameter("addData"));
		for (int i = 0; i < addList.size(); i++) {
			UserGroupVO addUser = (UserGroupVO) JSONObject.toBean(addList.getJSONObject(i), UserGroupVO.class);
			
			addUser.setGroupCode(request.getParameter("groupCode"));
			if((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.user.isUserGroupItemExist", addUser) > 0) {
				if (rtnStr.equals("")) {
					rtnStr = addUser.getUserNm() + "(" + addUser.getDeptNm() + ")";
				} else {
					rtnStr = rtnStr + " ," + addUser.getUserNm() + "(" + addUser.getDeptNm() + ")";
				}
			}
		}
		return rtnStr;
	}
	
	public int insertUserGroupItem(HttpServletRequest request) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			JSONArray addList = Common.toJSONArray( request.getParameter("addData"));
			for (int i = 0; i < addList.size(); i++) {
				UserGroupVO addUser = (UserGroupVO) JSONObject.toBean(addList.getJSONObject(i), UserGroupVO.class);
				
				addUser.setGroupCode(request.getParameter("groupCode"));
				
				insert("com.xcurenet.sqlmap.mappers.mysql.user.insertUserGroupItem", addUser);
				result++;
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public int deleteUserGroupItem(HttpServletRequest request) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			JSONArray delData = Common.toJSONArray( request.getParameter("delData"));
			for (int i = 0; i < delData.size(); i++) {
				UserGroupVO delGroup = (UserGroupVO) JSONObject.toBean(delData.getJSONObject(i), UserGroupVO.class);
				
				delete("com.xcurenet.sqlmap.mappers.mysql.user.deleteUserGroupItem", delGroup);
				result++;
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public String getBusiNmByIpRange(UserVO user) {
		UserVO result = selectOne("com.xcurenet.sqlmap.mappers.mysql.user.getBusiNmByIpRange", user);
		if(Common.isNotEmpty(result)) return Common.nvl(result.getBusiNm());
		else return "";
	}
	
	@Override
	public String getDeptNmByIpRange(UserVO user) {
		UserVO result = selectOne("com.xcurenet.sqlmap.mappers.mysql.user.getDeptNmByIpRange", user);
		if(Common.isNotEmpty(result)) return Common.nvl(result.getDeptNm());
		else return "";
	}
	
	@Override
	public List<UserGroupVO> getConUserGroupList(String itemList) {
		Map<String, Object> param = new HashMap<>();
		param.put("itemList", itemList);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.user.getConUserGroupList", param);
	}

}
