package com.xcurenet.admin.service;

import java.util.List;
import java.util.Map;

public interface AdminService {

	public List<Map<String, Object>> getAdminHpByConfId(final String confId);

	public List<Map<String, Object>> getAdminNotifyByConfId(final String confId);

	public void insertAdminDashBoardConf(AdminVO admin);

	public List<AdminVO> getAdminList();
	
	public List<AdminVO> getAdminList(AdminVO admin);

	public void updateAdminStatus();

	public int updateAdminStatusOK(final String adminId);

	public AdminVO getAdmin(final String adminId);

	public int insertAdminMenu(AdminVO admin);

	public int insertAdmin(AdminVO admin);
	
	public int insertAdminCheck(AdminVO admin);

	public int updateAdmin(AdminVO admin);

	public int updateAdminPassword(AdminVO admin);

	public int updateUserPasswordWrongCount(AdminVO admin);

	public int updateAllUserPasswordWrongCount();

	public int updateUserLoginOK(AdminVO admin);

	public boolean isAdminIdExist(AdminVO admin);

	public List<AdminVO> getApprobatorList(AdminVO admin);

	public int updateAdminInfo(AdminVO admin) throws Exception;

	public List<AdminVO> getAllIpMacList();

	public int insertSystemIpMac(final String systemIp1, final String systemIp2);

	public String getAdminMenu(final String adminId);

	public List<Map<String, Object>> getAdminEmailByConfId(String confId);
	
	/**
	 * 구글 OTP 관련
	 * @param adminId
	 * @return
	 */
	public String getAdminGenerate(String adminId);
	
	public void insertAdminGenerate(String adminId, String adminGenerate);
	
	public void deleteAdminGenerate(String adminId);

	public int insertAdminMfa(AdminMfaVO adminMfaVO);

	AdminMfaVO getAdminMfa(AdminMfaVO adminMfaVO);

	void deleteAdminMfa(AdminMfaVO adminMfaVO);

	void deleteAdminMfaByReqId(AdminMfaVO adminMfaVO);

	void clearAdminMfa();
}
