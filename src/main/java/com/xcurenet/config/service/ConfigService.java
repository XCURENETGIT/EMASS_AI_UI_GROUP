package com.xcurenet.config.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

public interface ConfigService {

	public List<ConfigVO> getConfList();

	public ConfigVO getConf(final String confId);

	public int setConf(final ConfigVO conf);
	
	public boolean execute(final ConfigVO conf);
	
	public void mailConfTest(String mail, HttpServletRequest request) throws Exception;

	void updateMenuByAgentMode1();
	void updateMenuByAgentMode2();
}
