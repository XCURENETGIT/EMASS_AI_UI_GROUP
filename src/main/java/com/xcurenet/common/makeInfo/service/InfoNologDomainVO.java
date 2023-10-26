package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.bouncycastle.pqc.crypto.util.PQCOtherInfoGenerator;

@Data
@Builder
public class InfoNologDomainVO {
	public String SERVICECD;
	private String DOMAIN;
	private int VERSION;
}
