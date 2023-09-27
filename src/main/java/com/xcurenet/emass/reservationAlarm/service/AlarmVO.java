package com.xcurenet.emass.reservationAlarm.service;

import lombok.Data;

@Data
public class AlarmVO {

	private String alarmSeq;

	private String alarmName;

	private String alarmType;
	
	private String alarmMailYn;
	
	private String alarmSmsYn;
	
	private String alarmMonitorYn;

	private String alarmCycle;

	private String alarmCycleVal;

	private String alarmWeek;

	private String alarmTime;

	private String alarmTo;

	private String alarmCC;

	private String alarmFormSeq;

	private String alarmVal;

	private String createDt;

	private String userId;

	private String userNm;
	
	private String userHp;

	private String useYn;
	
	private String adminId;
	
	private String formSeq;
	
	private String formSubject;
	
	private String formContent;
	
	private String formComment;
	
	private String alarmLogSeq;
	
	private String executeDt;
	
	private String rMsg;
	
	private String rCnt;
	
	private String csvYn;
	
	private String excelMaxCnt;
	
	private String encryptUseYN;
	private String encryptAlgorithm;
	private String encryptSize;
	private String encryptKey;
	
}
