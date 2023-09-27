package com.xcurenet.emass.dashboard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.dashboard.service.DeviceStatusService;
import com.xcurenet.emass.dashboard.service.DeviceStatusVO;

@Service("deviceStatusService")
public class DeviceStatusServiceImpl extends XcnAbstractDAO implements DeviceStatusService {

	@Override
	public DeviceStatusVO getDeviceStatus(final String deviceSeq) {
		Map<String, String> params = new HashMap<>();
		params.put("deviceSeq", deviceSeq);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.dashboard.getDeviceStatus", params);
	}

	@Override
	public List<DeviceStatusVO> getDeviceStatusList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.dashboard.getDeviceStatusList");
	}

}
