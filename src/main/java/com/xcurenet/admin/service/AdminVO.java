package com.xcurenet.admin.service;

import com.xcurenet.common.util.Common;

import lombok.Data;

@Data
public class AdminVO {

	private String adminId;

	private String adminName;

	private String adminPw;

	private String adminEmail;

	private String insideYn;

	private String adminHp;

	private String pwchgDt;

	private String lastLoginDt;

	private String lastLoginIp;

	private String status;

	private String firstAdminYn;

	private String adminType;
	
	private String adminTypeInfo;

	private String useYn;

	private String accessIp;

	private int accessFailCnt;

	private String accessFailDt;

	private String approbator;
	
	private String infoFeedbackYn;

	private String comment;

	private String createDt;

	private String loginIp;

	private int longTermUnuseDay;

	private int passwordChangeDay;

	private long aliveTime;

	private String coCd;

	private String busiCd;
	
	private String deptCd;

	private String service;

	private String regexp;
	
	private String menu;

	private String coNm;

	private String busiNm;
	
	private String searchStr;
	
	private String searchUseYn;
	
	private String oldId;
	
	private String mysqlUser;
	
	private String mysqlPw;
	
	private String mysqlOldUser;
	
	private String workStatus;
	
	private int authCocd;
	private int authBusi;
	private int authDept;
	
	private String readAuth;
	
	//외부 로그인 인증 확인을 위한 필드 타입(C: 기본, L: Ldap인증, S: SSO인증)
	private String loginType;

	public void setLoginType(String loginType) {
		if (Common.isEmpty(loginType)) loginType = "C";
		this.loginType = loginType;
	}
	
	private String encryptUseYN;
	private String encryptAlgorithm;
	private String encryptSize;
	private String encryptKey;
	
}
