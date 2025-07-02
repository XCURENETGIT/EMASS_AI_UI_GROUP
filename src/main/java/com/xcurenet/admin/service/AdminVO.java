package com.xcurenet.admin.service;

import com.xcurenet.common.util.Common;

import com.xcurenet.config.service.ConfigAdminVO;
import lombok.Data;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

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

	private List<ConfigAdminVO> adminConfList;

	/* 이상 행위 필드 */
	private String abnlAlarmHidden;
	private String abnlMailHidden;
	private String abnlSmsHidden;

	public ConfigAdminVO getAdminConf(String confId) {
		if(adminConfList == null) return null;

		return adminConfList.stream().filter(adminConf -> adminConf.getConfId().equals(confId)).findFirst().orElse(null);
	}

	public List<ConfigAdminVO> getAdminConfOption(){
		if(adminConfList == null) return null;

		String[] options = new String[] {"body.snippet.sum.use","toccbcc.sum.use","toccbcc.sum.count","message.overlap.use","message.keyword.highlight","host.query.use","session.info"};

		return adminConfList.stream().filter(adminConf -> Arrays.asList(options).contains(adminConf.getConfId())).collect(Collectors.toList());
	}
	
}
