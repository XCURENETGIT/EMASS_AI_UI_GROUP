package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.aggregation.ArrayOperators;

import java.util.List;

@Data
@Builder
public class InfoIpVO {
	private String IP;
	private String USERID;
	private int VERSION;

}
