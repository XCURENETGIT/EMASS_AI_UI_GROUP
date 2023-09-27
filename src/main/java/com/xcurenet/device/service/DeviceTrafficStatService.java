package com.xcurenet.device.service;

import java.util.List;
import java.util.Map;

public interface DeviceTrafficStatService {

	public List<Map<String, Object>> getTrafficStatList_Hour(final String startDt, final String endDt);

	public List<Map<String, Object>> getTrafficStatList_Week(final String startDt, final String endDt);

	public List<Map<String, Object>> getTrafficStatList_Day(final String startDt, final String endDt);

	public List<Map<String, Object>> getTrafficStatList_Month(final String startDt, final String endDt);

	public int updateDeviceTraffic(final DeviceTrafficStatVO traffic);

}