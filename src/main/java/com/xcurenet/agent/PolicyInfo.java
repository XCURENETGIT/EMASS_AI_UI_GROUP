package com.xcurenet.agent;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.ibatis.type.Alias;


@Data
@Alias("PolicyInfo")
@NoArgsConstructor
public class PolicyInfo {
	private String agentId;
	private String confId;
	private String confName;
	private String confVal;
	private String category;

	public PolicyInfo(String agentId, String confId, String confVal) {
		this.agentId = agentId;
		this.confId = confId;
		this.confVal = confVal;
	}
}
