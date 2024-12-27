package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_NOLOG_URL")
public class InfoNologUrlVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("URL")
	private String URL;
}
