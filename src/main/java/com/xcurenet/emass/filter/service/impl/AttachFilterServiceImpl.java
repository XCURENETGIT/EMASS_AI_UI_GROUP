package com.xcurenet.emass.filter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.AttachFilterService;
import com.xcurenet.emass.filter.service.AttachFilterVO;

@Service("attachFilterService")
public class AttachFilterServiceImpl extends XcnAbstractDAO implements AttachFilterService {

	@Override
	public List<AttachFilterVO> getAttachFilterList(String searchStr, String serviceCd) {
		Map<String, Object> param = new HashMap<>();
		param.put("searchStr", searchStr);
		param.put("serviceCd", serviceCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getAttachFilterList", param);
	}

	@Override
	public boolean isAttachExist(AttachFilterVO filter) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isAttachExist", filter) > 0;
	}

	@Override
	public int insertAttachFilter(AttachFilterVO filter) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertAttachFilter", filter);
	}

	@Override
	public int updateAttachFilter(AttachFilterVO filter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.filter.updateAttachFilter", filter);
	}

	@Override
	public int deleteAttachFilter(List<AttachFilterVO> filters) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AttachFilterVO filter : filters) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deleteAttachFilter", filter);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

}
