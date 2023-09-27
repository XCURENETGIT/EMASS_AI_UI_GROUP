package com.xcurenet.emass.adminFilter.service;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class FilterImportVO {
	private MultipartFile file;
	private String filePath;
	private String fileName;
}
