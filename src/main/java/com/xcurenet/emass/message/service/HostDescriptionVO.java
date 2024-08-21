package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class HostDescriptionVO {

	String host;
	String scheme;
	String port;
	String categoryCd;
	String categoryNm;
	String nationCd;
	String description;
	String dbType;
	String processYn;
	String nationEn;
	String nationKo;

}
