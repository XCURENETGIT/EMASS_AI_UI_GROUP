package com.xcurenet.emass.workday.service;

public interface WorkdayService {

	public WorkdayVO getWorkday(final String busiCd);

	public int saveWorkday(WorkdayVO workday);
}
