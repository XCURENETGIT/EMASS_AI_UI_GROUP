package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class SizeFilterVO {
	private String sizeLogSeq;
	private String groupCd;
	private String serviceCd;
	private String groupNm;
	private String serviceNm;
	private String lowSize;
	private String highSize;
	private String sizeCondition;
	private String createDt;
	private String useYn;
}
