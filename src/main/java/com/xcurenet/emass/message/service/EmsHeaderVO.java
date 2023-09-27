package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class EmsHeaderVO {
	private String msgId;
	private String headerPath;
	private byte[] header;
}
