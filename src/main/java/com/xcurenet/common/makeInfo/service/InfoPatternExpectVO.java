package com.xcurenet.common.makeInfo.service;

import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_PATTERN_EXCEPT")
public class InfoPatternExpectVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("PRIVATETYPE")
	private String PRIVATETYPE;

	@Field("PATTERN")
	private String PATTERN;
}
