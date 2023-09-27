package com.xcurenet.emass.keyword.service;

import java.util.List;

import net.sf.json.JSONObject;

public interface KeywordGroupService {

	public List<KeywordGroupVO> getKeywordGroupList(final String searchStr, final int offset, final int limit);
	
	public List<KeywordGroupVO> getKeywordGroupList(final JSONObject param);
	
	public KeywordGroupVO getNextKeywordGroupSeq();
	
	public boolean isGroupNameExist(final KeywordGroupVO group);

	public int insertKeywordGroup(final KeywordGroupVO group);

	public int updateKeywordGroup(final KeywordGroupVO group);

	public int deleteKeywordGroup(final List<KeywordGroupVO> groups);
}
