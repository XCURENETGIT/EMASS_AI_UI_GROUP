package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.EpmsgTypeService;
import com.xcurenet.code.service.EpmsgTypeVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;

@Service("epmsgTypeService")
public class EpmsgTypeServiceImpl extends XcnAbstractDAO implements EpmsgTypeService {

	@Override
	public List<EpmsgTypeVO> getEpmsgTypeList(String searchStr, String searchUseYn) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("searchUseYn", searchUseYn);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getEpmsgTypeList", param);
	}

	@Override
	public List<EpmsgTypeVO> getUsedEpmsgTypeList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getUsedEpmsgTypeList");
	}

	@Override
	public boolean isEpmsgTypeExist(EpmsgTypeVO epmsgType) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isEpmsgTypeExist", epmsgType) > 0;
	}

	@Override
	public int insertEpmsgType(EpmsgTypeVO epmsgType) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertEpmsgType", epmsgType);
	}

	@Override
	public int updateEpmsgType(EpmsgTypeVO epmsgType) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateEpmsgType", epmsgType);
	}

	@Override
	public int deleteEpmsgType(List<EpmsgTypeVO> epmsgTypes) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (EpmsgTypeVO epmsgType : epmsgTypes) {
				result += delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteEpmsgType", epmsgType);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
}
