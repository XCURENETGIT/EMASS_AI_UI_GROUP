package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class UserVo_Mgo {

    @Value("id")
    private String	id;  //	사용자 ID
    @Value("name")
    private String	name;  //	사용자 이름
    @Value("ipCoCd")
    private String	ipCoCd;  //	회사코드(SRC_IP기준)
    @Value("ipCoNm")
    private String	ipCoNm;  //	회사명(SRC_IP기준)
    @Value("ipBusiCd")
    private String	ipBusiCd;  //	사업장코드(SRC_IP기준)
    @Value("ipBusiNm")
    private String	ipBusiNm;  //	사명장명(SRC_IP기준)
    @Value("ipDeptCd")
    private String	ipDeptCd;  //	부서코드 IP기준
    @Value("ipDeptNm")
    private String	ipDeptNm;  //	부서명 IP기준
    @Value("coCd")
    private String	coCd;  //	회사코드
    @Value("coNm")
    private String	coNm;  //	회사명
    @Value("busiCd")
    private String	busiCd;  //	사업장 코드
    @Value("busiNm")
    private String	busiNm;  //	사업장명
    @Value("suborgCd")
    private String	suborgCd;  //	총괄코드
    @Value("suborgNm")
    private String	suborgNm;  //	총괄명
    @Value("deptCd")
    private String	deptCd;  //	부서코드
    @Value("deptNm")
    private String	deptNm;  //	부서명
    @Value("jikgubCd")
    private String	jikgubCd;  //	직급코드
    @Value("jikgubNm")
    private String	jikgubNm;  //	직급명
    @Value("ceo")
    private String	ceo;  //	CEO 여부 (Y/N)
    @Value("inside")
    private String	inside;  //	내부/외부 구분 (I/O)


}
