package com.xcurenet.searchWord.service;

import lombok.Data;

@Data
public class SearchWordVO {
	private int keywordId;
	private int searchRelaId;
	private String searchWord;
	private int searchCount;
	private String relationWord;
	private float searchWordRelaNumber;


}
