package com.xcurenet.emass.customDashboard.service;

import java.util.List;

import lombok.Data;

@Data
public class CustomDashboardVO {
	private String menuKey;
	private String dashKey;
	private String id;
	private String dashName;
	private String dashType;
	private String dashMultiLeft;
	private String dashMultiRight;
	private String dashChart;
	private String dashChartX;
	private String dashChartY;
	private String dashIcon;
	private String dashColor;
	private int x;
	private int y;
	private int width;
	private int height;
	private int minWidth;
	private int minHeight;
	private int maxWidth;
	private int maxHeight;
	private String html;
	private String dashCondition;
	private String dashComment;
	private String adminId;
	private String useYn;
	
	private String searchStr;
	private String adminIds;
}
