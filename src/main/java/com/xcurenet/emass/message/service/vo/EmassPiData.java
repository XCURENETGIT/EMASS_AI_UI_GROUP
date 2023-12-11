package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@ToString
public class EmassPiData {

	@Field("id")
	private String piId;

	@Field("type")
	private String type;

	@Field("attachNm")
	private String attachName;

	@Field("kwds")
	private List<String> kwds;

	@Field("amount")
	private int amount;
}
