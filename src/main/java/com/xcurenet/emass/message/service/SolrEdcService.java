package com.xcurenet.emass.message.service;

import com.xcurenet.emass.message.service.impl.parseJsonFile;
import com.xcurenet.emass.searchHistory.vo.SearchHistoryGroupVO;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.ElasticsearchException;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface SolrEdcService {

	public SolrClient getSolrServer();

	public SearchHistoryGroupVO getSearchHistoryList(final SolrQuery sq) throws SolrServerException, IOException;

	public SearchHits<SolrEdcVO>  getList(final SolrQuery sq) throws SolrServerException, IOException;

	public SolrEdcVO getSelectOne(final String msgId,final boolean isUnknownDocument);

	public SolrEdcMessageVO getEmassMessage(final SolrQuery sq, final String adminId) throws IOException, SolrServerException;


	public SolrEdcMessageVO getEmassMessage(final SolrQuery sq, final String adminId, final String readYn, final String consentNo) throws IOException, SolrServerException;
	public SolrEdcMessageVO getEmassMessage(final SolrQuery sq, final String adminId, final String readYn, final String consentNo, final String adminAllRead) throws IOException, SolrServerException;

	public MessengerEdcGroupVO getMessengerGroupList(final SolrQuery sq, final String adminId) throws IOException, SolrServerException;

	public MessengerEdcGroupVO getMessengerGroupList(final SolrQuery sq, final String adminId, final boolean detail) throws IOException, SolrServerException;

	public MessengerEdcGroupVO getMessengerGroupList(final SolrQuery sq, final String adminId, final boolean detail, final boolean original) throws IOException, SolrServerException;

	public MessengerGroupUserVO getMessengerGroupUserList(final SolrQuery sq, final String adminId) throws IOException, SolrServerException;
	public MessengerGroupSvcVO getCollectionMessageSvc(final SolrQuery sq, final String adminId) throws IOException, SolrServerException;
	public MessengerGroupUserVO getGenerativeGroupUserList(final SolrQuery sq, final String adminId) throws IOException, SolrServerException;

	public void setFeedback(final String msgId, final String ml_confd_feedback) throws ElasticsearchException, IOException;


	public SolrEdcMessageVO setOverlap(SolrEdcMessageVO solrVo) throws SolrServerException, IOException;

	public List<SolrEdcVO>  setOverlap(List<SolrEdcVO> emass) throws SolrServerException, IOException;

	public boolean setSecretInfo(String sourceKey, String securityYn, String doublSecurityPctStr, Map<String, List<parseJsonFile>> sortList) throws SolrServerException, IOException;

	public boolean updateSolrFeedbackData(List<parseJsonFile> feedbackList);

	String[] getExistIndics(String msgId,String format);

	Long getTotalCnt(String query);

	public List<SolrEdcVO> getCheckedList(List<SolrEdcVO> solrVo);

//	public void getCurIdx();


}
