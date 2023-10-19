package com.xcurenet.emass.message.service;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
public class EmsPiVO {


	@Field(name="TYPE")
	private String type;
	@Field(name="ATTACHNAME")
	private String attachName;
	@Field(name="PI_ID")
	private String piid;
	private String piName;
	@Field(name="KWDS")
	private String kwds;
	@Field(name="AMOUNT")
	private long total;
}
