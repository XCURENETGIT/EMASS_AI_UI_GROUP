package com.xcurenet.emass.service.service;

import lombok.Data;

@Data
public class ServiceTypeVO {
	private String serviceCd;
	private String serviceNm;
	private String serviceLv1Nm;
	private String serviceLv2Nm;
	private String inOut;
	private String groupCd;
	private String groupNm;
	private String useYn;
}
