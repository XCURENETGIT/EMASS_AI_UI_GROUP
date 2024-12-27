package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_KEYWORD")
public class InfoKeywordVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("KEYWORD")
	private String KEYWORD;
}
