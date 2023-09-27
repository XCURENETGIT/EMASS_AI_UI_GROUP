package com.xcurenet.audit.service;

public enum ParentMenu {

	SYSTEM("SYSTEM"), DATA_MONITOR("DATA_MONITOR"), DATA_ANALYSIS("DATA_ANALYSIS"), POLICY_SETUP("POLICY_SETUP"), OPERATION_MGMT("OPERATION_MGMT"), EMPTY("");

	private String parentMenuId;

	ParentMenu(String arg) {
		this.parentMenuId = arg;
	}

	public String getParentMenuId() {
		return this.parentMenuId;
	}
}