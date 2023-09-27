package com.xcurenet.emass.adminFolder.service;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class FolderImportVO {
	private MultipartFile file;
	private String filePath;
	private String fileName;
}
