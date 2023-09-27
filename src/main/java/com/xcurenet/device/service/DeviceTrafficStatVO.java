package com.xcurenet.device.service;

import lombok.Data;

@Data
public class DeviceTrafficStatVO {
	private String deviceSeq;
	private String updateDt;
	private String port;
	private int direction;
	private int hourSize;
	private int hourCnt;
	private String insertDt;
}
