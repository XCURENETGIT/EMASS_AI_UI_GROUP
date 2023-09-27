package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.code.service.BusiService;
import com.xcurenet.code.service.CoService;
import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.DeptService;
import com.xcurenet.code.service.GeneralService;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.iprange.service.IpRangeService;
import com.xcurenet.user.service.UserService;

@Service("coService")
public class CoServiceImpl extends XcnAbstractDAO implements CoService {

	@Resource(name = "busiService")
	public BusiService busiService;

	@Resource(name = "userService")
	public UserService userService;

	@Resource(name = "generalService")
	public GeneralService generalService;

	@Resource(name = "deptService")
	public DeptService deptService;

	@Autowired
	public IpRangeService ipRangeService;

	@Override
	public int getCoListTotal(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.code.getCoListTotal", param);
	}

	@Override
	public List<CoVO> getAllCoList() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCoList", param);
	}

	@Override
	public List<CoVO> getCoList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCoList", param);
	}

	@Override
	public int insertCo(CoVO co) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertCo", co);
	}

	@Override
	public int updateCo(CoVO co) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateCo", co);
	}

	@Override
	public int deleteCo(CoVO co) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			userService.updateUserCo(co);
			busiService.deleteBusiCo(co);
			generalService.deleteGeneralCo(co);
			deptService.deleteDeptCo(co);
			ipRangeService.deleteIpRange(co);
			delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteCo", co);
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public boolean isCoNmExist(CoVO co) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isCoNmExist", co) > 0;
	}

	@Override
	public boolean isCoCdExist(CoVO co) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isCoCdExist", co) > 0;
	}
}
