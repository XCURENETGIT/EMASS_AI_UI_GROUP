package com.xcurenet.emass.customDashboard.service;

import lombok.Data;

@Data
public class FileDataVO {
	private String url;
	private String srcIp;
	private String dstIp;
	private String statCnt;
	private String size;
	private String path;
	private String host;
	private String seq;
	private String date;
}
