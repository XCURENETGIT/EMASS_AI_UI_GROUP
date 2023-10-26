package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoNologSizeVO {
	private String SERVICECD;
	private int VERSION;
	private int LOWSIZE;
	private int HIGHSIZE;
	private String SIZE_CONDITION;
}
