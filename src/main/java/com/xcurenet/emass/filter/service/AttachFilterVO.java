package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class AttachFilterVO {
	private String attachLogSeq;
	private String groupCd;
	private String serviceCd;
	private String groupNm;
	private String serviceNm;
	private String attach;
	private String createDt;
	private String useYn;
}
