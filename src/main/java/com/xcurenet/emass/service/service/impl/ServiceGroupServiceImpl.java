package com.xcurenet.emass.service.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.service.service.ServiceGroupService;
import com.xcurenet.emass.service.service.ServiceGroupVO;

@Service("serviceGroupService")
public class ServiceGroupServiceImpl extends XcnAbstractDAO implements ServiceGroupService {

	@Override
	public List<ServiceGroupVO> getServiceGroupList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceGroupList", new HashMap<String, Object>());
	}

	@Override
	public List<ServiceGroupVO> getServiceGroupList(String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.service.getServiceGroupList", param);
	}

}
