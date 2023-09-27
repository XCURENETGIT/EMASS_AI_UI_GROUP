package com.xcurenet.common.snmp.service;

import lombok.Data;

@Data
public class SnmpTrapVO {
	private String eventDt;
	private int seq;
	private String deviceNm;
	private String deviceIp;
	private String masterIp;
	private String devision;
	private String eventLevel;
	private String title;
	private String content;
}
