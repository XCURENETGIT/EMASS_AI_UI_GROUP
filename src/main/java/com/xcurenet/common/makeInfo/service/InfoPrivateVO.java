package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoPrivateVO {
	private String CODE;
	private int VERSION;
	private String REGEX;
}
