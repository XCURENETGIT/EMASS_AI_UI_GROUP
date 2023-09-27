package com.xcurenet.admin.service;

import java.util.List;

import net.sf.json.JSONObject;

public interface AuthorityService {

	public List<AuthorityVO> getAdminAuthority(final JSONObject param);

}
