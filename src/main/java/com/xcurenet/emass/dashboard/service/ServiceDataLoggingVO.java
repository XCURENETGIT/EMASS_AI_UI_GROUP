package com.xcurenet.emass.dashboard.service;

import java.util.List;

import lombok.Data;

@Data
public class ServiceDataLoggingVO {

	private String adminId;
	
	private String startDt;
	
	private String endDt;

	private String termDtStr;

	private List<List<Object>> facet;
}
