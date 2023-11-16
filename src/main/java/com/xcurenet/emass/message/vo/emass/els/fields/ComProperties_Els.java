package com.xcurenet.emass.message.vo.emass.els.fields;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class ComProperties_Els {

    @JsonProperty("alias")
    private String	alias; //	발신자 별칭
    @JsonProperty("id")
    private String	id; //	발신자 ID
    @JsonProperty("userId")
    private String	userId; //	발신자 아이디(인사연동)
    @JsonProperty("name")
    private String	name; //	발신자 이름(인사연동)
    @JsonProperty("email")
    private String	email; //	발신자 이메일 (인사연동)
    @JsonProperty("ip")
    private String	ip; //	수신자 아이피
    @JsonProperty("coCd")
    private String	coCd; //	회사코드
    @JsonProperty("coNm")
    private String	coNm; //	회사명
    @JsonProperty("busiCd")
    private String	busiCd; //	사업장 코드
    @JsonProperty("busiNm")
    private String	busiNm; //	사업장명
    @JsonProperty("suborgCd")
    private String	suborgCd; //	총괄코드
    @JsonProperty("suborgNm")
    private String	suborgNm; //	총괄명
    @JsonProperty("deptCd")
    private String	deptCd; //	부서코드
    @JsonProperty("deptNm")
    private String	deptNm; //	부서명
    @JsonProperty("jikgubCd")
    private String	jikgubCd; //	직급코드
    @JsonProperty("jikgubNm")
    private String	jikgubNm; //	직급명
    @JsonProperty("ceo")
    private String	ceo; //	CEO 여부
    @JsonProperty("inside")
    private String	inside; //	내부/외부 구분

}
