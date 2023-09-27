package com.xcurenet.menu.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public interface MenuService {

	public List<MenuVO> getMenuList(final HttpServletRequest request);

	public List<MenuVO> getMenuList(final String adminId, final String adminAuth, HttpSession session);

}
