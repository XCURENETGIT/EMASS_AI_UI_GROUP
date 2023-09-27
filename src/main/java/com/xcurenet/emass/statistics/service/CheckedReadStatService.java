package com.xcurenet.emass.statistics.service;

import java.util.Map;



public interface CheckedReadStatService {
	public Map<String, Object> getCheckedReadStatList(String xAxis, String startDate, String endDate, String adminType, String adminId);
}
