package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.code.service.BusiService;
import com.xcurenet.code.service.BusiVO;
import com.xcurenet.code.service.CoVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.iprange.service.IpRangeService;

@Service("busiService")
public class BusiServiceImpl extends XcnAbstractDAO implements BusiService {
	
	@Autowired
	public IpRangeService ipRangeService;

	@Override
	public List<BusiVO> getAllBusiList() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getBusiList", param);
	}

	@Override
	public List<BusiVO> getBusiList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getBusiList", param);
	}

	@Override
	public List<BusiVO> getBusiListByCo(String coCd) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("coCd", coCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getBusiListByCo", param);
	}

	@Override
	public boolean isBusiNmExist(BusiVO busi) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isBusiNmExist", busi) > 0;
	}

	@Override
	public boolean isBusiCdExist(BusiVO busi) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isBusiCdExist", busi) > 0;
	}

	@Override
	public int insertBusi(BusiVO busi) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertBusi", busi);
	}

	@Override
	public int updateBusi(BusiVO busi) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateBusi", busi);
	}

	@Override
	public int deleteBusi(BusiVO busi) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			ipRangeService.deleteIpRange(busi);
			delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteBusi", busi);
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteBusiCo(CoVO co) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteBusiCo", co);
	}




}
