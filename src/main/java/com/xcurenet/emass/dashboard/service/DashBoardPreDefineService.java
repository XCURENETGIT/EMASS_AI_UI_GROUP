package com.xcurenet.emass.dashboard.service;

import org.apache.solr.client.solrj.SolrServerException;

import java.io.IOException;


public interface DashBoardPreDefineService {

	public TodayDataStatusVO getTodayDataStatus(final TodayDataStatusVO todayDataStatusVO) throws IOException, SolrServerException;

	public PatternPrivacyVO getTodayPatternPrivacy(final PatternPrivacyVO patternPrivacyVO) throws IOException, SolrServerException;

	public RiskBehaviorVO getTodayRiskBehavior(final RiskBehaviorVO riskBehaviorVO) throws IOException, SolrServerException;

	public KeywordDetectionVO getTodayKeywordDetection(final KeywordDetectionVO keywordDetectionVO) throws IOException, SolrServerException;

	public ServiceDataLoggingVO getServiceDataLogging(final ServiceDataLoggingVO serviceDataLoggingVO) throws IOException, SolrServerException;

	public InterestUserMailVO getInterestUserMail(final InterestUserMailVO interestUserMailVO) throws IOException ;

	public InterestUserServiceVO getInterestUserService(final InterestUserServiceVO interestUserServiceVO) throws IOException ;

	public FileTopVO getTodayFileTop(FileTopVO vo) throws SolrServerException, IOException;

	// public DashboardVO getDashboard(final DashboardVO dashboardVO) throws
	// IOException;
}
