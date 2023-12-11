package com.xcurenet.emass.message.service;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@ToString
public class EmassRecvData {
	@Field("to")
	private List<EmassMailPropertiesData> to;

	@Field("cc")
	private List<EmassMailPropertiesData> cc;

	@Field("bcc")
	private List<EmassMailPropertiesData> bcc;
}
