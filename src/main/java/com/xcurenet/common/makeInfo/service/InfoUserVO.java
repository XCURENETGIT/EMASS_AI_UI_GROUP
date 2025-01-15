package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_USER")
public class InfoUserVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("USERID")
	private String USERID;

	@Field("NAME")
	private String NAME;

	@Field("COCD")
	private String COCD;

	@Field("CONM")
	private String CONM;

	@Field("SUBORGCD")
	private String SUBORGCD;

	@Field("SUBORGNM")
	private String SUBORGNM;

	@Field("BUSICD")
	private String BUSICD;

	@Field("BUSINM")
	private String BUSINM;

	@Field("DEPTCD")
	private String DEPTCD;

	@Field("DEPTNM")
	private String DEPTNM;

	@Field("JIKGUBCD")
	private String JIKGUBCD;

	@Field("JIKGUBNM")
	private String JIKGUBNM;

	@Field("CEO")
	private String CEO;

	@Field("SABUN")
	private String SABUN;
}
