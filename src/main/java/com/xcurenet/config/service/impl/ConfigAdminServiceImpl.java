package com.xcurenet.config.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;

@Service("configAdminService")
public class ConfigAdminServiceImpl extends XcnAbstractDAO implements ConfigAdminService {

	@Override
	public List<ConfigAdminVO> getAdminConfList(String adminId) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.config.getConfigAdminList", adminId);
	}

	@Override
	public ConfigAdminVO getConfAdmin(String confId, String adminId) {
		Map<String, String> param = new HashMap<>();
		param.put("confId", confId);
		param.put("adminId", adminId);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getConfAdmin", param);
	}

	@Override
	public int setConfAdmin(ConfigAdminVO conf) {
		if ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.config.isConfAdminIdIdExist", conf) > 0) {
			return update("com.xcurenet.sqlmap.mappers.mysql.config.updateConfigAdmin", conf);
		} else {
			return update("com.xcurenet.sqlmap.mappers.mysql.config.insertConfigAdmin", conf);
		}
	}
	
	@Override
	public List<ConfigAdminVO> getConfAdminOption(String adminId) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.config.getConfAdminOption", param);
	}
	
	@Override
	public int setConfAdminOption(final String confId, final String val, final String adminId) {
		Map<String, String> param = new HashMap<>();
		param.put("confId", confId);
		param.put("val", val);
		param.put("adminId", adminId);
		return update("com.xcurenet.sqlmap.mappers.mysql.config.insertConfigAdminOption", param);
	}
}
