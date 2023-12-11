package com.xcurenet.emass.message.service;

import lombok.Data;
import lombok.ToString;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.mongodb.core.mapping.Field;

@Log4j2
@Data
@ToString
public class EmassUserData {
	@Field("id")
	private String id;

	@Field("userId")
	private String userId;

	@Field("name")
	private String name;

	@Field("ipCoCd")
	private String ipCoCd;

	@Field("ipCoNm")
	private String ipCoNm;

	@Field("ipBusiCd")
	private String ipBusiCd;

	@Field("ipBusiNm")
	private String ipBusiNm;

	@Field("ipDeptCd")
	private String ipDeptCd;

	@Field("ipDeptNm")
	private String ipDeptNm;

	@Field("coCd")
	private String coCd;

	@Field("coNm")
	private String coNm;

	@Field("suborgCd")
	private String suborgCd;

	@Field("suborgNm")
	private String suborgNm;

	@Field("busiCd")
	private String busiCd;

	@Field("busiNm")
	private String busiNm;

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

	@Field("ip")
	private String ip;

	@Field("email")
	private String email;
}
