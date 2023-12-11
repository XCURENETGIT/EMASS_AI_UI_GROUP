package com.xcurenet.emass.message.service;

import java.io.IOException;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;

import lombok.Data;
import org.joda.time.DateTime;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

import javax.print.attribute.standard.MediaSize;

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
}
