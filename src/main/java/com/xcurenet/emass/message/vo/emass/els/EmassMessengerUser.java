package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class EmassMessengerUser {

	@JsonProperty("attachCnt")
	private int	attachCnt;	//첨부파일 개수
	@JsonProperty("body_size")
	private int body_size;
	@JsonProperty("sender")
	private String sender;
	@JsonProperty("usrIp")
	private String	usrIp;
	@JsonProperty("usr_Id")
	private String	usr_Id;	//사용자구분 아이디
	@JsonProperty("coNm")
	private String	coNm; //	회사명
	@JsonProperty("deptNm")
	private String	deptNm; //	부서명
	@JsonProperty("jikgubNm")
	private String	jikgubNm; //	직급명




}
