package com.xcurenet.admin.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.xcurenet.admin.service.AdminMfaVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.customDashboard.service.CustomDashBoardService;
import com.xcurenet.emass.customDashboard.service.CustomDashboardMenuVO;

@Service("adminService")
public class AdminServiceImpl extends XcnAbstractDAO implements AdminService {

	@Autowired
	public CustomDashBoardService customDashBoardService;

	@Override
	public List<AdminVO> getAdminList() {
		return getAdminList(new AdminVO());
	}

	@Override
	public List<AdminVO> getAdminList(AdminVO admin) {
		String encryptUserYN = Config.getString("private.encrypt.useYN");
		String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
		String encryptSize = Config.getString("private.encrypt.size");
		String encryptKey = Config.getString("private.encrypt.key");
		if(Common.isEquals(encryptUserYN, "Y")){
			admin.setEncryptUseYN(encryptUserYN);
			admin.setEncryptAlgorithm(encryptAlgorithm);
			admin.setEncryptSize(encryptSize);
			admin.setEncryptKey(encryptKey);
		}

		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminList", admin);
	}


	@Override
	public int updateAdminStatusOK(final String adminId) {
		return update("com.xcurenet.sqlmap.mappers.mysql.admin.updateAdminStatusOK", adminId);
	}

	@Override
	public void updateAdminStatus() {
		update("com.xcurenet.sqlmap.mappers.mysql.admin.updateAdminStatus", Config.getString("long.term.unused", "60"));
	}

	@Override
	public void insertAdminDashBoardConf(AdminVO admin){
		insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminDashBoardConf", admin);
	}

	private CustomDashboardMenuVO getCustomMenuVo(AdminVO admin) {
		CustomDashboardMenuVO vo = new CustomDashboardMenuVO();
		vo.setAdminId(admin.getAdminId());
		vo.setDefaultMenu("Y");
		vo.setMenuIcon("fa fa-th");
		vo.setMenuName("Default Dashboard");
		vo.setUseYn("Y");
		return vo;
	}

	@Override
	public int insertAdmin(AdminVO admin) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			String encryptUserYN = Config.getString("private.encrypt.useYN");
			String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
			String encryptSize = Config.getString("private.encrypt.size");
			String encryptKey = Config.getString("private.encrypt.key");
			if(Common.isEquals(encryptUserYN, "Y")){
				admin.setEncryptUseYN(encryptUserYN);
				admin.setEncryptAlgorithm(encryptAlgorithm);
				admin.setEncryptSize(encryptSize);
				admin.setEncryptKey(encryptKey);
			}
			result = insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdmin", admin);

			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminAccessIp", admin);
			final String[] accessIps = Common.trimAll(Common.nvl(admin.getAccessIp())).split(",");
			for (String ip : accessIps) {
				if (Common.isEmpty(ip.trim())) continue;
				AdminVO vo = new AdminVO();
				vo.setAdminId(admin.getAdminId());
				vo.setAccessIp(ip);
				insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminAccessIp", vo);
			}

			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminCo", admin);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminBusi", admin);
			//insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminDept", admin); // 부서 조회권한
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminSvc", admin);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminPattern", admin);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminCeoAuth", admin);
			CustomDashboardMenuVO customDashboardMenuVO = getCustomMenuVo(admin);
			customDashboardMenuVO.setDefaultDashboard("Y");
			customDashBoardService.saveDashBoardMenu(customDashboardMenuVO);
			insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContentDefault", admin);

			customDashboardMenuVO = getAiDashboard(admin);
			customDashBoardService.saveDashBoardMenu(customDashboardMenuVO);
			//insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardPositionDefault", admin);

			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminMenu", admin);
			final String[] authIds = Common.trimAll(Common.nvl(admin.getMenu())).split(",");
			for (String authId : authIds) {
				if (Common.isEmpty(authId.trim())) continue;
				AdminVO vo = new AdminVO();
				vo.setAdminId(admin.getAdminId());
				vo.setMenu(authId);
				insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminMenu", vo);
			}
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminDashBoardConf", admin);
//			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminDashBoardConf", admin.getOldId());
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminDashBoardConf", admin);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	private CustomDashboardMenuVO getAiDashboard(AdminVO admin) {
		CustomDashboardMenuVO vo = new CustomDashboardMenuVO();
		vo.setAdminId(admin.getAdminId());
		vo.setDefaultMenu("N");
		vo.setMenuIcon("fa fa-laptop");
		vo.setMenuName("AI Dashboard");
		vo.setDefaultDashboard("I");
		vo.setUseYn("Y");
		return vo;
	}

	@Override
	public int insertAdminCheck(AdminVO admin) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			if((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminDashBoardConfCnt", admin) == 0){
				customDashBoardService.saveDashBoardMenu(getCustomMenuVo(admin));
				insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContentDefault", admin);
				insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminDashBoardConf", admin);
			}

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int insertAdminMenu(AdminVO admin) {
		final String[] authIds = Common.trimAll(Common.nvl(admin.getMenu())).split(",");
		for (String authId : authIds) {
			if (Common.isEmpty(authId.trim())) continue;
			AdminVO vo = new AdminVO();
			vo.setAdminId(admin.getAdminId());
			vo.setMenu(authId);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminMenu", vo);
		}
		return 0;
	}

	@Override
	public int updateAdmin(AdminVO admin) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			String encryptUserYN = Config.getString("private.encrypt.useYN");
			String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
			String encryptSize = Config.getString("private.encrypt.size");
			String encryptKey = Config.getString("private.encrypt.key");
			if(Common.isEquals(encryptUserYN, "Y")){
				admin.setEncryptUseYN(encryptUserYN);
				admin.setEncryptAlgorithm(encryptAlgorithm);
				admin.setEncryptSize(encryptSize);
				admin.setEncryptKey(encryptKey);
			}


			AdminVO old = selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdmin", admin);
			if (Common.isEquals(old.getAdminPw(), admin.getAdminPw())) {
				admin.setAdminPw(null);
			}
			result = update("com.xcurenet.sqlmap.mappers.mysql.admin.updateAdmin", admin);

			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminAccessIp", admin);
			final String[] accessIps = Common.trimAll(Common.nvl(admin.getAccessIp())).split(",");
			for (String ip : accessIps) {
				if (Common.isEmpty(ip.trim())) continue;
				AdminVO vo = new AdminVO();
				vo.setAdminId(admin.getAdminId());
				vo.setAccessIp(ip);
				insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminAccessIp", vo);
			}

			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminCo", admin);
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminBusi", admin);
//			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminDept", admin); ////부서조회권한
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminSvc", admin);
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminPattern", admin);
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminMenu", admin);
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminCeoAuth", admin);

			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminCo", admin);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminBusi", admin);
//			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminDept", admin); //부서조회권한
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminSvc", admin);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminPattern", admin);
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminCeoAuth", admin);
			final String[] authIds = Common.trimAll(Common.nvl(admin.getMenu())).split(",");
			for (String authId : authIds) {
				if (Common.isEmpty(authId.trim())) continue;
				AdminVO vo = new AdminVO();
				vo.setAdminId(admin.getAdminId());
				vo.setMenu(authId);
				insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminMenu", vo);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int updateAdminInfo(AdminVO admin) throws Exception {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminAccessIp", admin.getOldId());
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminAccessIp", admin.getAdminId());
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminAccessIp", admin);
			result = update("com.xcurenet.sqlmap.mappers.mysql.admin.updateAdminInfo", admin);

			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminDashBoardConf", admin.getOldId());
			insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminDashBoardConf", admin);

			tx.commit();

//			DbmsConf db = new DbmsConf();
//			admin.setMysqlOldUser(db.getUser());
//			update("com.xcurenet.sqlmap.mappers.mysql.admin.updateDatabaseInfo", admin);
//			update("com.xcurenet.sqlmap.mappers.mysql.admin.grantDatabaseInfo", admin);
//			update("com.xcurenet.sqlmap.mappers.mysql.admin.flushPrivileges", admin);
//
//			if( db.makeDbmsConf(admin.getMysqlUser(), admin.getMysqlPw()) ) {
//				tx.commit();
//			} else {
//				throw new Exception("!fail make conf file.");
//			}
		} finally {
			tx.end();
		}
		return result;

	}

	@Override
	public int updateAdminPassword(AdminVO admin) {
		return update("com.xcurenet.sqlmap.mappers.mysql.admin.updateAdminPassword", admin);
	}

	@Override
	public AdminVO getAdmin(String adminId) {
		AdminVO admin = new AdminVO();
		String encryptUserYN = Config.getString("private.encrypt.useYN");
		String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
		String encryptSize = Config.getString("private.encrypt.size");
		String encryptKey = Config.getString("private.encrypt.key");
		if(Common.isEquals(encryptUserYN, "Y")){
			admin.setEncryptUseYN(encryptUserYN);
			admin.setEncryptAlgorithm(encryptAlgorithm);
			admin.setEncryptSize(encryptSize);
			admin.setEncryptKey(encryptKey);
		}
		admin.setAdminId(adminId);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdmin", admin);
	}

	@Override
	public int updateUserPasswordWrongCount(AdminVO admin) {
		return update("com.xcurenet.sqlmap.mappers.mysql.admin.updateUserPasswordWrongCount", admin);
	}

	@Override
	public int updateUserLoginOK(AdminVO admin) {
		return update("com.xcurenet.sqlmap.mappers.mysql.admin.updateUserLoginOK", admin);
	}

	@Override
	public int updateAllUserPasswordWrongCount() {
		return update("com.xcurenet.sqlmap.mappers.mysql.admin.updateAllUserPasswordWrongCount", null);
	}

	@Override
	public List<Map<String, Object>> getAdminHpByConfId(String confId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminHpByConfId", confId);
	}

	@Override
	public List<Map<String, Object>> getAdminNotifyByConfId(String confId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminNotifyByConfId", confId);
	}

	@Override
	public boolean isAdminIdExist(AdminVO admin) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.isAdminIdExist", admin) > 0) return true;
		return false;
	}

	@Override
	public List<AdminVO> getApprobatorList(AdminVO admin) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getApprobatorList", admin);
	}

	@Override
	public List<AdminVO> getAllIpMacList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAllIpMacList");
	}

	@Override
	public int insertSystemIpMac(String systemIp1, String systemIp2) {
		int result = 0;
		int result1 = 0;
		int result2 = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			delete("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAllIpMac", systemIp1);
			if (!systemIp1.equals("")) result1 = insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertSystemIpMac", systemIp1);
			if (!systemIp2.equals("")) result2 = insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertSystemIpMac", systemIp2);

			tx.commit();
		} finally {
			tx.end();
		}
		result = result1 + result2;
		return result;

	}

	@Override
	public List<Map<String, Object>> getAdminEmailByConfId(String confId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminEmailByConfId", confId);
	}

	@Override
	public String getAdminMenu(String adminId) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminMenuById", adminId);
	}

	/**
	 * 구글 OTP 개인키 조회
	 */
	@Override
	public String getAdminGenerate(String adminId) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminGenerate", adminId);
	}

	/**
	 * 구글 OTP 개인키 저장
	 */
	@Override
	public void insertAdminGenerate(String adminId, String adminGenerate) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("adminGenerate", adminGenerate);
		insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminGenerate", param);
	}

	/**
	 * 구글 OTP 개인키 제거
	 */
	@Override
	public void deleteAdminGenerate(String adminId) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		insert("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminGenerate", param);
	}

	@Override
	public int insertAdminMfa(AdminMfaVO adminMfaVO) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.admin.insertAdminMfa", adminMfaVO);
	}

	@Override
	public AdminMfaVO getAdminMfa(AdminMfaVO adminMfaVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminMfa", adminMfaVO);
	}

	@Override
	public void deleteAdminMfa(AdminMfaVO adminMfaVO) {
		insert("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminMfa", adminMfaVO);
	}

	@Override
	public void deleteAdminMfaByReqId(AdminMfaVO adminMfaVO) {
		insert("com.xcurenet.sqlmap.mappers.mysql.admin.deleteAdminMfaByReqId", adminMfaVO);
	}

	@Override
	public void clearAdminMfa() {
		insert("com.xcurenet.sqlmap.mappers.mysql.admin.clearAdminMfa", null);
	}

}
