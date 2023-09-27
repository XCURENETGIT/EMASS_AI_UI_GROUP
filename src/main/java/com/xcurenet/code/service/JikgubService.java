package com.xcurenet.code.service;

import java.util.List;

public interface JikgubService {

	public List<JikgubVO> getAllJikgubList();

	public List<JikgubVO> getJikgubList(final String searchStr, final int offset, final int limit);

	public boolean isJikgubNmExist(JikgubVO jikgub);

	public boolean isJikgubCdExist(JikgubVO jikgub);

	public int insertJikgub(JikgubVO jikgub);

	public int updateJikgub(JikgubVO jikgub);

	public int deleteJikgub(JikgubVO jikgub);
}