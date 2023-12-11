package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
public class EmsHeaderVO {
	private String msgId;
	private String headerPath;
	private byte[] header;
}
