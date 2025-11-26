package com.xcurenet.pattern.service;


import java.util.List;

public interface PatternService {
	List<PatternVO> getPatternService(String searchStr, int offset, int limit, String patternType);

	boolean isPatternCode(PatternVO patternVO);

	void insertPattern(PatternVO patternVO, String adminId);

	public int deletePattern(List<PatternVO> patternVO);

	void updatePattern(PatternVO patternVO, String adminId);

	List<PatternVO> allPatternCodes();

	public List<PatternVO> getPatternTypeCodes(String enable,String codeType);
}
