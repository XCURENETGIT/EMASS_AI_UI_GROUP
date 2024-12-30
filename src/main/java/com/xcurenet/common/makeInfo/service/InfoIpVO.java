package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.aggregation.ArrayOperators;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@Document(collection = "INFO_IP")
public class InfoIpVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("IP")
	private String IP;

	@Field("USERID")
	private String USERID;
}
