package com.xcurenet.audit.service;

import lombok.Data;

@Data
public class AuditRequestVO {

	private String pMenuId;
	private String menuId;
	private String operation;
	private String className;
	private String method;
	private String path;
	private String information;

	private String desc;
}
