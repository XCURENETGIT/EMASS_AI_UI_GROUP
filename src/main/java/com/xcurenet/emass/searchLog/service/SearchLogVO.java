package com.xcurenet.emass.searchLog.service;

import lombok.Data;

@Data
public class SearchLogVO {
	
	private long searchSeq;
	private String searchDt; 	
	private String searchId;  	
	private String searchName;
	private String searchType;
	private long pFilterSeq;
	private long filterSeq;	
	private String filterNm; 	
	private String consentNo; 	
	private String consentUserId; 	
	private String consentName;
	private String conditions;  

	private String name;
	private String userId;	
	
}
