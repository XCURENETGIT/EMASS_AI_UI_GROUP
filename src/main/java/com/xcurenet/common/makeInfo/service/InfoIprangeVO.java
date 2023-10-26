package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoIprangeVO {
	private String BUSICD;
	private String BUSINM;
	private String CITY;
	private String COCD;
	private String CONM;
	private String COUNTRY;
	private String EIP;
	private String INSIDE;
	private String LATITUDE;
	private String LONGITUDE;
	private String SLP;
	private int VERSION;
}
