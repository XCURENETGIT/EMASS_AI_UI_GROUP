package com.xcurenet.emass.dashboard.service;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class InterestUserServiceVO {

	private String startDt;

	private String endDt;

	private String adminId;

	private String userSeq;

	private String termDtStr;

	private List<Map<String,Object>> facet;
}
