package com.xcurenet.emass.dashboard.service;

import lombok.Data;

import java.util.List;
@Data
public class AbnlBhavDetectedVO {

	private String adminId;

	private String startDt;

	private String endDt;

	private String termDtStr;

	private List<List<Object>> facet;

}
