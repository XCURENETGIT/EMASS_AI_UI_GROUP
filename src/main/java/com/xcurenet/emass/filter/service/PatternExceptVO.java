package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class PatternExceptVO {
	private String patternLogSeq;
	private String privateType;
	private String pattern;
	private String createDt;
	private String createUser;
	private String useYn;
}
