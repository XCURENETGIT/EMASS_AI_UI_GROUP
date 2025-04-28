package com.xcurenet.agent;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("StatusInfo")
@JsonInclude(JsonInclude.Include.NON_NULL)
public class StatusInfo {
	private String agentId;
	private String clientIp;
	private String lastLoginDt;
	private String userId;
	private String status;

	private String userNm;
	private String userEmail;
	private String coNm;
	private String deptNm;
	private String jikgubNm;
}
