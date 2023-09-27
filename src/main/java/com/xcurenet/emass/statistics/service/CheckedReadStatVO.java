package com.xcurenet.emass.statistics.service;

import lombok.Data;

@Data
public class CheckedReadStatVO {
	private String header;
	private String rowKey;
	private long cnt;
}
