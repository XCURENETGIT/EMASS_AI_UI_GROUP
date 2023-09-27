package com.xcurenet.interestUser.service;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class AdminUserGroupImportVO {
	private MultipartFile attach;
	private String encoding;
	private String importGroupSeq;
}
