package com.xcurenet.emass.customDashboard.service;

import lombok.Data;

@Data
public class CustomDashboardMenuVO {
	private String menuKey;
	private String menuName;
	private String menuIcon;
	private String adminId;
	private String useYn;
	private String defaultMenu;
	private String updateDt;
}
