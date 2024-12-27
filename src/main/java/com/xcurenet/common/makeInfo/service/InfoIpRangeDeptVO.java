package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_IPRANGE_DEPT")
public class InfoIpRangeDeptVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("SIP")
	private String SIP;

	@Field("EIP")
	private String EIP;

	@Field("DEPTCD")
	private String DEPTCD;

	@Field("DEPTNM")
	private String DEPTNM;

	@Field("COCD")
	private String COCD;

	@Field("CONM")
	private String CONM;

	@Field("INSIDE")
	private String INSIDE;
}
