package com.xcurenet.emass.holiday.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.holiday.service.HolidayService;
import com.xcurenet.emass.holiday.service.HolidayVO;

@Service("holidayService")
public class HolidayServiceImpl extends XcnAbstractDAO implements HolidayService {

	@Override
	public List<HolidayVO> getHolidayList(String busiCd, String year) {
		Map<String, Object> param = new HashMap<>();
		param.put("busiCd", busiCd);
		param.put("year", year);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.holiday.getHolidayList", param);
	}

	@Override
	public boolean isHolidayExist(HolidayVO holiday) {
		return ((int) selectOne("com.xcurenet.sqlmap.mappers.mysql.holiday.isHolidayExist", holiday)) > 0;
	}

	@Override
	public int insertHoliday(HolidayVO holiday) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.holiday.insertHoliday", holiday);
	}
	
	@Override
	public int updateHoliday(HolidayVO holiday) {
		return update("com.xcurenet.sqlmap.mappers.mysql.holiday.updateHoliday", holiday);
	}

	@Override
	public int deleteHoliday(HolidayVO holiday) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.holiday.deleteHoliday", holiday);
	}

}
