package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassBodyData {
	
	@Field("size")
	private int bodySize;

	@Field("imgCnt")
	private int bodyImageCnt;

	@Field("bodyCharset")
	private String bodyCharset;
	
	@Field("path")
	private String bodyPath;
	
	@Field("textPath")
	private String bodyTextPath;
	
	@Field("hash")
	private String bodyHash;

	private String body_snippet;
}
