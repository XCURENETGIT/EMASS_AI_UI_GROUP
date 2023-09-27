package com.xcurenet.emass.filter.service;

import java.util.List;

public interface AttachFilterService {

	public List<AttachFilterVO> getAttachFilterList(final String searchStr, final String serviceCd);

	public boolean isAttachExist(AttachFilterVO filter);

	public int insertAttachFilter(AttachFilterVO filter);

	public int updateAttachFilter(AttachFilterVO filter);

	public int deleteAttachFilter(List<AttachFilterVO> filters);
}
