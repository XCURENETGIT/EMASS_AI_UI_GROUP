package com.xcurenet.emass.consent.service;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ConsentVO {
	private String no;
	private String type;
	private String name;
	private String userId;
	private String deptCd;
	private String deptNm;
	private String edate;
	private String attachedYn;
	private String searchYn;
	private String createDt;
	private String createId;
	private String createNm;
	private String purpose;
	private String appCd;
	private String userIp;
	private String userEmail;
	private MultipartFile attach;
	private String filePath;
	private String fileName;
	private String fileDeleteYn;
	private String alarmYn;
	private String alarmMailYn;
	private String alarmSmsYn;
	private String alarmMonitorYn;
	private String registrantYn;
}
