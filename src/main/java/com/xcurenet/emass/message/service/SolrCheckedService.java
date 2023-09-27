package com.xcurenet.emass.message.service;

import java.io.IOException;
import java.util.List;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;

public interface SolrCheckedService {

	public List<SolrCheckedVO> getCheckedList(final SolrQuery sq) throws SolrServerException, IOException;

	public List<SolrEdcVO> findReadList(final List<SolrEdcVO> emass, final String adminId) throws SolrServerException, IOException;

	public void setRead(final SolrCheckedVO checked);

	public boolean setMessengerRead(List<SolrEdcVO> data, String adminId);

	public SolrEdcMessageVO getCheckedStatList(SolrQuery sq) throws SolrServerException, IOException;

}
