package com.xcurenet.emass.dashboard.service;

import lombok.Data;

@Data
public class DashboardVO {
	private String adminId;
	private String dashKey;
	private String dashVal;
	private int orderRow;
	private int orderCol;
	private String dashClass;
	private String dashIcon;
}
