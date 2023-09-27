package com.xcurenet.emass.holiday.service;

import java.util.List;

public interface HolidayService {

	public List<HolidayVO> getHolidayList(final String busiCd, final String year);

	public boolean isHolidayExist(final HolidayVO holiday);

	public int insertHoliday(HolidayVO holiday);
	
	public int updateHoliday(HolidayVO holiday);

	public int deleteHoliday(HolidayVO holiday);
}
