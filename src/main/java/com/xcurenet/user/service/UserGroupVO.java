package com.xcurenet.user.service;

import lombok.Data;

@Data
public class UserGroupVO {
	private String groupCode;
	private String groupName;
	private long listSeq;
	private String userId;
	private String userNm;
	private String coCd;
	private String coNm;
	private String generalCd;
	private String generalNm;
	private String busiCd;
	private String busiNm;
	private String deptCd;
	private String deptNm;
	private String jikinCd;
	private String jikinNm;
	private String jikgubCd;
	private String jikgubNm;
	private String ceo;
	private String userIp;
	private String userEmail;
	private String encryptUseYN;
	private String encryptAlgorithm;
	private String encryptSize;
	private String encryptKey;
	private String pdeptCd;
	private String pdeptNm;
}
