package com.xcurenet.searchWord.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SearchWordService {
	public List<SearchWordVO> getSearchWord(int offset, int limit, String searchStr);

	int insertSearchWord(SearchWordVO searchWordVO);

	public boolean isSearchWord(SearchWordVO searchWordVO);


	public int insertRelSearchWord(SearchWordVO searchWordVO);

	public int tableIsExist();

	public int tableNum();

	public int findSearchWordNum(SearchWordVO searchWordVO);

	public int deleteSearchWord(List<SearchWordVO> searchWords);

	public int updateSearchWord(SearchWordVO searchWordVO);

	public int deleteSearchRelWord(List<SearchWordVO> searchWords, int keywordId);
}
