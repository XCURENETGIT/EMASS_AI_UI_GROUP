package com.xcurenet.agent;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("PacInfo")
public class PacInfo {
	private Integer consumerId;
	private String consumerNm;
	private Integer pacId;
	private String pacDesc;
	private String pacVal;
	private String pacUsed;
	private String createDt;
	private String createUser;
	private String updateDt;
	private String updateUser;
}
