package com.xcurenet.emass.service.service;

import java.util.List;

public interface ServiceGroupService {

	public List<ServiceGroupVO> getServiceGroupList();

	public List<ServiceGroupVO> getServiceGroupList(final String searchStr);
}
