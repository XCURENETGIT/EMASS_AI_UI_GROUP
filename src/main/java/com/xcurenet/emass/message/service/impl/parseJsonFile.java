package com.xcurenet.emass.message.service.impl;
import java.sql.Date;

import lombok.Data;

@Data
public class parseJsonFile implements Comparable<parseJsonFile>{
	private String msgId;
	private String securityYn;
	private String mlFeedbackYN;
	private Double securityPct;
	private String attachName;
	Date mlFeedbackTime;
	
	public parseJsonFile(String msgId) {
		this.msgId = msgId;
	}
	
	public parseJsonFile(String msgId, String securityYn) {
		this.msgId = msgId;
		this.securityYn = securityYn;
	}
	
	public parseJsonFile(String msgId, String securityYn, Double securityPct) {
		this.msgId = msgId;
		this.securityYn = securityYn;
		this.securityPct = securityPct;
	}
	
	public parseJsonFile(String msgId, String attachName, String securityYn, Double securityPct) {
		this.msgId = msgId;
		this.attachName = attachName;
		this.securityYn = securityYn;
		this.securityPct = securityPct;
	}
	
	public parseJsonFile(String msgId, String attachName, String securityYn, String mlFeedbackYN, Double securityPct, Date mlFeedbackTime) {
		this.msgId = msgId;
		this.attachName = attachName;
		this.securityYn = securityYn;
		this.mlFeedbackYN = mlFeedbackYN;
		this.securityPct = securityPct;
		this.mlFeedbackTime = mlFeedbackTime;
	}
	
	@Override
	public int compareTo(parseJsonFile j) {
		
		if(this.securityPct < j.securityPct) {
			return 1;
		} else if(this.securityPct > j.securityPct) {
			return -1;
		} else {
			return 0;
		}
	}
}


