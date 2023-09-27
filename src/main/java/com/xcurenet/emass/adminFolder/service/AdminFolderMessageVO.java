package com.xcurenet.emass.adminFolder.service;

import com.xcurenet.common.util.Common;

import lombok.Data;

@Data
public class AdminFolderMessageVO {
	private String folderSeq;
	private String oldFolderSeq;
	private String msgId;
	private String consentNo;
	private String [] msgIds;
	private String adminId; // ADMIN_ID
	
	private int offset;
	private int limit;
	public void setMsgIds(String msgIds) {
		if(Common.isEmpty(msgIds)) return;
		this.msgIds = msgIds.split(","); 
	}
}
