package com.xcurenet.emass.filter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.SizeFilterService;
import com.xcurenet.emass.filter.service.SizeFilterVO;

@Service("sizeFilterService")
public class SizeFilterServiceImpl extends XcnAbstractDAO implements SizeFilterService {

	@Override
	public List<SizeFilterVO> getSizeFilterList(String serviceCd) {
		Map<String, Object> param = new HashMap<>();
		param.put("serviceCd", serviceCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getSizeFilterList", param);
	}

	@Override
	public boolean isSizeExist(SizeFilterVO filter) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isSizeExist", filter) > 0;
	}

	@Override
	public int insertSizeFilter(SizeFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertSizeFilter", filter);
	}

	@Override
	public int updateSizeFilter(SizeFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateSizeFilter", filter);
	}

	@Override
	public int deleteSizeFilter(List<SizeFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (SizeFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteSizeFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

}
