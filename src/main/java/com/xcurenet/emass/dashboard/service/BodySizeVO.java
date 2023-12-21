package com.xcurenet.emass.dashboard.service;

import lombok.Data;

import java.util.List;

@Data
public class BodySizeVO {

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;

	private List<List<Object>> data;
}
