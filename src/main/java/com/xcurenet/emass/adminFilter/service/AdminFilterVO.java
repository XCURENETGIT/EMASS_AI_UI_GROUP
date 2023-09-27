package com.xcurenet.emass.adminFilter.service;

import lombok.Data;

@Data
public class AdminFilterVO {
	private long id; // FILTER_SEQ
	private String adminId; // ADMIN_ID
	private long pId; // P_FILTER_SEQ
	private String name; // FILTER_NM
	private String filterType; // FILTER_TYPE
	private String filterOrder; // FILTER_ORDER
	private String userDtCd; // USER_DT_CD
	private String startDt; // START_DT
	private String endDt; // END_DT
	private String conditions; // FILTER_VAL
	private String conditionType; //CONDITION_TYPE
	private String open;
	private String drag;
	private String icon;
	private String dashboard;

	public long getpId() {
		return pId;
	}
	public void setpId(long pId) {
		this.pId = pId;
	}
}
