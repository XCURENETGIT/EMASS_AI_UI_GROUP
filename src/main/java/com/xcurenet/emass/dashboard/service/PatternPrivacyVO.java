package com.xcurenet.emass.dashboard.service;

import lombok.Data;

@Data
public class PatternPrivacyVO {

	private String total;

	private String unRead;

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;
}
