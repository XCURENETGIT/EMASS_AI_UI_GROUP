package com.xcurenet.emass.filter.service;

import java.util.List;

public interface PatternExceptService {
	public List<PatternExceptVO> getPatternExceptList(final String searchStr, final String regex);

	public boolean isPatternExist(PatternExceptVO patternExceptVO);

	public int insertPatternExcept(PatternExceptVO patternExceptVO, String adminId);

	int updatePatternExcept(PatternExceptVO patternExceptVO);

	int deletePatternExcept(List<PatternExceptVO> patternExceptlist);
}
