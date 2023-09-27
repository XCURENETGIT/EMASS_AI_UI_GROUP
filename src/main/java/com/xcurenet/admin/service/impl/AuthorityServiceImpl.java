package com.xcurenet.admin.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.common.dao.XcnAbstractDAO;

import net.sf.json.JSONObject;

@Service("authorityService")
public class AuthorityServiceImpl extends XcnAbstractDAO implements AuthorityService {

	@Override
	public List<AuthorityVO> getAdminAuthority(JSONObject param) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.admin.getAdminAuthority", param);
	}
}
