package com.xcurenet.emass.filter.service;

import java.util.List;

public interface SizeFilterService {

	public List<SizeFilterVO> getSizeFilterList(final String serviceCd);

	public boolean isSizeExist(SizeFilterVO filter);

	public int insertSizeFilter(SizeFilterVO filter);

	public int updateSizeFilter(SizeFilterVO filter);

	public int deleteSizeFilter(List<SizeFilterVO> filters);
}