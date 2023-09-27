package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.JikinService;
import com.xcurenet.code.service.JikinVO;
import com.xcurenet.common.dao.XcnAbstractDAO;

@Service("jikinService")
public class JikinServiceImpl extends XcnAbstractDAO implements JikinService {

	@Override
	public List<JikinVO> getAllJikinList() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getJikinList", param);
	}

	@Override
	public List<JikinVO> getJikinList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getJikinList", param);
	}

	@Override
	public int insertJikin(JikinVO jikin) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertJikin", jikin);
	}

	@Override
	public int updateJikin(JikinVO jikin) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateJikin", jikin);
	}

	@Override
	public int deleteJikin(JikinVO jikin) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteJikin", jikin);
	}

	@Override
	public boolean isJikinNmExist(JikinVO jikin) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isJikinNmExist", jikin) > 0;
	}

	@Override
	public boolean isJikinCdExist(JikinVO jikin) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isJikinCdExist", jikin) > 0;
	}

}
