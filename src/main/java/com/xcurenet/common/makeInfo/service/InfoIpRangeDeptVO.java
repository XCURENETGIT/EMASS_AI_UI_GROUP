package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoIpRangeDeptVO {
	private int VERSION;
	private String SLP;
	private String EIP;
	private String DEPTCD;
	private String DEPTNM;
	private String COCD;
	private String CONM;
	private String INSIDE;
}
