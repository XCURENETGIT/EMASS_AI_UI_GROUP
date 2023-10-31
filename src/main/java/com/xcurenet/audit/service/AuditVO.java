package com.xcurenet.audit.service;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collation = "INFO_AUDIT")
public class AuditVO {

	private String date;
	private String adminId;
	private long seq;
	private String product;
	private String category;
	private String operation;
	private String adminName;
	private String adminIp;
	private String menuId;
	private String pMenuId;
	private String information;
	private String comment;
	private String pDate;
}
