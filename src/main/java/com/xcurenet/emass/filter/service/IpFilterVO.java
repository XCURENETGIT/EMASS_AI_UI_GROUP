package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class IpFilterVO {
	private String ipLogSeq;
	private String userId;
	private String groupNm;
	private String serviceCd;
	private String serviceNm;
	private String userIpAll;
	private String userSIp;
	private String userEIp;
	private String userPortAll;
	private String userSPort;
	private String userEPort;
	private String serverIpAll;
	private String serverSIp;
	private String serverEIp;
	private String serverPortAll;
	private String serverSPort;
	private String serverEPort;
	private String comment;
	private String createDt;
	private String createId;
	private String updateDt;
	private String updateId;
	private String useYn;
	private String deviceInfo;
	private String deviceSeq;
	private String deviceIp;
	private String deviceNm;
	private String code;
	private String codeName;
	private String userIpDesc;
	private String serverIpDesc;
	private String userPortDesc;
	private String serverPortDesc;
	private String ruleVersion;
	private String protocol;
	private String action;
	private String ipVer;
}
