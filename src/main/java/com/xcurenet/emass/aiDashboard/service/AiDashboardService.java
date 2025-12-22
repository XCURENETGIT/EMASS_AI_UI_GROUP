package com.xcurenet.emass.aiDashboard.service;

import com.xcurenet.emass.aiDashboard.model.AiDashboardStatVO;
import org.apache.solr.client.solrj.SolrServerException;

import java.io.IOException;

public interface AiDashboardService {
    AiDashboardStatVO getAiDashboardStats(String adminId) throws IOException, SolrServerException;
}
