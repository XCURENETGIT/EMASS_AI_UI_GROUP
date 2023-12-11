package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassDayData {

	@Field("week")
	private int week;
	
	@Field("work")
	private String work;
}
