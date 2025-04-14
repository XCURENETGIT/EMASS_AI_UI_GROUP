package com.xcurenet.emass.iprange.service;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class IpRangeVO {
	private String coCd;
	private String coNm;
	private String busiCd;
	private String busiNm;
	private String pdeptCd;
	private String pdeptNm;
	private String deptCd;
	private String deptNm;
	private String startIp;
	private String endIp;
	private String orgStartIp;
	private String orgEndIp;
	private String comment;
	private String createDt;
	private String createId;
	private String updateDt;
	private String updateId;
	private String country;
	
	private MultipartFile attach;
	private String encoding;
	private String separator;
}
