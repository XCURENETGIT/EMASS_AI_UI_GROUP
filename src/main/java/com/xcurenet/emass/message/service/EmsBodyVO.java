package com.xcurenet.emass.message.service;

import java.io.IOException;

import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;

import lombok.Data;

@Data
public class EmsBodyVO {
	private String msgId;
	private String bodyHash;
	private long bodySize;
	private String bodyCharset;
	private String bodyPath;
	private byte[] body;
	private String bodyType;
	private String bodyText;

	private String subject;
	private String svc;
	private String srcIp;
	private String dstIp;
	private String host;
	private String path;
	private String userId;
	private String name;
	private String ctime;
	private String epmsgType;

	public void setSrcIp(String srcIp) {
		if (Common.isNotEmpty(srcIp)) {
			try {
				this.srcIp = new IP(srcIp).toCanonicalAddr();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void setDstIp(String dstIp) {
		if (Common.isNotEmpty(dstIp)) {
			try {
				this.dstIp = new IP(dstIp).toCanonicalAddr();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	// public void setBody(byte[] body) {
	// if (body != null) {
	// CryptoCommon crypto = new CryptoCommon();
	// this.body = crypto.decrypt(body);
	// } else this.body = body;
	// }
}
