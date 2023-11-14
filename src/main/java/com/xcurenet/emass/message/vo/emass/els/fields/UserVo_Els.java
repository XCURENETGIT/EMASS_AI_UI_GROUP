package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class UserVo_Els {
    private String	userid;	//사용자 ID
    private String	name;   //사용자 이름
    private String	ip_cocd;    //회사코드 IP기준
    private String	ip_conm;    //회사명 IP기준
    private String	ip_busicd;  //	사업장코드 IP기준
    private String	ip_businm;  //	사명장명 IP기준
    private String	ip_deptcd;  //	부서코드 IP기준
    private String	ip_deptnm;  //	부서명 IP기준
    private String	cocd;   //	회사코드
    private String	conm;   //	회사명
    private String	busicd;	//사업장 코드
    private String	businm; // 사업장명
    private String	suborgcd;   //	총괄코드
    private String	suborgnm;   //	총괄명
    private String	deptcd;	    //부서코드
    private String	deptnm; 	//부서명
    private String	jikgubcd;   //	직급코드
    private String	jikgubnm;   //	직급명
    private boolean	ceo;    //CEO 여부
    private boolean	inside;	//내부/외부 구분

}
