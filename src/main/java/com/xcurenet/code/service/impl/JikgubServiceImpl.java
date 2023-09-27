package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.JikgubService;
import com.xcurenet.code.service.JikgubVO;
import com.xcurenet.common.dao.XcnAbstractDAO;

@Service("jikgubService")
public class JikgubServiceImpl extends XcnAbstractDAO implements JikgubService {

	@Override
	public List<JikgubVO> getAllJikgubList() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getJikgubList", param);
	}

	@Override
	public List<JikgubVO> getJikgubList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getJikgubList", param);
	}

	@Override
	public int insertJikgub(JikgubVO jikgub) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertJikgub", jikgub);
	}

	@Override
	public int updateJikgub(JikgubVO jikgub) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateJikgub", jikgub);
	}

	@Override
	public int deleteJikgub(JikgubVO jikgub) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteJikgub", jikgub);
	}

	@Override
	public boolean isJikgubNmExist(JikgubVO jikgub) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isJikgubNmExist", jikgub) > 0;
	}

	@Override
	public boolean isJikgubCdExist(JikgubVO jikgub) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isJikgubCdExist", jikgub) > 0;
	}

}
