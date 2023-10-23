package com.xcurenet.emass.message.service;

import java.io.IOException;

import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

import javax.print.attribute.standard.MediaSize;

@Data
public class EmsBodyVO {

	@Id
	@Field(name = "_id")
	private String msgId;

	private String bodyHash;
	private long bodySize;
	private String bodyCharset;
	@Field(name = "BODY_PATH")
	private String bodyPath;
	private byte[] body;
	private String bodyType;
	private String bodyText;
	@Field(name = "SUBJECT")
	private String subject;
	private String svc;
	private String srcIp;
	private String dstIp;
	private String host;
	private String path;
	@Field(name = "USERID")
	private String userId;

	@Field(name = "FILENAME")
	private String fileName;

	@Field(name = "NAME")
	private String name;

	@Field(name = "CTIME")
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
