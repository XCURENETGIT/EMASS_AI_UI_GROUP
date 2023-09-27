package com.xcurenet.xcnlog.service;

import lombok.Data;

@Data
public class XcnLogVO {
	private int seq;
	private String ip;
	private String ctime;
	private String module;
	private String service;
	private String type;
	private String info;

	private String startDt;
	private String endDt;
	private int limit;
	private long offset;
}
