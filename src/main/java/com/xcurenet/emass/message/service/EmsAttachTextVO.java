package com.xcurenet.emass.message.service;

import com.xcurenet.common.util.Common;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "EMS_ATTACHTEXT")
public class EmsAttachTextVO {
	private String attachName;
	private String attachTextPath;
	private String attachTextHarPath;
	private String attachSize;
	private String attachPath;
	private String attachHarPath;
	private String attachExt;

	@Field("text")
	private String attachText;

	private int attachTextTotalLine;

	public void setAttachSize(String attachSize) {
		this.attachSize = Common.convertFileSize(attachSize);
	}

	public void setAttachText(String attachText) {
		this.attachText = attachText.replaceAll("\\\u2028", "\n").replaceAll("\u2029", "\n\n");
	}
}
