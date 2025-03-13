package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class LlmVO {

	private String llmConf;
	private String llmPromt;
	private String llmModel;
	private String llmContent;
}
