package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class IdFilterVO {
	private String idLogSeq;
	private String groupCd;
	private String serviceCd;
	private String groupNm;
	private String serviceNm;
	private String userId;
	private String createDt;
	private String createId;
	private String updateDt;
	private String updateId;
	private String useYn;
}
