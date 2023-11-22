package com.xcurenet.emass.dashboard.service;

import java.io.IOException;


public interface DashBoardPreDefineService {

	public TodayDataStatusVO getTodayDataStatus(final TodayDataStatusVO todayDataStatusVO) throws IOException ;

	public PatternPrivacyVO getTodayPatternPrivacy(final PatternPrivacyVO patternPrivacyVO) throws IOException ;

	public RiskBehaviorVO getTodayRiskBehavior(final RiskBehaviorVO riskBehaviorVO) throws IOException ;

	public KeywordDetectionVO getTodayKeywordDetection(final KeywordDetectionVO keywordDetectionVO) throws IOException ;

	public ServiceDataLoggingVO getServiceDataLogging(final ServiceDataLoggingVO serviceDataLoggingVO) throws IOException;

	public InterestUserMailVO getInterestUserMail(final InterestUserMailVO interestUserMailVO) throws IOException ;

	public InterestUserServiceVO getInterestUserService(final InterestUserServiceVO interestUserServiceVO) throws IOException ;

	// public DashboardVO getDashboard(final DashboardVO dashboardVO) throws
	// IOException;
}
