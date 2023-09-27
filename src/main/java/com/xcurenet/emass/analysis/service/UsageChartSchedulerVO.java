package com.xcurenet.emass.analysis.service;

import java.io.Serializable;
import java.util.Calendar;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import lombok.Data;

public @Data class UsageChartSchedulerVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private String ctime;
	private String dateMonth;
	private String dateDay;
	private String dateTime;
	private int dateWeekOfMonth;
	private int dateDayOfWeek;
	private int inMail;
	private int outMail;
	private long fileSize;
	private long ftp;
	private long totalSize;

	public String getDateMonth() {
		if(dateMonth == null) {
			return ctime.substring(0, 6);
		} else {
			return dateMonth;
		}
	}

	public String getDateDay() {
		if(dateDay == null) {
			return ctime.substring(6, 8);
		} else {
			return dateDay;
		}
	}

	public String getDateTime() {
		if(dateTime == null) {
			return ctime.substring(8, 10);
		} else {
			return dateTime;
		}
	}

	public int getDateWeekOfMonth() {
		if(dateWeekOfMonth == 0) {
	        Calendar calendar = Calendar.getInstance();
			DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
			DateTime date = DateTime.parse(ctime.substring(0, 8), yyyyMMdd);
			calendar.setTime(date.toDate());
			return calendar.get(Calendar.WEEK_OF_MONTH);
		} else {
			return dateWeekOfMonth;
		}
	}
	public int getDateDayOfWeek() {
		if(dateDayOfWeek == 0) {
	        Calendar calendar = Calendar.getInstance();
			DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
			DateTime date = DateTime.parse(ctime.substring(0, 8), yyyyMMdd);
			calendar.setTime(date.toDate());
			return calendar.get(Calendar.DAY_OF_WEEK);
		} else {
			return dateDayOfWeek;
		}
	}

}
