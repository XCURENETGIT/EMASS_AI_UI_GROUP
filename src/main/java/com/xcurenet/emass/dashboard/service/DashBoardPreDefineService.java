package com.xcurenet.emass.dashboard.service;

import com.xcurenet.common.vo.XcnResponseVO;
import org.apache.solr.client.solrj.SolrServerException;

import java.io.IOException;
import java.util.List;
import java.util.Map;


public interface DashBoardPreDefineService {

	public TodayDataStatusVO getTodayDataStatus(final TodayDataStatusVO todayDataStatusVO) throws IOException, SolrServerException;

	public PatternPrivacyVO getTodayPatternPrivacy(final PatternPrivacyVO patternPrivacyVO) throws IOException, SolrServerException;

	public RiskBehaviorVO getTodayRiskBehavior(final RiskBehaviorVO riskBehaviorVO) throws IOException, SolrServerException;

	public KeywordDetectionVO getTodayKeywordDetection(final KeywordDetectionVO keywordDetectionVO) throws IOException, SolrServerException;

	public ServiceDataLoggingVO getServiceDataLogging(final ServiceDataLoggingVO serviceDataLoggingVO) throws IOException, SolrServerException;


	public FileTopVO getTodayFileTop(FileTopVO vo) throws SolrServerException, IOException;

	public FileTopVO getTodayFilePerson(FileTopVO vo) throws SolrServerException, IOException;

	public TodayNotWorkVO getTodayNotWork(TodayNotWorkVO vo) throws SolrServerException, IOException;

	public XcnResponseVO getBodySize(BodySizeVO vo) throws Exception;

	public List<Map<String, Object>> getTrafficSize() throws Exception;

	public List<Map<String, Object>> getTodayTrafficSize() throws Exception;

	public PatternPrivacyVO getTodayPassportData(PatternPrivacyVO vo) throws SolrServerException, IOException;

	public PatternPrivacyVO getTodayDriveData(PatternPrivacyVO vo) throws SolrServerException, IOException;
	public PatternPrivacyVO TodayForeignerData(PatternPrivacyVO vo) throws SolrServerException, IOException;
	public PatternPrivacyVO TodaySecurityData(PatternPrivacyVO vo) throws SolrServerException, IOException;
	public PatternPrivacyVO TodayCardNumberData(PatternPrivacyVO vo) throws SolrServerException, IOException;
	public PatternPrivacyVO getExtensionModulation(PatternPrivacyVO vo) throws SolrServerException, IOException;

}
