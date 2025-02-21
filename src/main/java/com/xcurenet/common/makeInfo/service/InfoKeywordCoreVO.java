package com.xcurenet.common.makeInfo.service;

import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_KEYWORD_CORE")
public class InfoKeywordCoreVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("KEYWORD")
	private String KEYWORD;

	@Field("CATEGORY")
	private String CATEGORY;
}
