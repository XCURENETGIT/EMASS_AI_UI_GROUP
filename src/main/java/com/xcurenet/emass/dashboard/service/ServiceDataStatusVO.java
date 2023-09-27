package com.xcurenet.emass.dashboard.service;

import java.util.List;

import lombok.Data;

@Data
public class ServiceDataStatusVO {

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;

	private List<List<Object>> facet;
}
