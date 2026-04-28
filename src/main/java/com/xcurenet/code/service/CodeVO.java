package com.xcurenet.code.service;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import lombok.Data;

@JsonInclude(Include.NON_NULL)
@Data
public class CodeVO {
	private String deviceSeq;
	private String codeType;
	private String code;
	private String codeName;
	private String searchStr;
	private String adminId;
	private String coCd;
	private String tempCode1;
	private String tempNm1;
	private String tempCode2;
	private String tempNm2;
	private String useYn;
	private String ceoReadAuth;
	private String email;
	private String isAuto;
}
