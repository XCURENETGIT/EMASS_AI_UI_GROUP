package com.xcurenet.emass.analysis.service;

import lombok.Data;

public @Data class SearchVO {
	private String adminId;
	private String item;
	private String itemName;
	private String unit;
	private String startDate;
	private String endDate;
	private String date;
	private String title;
	private String sendUser;
	private String receiveUser;
	private String observePersonnel;
	private String keyPersonnel;
	private String keyword;
	private String name;
	private String listData;
	private String interGroup;
	private String query;
	private Integer fileSize;
	private Integer offset;
	private Integer limit;
}
