package com.xcurenet.common.makeInfo.service.impl;

import javax.annotation.Resource;

import com.xcurenet.common.util.MongoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.config.Config;

@Service("makeInfoService")
public class MakeInfoServiceImpl extends XcnAbstractDAO implements MakeInfoService {

	@Resource(name = "config")
	public Config config;


	@Autowired
	MongoUtil mongoUtil;

	@Autowired
	private MakeInfoServiceMysql makeInfoServiceMysql;

	@Override
	public int addInfoUser() {
		int result = 0;
		makeInfoServiceMysql.addInfoUser();
		config.reloadUser();
		config.reloadCo();
		config.reloadDept();
		config.reloadJikgub();
		config.reloadEmail();
		makeInfoServiceMysql.updateAdminUserGroupList();

		return result;
	}

	@Override
	public int addInfoDevice() {
		return makeInfoServiceMysql.addInfoDevice();
	}

	@Override
	public int addInfoHoliday() {
		return makeInfoServiceMysql.addInfoHoliday();
	}

	@Override
	public int addInfoWorkDay() {
		return makeInfoServiceMysql.addInfoWorkDay();
	}

	@Override
	public int addInfoIpRange() {
		return makeInfoServiceMysql.addInfoIpRange();
	}

	@Override
	public int addInfoIpRangeDept() {
		return makeInfoServiceMysql.addInfoIpRangeDept();
	}

	@Override
	public int addInfoKeyword() {
		return makeInfoServiceMysql.addInfoKeyword();
	}

	@Override
	public int addInfoRegExp() {
		return makeInfoServiceMysql.addInfoRegExp();
	}

	@Override
	public int addInfoNoLog() {
		return makeInfoServiceMysql.addInfoNoLog();
	}

}
