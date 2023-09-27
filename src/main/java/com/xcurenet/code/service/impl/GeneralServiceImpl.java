package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.GeneralService;
import com.xcurenet.code.service.GeneralVO;
import com.xcurenet.common.dao.XcnAbstractDAO;

@Service("generalService")
public class GeneralServiceImpl extends XcnAbstractDAO implements GeneralService {

	@Override
	public List<GeneralVO> getAllGeneralList() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getGeneralList", param);
	}

	@Override
	public List<GeneralVO> getGeneralList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getGeneralList", param);
	}

	@Override
	public List<GeneralVO> getGeneralListByCo(String coCd) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("coCd", coCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getGeneralListByCo", param);
	}

	@Override
	public boolean isGeneralNmExist(GeneralVO general) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isGeneralNmExist", general) > 0;
	}

	@Override
	public boolean isGeneralCdExist(GeneralVO general) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isGeneralCdExist", general) > 0;
	}

	@Override
	public int insertGeneral(GeneralVO general) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertGeneral", general);
	}

	@Override
	public int updateGeneral(GeneralVO general) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateGeneral", general);
	}

	@Override
	public int deleteGeneral(GeneralVO general) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteGeneral", general);
	}

	@Override
	public int deleteGeneralCo(CoVO co) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteGeneralCo", co);
	}
}
