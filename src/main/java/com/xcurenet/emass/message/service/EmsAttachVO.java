package com.xcurenet.emass.message.service;

import java.sql.Date;

import lombok.Data;

@Data
public class EmsAttachVO implements Comparable<EmsAttachVO>{
	private String msgId;
	private String attachId;
	private String attachName;
	private String attachNameExist;
	private String attachPath;
	private String attachHarPath;
	private long attachSize;
	private String attachExt;
	private String attachDesc;
	private String attachHash;
	private String encrypted;
	private String filterType;
	private String fLink;
	private String fLinkKey;
	private String summary;
	private String attachTextPath;
	private String attachTextHarPath;
	private String attachSpace;
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

