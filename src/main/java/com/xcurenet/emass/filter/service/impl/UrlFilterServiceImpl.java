package com.xcurenet.emass.filter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.UrlFilterService;
import com.xcurenet.emass.filter.service.UrlFilterVO;

@Service("urlFilterService")
public class UrlFilterServiceImpl extends XcnAbstractDAO implements UrlFilterService {

	@Override
	public List<UrlFilterVO> getUrlFilterList(String searchStr) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getUrlFilterList", param);
	}

	@Override
	public boolean isUrlExist(UrlFilterVO filter) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isUrlExist", filter) > 0;
	}

	@Override
	public int insertUrlFilter(UrlFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertUrlFilter", filter);
	}

	@Override
	public int updateUrlFilter(UrlFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateUrlFilter", filter);
	}

	@Override
	public int deleteUrlFilter(List<UrlFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (UrlFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteUrlFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

}
