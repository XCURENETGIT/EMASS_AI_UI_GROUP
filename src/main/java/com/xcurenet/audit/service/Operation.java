package com.xcurenet.audit.service;

public enum Operation {

	LOGIN("LOGIN"),
	LOGOUT("LOGOUT"),
	CHG_PWD("CHG_PWD"),
	CHG_INTEREST("CHG_INTEREST"),
	CHG_DEV("CHG_DEV"),
	CHG_FILESIZE("CHG_FILESIZE"),
	SEARCH("SEARCH"),
	SEARCH_EXPERT("SEARCH_EXPERT"),
	INSERT("INSERT"),
	UPDATE("UPDATE"),
	DELETE("DELETE"),
	SAVE("SAVE"),
	RETURN("RETURN"),
	APPROVE("APPROVE"),
	CANCEL("CANCEL"),
	RULE_APPLY("RULE_APPLY"),
	UPLOAD("UPLOAD"),
	MAIL_SEND("MAIL_SEND"),
	BODY_VIEW("BODY_VIEW"),
	BODY_SAVE("BODY_SAVE"),
	ATTACH_SAVE("ATTACH_SAVE"),
	HEADER_SAVE("HEADER_SAVE"),
	ORI_BODY_SAVE("ORI_BODY_SAVE"),
	BODY_PRINT("BODY_PRINT"),
	DOWNLOAD("DOWNLOAD"),
	IMPORT("IMPORT"),
	EXPORT("EXPORT"),
	
	EMPTY("");

	private String operation;

	Operation(String arg) {
		this.operation = arg;
	}

	public String getOperation() {
		return this.operation;
	}

}