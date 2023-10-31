package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoUserVO {
	private String USERID;
	private String BUSICD;
	private String BUSINM;
	private String CEO;
	private String COCD;
	private String CONM;
	private String DEPTCD;
	private String DEPTNM;
	private String JIKGUBCD;
	private String JIKGUBNM;
	private String NAME;
	private String SUBORGCD;
	private String SUBORGNM;
	private int VERSION;

}
