package com.xcurenet.emass.dashboard.service;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class FileTopVO {
	private List<Object> list;

	private List<String> fileSize;

	private List<String> fileType;

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;

	private String total;
}
