package com.xcurenet.emass.message.service;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassMailPropertiesData {
	@Field("alias")
	private String alias;

	@Field("id")
	private String id;

	@Field("userId")
	private String userId;

	@Field("name")
	private String name;

	@Field("email")
	private String email;

	@Field("ip")
	private String ip;

	@Field("coCd")
	private String coCd;

	@Field("coNm")
	private String coNm;

	@Field("busiCd")
	private String busiCd;

	@Field("busiNm")
	private String busiNm;

	@Field("suborgCd")
	private String suborgCd;

	@Field("suborgNm")
	private String suborgNm;

	@Field("deptCd")
	private String deptCd;

	@Field("deptNm")
	private String deptNm;

	@Field("jikgubCd")
	private String jikgubCd;

	@Field("jikgubNm")
	private String jikgubNm;

	@Field("ceo")
	private String ceo;

	@Field("inside")
	private String inside;

	@Field("sabun")
	private String sabun;
}
