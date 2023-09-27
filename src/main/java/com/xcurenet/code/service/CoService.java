package com.xcurenet.code.service;

import java.util.List;

public interface CoService {

	public int getCoListTotal(final String searchStr, final int offset, final int limit);

	public List<CoVO> getAllCoList();

	public List<CoVO> getCoList(final String searchStr, final int offset, final int limit);

	public boolean isCoNmExist(CoVO co);

	public boolean isCoCdExist(CoVO co);

	public int insertCo(CoVO co);

	public int updateCo(CoVO co);

	public int deleteCo(CoVO co);
}
