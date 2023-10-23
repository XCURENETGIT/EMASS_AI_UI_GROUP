package com.xcurenet.emass.message.service;

import java.sql.Date;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
public class EmsAttachVO implements Comparable<EmsAttachVO>{
	@Field(name = "_id")
	private String msgId;
	@Field(name = "ATTACHID")
	private String attachId;
	@Field(name = "ATTACHNAME")
	private String attachName;
	@Field(name = "ATTACHNAMEEXIST")
	private String attachNameExist;
	@Field(name = "ATTACHPATH")
	private String attachPath;
	@Field(name = "ATTACHHARPATH")
	private String attachHarPath;
	@Field(name = "ATTACHSIZE")
	private long attachSize;
	@Field(name = "ATTACHEXT")
	private String attachExt;
	@Field(name = "ATTACHDESC")
	private String attachDesc;
	@Field(name = "ATTACHHASH")
	private String attachHash;
	@Field(name = "ENCRYPTED")
	private String encrypted;
	@Field(name = "FILTERTYPE")
	private String filterType;
	@Field(name = "FLINK")
	private String fLink;
	@Field(name = "FLINKKEY")
	private String fLinkKey;
	private String summary;
	@Field(name = "ATTACHTEXTPATH")
	private String attachTextPath;
	@Field(name = "ATTACHTEXTHARPATH")
	private String attachTextHarPath;
	@Field(name = "ATTACHSPACE")
	private String attachSpace;

	@Field(name = "ATTACHTEXT")
	private String attachText;

	@Field(name = "DRM")
	private String drm;


	private boolean consentFlag;

	private String subject;
	private String svc;
	private String srcIp;
	private String dstIp;
	private String host;
	private String path;
	private String userId;
	private String name;
	private String ctime;


	private String ocrYn;
	private String ocrText;
	private String ocrImageStr;
	
	private int ml_confd_class;
	private double ml_confd_prob;
	private Date mlFeedbackTime;
	private String mlFeedbackTimeStr;
	private String mlFeedbackComment;
	private int mlFeedbackYN;
	private String features;

	public int compareTo(EmsAttachVO j) {
		
		if(this.ml_confd_prob < j.ml_confd_prob) {
			return 1;
		} else if(this.ml_confd_prob > j.ml_confd_prob) {
			return -1;
		} else {
			return 0;
		}
	}
}

