package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_ACCOUNT")
public class InfoAccountVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("USERID")
	private String USERID;

	@Field("SERVICECD")
	private String SERVICECD;

	@Field("ACCOUNT")
	private String ACCOUNT;
}
