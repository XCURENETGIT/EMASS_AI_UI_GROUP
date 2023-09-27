package com.xcurenet.config.service;

import java.util.List;

public interface ConfigAdminService {

	public List<ConfigAdminVO> getAdminConfList(final String adminId);

	public ConfigAdminVO getConfAdmin(final String confId, final String adminId);

	public int setConfAdmin(final ConfigAdminVO conf);
	
	public List<ConfigAdminVO> getConfAdminOption(final String adminId);
	
	public int setConfAdminOption(final String confId, final String val, final String adminId);
	
}
