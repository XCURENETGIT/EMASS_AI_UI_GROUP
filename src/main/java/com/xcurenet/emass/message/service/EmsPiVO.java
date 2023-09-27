package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class EmsPiVO {
	private String type;
	private String attachName;
	private String piid;
	private String piName;
	private String kwds;
	private long total;
}
