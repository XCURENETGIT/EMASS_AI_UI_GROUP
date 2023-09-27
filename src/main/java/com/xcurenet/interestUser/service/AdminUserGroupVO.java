package com.xcurenet.interestUser.service;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import lombok.Data;

@JsonInclude(Include.NON_NULL)
@Data
public class AdminUserGroupVO {
	private String groupSeq;
	private String adminId;
	private String groupName;
	private String groupColor;
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
	private String pdeptNm;
	private String pdeptCd;
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
	private int NUM;
}
