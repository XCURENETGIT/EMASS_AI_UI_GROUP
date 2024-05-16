package com.xcurenet.regexPattern.service;

import java.util.List;

public interface RegexPatternService {

	public int insertRegexPattern(final RegexPatternVO regexPattern);

	List<RegexPatternVO> getRegexPatternList(String searchStr,int offset,int limit);

	public int deleteRegexPattern(List<RegexPatternVO> regexPatterns);

	public boolean isRegexPatternName(RegexPatternVO regexPattern);

	public int updateRegexPattern(RegexPatternVO regexPattern);

	public boolean checkRegexp(RegexPatternVO regexPattern);
}
