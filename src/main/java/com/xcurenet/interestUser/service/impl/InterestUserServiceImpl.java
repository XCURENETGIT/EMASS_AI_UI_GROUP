package com.xcurenet.interestUser.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.CoVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.interestUser.service.AdminUserGroupVO;
import com.xcurenet.interestUser.service.InterestSimpleUserVO;
import com.xcurenet.interestUser.service.InterestUserService;


@Service("interestUserService")
public class InterestUserServiceImpl extends XcnAbstractDAO implements InterestUserService {

	@Override
	public List<InterestSimpleUserVO> getInterestSimpleUserList(String adminId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestSimpleUserList", param);
	}

	@Override
	public List<InterestSimpleUserVO> getInterestAllList(String adminId) {
		return getInterestList(adminId, null, null, null);
	}
	
	@Override
	public List<InterestSimpleUserVO> getInterestList(String adminId, String userType, String searchType, String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		param.put("userType", userType);
		param.put("searchType", searchType);
		param.put("searchStr", searchStr);

		return selectList("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestList", param);
	}

	@Override
	public InterestSimpleUserVO getInterestSimpleUser(String userSeq) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestSimpleUser", userSeq);
	}

	@Override
	public List<InterestSimpleUserVO> getAllInterestSimpleUser(String adminId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.interestUser.getAllInterestSimpleUser", adminId);
	}

	@Override
	public boolean isInterestUserIdExist(InterestSimpleUserVO user) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.interestUser.isInterestUserIdExist", user) > 0) return true;
		return false;
	}

	@Override
	public int updateInterestUser(InterestSimpleUserVO user) {
		int rs = 0;
		TransactionManager tr = getTransactionManager();
		try {
			tr.start();
			rs += update("com.xcurenet.sqlmap.mappers.mysql.interestUser.updateInterestUser", user);
			deleteInterestUserIp(user);
			deleteInterestUserEmail(user);

			insertInterestUserIp(user);
			insertInterestUserEmail(user);
			tr.commit();
		} finally {
			tr.end();
		}
		return rs;
	}

	@Override
	public int insertInterestUser(final InterestSimpleUserVO user) {
		user.setUserSeq( getMaxUserSeq());
		if (Common.isNotEmpty(user.getUserIp())) {
			insertInterestUserIp(user);
		}
		if (Common.isNotEmpty(user.getUserEmail())) {
			insertInterestUserEmail(user);
		}

		return insert("com.xcurenet.sqlmap.mappers.mysql.interestUser.insertInterestUser", user);
	}

	@Override
	public String getMaxUserSeq() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.interestUser.getMaxUserSeq");
	}

	@Override
	public int insertInterestUserIp(final InterestSimpleUserVO user) {
		int result = 0;
		final String userSeq = user.getUserSeq();
		final String[] userIps = Common.trimAll(Common.nvl(user.getUserIp())).split(",");
		for (String userIp : userIps) {
			InterestSimpleUserVO vo = new InterestSimpleUserVO();
			vo.setUserSeq(userSeq);
			vo.setUserIp(userIp);
			result += insert("com.xcurenet.sqlmap.mappers.mysql.interestUser.insertInterestUserIp", vo);
		}
		return result;
	}

	@Override
	public int insertInterestUserEmail(final InterestSimpleUserVO user) {
		int result = 0;
		final String userSeq = user.getUserSeq();
		final String[] userEmails = Common.trimAll(Common.nvl(user.getUserEmail())).split(",");
		for (String userEmail : userEmails) {
			InterestSimpleUserVO vo = new InterestSimpleUserVO();
			vo.setUserSeq(userSeq);
			vo.setUserEmail(userEmail);
			result += insert("com.xcurenet.sqlmap.mappers.mysql.interestUser.insertInterestUserEmail", vo);
		}
		return result;
	}

	@Override
	public int deleteInterestUserIp(final InterestSimpleUserVO user) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.interestUser.deleteInterestUserIp", user);
	}

	@Override
	public int deleteInterestUserEmail(final InterestSimpleUserVO user) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.interestUser.deleteInterestUserEmail", user);
	}

	@Override
	public int updateInterestUserCo(CoVO co) {
		return 0;
	}

	@Override
	public int deleteInterestUser(List<InterestSimpleUserVO> user) {
		int rs = 0;
		TransactionManager tr = getTransactionManager();
		try {
			tr.start();
			for (int i = 0; i < user.size(); i++) {
				rs += update("com.xcurenet.sqlmap.mappers.mysql.interestUser.updateInterestUserConf", user.get(i));
				rs += delete("com.xcurenet.sqlmap.mappers.mysql.interestUser.deleteInterestUser", user.get(i));
				rs += delete("com.xcurenet.sqlmap.mappers.mysql.interestUser.deleteInterestUserIp", user.get(i));
				rs += delete("com.xcurenet.sqlmap.mappers.mysql.interestUser.deleteInterestUserEmail", user.get(i));
			}
			tr.commit();
		} finally {
			tr.end();
		}
		return rs;
	}

	@Override
	public int getInterestCount(String adminId) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestCount", adminId);
	}

	@Override
	public InterestSimpleUserVO getInterestIpExist(InterestSimpleUserVO user) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestIpExist", user);
	}

	@Override
	public InterestSimpleUserVO getInterestEmailExist(InterestSimpleUserVO user) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestEmailExist", user);
	}
	
	public List<AdminUserGroupVO> getInterUserGroupList(final String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterUserGroupList", param);
	}
	
	public List<AdminUserGroupVO> getInterUserGroupUserList(final String groupCodes) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupCodes", groupCodes);
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterUserGroupUserList", param);
	}
	
	public List<AdminUserGroupVO> getInterestUserInfo(String userId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.interestUser.getInterestUserInfo", userId);
	}
}
