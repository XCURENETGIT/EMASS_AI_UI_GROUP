package com.xcurenet.emass.aiDashboard.service;

import com.xcurenet.emass.aiDashboard.model.AiDashboardStatVO;

import java.io.IOException;

public interface AiDashboardService {
    AiDashboardStatVO getAiDashboardStats() throws IOException;
    AiDashboardStatVO redefined(AiDashboardStatVO aiDashboardStatVO) throws IOException;
}
