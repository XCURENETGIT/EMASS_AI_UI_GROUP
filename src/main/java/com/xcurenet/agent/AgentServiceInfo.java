package com.xcurenet.agent;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("AgentServiceInfo")
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AgentServiceInfo {
	private String groupCd;
	private String groupNm;
	private String serviceCd;
	private String serviceNm;
	private String loggingYn;
}
