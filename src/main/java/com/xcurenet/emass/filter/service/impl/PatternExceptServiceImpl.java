package com.xcurenet.emass.filter.service.impl;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.filter.service.PatternExceptService;
import com.xcurenet.emass.filter.service.PatternExceptVO;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("patternExceptService")
public class PatternExceptServiceImpl extends XcnAbstractDAO implements PatternExceptService {

	@Override
	public List<PatternExceptVO> getPatternExceptList(String searchStr, String privateType) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("privateType", privateType);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.filter.getPatternExceptList", param);
	}

	@Override
	public boolean isPatternExist(PatternExceptVO patternExceptVO) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.filter.isPatternExist", patternExceptVO) > 0;
	}

	@Override
	public int insertPatternExcept(PatternExceptVO patternExceptVO, String adminId) {
		patternExceptVO.setCreateUser(adminId);

		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.insertPatternExcept", patternExceptVO);
	}
	@Override
	public int updatePatternExcept(PatternExceptVO patternExceptVO) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.filter.updatePatternExcept", patternExceptVO);
	}
	@Override
	public int deletePatternExcept(List<PatternExceptVO> patternExceptlist) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (PatternExceptVO patternExceptVO : patternExceptlist) {
				delete("com.xcurenet.sqlmap.mappers.mysql.filter.deletePatternExcept", patternExceptVO);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}
}
