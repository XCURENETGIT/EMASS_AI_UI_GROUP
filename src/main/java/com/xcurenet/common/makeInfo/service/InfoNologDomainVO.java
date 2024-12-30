package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.bouncycastle.pqc.crypto.util.PQCOtherInfoGenerator;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_NOLOG_DOMAIN")
public class InfoNologDomainVO {

	@Indexed
	@Field("VERSION")
	private int VERSION;

	@Field("SERVICECD")
	public String SERVICECD;

	@Field("DOMAIN")
	private String DOMAIN;
}
