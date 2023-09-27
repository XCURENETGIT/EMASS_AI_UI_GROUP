package com.xcurenet.emass.dashboard.service;

import java.io.IOException;

import org.apache.solr.client.solrj.SolrServerException;

public interface DashBoardPreDefineService {

	public TodayDataStatusVO getTodayDataStatus(final TodayDataStatusVO todayDataStatusVO) throws IOException, SolrServerException;

	public PatternPrivacyVO getTodayPatternPrivacy(final PatternPrivacyVO patternPrivacyVO) throws IOException, SolrServerException;

	public RiskBehaviorVO getTodayRiskBehavior(final RiskBehaviorVO riskBehaviorVO) throws IOException, SolrServerException;

	public KeywordDetectionVO getTodayKeywordDetection(final KeywordDetectionVO keywordDetectionVO) throws IOException, SolrServerException;

	public ServiceDataLoggingVO getServiceDataLogging(final ServiceDataLoggingVO serviceDataLoggingVO) throws IOException, SolrServerException;

	public InterestUserMailVO getInterestUserMail(final InterestUserMailVO interestUserMailVO) throws IOException, SolrServerException;

	public InterestUserServiceVO getInterestUserService(final InterestUserServiceVO interestUserServiceVO) throws IOException, SolrServerException;

	// public DashboardVO getDashboard(final DashboardVO dashboardVO) throws
	// IOException;
}
