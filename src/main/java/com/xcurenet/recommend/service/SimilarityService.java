package com.xcurenet.recommend.service;

import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import org.apache.solr.client.solrj.SolrServerException;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public interface SimilarityService {

	public SolrEdcMessageVO getSimilarity(HttpServletRequest request) throws SolrServerException, IOException;
}
