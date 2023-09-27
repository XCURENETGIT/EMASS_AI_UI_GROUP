package com.xcurenet.emass.message.service;

import java.sql.Date;

import lombok.Data;

@Data
public class EmsMlFeedbackDataVO {
	private String msgId;
	private String attachId;
	private String attachName;
	private String attachHash;
	private int ml_confd_feedback;
	private Date ml_feedback_date;
	private String ml_feedback_comment;
}
