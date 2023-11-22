//package com.xcurenet.emass.analysis.service;
//
//import java.io.IOException;
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Calendar;
//import java.util.HashMap;
//import java.util.Iterator;
//import java.util.List;
//import java.util.Map;
//
//import org.joda.time.DateTime;
//import org.joda.time.format.DateTimeFormat;
//import org.joda.time.format.DateTimeFormatter;
//
//import com.fasterxml.jackson.core.JsonParseException;
//import com.fasterxml.jackson.databind.JsonMappingException;
//import com.xcurenet.common.util.Common;
//import com.xcurenet.common.vo.XcnFacetsVO;
//import com.xcurenet.emass.message.service.SolrEdcMessageVO;
//
//import lombok.Data;
//import lombok.Getter;
//import lombok.Setter;
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//public class UsageColumnChartVO extends XcnFacetsVO {
//
//	public UsageColumnChartVO(SolrEdcMessageVO edc, String item, String unit) throws JsonParseException, JsonMappingException, IOException {
//		super(edc);
//		this.usageBuckets = getList(new UsageBuckets());
//		setChartData(item);
//		if (unit.equals("w")) {
//			setWeekData();
//		}
//	}
//
//	private List<UsageBuckets> usageBuckets;
//	@Getter
//	@Setter
//	private String name;
//	@Getter
//	private List<ColumnChart> data;
//
//	public static class UsageBuckets extends XcnFacetsVO.Buckets {
//		@Getter
//		@Setter
//		private long size;
//	}
//
//	public @Data class ColumnChart {
//		private String name;
//		private long y;
//	}
//
//	private void setChartData(String item) {
//		this.data = new ArrayList<ColumnChart>();
//
//		for (UsageBuckets usageBucket : usageBuckets) {
//			ColumnChart columnChart = new ColumnChart();
//
//			if (item.equals("inMail") || item.equals("outMail")) {
//				columnChart.setY(usageBucket.getCount());
//			} else {
//				columnChart.setY(usageBucket.getSize());
//			}
//			String date = "";
//			switch (usageBucket.getVal().length()) {
//				case 6:
//					date = Common.formatMonth(usageBucket.getVal());
//					break;
//				case 8:
//					date = Common.formatDate(usageBucket.getVal());
//					break;
//				case 2:
//					date = Common.formatDate(new StringBuilder().append(usageBucket.getVal()).append("Hour").toString());
//					break;
//				default:
//					date = usageBucket.getVal();
//			}
//			columnChart.setName(date);
//			data.add(columnChart);
//		}
//	}
//
//	private void setWeekData() {
//		Map<String, Long> tmpData = new HashMap<>();
//		for (ColumnChart columnChart : data) {
//			String key = firstDateOfWeek(columnChart.getName());
//			if (tmpData.containsKey(key)) {
//				tmpData.put(key, tmpData.get(key) + columnChart.getY());
//			} else {
//				tmpData.put(key, columnChart.getY());
//			}
//		}
//
//		data.clear();
//		Iterator<String> keys = tmpData.keySet().iterator();
//		while (keys.hasNext()) {
//			String key = keys.next();
//			ColumnChart columnChart = new ColumnChart();
//			columnChart.setY(tmpData.get(key));
//			columnChart.setName(key);
//			data.add(columnChart);
//		}
//	}
//
//	private String firstDateOfWeek(String orgDate) {
//		Calendar calendar = Calendar.getInstance();
//		// the day of the week spelled out completely
//		SimpleDateFormat simpleDateformat = new SimpleDateFormat("yyyyMMdd");
//		try {
//			calendar.setTimeInMillis(simpleDateformat.parse(orgDate).getTime());
//		} catch (ParseException e) {
//			log.error("주단위 데이터 생성시 날짜 데이터 오류", e);
//		}
//		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
//		DateTime date = DateTime.parse(orgDate.replaceAll("-", ""), yyyyMMdd);
//		return yyyyMMdd.print(date.plusDays(-1 * (calendar.get(Calendar.DAY_OF_WEEK) - 1)));
//	}
//
//}
