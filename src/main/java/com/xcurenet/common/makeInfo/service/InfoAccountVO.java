package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoAccountVO {
	private String USERID;
	private int VERSION;
	private String SERVICECD;
	private String ACCOUNT;
}
