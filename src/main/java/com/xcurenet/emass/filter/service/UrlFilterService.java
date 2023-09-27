package com.xcurenet.emass.filter.service;

import java.util.List;

public interface UrlFilterService {

	public List<UrlFilterVO> getUrlFilterList(final String searchStr);

	public boolean isUrlExist(UrlFilterVO filter);

	public int insertUrlFilter(UrlFilterVO filter);

	public int updateUrlFilter(UrlFilterVO filter);

	public int deleteUrlFilter(List<UrlFilterVO> filters);
}
