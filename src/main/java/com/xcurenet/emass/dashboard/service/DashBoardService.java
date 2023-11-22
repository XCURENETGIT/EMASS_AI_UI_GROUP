package com.xcurenet.emass.dashboard.service;

import com.xcurenet.emass.adminFilter.service.AdminFilterVO;

import java.io.IOException;
import java.util.List;

public interface DashBoardService {

	public List<DashboardVO> getDashBoardConfigs(final String adminId);

	public DashboardVO getDashBoardConfig(final String adminId, final String dashKey);

	public int saveDashBoardConfig(final DashboardVO dashboard);

	public int initDashBoardConfig(final DashboardVO dashboard);

	public FileSendVO getFileSend(final FileSendVO filesend) throws IOException;

	public long getAdminFilterAmount(final AdminFilterVO adminFilterVo) throws Exception;

}
