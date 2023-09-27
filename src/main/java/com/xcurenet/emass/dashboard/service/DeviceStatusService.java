package com.xcurenet.emass.dashboard.service;

import java.util.List;

public interface DeviceStatusService {

	public DeviceStatusVO getDeviceStatus(final String deviceSeq);

	public List<DeviceStatusVO> getDeviceStatusList( );
}
