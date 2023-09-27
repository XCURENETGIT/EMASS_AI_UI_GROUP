package com.xcurenet.common.url;

import java.util.concurrent.Callable;

import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.message.service.EmsHeaderVO;
import com.xcurenet.emass.message.service.EmsMessageService;

public class RefererData implements Callable<RefererData> {

	private String msgId;
	private String url;

	public EmsMessageService emsMessageService;

	public RefererData(final String msgId, final EmsMessageService emsMessageService) {
		this.msgId = msgId;
		this.emsMessageService = emsMessageService;
	}

	public String getReferer() {
		EmsHeaderVO headerVo = emsMessageService.getEmassHeader(msgId);
		if (headerVo == null || headerVo.getHeader() == null) return null;
		String charset = DetectCharset.getCharset(headerVo.getHeader());
		if (charset == null || (charset != "UTF-8" && charset != "EUC-KR")) charset = "EUC-KR";
		return getRefererParser(Common.toString(headerVo.getHeader(), charset));
	}

	public String getRefererParser(final String header) {
		String[] lines = Common.toArray(header, "\r\n");
		for (String line : lines) {
			if (line.indexOf("Referer:") > -1) {
				return line.replaceAll("Referer:", "").trim();
			}
		}
		return null;
	}

	@Override
	public RefererData call() throws Exception {
		this.url = getReferer();
		return this;
	}

	public String getMsgId() {
		return msgId;
	}

	public String getUrl() {
		return url;
	}
}
