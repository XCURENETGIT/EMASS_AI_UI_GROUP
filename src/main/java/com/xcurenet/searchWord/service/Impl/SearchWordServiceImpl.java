package com.xcurenet.searchWord.service.Impl;


import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.searchWord.service.SearchWordService;
import com.xcurenet.searchWord.service.SearchWordVO;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("searchWordService")
public class SearchWordServiceImpl extends XcnAbstractDAO implements SearchWordService {
	@Override
	public List<SearchWordVO> getSearchWord(int offset, int limit, String searchStr) {
		Map<String, Object> param = new HashMap();
		param.put("limit", limit);
		param.put("offset", offset);
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.searchWord.getSearchWordList", param);
	}

	@Override
	public int insertSearchWord(SearchWordVO searchWordVO) {
		insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchWord", searchWordVO);
		return insertRelSearchWord(searchWordVO);
	}

	@Override
	public boolean isSearchWord(SearchWordVO searchWordVO) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.isSearchWordExist", searchWordVO) > 0;
	}

	@Override
	public int insertRelSearchWord(SearchWordVO searchWordVO) {
		searchWordVO.setKeywordId(findSearchWordNum(searchWordVO));
		return insert("com.xcurenet.sqlmap.mappers.mysql.searchWord.insertSearchRelWord", searchWordVO);

	}

	@Override
	public int tableIsExist() {
		int one = (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.tableIsExist1");
		int two = (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.tableIsExist2");
		return one+two;
	}

	public int findSearchWordNum(SearchWordVO searchWordVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.searchWord.getSearchWordNum", searchWordVO);
	}

	@Override
	public int deleteSearchWord(List<SearchWordVO> searchWords) {
		int result = 0;
		for (SearchWordVO searchWordVO : searchWords) {
			delete("com.xcurenet.sqlmap.mappers.mysql.searchWord.deleteSearchWord", searchWordVO);
			delete("com.xcurenet.sqlmap.mappers.mysql.searchWord.deleteSearchReNum", searchWordVO);
		}
		return result;
	}

	@Override
	public int updateSearchWord(SearchWordVO searchWordVO) {
		return update("com.xcurenet.sqlmap.mappers.mysql.searchWord.updateSearchWord", searchWordVO);
	}

	@Override
	public int deleteSearchRelWord(List<SearchWordVO> searchWords, int keywordId) {
		int result = 0;
		for (SearchWordVO searchWordVO : searchWords) {
			Map<String, Object> map = new HashMap<>();
			map.put("keywordId", keywordId);
			map.put("relationWord", searchWordVO.getRelationWord());
			delete("com.xcurenet.sqlmap.mappers.mysql.searchWord.deleteSearchRelWord", map);
		}
		result = 1;
		return result;
	}
}
