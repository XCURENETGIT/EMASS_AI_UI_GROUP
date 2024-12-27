package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_EMAILADDR")
public class InfoEmailaddrVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("EMAILADDR")
	private String EMAILADDR;

	@Field("USERID")
	private String USERID;
}
