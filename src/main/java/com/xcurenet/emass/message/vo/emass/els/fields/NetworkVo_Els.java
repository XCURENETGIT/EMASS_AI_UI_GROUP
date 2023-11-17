package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class NetworkVo_Els {
	@JsonProperty("srcIp")
	private String	srcIp;  //	발신자 IP
	@JsonProperty("srcPort")
	private int	srcPort;  //	발신자 PORT
	@JsonProperty("dstIp")
	private String	dstIp;  //	목적지 IP
	@JsonProperty("dstPort")
	private int	dstPort;  //	목적지 PORT
	@JsonProperty("protocol")
	private String	protocol;  //	프토토콜
	@JsonProperty("cid")
	private String	cid;  //	세션ID

}

