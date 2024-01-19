package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class DomainFilterVO {
	private String domainLogSeq;
	private String groupCd;
	private String serviceCd;
	private String groupNm;
	private String serviceNm;
	private String domain;
	private String createDt;
	private String createId;
	private String updateDt;
	private String updateId;
	private String useYn;
}
