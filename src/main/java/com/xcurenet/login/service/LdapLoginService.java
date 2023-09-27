package com.xcurenet.login.service;

import com.xcurenet.admin.service.AdminVO;

public interface LdapLoginService {

	public AdminVO loginProcess(final String adminId, final String adminPw);
}
