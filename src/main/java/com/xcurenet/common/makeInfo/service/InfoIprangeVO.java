package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_IPRANGE")
public class InfoIprangeVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("BUSICD")
	private String BUSICD;

	@Field("BUSINM")
	private String BUSINM;


	@Field("COCD")
	private String COCD;

	@Field("CONM")
	private String CONM;

	@Field("EIP")
	private String EIP;

	@Field("INSIDE")
	private String INSIDE;

	@Field("SIP")
	private String SIP;

	@Field("COUNTRY")
	private String COUNTRY;

}
