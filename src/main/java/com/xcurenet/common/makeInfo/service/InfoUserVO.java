package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoUserVO {
	private int VERSION;
	private String USERID;
	private String NAME;
	private String COCD;
	private String CONM;
	private String SUBORGCD;
	private String SUBORGNM;
	private String BUSICD;
	private String BUSINM;
	private String DEPTCD;
	private String DEPTNM;
	private String JIKGUBCD;
	private String JIKGUBNM;
	private String CEO;
	private String SABUN;




}
