package com.xcurenet.emass.dashboard.service;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class FileTopVO {

	private List<String> fileSize;

	private List<String> fileType;

	private List<String> fileName;
	private List<String> fileId;

	private List<String> user;

	private List<List<Object>> facet;

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;

	private String total;
}
