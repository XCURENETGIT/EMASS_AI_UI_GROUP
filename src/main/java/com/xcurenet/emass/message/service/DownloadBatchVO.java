package com.xcurenet.emass.message.service;

import lombok.Data;

@Data
public class DownloadBatchVO {
	private String downSeq;
	private String exportType;
	private String exportFileExt;
	private String downVal;
	private String adminId;
	private String reqDt;
	private String endDt;
	private String downStatus;
	private String statusStr;
	private String downFilePath;
	private String downFileSize;
	private String skipText;
	private long ingRows;
	private long totalRows;
	private long skipCnt;
}
