package com.xcurenet.emass.dashboard.service;

import lombok.Data;

@Data
public class TodayPatternVO {
	private String total;

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;

	//주민 번호
	private String pi_SN;

	//카드번호
	private String pi_CN;

	//확장자 변조 파일
	private String pi_EC;

	//외국인 등록번호
	private String pi_FN;

	//운전면허번호
	private String pi_DN;

	//여권번호
	private String  pi_PN;


}
