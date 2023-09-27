package com.xcurenet.emass.adminFilter.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.adminFilter.service.AdminFilterService;
import com.xcurenet.emass.adminFilter.service.AdminFilterVO;
import com.xcurenet.emass.dashboard.service.DashBoardService;
import com.xcurenet.emass.dashboard.service.DashboardVO;

import net.sf.json.JSONObject;

@Service("AdminFilterService")
public class AdminFilterServiceImpl extends XcnAbstractDAO implements AdminFilterService {

	@Autowired
	private DashBoardService dashBoardService;

	@Override
	public List<AdminFilterVO> getAdminFilterList(String adminId, String searchStr, String contextPath) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		param.put("searchStr", searchStr);
		param.put("contextPath", contextPath);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminFilter.getAdminFilterList", param);
	}

	@Override
	public List<AdminFilterVO> getAdminFilterListForExport(JSONObject param) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.adminFilter.getAdminFilterListForExport", param);
	}

	@Override
	public int setAdminFilterListForImport(List<AdminFilterVO> filterVos) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		Map<Long, Long> ids = new HashMap<Long, Long>();
		try {
			tx.start();
			long nextId = getNextAdminFilterId();
			for (int i = 0; i < filterVos.size(); i++) {
				AdminFilterVO adminFilter = filterVos.get(i);
				long newId = nextId+i;
				long oldId = adminFilter.getId();
				long oldPId = adminFilter.getpId();
				ids.put(oldId, newId);
				
				long newPId = Common.isEmpty(ids.get(oldPId)) ? 1000 : ids.get(adminFilter.getpId());
				
				adminFilter.setId(newId);
				adminFilter.setpId(newPId);
				result = insert("com.xcurenet.sqlmap.mappers.mysql.adminFilter.insertAdminFilter", adminFilter);
			}
			
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	public static void main(String[] args) {
		Map<Long, Long> ids = new HashMap<Long, Long>();
		System.out.println(ids.get(1024));
	}

	@Override
	public AdminFilterVO getAdminFilter(long filterSeq) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.adminFilter.getAdminFilter", filterSeq);
	}

	@Override
	public int insertAdminFilter(AdminFilterVO adminFilter) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			adminFilter.setId(getNextAdminFilterId());
			result = insert("com.xcurenet.sqlmap.mappers.mysql.adminFilter.insertAdminFilter", adminFilter);

			DashboardVO dashboard = new DashboardVO();
			dashboard.setAdminId(adminFilter.getAdminId());
			dashboard.setDashKey(adminFilter.getDashboard());
			dashboard.setDashVal(Common.nvl(adminFilter.getId()));
			dashBoardService.saveDashBoardConfig(dashboard);

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int updateAdminFilter(AdminFilterVO adminFilter) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = update("com.xcurenet.sqlmap.mappers.mysql.adminFilter.updateAdminFilter", adminFilter);

			DashboardVO dashboard = new DashboardVO();
			dashboard.setAdminId(adminFilter.getAdminId());
			dashboard.setDashKey(adminFilter.getDashboard());
			dashboard.setDashVal(Common.nvl(adminFilter.getId()));

			dashBoardService.initDashBoardConfig(dashboard);
			dashBoardService.saveDashBoardConfig(dashboard);

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int updateFilterStatus(AdminFilterVO AdminFilter) {
		return update("com.xcurenet.sqlmap.mappers.mysql.adminFilter.updateFilterStatus", AdminFilter);
	}

	@Override
	public int deleteAdminFilter(List<AdminFilterVO> filterVos) {
		int rs = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AdminFilterVO adminFilter : filterVos) {
				rs += update("com.xcurenet.sqlmap.mappers.mysql.adminFilter.deleteFilterStatus", adminFilter);

				DashboardVO dashboard = new DashboardVO();
				dashboard.setAdminId(adminFilter.getAdminId());
				dashboard.setDashKey(adminFilter.getDashboard());
				dashboard.setDashVal(Common.nvl(adminFilter.getId()));

				dashBoardService.initDashBoardConfig(dashboard);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return rs;
	}

	@Override
	public int updateFilterOrder(List<AdminFilterVO> filterVos) {
		int rs = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AdminFilterVO filterVo : filterVos) {
				rs += update("com.xcurenet.sqlmap.mappers.mysql.adminFilter.updateFilterOrder", filterVo);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return rs;
	}

	@Override
	public long getNextAdminFilterId() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.adminFilter.getNextAdminFilterId");
	}
}
