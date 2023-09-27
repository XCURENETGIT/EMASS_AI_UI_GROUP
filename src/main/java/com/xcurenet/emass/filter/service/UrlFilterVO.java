package com.xcurenet.emass.filter.service;

import lombok.Data;

@Data
public class UrlFilterVO {
	private String urlLogSeq;
	private String url;
	private String createDt;
	private String useYn;
}
