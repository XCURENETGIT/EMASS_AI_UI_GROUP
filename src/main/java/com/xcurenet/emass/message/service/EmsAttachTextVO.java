package com.xcurenet.emass.message.service;

import com.xcurenet.common.util.Common;

import lombok.Data;

@Data
public class EmsAttachTextVO {
	private String attachName;
	private String attachTextPath;
	private String attachTextHarPath;
	private String attachSize;
	private String attachPath;
	private String attachHarPath;
	private String attachExt;
	private String attachText;
	private int attachTextTotalLine;

	public void setAttachSize(String attachSize) {
		this.attachSize = Common.convertFileSize(attachSize);
	}

	public void setAttachText(String attachText){
		this.attachText = attachText.replaceAll("\\\u2028", "\n").replaceAll("\u2029", "\n\n");
	}
}
