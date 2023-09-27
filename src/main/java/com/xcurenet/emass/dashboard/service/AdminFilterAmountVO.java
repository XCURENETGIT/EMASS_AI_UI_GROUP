package com.xcurenet.emass.dashboard.service;

import lombok.Data;

@Data
public class AdminFilterAmountVO {

	private String total;

	private String startDt;

	private String endDt;

	private String adminId;

	private long filterSeq;

	private String filterNm;

	private String termDtStr;
}
