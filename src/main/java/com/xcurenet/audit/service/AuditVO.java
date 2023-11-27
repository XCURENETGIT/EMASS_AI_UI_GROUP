package com.xcurenet.audit.service;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.joda.time.DateTime;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;

@Data
@Document(collection = "INFO_AUDIT")
public class AuditVO {

	@Id
	private String id;

	@Indexed
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private DateTime date;

	@Indexed
	private String adminId;

	@Indexed
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
