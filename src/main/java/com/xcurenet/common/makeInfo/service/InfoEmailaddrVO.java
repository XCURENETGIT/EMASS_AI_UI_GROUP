package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoEmailaddrVO {
	private String EMAILADDR;
	private String USERID;
	private int VERSION;
}
