package com.xcurenet.interestUser.service;

import lombok.Data;

@Data
public class InterestSimpleUserVO {
	private String userSeq;
	private String adminId;
	private String userType;
	private String userNm;
	private String userId;
	private String comment;

	private String userIp;
	private String userEmail;
	private String cnt;
}
