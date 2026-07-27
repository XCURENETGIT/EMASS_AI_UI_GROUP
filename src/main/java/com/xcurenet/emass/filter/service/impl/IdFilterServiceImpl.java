package com.xcurenet.emass.filter.service.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.IdFilterService;
import com.xcurenet.emass.filter.service.IdFilterVO;

@Service("idFilterService")
public class IdFilterServiceImpl extends XcnAbstractDAO implements IdFilterService {

	@Override
	public List<IdFilterVO> getIdFilterList(String searchStr, String serviceCd) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("serviceCd", serviceCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getIdFilterList", param);
	}

	@Override
	public boolean isIdExist(IdFilterVO filter) {
		if (filter.getServiceCd() == null || filter.getServiceCd().trim().isEmpty()) {
			return false;
		}
		Map<String, Object> param = new HashMap<>();
		param.put("userId", filter.getUserId());
		param.put("idLogSeq", filter.getIdLogSeq());
		param.put("serviceCdList", Arrays.asList(filter.getServiceCd().split(",")));
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isIdExist", param) > 0;
	}

	@Override
	public boolean isServiceCdCountExceeded(String serviceCd) {
		if (serviceCd == null || serviceCd.trim().isEmpty()) {
			return false;
		}
		long count = Arrays.stream(serviceCd.split(",")).filter(cd -> !cd.trim().isEmpty()).count();
		return count > 20;
	}

	@Override
	public int insertIdFilter(IdFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertIdFilter", filter);
	}

	@Override
	public int updateIdFilter(IdFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateIdFilter", filter);
	}

	@Override
	public int deleteIdFilter(List<IdFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (IdFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteIdFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;

	}

}
