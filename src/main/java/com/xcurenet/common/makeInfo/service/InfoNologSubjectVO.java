package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoNologSubjectVO {
	private String SUBJECT;
	private String SERVICECD;
	private int VERSION;
}
