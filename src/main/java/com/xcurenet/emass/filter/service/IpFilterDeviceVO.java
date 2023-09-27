package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class IpFilterDeviceVO {
	private int deviceSeq;
	private int deviceName;
	private int ipLogSeq;
	private int version;
	private String rutime;
}
