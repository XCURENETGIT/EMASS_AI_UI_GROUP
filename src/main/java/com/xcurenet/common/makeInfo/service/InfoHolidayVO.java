package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoHolidayVO {
	private int VERSION;
	private String COCD;
	private String BUSICD;
	private String DATE;
	private String COMMENTS;
}
