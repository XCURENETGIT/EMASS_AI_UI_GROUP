package com.xcurenet.common.util.download.local;

import lombok.Data;

@Data
public class AttachVO {
	private String fileName;
	private String filePath;
	private long fileSize;
	private boolean cryptoCheck;
}
