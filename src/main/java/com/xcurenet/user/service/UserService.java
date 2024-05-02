package com.xcurenet.user.service;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.code.service.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface UserService {

	public List<Map<String, String>> getUserIds();

	public List<Map<String, String>> getUserNames();
	
	public List<Map<String, String>> getUserCoNms();

	public List<Map<String, String>> getUserBusiNms();
	
	public List<Map<String, String>> getUserDepts();
	
	public List<Map<String, String>> getUserJikgubs();
	
	public List<Map<String, String>> getUserEmails();
	
	public List<Map<String, String>> getUserNamebyEmail();

	public List<UserVO> getAllUserList(final String adminId);
	
	public AdminVO getAdminAuthCoBusi(final String adminId);

	public List<UserVO> getUserList(final String adminId, final String userType, final String searchType, final String searchStr, final int offset, final int limit);

	public boolean isUserIdExist(final UserVO user);

	public int updateUser(final UserVO user);

	public int insertUser(final UserVO user);

	public int insertUserIp(final UserVO user);

	public int insertUserEmail(final UserVO user);

	public int deleteUserGroupWithDelUser(final UserVO user);
	
	public int updateAdminUserGroupList( );
	
	public int deleteUserIp(final UserVO user);

	public int deleteUserEmail(final UserVO user);

	public int updateUserCo(final CoVO co);

	public int deleteUser(final UserVO user);

	public boolean scheduleUser(final List<UserVO> users, List<CoVO> cos, List<GeneralVO> generals, List<BusiVO> busis, List<DeptVO> depts, List<JikgubVO> jikgubs, List<JikinVO> jikins);
	
	public List<UserGroupVO> getUserGroupList(final String searchStr, String adminId, String adminType);	 
	
	public boolean isUserGroupExist(final UserGroupVO userGroup);
	
	public int insertUserGroup(final UserGroupVO userGroup);
	
	public int updateUserGroup(final UserGroupVO userGroup);
	
	public int deleteUserGroup(final HttpServletRequest request);
	
	public List<UserGroupVO> getUserGroupItemList(final String groupCode, final String searchStr);
	
	public List<UserGroupVO> getUserGroupUserList(final String groupCodes);
	
	public String isUserGroupItemExist(final HttpServletRequest request);
	
	public int insertUserGroupItem(final HttpServletRequest request);
	
	public int deleteUserGroupItem(final HttpServletRequest request);
	
	public String getBusiNmByIpRange(final UserVO user);
	
	public String getDeptNmByIpRange(final UserVO user);
	
	public List<UserGroupVO> getConUserGroupList(String itemList);

	/* 회사 코드맵핑정보 */
	public List<PersCodeInfo>  getCompInfo();
	/* 사업장 코드맵핑정보 */
	public List<PersCodeInfo>  getBusiInfo();
	/* 부서 코드맵핑정보 */
	public List<PersCodeInfo>  getDeptInfo();
	/* 직급 코드맵핑정보 */
	public List<PersCodeInfo>  getJikgubInfo();
	/* 서비스 코드맵핑정보 */
	public List<PersCodeInfo>  getServiceInfo();
	public UserVO getUseridbyEmailIp(String usrid);

	public int insertUserAccount(final UserVO user);

	public int deleteUserAccount(final UserVO user);

	public String getUserAccountInfo(final UserVO user);
	public String getUserAccountInfosvc12(final UserVO user);
	public String getUserAccountList(String sender,String svc12);

}
