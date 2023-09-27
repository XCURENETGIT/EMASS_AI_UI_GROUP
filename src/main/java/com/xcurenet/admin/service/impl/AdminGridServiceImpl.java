package com.xcurenet.admin.service.impl;

import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminGridService;
import com.xcurenet.admin.service.AdminGridVO;
import com.xcurenet.common.dao.XcnAbstractDAO;

@Service("adminGridService")
public class AdminGridServiceImpl extends XcnAbstractDAO implements AdminGridService {

	@Override
	public AdminGridVO getGridHeader(final AdminGridVO grid) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.admin.getGridHeader", grid);
	}

	@Override
	public int updateGridHeader(final AdminGridVO grid) {
		return update("com.xcurenet.sqlmap.mappers.mysql.admin.updateGridHeader", grid);
	}
}
