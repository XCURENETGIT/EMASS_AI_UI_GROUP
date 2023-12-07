package com.xcurenet.admin.service;

import lombok.Data;

@Data
public class AuthorityVO {
	private String type;
	private String query;
	private int cnt;
	private String codes;
}
