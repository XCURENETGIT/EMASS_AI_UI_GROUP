package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassHttpData {
	
	@Field("host")
	private String host;

	@Field("path")
	private String path;

	@Field("query")
	private String query;

	@Field("header")
	private String header;

}
