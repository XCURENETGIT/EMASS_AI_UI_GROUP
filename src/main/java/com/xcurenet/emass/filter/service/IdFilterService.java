package com.xcurenet.emass.filter.service;

import java.util.List;

public interface IdFilterService {

	public List<IdFilterVO> getIdFilterList(final String searchStr, final String serviceCd);

	public boolean isIdExist(IdFilterVO filter);

	public boolean isServiceCdCountExceeded(String serviceCd);

	public int insertIdFilter(IdFilterVO filter);

	public int updateIdFilter(IdFilterVO filter);

	public int deleteIdFilter(List<IdFilterVO> filters);
}
