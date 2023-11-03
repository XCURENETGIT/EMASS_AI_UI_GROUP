package com.xcurenet.regexPattern.service.Impl;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.keyword.service.KeywordVO;
import com.xcurenet.regexPattern.service.RegexPatternService;
import com.xcurenet.regexPattern.service.RegexPatternVO;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("regexPatternService")
public class RegexPatternServiceImpl extends XcnAbstractDAO implements RegexPatternService {
	@Override
	public int insertRegexPattern(RegexPatternVO regexPattern) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.regexPattern.insertRegexPattern", regexPattern);
	}

	@Override
	public List<RegexPatternVO> getRegexPatternList(String searchStr,int offset,int limit) {
		Map<String, Object> param = new HashMap();
		param.put("limit", limit);
		param.put("offset", offset);
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.regexPattern.getRegexPatternList", param);
	}

	@Override
	public int deleteRegexPattern(List<RegexPatternVO> regexPatterns) {
		int result = 0;

		for (RegexPatternVO regexPatternVO : regexPatterns) {
			delete("com.xcurenet.sqlmap.mappers.mysql.regexPattern.deleteRegexPattern", regexPatternVO);
		}
		return result;
	}

	@Override
	public int updateRegexPattern(RegexPatternVO regexPattern) {
		System.out.println(regexPattern.getRegexSeq());
		return update("com.xcurenet.sqlmap.mappers.mysql.regexPattern.updateRegex", regexPattern);
	}

	@Override
	public boolean isRegexPatternName(RegexPatternVO regexPattern) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.regexPattern.isRegexPatternName", regexPattern) > 0;
	}

}
