package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.AttachTypeService;
import com.xcurenet.code.service.AttachTypeVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;

@Service("attachTypeService")
public class AttachTypeServiceImpl extends XcnAbstractDAO implements AttachTypeService {

	@Override
	public List<AttachTypeVO> getAttachType( ) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAttachType");
	}
	
	@Override
	public List<AttachTypeVO> getAttachTypeList(String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAttachTypeList", param);
	}

	@Override
	public int getAttachTypeListTotal(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.code.getAttachTypeListTotal", param);
	}

	@Override
	public int insertAttachType(AttachTypeVO attach) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertAttachType", attach);
	}

	@Override
	public int updateAttachType(AttachTypeVO attach) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateAttachType", attach);
	}

	@Override
	public int deleteAttachType(List<AttachTypeVO> attachs) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AttachTypeVO attach : attachs) {
				result = delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteAttachType", attach);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public boolean isAttachTypeExist(AttachTypeVO attach) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isAttachTypeExist", attach) > 0;
	}
}
