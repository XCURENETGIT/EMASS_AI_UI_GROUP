package com.xcurenet.emass.reservationAlarm.service;

import java.util.List;

import com.xcurenet.admin.service.AdminVO;

public interface AlarmService {

	public List<AlarmVO> getAlarmList(final String searchStr);
	
	public List<AdminVO> getAdminEmailList(final String searchStr);

	public AlarmVO getAlarm(final String alarmSeq);
	
	public AlarmVO getNextAlarmSeq();

	public int insertAlarm(AlarmVO alarm);

	public int updateAlarm(AlarmVO alarm);
	
	public int deleteAlarm(List<AlarmVO> alarms);
	
	public List<AlarmVO> getMailFormList(final String searchStr);
	
	public int insertMailForm(AlarmVO alarm);
	
	public int updateMailForm(AlarmVO alarm);
	
	public int deleteMailForm(List<AlarmVO> alarms);
	
	public List<AlarmVO> getNowExecuteList();
	
	public int insertAlarmLog(final String alarmSeq, long totalCnt, String query, String searchField);
	
	public List<AlarmLogVO> getAlarmLog(final String alarmSeq);
	
	public List<AlarmLogVO> getAlarmLogQuery(final String alarmLogSeq);
	
	public int deleteAlarmLog(List<AlarmLogVO> alarms);

}
