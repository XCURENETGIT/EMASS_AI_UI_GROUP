package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_WORKDAY")
public class InfoWorkdayVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("COCD")
	private String COCD;

	@Field("BUSICD")
	private String BUSICD;

	@Field("WDAY")
	private String WDAY;

	@Field("WHOUR")
	private String WHOUR;
}
