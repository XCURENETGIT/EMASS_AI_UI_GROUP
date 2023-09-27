package com.xcurenet.device.service;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class DeviceTrafficStatListVO {
	private List<Map<String, String>> header;
	private List<Map<String, Object>> data;

}
