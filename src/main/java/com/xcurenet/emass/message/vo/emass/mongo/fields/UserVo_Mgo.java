package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class UserVo_Mgo {
    private String	id;	 //사용자 ID
    private String	name; //	사용자 이름
    private String	ipCoCd;	//회사코드(SRC_IP기준)
    private String	ipCoNm;	//회사명(SRC_IP기준)
    private String	ipBusiNm; //	사명장명(SRC_IP기준)
    private String	ipBusiCd; //	사업장코드(SRC_IP기준)
    private String	coCd; //	회사코드
    private String	coNm; //	회사명
    private String	busiCd;	//사업장 코드
    private String	busiNm;	//사업장명
    private String	suborgCd; //	총괄코드
    private String	suborgNm; //	총괄명
    private String	deptNm;	 //부서명
    private String	deptCd;	 //부서코드
    private String	jikgubNm; //직급명
    private String	jikgubCd;   //	직급코드
    private String	ceo;    //CEO 여부
    private boolean	inside;	//내부/외부 구분

}
