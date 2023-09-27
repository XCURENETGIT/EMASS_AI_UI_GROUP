package com.xcurenet.common.sms;

import lombok.Data;

@Data
public class SmsVO {

	private String receiver;
	private String content;
	private String smsType;
}
