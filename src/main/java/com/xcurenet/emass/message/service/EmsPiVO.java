package com.xcurenet.emass.message.service;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
public class EmsPiVO {
	private String type;
	private String attachName;
	private String piid;
	private String piName;
	private String kwds;
	private long total;
	private boolean customPattern;
}

