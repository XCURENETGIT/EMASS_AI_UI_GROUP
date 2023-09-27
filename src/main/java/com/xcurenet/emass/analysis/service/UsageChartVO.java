package com.xcurenet.emass.analysis.service;

import lombok.Data;

public @Data class UsageChartVO {
	private String key;
	private String date;
	private int dayOfWeek;
	private int weekOfMonth;
	private long value;
	private long average;
}
