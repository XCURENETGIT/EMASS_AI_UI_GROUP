package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class UserVo_Els {

	@JsonProperty("id")
	private String	id; //	사용자 ID
	@JsonProperty("userId")
	private String userId; //	사용자 ID (인사연동 기준 아이디 기존)
	@JsonProperty("name")
	private String	name; //	사용자 이름
	@JsonProperty("ipCoCd")
	private String	ipCoCd; //	회사코드 IP기준
	@JsonProperty("ipCoNm")
	private String	ipCoNm; //	회사명 IP기준
	@JsonProperty("ipBusiCd")
	private String	ipBusiCd; //	사업장코드 IP기준
	@JsonProperty("ipBusiNm")
	private String	ipBusiNm; //	사명장명 IP기준
	@JsonProperty("ipDeptCd")
	private String	ipDeptCd; //	부서코드 IP기준
	@JsonProperty("ipDeptNm")
	private String	ipDeptNm; //	부서명 IP기준
	@JsonProperty("coCd")
	private String	coCd; //	회사코드
	@JsonProperty("coNm")
	private String	coNm; //	회사명
	@JsonProperty("busiCd")
	private String	busiCd; //	사업장 코드
	@JsonProperty("busiNm")
	private String	busiNm; //
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
