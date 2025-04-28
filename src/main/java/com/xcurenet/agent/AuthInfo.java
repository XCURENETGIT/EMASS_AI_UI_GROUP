package com.xcurenet.agent;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("AuthInfo")
public class AuthInfo {
	private String authEmail;
	private String agentId;
	private String userId;

	private Integer limitAgentCount;
	private String expireDate;
	private String createDt;
	private String createUser;
}
