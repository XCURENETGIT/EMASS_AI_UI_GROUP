package com.xcurenet.emass.message.vo.emass.mongo.fields;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class ComProperties_Mgo {
    @Value("alias")
    private String	alias;   //	발신자 별칭
    @Value("id")
    private String	id;   //	발신자 ID
    @Value("userId")
    private String	userId;   //	발신자 아이디(인사연동)
    @Value("name")
    private String	name;   //	발신자 이름
    @Value("email")
    private String	email;   //	발신자 MAIL
    @Value("ip")
    private String	ip;   //	수신자 아이피
    @Value("coCd")
    private String	coCd;   //	회사코드
    @Value("coNm")
    private String	coNm;   //	회사명
    @Value("busiCd")
    private String	busiCd;   //	사업장 코드
    @Value("busiNm")
    private String	busiNm;   //	사업장명
    @Value("suborgCd")
    private String	suborgCd;   //	총괄코드
    @Value("suborgNm")
    private String	suborgNm;   //	총괄명
    @Value("deptCd")
    private String	deptCd;   //	부서코드
    @Value("deptNm")
    private String	deptNm;   //	부서명
    @Value("jikgubCd")
    private String	jikgubCd;   //	직급코드
    @Value("jikgubNm")
    private String	jikgubNm;   //	직급명
    @Value("ceo")
    private String	ceo;   //	CEO 여부
    @Value("inside")
    private String	inside;   //	내부/외부 구분

}