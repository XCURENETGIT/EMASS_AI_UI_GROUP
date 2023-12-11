package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@ToString
public class EmassNetworkData {

	@Field("srcIp")
	private String srcIp;

	@Field("srcPort")
	private int sPort;

	@Field("dstIp")
	private String dstIp;

	@Field("dstPort")
	private int dPort;

	@Field("protocol")
	private String protocol;
	
	@Field("cid")
	private String cid;	
}
