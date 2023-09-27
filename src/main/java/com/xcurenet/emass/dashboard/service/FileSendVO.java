package com.xcurenet.emass.dashboard.service;

import lombok.Data;

@Data
public class FileSendVO {

	private String total;

	private long fileSize;

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;
}
