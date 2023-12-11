package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.joda.time.DateTime;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassCheckedData {

	@Field("readId")
	private String readId;
	
	@Field("readDate")
	private DateTime readDate;
}
