package com.xcurenet.emass.searchLog.service;

import java.util.List;

import net.sf.json.JSONObject;

public interface SearchLogService {

	public int insertSearchLog(JSONObject param);

	public List<SearchLogVO> getSearchLogList(final String startDt, final String endDt, final String adminId, final String searchType, final int offset, final int limit);
}
