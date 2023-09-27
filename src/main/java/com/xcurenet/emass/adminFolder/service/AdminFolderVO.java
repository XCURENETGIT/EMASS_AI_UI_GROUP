package com.xcurenet.emass.adminFolder.service;

import lombok.Data;

@Data
public class AdminFolderVO {
	private long id; // FOLDER_SEQ
	private String adminId; // ADMIN_ID
	private long pId; // P_FOLDER_SEQ
	private String name; // FOLDER_NM
	private int msgCnt; // MSG COUNT
	private String folderType; // FOLDER_TYPE
	private String folderOrder; // FOLDER_ORDER
	private String open;
	private String drag;
	private String icon;

	public long getpId() {
		return pId;
	}
	public void setpId(long pId) {
		this.pId = pId;
	}
}
