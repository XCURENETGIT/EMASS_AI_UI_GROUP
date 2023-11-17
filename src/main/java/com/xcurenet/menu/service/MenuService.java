package com.xcurenet.menu.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public interface MenuService {

	public String getMenuList(final HttpServletRequest request);

	public String getMenuList(final String adminId, final String adminAuth, HttpSession session);

}
