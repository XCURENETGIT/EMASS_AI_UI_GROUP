package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoKeywordVO {
	private String KEYWORD;
	private int VERSION;
}
