package com.xcurenet.code.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.code.service.CoVO;
import com.xcurenet.code.service.DeptService;
import com.xcurenet.code.service.DeptVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.iprange.service.IpRangeDeptService;

@Service("deptService")
public class DeptServiceImpl extends XcnAbstractDAO implements DeptService {
	
	@Autowired
	private IpRangeDeptService ipRangeDeptService;

	@Override
	public List<DeptVO> getAllDeptList() {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", 0);
		param.put("limit", 0);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getDeptList", param);
	}

	@Override
	public List<DeptVO> getDeptList(String searchStr, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getDeptList", param);
	}

	@Override
	public List<DeptVO> getDeptListByCo(String coCd) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("coCd", coCd);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getDeptListByCo", param);
	}

	@Override
	public boolean isDeptNmExist(DeptVO dept) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isDeptNmExist", dept) > 0;
	}

	@Override
	public boolean isDeptCdExist(DeptVO dept) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.code.isDeptCdExist", dept) > 0;
	}

	@Override
	public int insertDept(DeptVO dept) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.code.insertDept", dept);
	}

	@Override
	public int updateDept(DeptVO dept) {
		return update("com.xcurenet.sqlmap.mappers.mysql.code.updateDept", dept);
	}

	@Override
	public int deleteDept(DeptVO dept) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			ipRangeDeptService.deleteIpRangeDept(dept);
			delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteDept", dept);
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteDeptCo(CoVO co) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.code.deleteDeptCo", co);
	}
}
