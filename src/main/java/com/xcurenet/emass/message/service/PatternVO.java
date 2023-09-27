package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class PatternVO {
	private String code;
	private String name;
	private String regex;
	private String unitId;
	private String adminId;
	private String searchStr;
}
