package com.xcurenet.emass.dashboard.service;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class TodayNotWorkVO {

	private String total;

	private String unRead;

	private String startDt;

	private String endDt;

	private String adminId;

	private String termDtStr;

}
