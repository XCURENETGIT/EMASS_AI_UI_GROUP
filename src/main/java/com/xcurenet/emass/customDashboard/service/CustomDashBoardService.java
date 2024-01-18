package com.xcurenet.emass.customDashboard.service;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.vo.XcnResponseVO;

public interface CustomDashBoardService {

	public List<CustomDashboardMenuVO> getDashBoardMenuList(final CustomDashboardMenuVO customDashboardMenuVo);
	public int saveDashBoardMenu(final CustomDashboardMenuVO customDashboardMenuVo);
	public int deleteDashBoardMenu(final List<CustomDashboardMenuVO> customDashboardMenuVos);
	public int changeDashBoardDefaultMenu(final CustomDashboardMenuVO customDashboardMenuVo);

	public List<CustomDashboardVO> getDefaultDashBoardContentList() throws Exception;
	public List<CustomDashboardVO> getDashBoardContentList(final CustomDashboardVO customDashboardVo) throws Exception;
	public int saveDashBoardContent(final CustomDashboardVO customDashboardVo);
	public int deleteDashBoardContent(final List<CustomDashboardVO> customDashboardVos);
	public int insertDashboardShare(List<String> dashKey, List<String> adminId);
	public int deleteDashBoardaAdminShare(List<String> dashKey, List<String> oldAdmin);
	public List<AdminVO> getShareAdmin(List<String> dashKey);
	public int isShareExist(String adminId, String pdashKey, String dashKey);
	public int deleteDashboardShare(String adminId, String pdashKey, String dashKey);
	public void deleteDashBoardContentBatch(CustomDashboardVO deleteData, String adminId);
	public int deleteAdminShare(String pdashKey);
	
	public List<CustomDashboardVO> getDashBoardList(final CustomDashboardVO customDashboardVo) throws Exception;
	public int saveDashBoard(final List<CustomDashboardVO> customDashboardVos);
	public int deleteDashBoard(final CustomDashboardVO customDashboardVo);
	
	public XcnResponseVO getDashBoardContentData(CustomDashboardVO customDashboardVo);
	
	public int insertDashBoardDefaultData(final CustomDashboardVO customDashboardVo);
	
	public String getLoggingDataSetting(final HttpSession session) throws Exception;
	
	public XcnResponseVO getLoggingData(final HttpServletRequest request, final HttpSession session) throws Exception;
	
	public List<HdfsVO> getHdfsData(final HttpServletRequest request, final HttpSession session) throws Exception;
	
	public int insertHDFSInfo(Map<String, String> map);
	
	public int insertHDFSDirSize(Map<String, String> param);
	
	public int saveLoggingData(final HttpServletRequest request, final HttpSession session);
	
	public List<FileDataVO> getFileSizeData(HttpServletRequest request, HttpSession session) throws Exception;
	
	public List<FileDataVO> getFileCount(HttpServletRequest request, HttpSession session) throws Exception;
	
	public int checkMonitorDB();

	public String isDefaultDashboard(CustomDashboardMenuVO customDashboardMenuVO);
}
