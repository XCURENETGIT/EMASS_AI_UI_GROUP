package com.xcurenet.emass.keyword.service;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class KeywordImportVO {
	private MultipartFile attach;
	private String encoding;
	private String separator;
}
