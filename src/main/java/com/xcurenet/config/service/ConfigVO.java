package com.xcurenet.config.service;

import lombok.Data;

@Data
public class ConfigVO {
	private String confId;
	private String val;
	private String defaultVal;
	private String updateDt;
}
