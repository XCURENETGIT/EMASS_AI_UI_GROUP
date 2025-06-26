package com.xcurenet.config.service;

import lombok.Data;

@Data
public class AbnlDetectConfigVO {
	private String adminId;
	private String abnlCode;
	private String abnlName;
	private String alarmType;
	private String adminEmail;
	private String adminHp;
}
