package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_IPRANGE")
public class InfoIprangeVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("BUSICD")
	private String BUSICD;

	@Field("BUSINM")
	private String BUSINM;

	@Field("CITY")
	private String CITY;

	@Field("COCD")
	private String COCD;

	@Field("CONM")
	private String CONM;

	@Field("COUNTRY")
	private String COUNTRY;

	@Field("EIP")
	private String EIP;

	@Field("INSIDE")
	private String INSIDE;

	@Field("LATITUDE")
	private String LATITUDE;

	@Field("LONGITUDE")
	private String LONGITUDE;

	@Field("SIP")
	private String SIP;

}
