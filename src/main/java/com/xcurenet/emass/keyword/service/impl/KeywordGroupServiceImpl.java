package com.xcurenet.emass.keyword.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.keyword.service.KeywordGroupService;
import com.xcurenet.emass.keyword.service.KeywordGroupVO;

import net.sf.json.JSONObject;

@Service("keywordGroupService")
public class KeywordGroupServiceImpl extends XcnAbstractDAO implements KeywordGroupService {

	@Override
	public List<KeywordGroupVO> getKeywordGroupList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.keyword.getKeywordGroupList", param);
	}
	
	@Override
	public List<KeywordGroupVO> getKeywordGroupList(JSONObject param) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.keyword.getKeywordGroupList", param);
	}

	@Override
	public int insertKeywordGroup(KeywordGroupVO group) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.keyword.insertKeywordGroup", group);
	}

	@Override
	public int updateKeywordGroup(KeywordGroupVO group) {
		return update("com.xcurenet.sqlmap.mappers.mysql.keyword.updateKeywordGroup", group);
	}

	@Override
	public int deleteKeywordGroup(List<KeywordGroupVO> groups) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (KeywordGroupVO group : groups) {
				delete("com.xcurenet.sqlmap.mappers.mysql.keyword.deleteKeywordGroup", group);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public KeywordGroupVO getNextKeywordGroupSeq() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.keyword.getNextKeywordGroupSeq");
	}

	@Override
	public boolean isGroupNameExist(KeywordGroupVO group) {
		return (int)selectOne("com.xcurenet.sqlmap.mappers.mysql.keyword.isKeywordGroupNameExist", group) > 0;
	}

}
