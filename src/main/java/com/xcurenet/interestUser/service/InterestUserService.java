package com.xcurenet.interestUser.service;

import java.util.List;

import com.xcurenet.code.service.CoVO;

public interface InterestUserService {

	public List<InterestSimpleUserVO> getInterestAllList(final String adminId);

	public List<InterestSimpleUserVO> getInterestSimpleUserList(final String adminId);
	
	public List<AdminUserGroupVO> getInterUserGroupList(final String searchStr);
	
	public List<AdminUserGroupVO> getInterUserGroupUserList(final String groupCodes);
	
	public List<AdminUserGroupVO> getInterestUserInfo(final String adminId);
	
	public List<InterestSimpleUserVO> getInterestList(final String adminId, final String userType, final String searchType, final String searchStr);

	public InterestSimpleUserVO getInterestSimpleUser(final String userSeq);

	public List<InterestSimpleUserVO> getAllInterestSimpleUser(final String adminId);

	public boolean isInterestUserIdExist(final InterestSimpleUserVO user);

	public int updateInterestUser(final InterestSimpleUserVO user);

	public int insertInterestUser(final InterestSimpleUserVO user);

	public int insertInterestUserIp(final InterestSimpleUserVO user);

	public int insertInterestUserEmail(final InterestSimpleUserVO user);

	public int deleteInterestUserIp(final InterestSimpleUserVO user);

	public int deleteInterestUserEmail(final InterestSimpleUserVO user);

	public int updateInterestUserCo(final CoVO co);

	public int deleteInterestUser(final List<InterestSimpleUserVO> user);

	public String getMaxUserSeq();

	public int getInterestCount(final String adminId);
	
	public InterestSimpleUserVO getInterestIpExist(final InterestSimpleUserVO user);
	
	public InterestSimpleUserVO getInterestEmailExist(final InterestSimpleUserVO user);
	
}
