package com.xcurenet.code.service;

import java.util.List;

public interface BusiService {

	public List<BusiVO> getAllBusiList();

	public List<BusiVO> getBusiList(final String searchStr, final int offset, final int limit);

	public List<BusiVO> getBusiListByCo(final String coCd);

	public boolean isBusiNmExist(BusiVO busi);

	public boolean isBusiCdExist(BusiVO busi);

	public int insertBusi(BusiVO busi);

	public int updateBusi(BusiVO busi);

	public int deleteBusi(BusiVO busi);

	public int deleteBusiCo(CoVO co);
}
