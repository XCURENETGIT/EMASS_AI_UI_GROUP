package com.xcurenet.emass.consent.service;

import java.util.List;

public interface ConsentService {

	public ConsentSeqVO getConsentSeq();

	public ConsentVO getConsentFileInfo(ConsentVO consent);

	public int insertConsentSeq(ConsentSeqVO vo);

	public int deleteConsentSeq(String date, int no);

	public List<ConsentVO> getConsentList(final String startDate, final String endDate, final String type, final String consentStatus, final String createNm, final String searchStr, final int offset, final int limit);
	
	public List<ConsentVO> getConsentSearchList(final String type, final String searchStr);

	public boolean isConsentExist(final ConsentVO consent);

	public int insertConsent(ConsentVO consent) throws Exception;

	public int updateConsent(ConsentVO consent) throws Exception;

	public int deleteConsent(List<ConsentVO> consents);

	public int insertUserIp(ConsentVO consent);

	public int deleteUserIp(ConsentVO consent);

	public int updateApproval(ConsentVO consent);
	
	public String getApprobator(String adminId);

}
