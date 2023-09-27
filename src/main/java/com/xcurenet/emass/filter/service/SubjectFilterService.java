package com.xcurenet.emass.filter.service;

import java.util.List;

public interface SubjectFilterService {

	public List<SubjectFilterVO> getSubjectFilterList(final String searchStr, final String serviceCd);

	public boolean isSubjectExist(SubjectFilterVO filter);

	public int insertSubjectFilter(SubjectFilterVO filter);

	public int updateSubjectFilter(SubjectFilterVO filter);

	public int deleteSubjectFilter(List<SubjectFilterVO> filters);
}
