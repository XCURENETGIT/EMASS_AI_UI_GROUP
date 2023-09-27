package com.xcurenet.emass.filter.service;

import java.util.List;

public interface DomainFilterService {

	public List<DomainFilterVO> getDomainFilterList(final String searchStr, final String serviceCd);

	public boolean isDomainExist(DomainFilterVO filter);

	public int insertDomainFilter(DomainFilterVO filter);

	public int updateDomainFilter(DomainFilterVO filter);

	public int deleteDomainFilter(List<DomainFilterVO> filters);
}
