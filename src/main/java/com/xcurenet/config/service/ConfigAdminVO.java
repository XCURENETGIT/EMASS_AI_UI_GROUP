package com.xcurenet.config.service;

import lombok.Data;

@Data
public class ConfigAdminVO {
	private String confId;
	private String adminId;
	private String val;
	private String defaultVal;
	private String updateDt;
}
