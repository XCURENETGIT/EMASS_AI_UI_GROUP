package com.xcurenet.emass.keyword.service;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public interface KeywordService {

	public List<KeywordVO> getKeywordList(final String searchGroupSeq, final String searchStr, final int offset, final int limit);

	public List<KeywordVO> getKeywordAllList();

	public boolean isKeywordNameExist(final KeywordVO keyword);

	public int insertKeyword(final KeywordVO keyword);

	public int updateKeyword(final KeywordVO keyword);

	public int deleteKeyword(final List<KeywordVO> keywords);

	public JSONObject importKeyword(JSONArray keywordList);
}
