package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassMLData {
	
	@Field("mlConfdClass")
	private int mlConfdClass;

	@Field("mlConfdClassOrg")
	private int mlConfdClassOrg;

	@Field("mlConfdFeedBack")
	private int mlConfdFeedBack;

	@Field("mlConfdUserId")
	private String mlConfdUserId;

	@Field("mlConfdProb")
	private double mlConfdProb;
}
