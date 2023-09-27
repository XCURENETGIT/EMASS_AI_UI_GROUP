package com.xcurenet.emass.statistics.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.statistics.service.CheckedReadStatService;
import com.xcurenet.emass.statistics.service.CheckedReadStatVO;


@Service("checkedReadStatService")
public class CheckedReadStatServiceImpl extends XcnAbstractDAO implements CheckedReadStatService {

	public Map<String, Object> getCheckedReadStatList(String xAxis, String startDate, String endDate, String adminType, String adminId) {
		
		Map<String, String> params = new HashMap<>();
		
		params.put("xAxis", xAxis);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("adminType", adminType);
		params.put("adminId", adminId);
		
		if(Common.isEquals(xAxis, "ctime_hh")) {
			params.put("dateFormat", "HH");
		} else if(Common.isEquals(xAxis, "ctime_yyyymmdd")) {
			params.put("dateFormat", "yyyyMMdd");
		} else if(Common.isEquals(xAxis, "ctime_yyyymm")) {
			params.put("dateFormat", "yyyyMM");
		}  
		
		List<CheckedReadStatVO> list = selectList("com.xcurenet.sqlmap.mappers.phoenix.stat.getCheckedReadStatList", params);

		Map<String, Object> result = new HashMap<String, Object>();
		
		List<String> header = new ArrayList<String>();
		for(CheckedReadStatVO item : list) {
			header.add(item.getHeader());
		}
        //List<String> duplicateRemoveList = new ArrayList<String>(new LinkedHashSet<String>(header));
		
        ArrayList<String> dataList = new ArrayList<String>(new HashSet <String>(header));
        Collections.sort(dataList);

		result.put("list", list);
		result.put("header", dataList);
		
		return result;
	}
}
