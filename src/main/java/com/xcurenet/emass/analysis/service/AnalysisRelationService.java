package com.xcurenet.emass.analysis.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.SolrServerException;

import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcVO;

import net.sf.json.JSONObject;

public interface AnalysisRelationService {

	public AnalysisRelationListVO dataRelationList(SearchVO searchVO) throws IOException, SolrServerException;

	public List<SolrEdcVO> dataDetailList(SearchVO searchVO) throws IOException, SolrServerException;

	public SolrEdcMessageVO dataSelectList(SearchVO searchVO) throws IOException, SolrServerException;

	public List<UsageChartVO> selectUsageChart(SearchVO searchVO) throws Exception;

	public AnalysisRelationListVO selectUsageList(SearchVO searchVO) throws Exception;

	public JSONObject selectDetailList(SearchVO searchVO, String chartName) throws Exception;
	
	public Map<String, String> plusHour(String targetDate, int start, int end) throws Exception;

	public String getLastTime() throws Exception;

	public List<UsageChartSchedulerVO> getTime(SearchVO searchVO) throws SolrServerException;

	public List<UsageChartSchedulerVO> getDay(SearchVO searchVO) throws SolrServerException;

	public List<UsageChartSchedulerVO> getMonth(SearchVO searchVO) throws SolrServerException;

	public List<UsageChartSchedulerVO> getWeek(SearchVO searchVO) throws SolrServerException;

	public AnalysisFreedomListVO freedomView(FreedomSearchVO searchVO) throws IOException, SolrServerException;

	public SolrEdcMessageVO selectFreedomMessageList(FreedomSearchVO freedomSearchVO) throws IOException, SolrServerException;

	public String getFreedomQuery(FreedomSearchVO freedomSearchVO);

	public int insertUsageCompare(List<UsageChartSchedulerVO> list) throws SolrServerException;

}