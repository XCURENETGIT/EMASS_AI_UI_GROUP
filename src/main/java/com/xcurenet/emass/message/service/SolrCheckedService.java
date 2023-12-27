package com.xcurenet.emass.message.service;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;

import java.io.IOException;
import java.util.List;

public interface SolrCheckedService {

	public void setRead(final String msgId, final String adminId);

	public boolean setMessengerRead(List<SolrEdcVO> data, String adminId);

	public SolrEdcMessageVO getCheckedStatList(SolrQuery sq) throws SolrServerException, IOException;

}
