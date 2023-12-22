package com.xcurenet.device.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceTrafficStatService;
import com.xcurenet.device.service.DeviceTrafficStatVO;

@Service("deviceTrafficStatService")
public class DeviceTrafficStatServiceImpl extends XcnAbstractDAO implements DeviceTrafficStatService {

	@Override
	public int updateDeviceTraffic(DeviceTrafficStatVO traffic) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.deviceStat.updateDeviceTraffic", traffic);
	}

	@Override
	public List<Map<String, Object>> getTrafficStatList_Hour(String startDt, String endDt) {
		StringBuffer query1 = new StringBuffer();
		StringBuffer query2 = new StringBuffer();
		for (int i = 0; i < 24; i++) {
			query1.append("CAST( CONCAT( IFNULL(TX_" + Common.lPad(i, 2, "0") + ",'0'), '/', IFNULL(RX_" + Common.lPad(i, 2, "0") + ",'0')) AS CHAR ) \"" + Common.lPad(i, 2, "0") + "\",");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%H') = '" + Common.lPad(i, 2, "0") + "' AND DIRECTION = '1' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"TX_" + Common.lPad(i, 2, "0") + "\",").append("\n");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%H') = '" + Common.lPad(i, 2, "0") + "' AND DIRECTION = '0' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"RX_" + Common.lPad(i, 2, "0") + "\",").append("\n");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDt", startDt);
		param.put("endDt", endDt);
		param.put("query1", query1.toString());
		param.put("query2", query2.toString());
		return selectList("com.xcurenet.sqlmap.mappers.mysql.deviceStat.getTrafficStatList", param);
	}

	@Override
	public List<Map<String, Object>> getTrafficStatList_Week(String startDt, String endDt) {
		StringBuffer query1 = new StringBuffer();
		StringBuffer query2 = new StringBuffer();
		for (int i = 0; i < 7; i++) {
			query1.append("CAST( CONCAT( IFNULL(TX_" + i + ",'0'), '/', IFNULL(RX_" + i + ",'0')) AS CHAR ) \"W_" + i + "\",");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%a') = '" + Common.WEEK_NAME_EN[i] + "' AND DIRECTION = '1' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"TX_" + i + "\",").append("\n");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%a') = '" + Common.WEEK_NAME_EN[i] + "' AND DIRECTION = '0' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"RX_" + i + "\",").append("\n");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDt", startDt);
		param.put("endDt", endDt);
		param.put("query1", query1.toString());
		param.put("query2", query2.toString());
		return selectList("com.xcurenet.sqlmap.mappers.mysql.deviceStat.getTrafficStatList", param);
	}

	@Override
	public List<Map<String, Object>> getTrafficStatList_Day(String startDt, String endDt) {
		StringBuffer query1 = new StringBuffer();
		StringBuffer query2 = new StringBuffer();
		System.out.println("startDt: "+startDt);
		System.out.println("endDt: "+endDt);
		int days = Common.diffOfDate(startDt, endDt);
		System.out.println("days: "+days);

		for (int i = 0; i <= days; i++) {
			String key = Common.formatDate(Common.plusDays(startDt, i));
			System.out.println("key: "+key);
			query1.append("CAST( CONCAT( IFNULL(TX_" + i + ",'0'), '/', IFNULL(RX_" + i + ", '0')) AS CHAR ) \"" + key + "\",");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%Y-%m-%d') = '" + key + "' AND DIRECTION = '1' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"TX_" + i + "\",").append("\n");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%Y-%m-%d') = '" + key + "' AND DIRECTION = '0' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"RX_" + i + "\",").append("\n");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDt", startDt);
		param.put("endDt", endDt);
		param.put("query1", query1.toString());
		param.put("query2", query2.toString());

		return selectList("com.xcurenet.sqlmap.mappers.mysql.deviceStat.getTrafficStatList", param);
	}

	@Override
	public List<Map<String, Object>> getTrafficStatList_Month(String startDt, String endDt) {
		StringBuffer query1 = new StringBuffer();
		StringBuffer query2 = new StringBuffer();
		int months = Common.diffOfMonth(startDt, endDt);
		for (int i = 0; i <= months; i++) {
			String key = Common.formatMonth(Common.plusMonth(startDt, i));
			query1.append("CAST( CONCAT( IFNULL(TX_" + i + ",'0'), '/', IFNULL(RX_" + i + ", '0')) AS CHAR ) \"" + key + "\",");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%Y-%m') = '" + key + "' AND DIRECTION = '1' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"TX_" + i + "\",").append("\n");
			query2.append("SUM( CASE WHEN DATE_FORMAT(INSERT_DT, '%Y-%m') = '" + key + "' AND DIRECTION = '0' THEN CASE WHEN HOUR_SIZE > 0 THEN ROUND(HOUR_SIZE/1024/1024,2) END END ) \"RX_" + i + "\",").append("\n");
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDt", startDt);
		param.put("endDt", endDt);
		param.put("query1", query1.toString());
		param.put("query2", query2.toString());
		return selectList("com.xcurenet.sqlmap.mappers.mysql.deviceStat.getTrafficStatList", param);
	}

}
