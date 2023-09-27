package com.xcurenet.code.service;

import java.util.List;

public interface JikinService {

	public List<JikinVO> getAllJikinList();

	public List<JikinVO> getJikinList(final String searchStr, final int offset, final int limit);

	public boolean isJikinNmExist(JikinVO jikin);

	public boolean isJikinCdExist(JikinVO jikin);

	public int insertJikin(JikinVO jikin);

	public int updateJikin(JikinVO jikin);

	public int deleteJikin(JikinVO jikin);
}