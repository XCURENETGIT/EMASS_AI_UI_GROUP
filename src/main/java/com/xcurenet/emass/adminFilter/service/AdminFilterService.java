package com.xcurenet.emass.adminFilter.service;

import java.util.List;

import net.sf.json.JSONObject;

public interface AdminFilterService {

	public List<AdminFilterVO> getAdminFilterList(final String adminId, final String searchStr, final String contextPath);
	
	public List<AdminFilterVO> getAdminFilterListForExport(final JSONObject param);
	
	public int setAdminFilterListForImport(final List<AdminFilterVO> filterVos);

	public AdminFilterVO getAdminFilter(final long filterSeq);

	public long getNextAdminFilterId();

	public int insertAdminFilter(AdminFilterVO AdminFilter);

	public int updateAdminFilter(AdminFilterVO AdminFilter);

	public int updateFilterStatus(AdminFilterVO AdminFilter);

	public int deleteAdminFilter(final List<AdminFilterVO> filterVos);

	public int updateFilterOrder(final List<AdminFilterVO> filterVos);
}
