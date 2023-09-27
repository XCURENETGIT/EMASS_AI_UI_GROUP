package com.xcurenet.emass.dashboard.service;

import lombok.Data;

@Data
public class DeviceStatusVO {

	private int deviceSeq;

	private String deviceIP;

	private String deviceName;

	private String deviceType;

	private String deviceStatus;
}
