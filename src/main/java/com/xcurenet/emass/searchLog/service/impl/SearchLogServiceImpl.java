package com.xcurenet.emass.searchLog.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.searchLog.service.SearchLogService;
import com.xcurenet.emass.searchLog.service.SearchLogVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Log4j2
@Service("searchLogService")
public class SearchLogServiceImpl extends XcnAbstractDAO implements SearchLogService {

	@Override
	public int insertSearchLog(JSONObject param) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			SearchLogVO searchLogVO = new SearchLogVO();
			JSONObject filterVal = Common.toJSONObject(param.get("data"));

			searchLogVO.setSearchType(Common.isEmpty(filterVal.get("consentNo")) ? "N" : "Y");
			searchLogVO.setSearchId(param.getString("_ses_user_id"));
			searchLogVO.setSearchName(param.getString("_ses_user_name"));
			searchLogVO.setPFilterSeq(Common.nvn(filterVal.get("p_filter_seq"), -1));
			searchLogVO.setFilterSeq(Common.nvn(filterVal.get("filter_seq"), -1));
			searchLogVO.setFilterNm(Common.nvl(filterVal.get("filterName")));
			searchLogVO.setConsentNo(Common.nvl(filterVal.get("consentNo")));
			searchLogVO.setConsentUserId(Common.nvl(filterVal.get("consentUserId")));
			searchLogVO.setConsentName(Common.nvl(filterVal.get("consentShortName")));
			if (Common.isEmpty(param.get("query"))) {
				searchLogVO.setConditions(Common.nvl(filterVal.getJSONArray("conditions")));
			} else {
				JSONArray array = new JSONArray();
				JSONObject obj = new JSONObject();
				obj.put("query", Common.nvl(param.get("query")));
				array.add(obj);
				searchLogVO.setConditions(Common.nvl(array));
			}
			result = insert("com.xcurenet.sqlmap.mappers.mysql.searchLog.insertSearchLog", searchLogVO);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public List<SearchLogVO> getSearchLogList(final String startDt, final String endDt, final String adminId, final String searchType, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDt", startDt);
		param.put("endDt", endDt);
		param.put("adminId", adminId);
		param.put("searchType", searchType);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.searchLog.getSearchLogList", param);
	}
}
