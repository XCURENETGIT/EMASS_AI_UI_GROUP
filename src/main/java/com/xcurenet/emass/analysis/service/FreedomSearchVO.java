package com.xcurenet.emass.analysis.service;

import lombok.Data;

public @Data class FreedomSearchVO {
	private String[] andOr;
	private String[] beforePparen;
	private String[] termsColumn;
	private String[] compare;
	private String[] context;
	private String[] sizeNum;
	private String[] startDate;
	private String[] endDate;
	private String[] serviceCd;
	private String[] afterPparen;
	
	private String[] column;

	private String[] groupBy;
	private String[] groupData;

	private String query;
	private Integer offset;
	private Integer limit;
	
	private String adminId;
}
