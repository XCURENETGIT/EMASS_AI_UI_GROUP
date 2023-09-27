package com.xcurenet.emass.customDashboard.service;

import lombok.Data;

@Data
public class HdfsVO {
	private String date;
	private String remaining;
	private String used;
	private String total;
	private String usedP;
}
