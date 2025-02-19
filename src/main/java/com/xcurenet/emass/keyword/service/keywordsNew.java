package com.xcurenet.emass.keyword.service;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class keywordsNew {

	List<KeywordsNewVO> KeywordsNewList = new ArrayList<>();
	Long totalCount = 0L;

}
