package com.xcurenet.emass.message.service;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class ApiResponseVO {
	private boolean success;
	private String code;
	private String result;
	private String message;
	private Object data;
	private long total;
}
