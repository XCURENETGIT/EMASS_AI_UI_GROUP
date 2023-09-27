package com.xcurenet.emass.message.service;

import java.sql.Date;

import lombok.Data;

@Data
public class EmsMlFeedbackVO {
	private String msgId;
	private String attachId;
	private String attachName;
	private String attachHash;
	private int mlSecurityYN;
	private int mlFeedbackYN;
	private Date mlFeedbackTime;
	private String mlFeedbackComment;
	private String mlFeedbackUser;
	private String mlFeedbackBuser;
	private double ml_confd_prob;
	private String mlFeedbackTimeStr;
	private String features;
}
