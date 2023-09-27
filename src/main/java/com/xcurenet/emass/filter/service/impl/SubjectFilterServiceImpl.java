package com.xcurenet.emass.filter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.SubjectFilterService;
import com.xcurenet.emass.filter.service.SubjectFilterVO;

@Service("subjectFilterService")
public class SubjectFilterServiceImpl extends XcnAbstractDAO implements SubjectFilterService {

	@Override
	public List<SubjectFilterVO> getSubjectFilterList(String searchStr, String serviceCd) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("serviceCd", serviceCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getSubjectFilterList", param);
	}

	@Override
	public boolean isSubjectExist(SubjectFilterVO filter) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isSubjectExist", filter) > 0;
	}

	@Override
	public int insertSubjectFilter(SubjectFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertSubjectFilter", filter);
	}

	@Override
	public int updateSubjectFilter(SubjectFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateSubjectFilter", filter);
	}

	@Override
	public int deleteSubjectFilter(List<SubjectFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (SubjectFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteSubjectFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

}
