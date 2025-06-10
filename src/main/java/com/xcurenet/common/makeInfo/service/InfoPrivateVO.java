package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_PRIVATE")
public class InfoPrivateVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("CODE")
	private String CODE;

	@Field("REGEX")
	private String REGEX;

	@Field("ENABLE")
	private String ENABLE;

}
