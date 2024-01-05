package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class EmsMessengerAdminXrootMtrVO {
	private String adminId;
	private String xRootMtr;
	private String msgId;
	private String userid;
	private String type;
	private String offset;
	private String temp_offset;
}
