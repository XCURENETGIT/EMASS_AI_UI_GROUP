package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_NOLOG_SIZE")
public class InfoNologSizeVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("SERVICECD")
	private String SERVICECD;

	@Field("LOWSIZE")
	private int LOWSIZE;

	@Field("HIGHSIZE")
	private int HIGHSIZE;

	@Field("SIZE_CONDITION")
	private String SIZE_CONDITION;
}
