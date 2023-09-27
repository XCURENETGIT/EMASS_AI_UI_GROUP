package com.xcurenet.emass.filter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.DomainFilterService;
import com.xcurenet.emass.filter.service.DomainFilterVO;

@Service("domainFilterService")
public class DomainFilterServiceImpl extends XcnAbstractDAO implements DomainFilterService {

	@Override
	public List<DomainFilterVO> getDomainFilterList(String searchStr, String serviceCd) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("serviceCd", serviceCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getDomainFilterList", param);
	}

	@Override
	public boolean isDomainExist(DomainFilterVO filter) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isDomainExist", filter) > 0;
	}

	@Override
	public int insertDomainFilter(DomainFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertDomainFilter", filter);
	}

	@Override
	public int updateDomainFilter(DomainFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateDomainFilter", filter);
	}

	@Override
	public int deleteDomainFilter(List<DomainFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (DomainFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteDomainFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

}
