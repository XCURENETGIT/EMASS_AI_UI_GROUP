package com.xcurenet.audit.service;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@Document(collection = "EMS_OPERATOR")
public class AuditMongoVO {
	@Id
	private String id;

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