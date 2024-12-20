package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassAttachData {

	@Field("id")
	private String attachId;

	@Field("name")
	private String attachName;

	@Field("path")
	private String attachPath;

	@Field("textPath")
	private String attachTextPath;

	@Field("size")
	private long attachSize;
	
	@Field("filterType")
	private String filterType;
	
	@Field("ext")
	private String attachExt;
	
//	@Field("summary")
//	private String summary;
	
	@Field("exist")
	private Boolean attachExist;
	
	@Field("flink")
	private String fLink;
	
	@Field("encrypted")
	private Boolean encrypted;	

	@Field("nameExist")
	private String attachNameExist;
	
	@Field("flinkKey")
	private String fLinkKey;	

	@Field("hash")
	private String attachHash;

	@Field("desc")
	private String attachDesc;	

	@Field("drm")
	private String drm;	
	
	@Field("isOcr")
	private String isOcr;

	@Field("space")
	private String attachSpace;
}
