package com.xcurenet.emass.workday.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.workday.service.WorkdayService;
import com.xcurenet.emass.workday.service.WorkdayVO;

@Service("workdayService")
public class WorkdayServiceImpl extends XcnAbstractDAO implements WorkdayService {

	@Override
	public WorkdayVO getWorkday(String busiCd) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("busiCd", busiCd);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.workday.getWorkday", param);
	}

	@Override
	public int saveWorkday(WorkdayVO workDay) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.workday.saveWorkday", workDay);
	}
}
