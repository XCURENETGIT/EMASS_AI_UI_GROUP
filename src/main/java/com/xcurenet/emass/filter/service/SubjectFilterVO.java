package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class SubjectFilterVO {
	private String subjectLogSeq;
	private String groupCd;
	private String serviceCd;
	private String groupNm;
	private String serviceNm;
	private String subject;
	private String createDt;
	private String useYn;
}
