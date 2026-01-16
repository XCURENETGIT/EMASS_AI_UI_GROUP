package com.xcurenet.emass.reservationAlarm.service;

import lombok.Data;

@Data
public class AlarmLogVO {
	
	private String alarmLogSeq;
	
	private String alarmSeq;
	
	private String executeDt;

	private String searchField;
	
	private String rMsg;
	
	private String rCnt;
	
}
