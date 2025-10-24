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
	private int NUM; //연관 키워드 등록 순서
	private int num; //키워드 No (행 번호)
}
