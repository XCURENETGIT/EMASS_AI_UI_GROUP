//package com.xcurenet.emass.analysis.service;
//
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Calendar;
//import java.util.List;
//
//import org.joda.time.DateTime;
//import org.joda.time.format.DateTimeFormat;
//import org.joda.time.format.DateTimeFormatter;
//
//import com.xcurenet.common.util.Common;
//import com.xcurenet.emass.message.service.SolrEdcVO;
//
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//public class UsageChart {
//
//	public List<UsageChartVO> getData(String item, String unit, List<SolrEdcVO> list) {
//		List<UsageChartVO> dataList = new ChartArrayList<>();
//
//		switch (unit) {
//			case "t":
//				dataList = timeDataProcessing(list, item);
//				break;
//
//			case "d":
//				dataList = dayDataProcessing(list, item);
//				break;
//			case "w":
//				dataList = weekDataProcessing(list, item);
//				break;
//			case "m":
//				dataList = monthDataProcessing(list, item);
//				break;
//		}
//
//		return dataList;
//	}
//
//	public List<UsageChartVO> timeDataProcessingScheduler(List<UsageChartSchedulerVO> usageChartSchedulerVOList, List<UsageChartSchedulerVO> averageList, SearchVO searchVO) throws Exception {
//		List<UsageChartVO> list = new ChartArrayList<>();
//		String startDate = getDate(searchVO.getStartDate());
//		String endDate = getDate(searchVO.getEndDate());
//		int diff = Common.diffOfDate(startDate, endDate);
//
//		for (UsageChartSchedulerVO usageChartSchedulerVO : usageChartSchedulerVOList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setKey(new StringBuilder().append(Common.formatDate(usageChartSchedulerVO.getCtime().substring(0, 8))).append(" ").append(usageChartSchedulerVO.getDateTime()).append("H").toString());
//			usageChartVO.setDate(usageChartSchedulerVO.getCtime());
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//			usageChartVO.setDayOfWeek(usageChartSchedulerVO.getDateDayOfWeek());
//			list.add(usageChartVO);
//		}
//		for (UsageChartVO usageChartVO : list) {
//			long average = 0;
//			int resultCount = 0;
//			long searchDate = Common.getTime(Common.plusDays(getDate(usageChartVO.getDate()), -1 * diff));
//			for (UsageChartSchedulerVO usageChartSchedulerVO : averageList) {
//				long averageDate = Common.getTime(getDate(usageChartSchedulerVO.getCtime()));
//				if (usageChartVO.getDate().substring(8, 10).equals(usageChartSchedulerVO.getDateTime()) && usageChartVO.getDayOfWeek() == usageChartSchedulerVO.getDateDayOfWeek() && searchDate > averageDate) {
//					average += ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem());
//					resultCount++;
//				}
//			}
//			usageChartVO.setAverage(resultCount == 0 ? 0 : (average / resultCount));
//		}
//
//		return list;
//	}
//
//	public List<UsageChartVO> dayDataProcessingScheduler(List<UsageChartSchedulerVO> usageChartSchedulerVOList, List<UsageChartSchedulerVO> averageList, SearchVO searchVO) throws Exception {
//		List<UsageChartVO> list = new ChartArrayList<>();
//		String startDate = getDate(searchVO.getStartDate());
//		String endDate = getDate(searchVO.getEndDate());
//		int diff = Common.diffOfDate(startDate, endDate);
//
//		for (UsageChartSchedulerVO usageChartSchedulerVO : usageChartSchedulerVOList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			String date = Common.formatDate(new StringBuilder().append(usageChartSchedulerVO.getDateMonth()).append(usageChartSchedulerVO.getDateDay()).toString());
//			usageChartVO.setKey(date);
//			usageChartVO.setDate(date);
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//			usageChartVO.setDayOfWeek(usageChartSchedulerVO.getDateDayOfWeek());
//			list.add(usageChartVO);
//		}
//		for (UsageChartVO usageChartVO : list) {
//			int resultCount = 0;
//			long searchDate = Common.getTime(Common.plusDays(usageChartVO.getDate(), -1 * diff));
//			for (UsageChartSchedulerVO usageChartSchedulerVO : averageList) {
//				long averageDate = Common.getTime(new StringBuilder().append(usageChartSchedulerVO.getDateMonth()).append(usageChartSchedulerVO.getDateDay()).toString());
//				if (usageChartVO.getDayOfWeek() == usageChartSchedulerVO.getDateDayOfWeek() && searchDate > averageDate) {
//					usageChartVO.setAverage(usageChartVO.getAverage() + ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//					resultCount++;
//				}
//			}
//			long average = (resultCount == 0 ? 0 : (usageChartVO.getAverage() / resultCount));
//			usageChartVO.setAverage(average);
//		}
//
//		return list;
//	}
//
//	public List<UsageChartVO> weekDataProcessingScheduler(List<UsageChartSchedulerVO> usageChartSchedulerVOList, List<UsageChartSchedulerVO> averageList, SearchVO searchVO) throws Exception {
//		List<UsageChartVO> list = new ChartArrayList<>();
//		String startDate = getDate(searchVO.getStartDate());
//		String endDate = getDate(searchVO.getEndDate());
//		int diff = Common.diffOfDate(startDate, endDate);
//
//		for (UsageChartSchedulerVO usageChartSchedulerVO : usageChartSchedulerVOList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setKey(new StringBuilder().append(Common.formatMonth(usageChartSchedulerVO.getDateMonth())).append(" ").append(usageChartSchedulerVO.getDateWeekOfMonth()).append("Week").toString());
//			usageChartVO.setDate(firstDateOfWeek(usageChartSchedulerVO.getCtime().substring(0, 8)));
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//			usageChartVO.setWeekOfMonth(usageChartSchedulerVO.getDateDayOfWeek());
//			list.add(usageChartVO);
//		}
//		for (UsageChartVO usageChartVO : list) {
//			int resultCount = 0;
//			long searchDate = Common.getTime(Common.plusWeek(usageChartVO.getDate(), -1 * (diff < 7 ? 0 : diff % 7)));
//			for (UsageChartSchedulerVO usageChartSchedulerVO : averageList) {
//				long averageDate = Common.getTime(firstDateOfWeek(usageChartSchedulerVO.getCtime().substring(0, 8)));
//				if (searchDate > averageDate) {
//					usageChartVO.setAverage(usageChartVO.getAverage() + ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//					resultCount++;
//				}
//			}
//			long average = (resultCount == 0 ? 0 : (usageChartVO.getAverage() / resultCount));
//			usageChartVO.setAverage(average);
//		}
//
//		return list;
//	}
//
//	public List<UsageChartVO> monthDataProcessingScheduler(List<UsageChartSchedulerVO> usageChartSchedulerVOList, List<UsageChartSchedulerVO> averageList, SearchVO searchVO) throws Exception {
//		List<UsageChartVO> list = new ChartArrayList<>();
//		String startDate = getDate(searchVO.getStartDate());
//		String endDate = getDate(searchVO.getEndDate());
//		int diff = Common.diffOfMonth(startDate, endDate);
//
//		for (UsageChartSchedulerVO usageChartSchedulerVO : usageChartSchedulerVOList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setKey(Common.formatMonth(usageChartSchedulerVO.getDateMonth()));
//			usageChartVO.setDate(usageChartSchedulerVO.getDateMonth());
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//			list.add(usageChartVO);
//		}
//		for (UsageChartVO usageChartVO : list) {
//			int resultCount = 0;
//			long searchDate = Common.getTime(Common.plusMonth(usageChartVO.getDate() + "01", -1 * diff));
//			for (UsageChartSchedulerVO usageChartSchedulerVO : averageList) {
//				long averageDate = Common.getTime(usageChartSchedulerVO.getDateMonth() + "01");
//				if (searchDate > averageDate) {
//					usageChartVO.setAverage(usageChartVO.getAverage() + ServiceCodeCheck.getUnitValue(usageChartSchedulerVO, searchVO.getItem()));
//					resultCount++;
//				}
//			}
//			long average = (resultCount == 0 ? 0 : (usageChartVO.getAverage() / resultCount));
//			usageChartVO.setAverage(average);
//		}
//
//		return list;
//	}
//
//	private List<UsageChartVO> timeDataProcessing(List<SolrEdcVO> edcList, String item) {
//		List<UsageChartVO> list = new ChartArrayList<>();
//
//		for (SolrEdcVO edc : edcList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setKey(new StringBuilder().append(Common.formatDate(edc.getCtime_yyyymmdd())).append(" ").append(edc.getCtime_hh()).append("Hour").toString());
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(edc, item));
//		}
//		return list;
//	}
//
//	private List<UsageChartVO> dayDataProcessing(List<SolrEdcVO> edcList, String item) {
//		List<UsageChartVO> list = new ChartArrayList<>();
//
//		for (SolrEdcVO edc : edcList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setDate(Common.formatDate(edc.getCtime_yyyymmdd()));
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(edc, item));
//		}
//		return list;
//	}
//
//	private List<UsageChartVO> weekDataProcessing(List<SolrEdcVO> edcList, String item) {
//		List<UsageChartVO> list = new ChartArrayList<>();
//
//		for (SolrEdcVO edc : edcList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setDate(Common.formatDate(firstDateOfWeek(edc.getCtime_yyyymmdd())));
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(edc, item));
//		}
//		return list;
//	}
//
//	private List<UsageChartVO> monthDataProcessing(List<SolrEdcVO> edcList, String item) {
//		List<UsageChartVO> list = new ChartArrayList<>();
//
//		for (SolrEdcVO edc : edcList) {
//			UsageChartVO usageChartVO = new UsageChartVO();
//			usageChartVO.setDate(Common.formatMonth(edc.getCtime_yyyymm()));
//			usageChartVO.setValue(ServiceCodeCheck.getUnitValue(edc, item));
//		}
//		return list;
//	}
//
//	private String getDate(String date) {
//		return date.replaceAll("-", "").substring(0, 8);
//	}
//
//	public String firstDateOfWeek(String orgDate) {
//
//		Calendar calendar = Calendar.getInstance();
//
//		// the day of the week spelled out completely
//		SimpleDateFormat simpleDateformat = new SimpleDateFormat("yyyyMMdd");
//		try {
//			calendar.setTimeInMillis(simpleDateformat.parse(orgDate).getTime());
//		} catch (ParseException e) {
//			log.error("주단위 데이터 생성시 날짜 데이터 오류", e);
//		}
//
//		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
//		DateTime date = DateTime.parse(orgDate.replaceAll("-", ""), yyyyMMdd);
//		return yyyyMMdd.print(date.plusDays(-1 * (calendar.get(Calendar.DAY_OF_WEEK) - 1)));
//	}
//
//	public class ChartArrayList<E> extends ArrayList<E> {
//
//		private static final long serialVersionUID = 1L;
//
//		@Override
//		public boolean add(E objectList) {
//			boolean add = true;
//			if (objectList instanceof UsageChartVO) {
//				for (int i = 0; i < this.size(); i++) {
//					if (((UsageChartVO) objectList).getDate().equals(((UsageChartVO) this.get(i)).getDate())) {
//						(((UsageChartVO) this.get(i))).setValue(((UsageChartVO) this.get(i)).getValue() + ((UsageChartVO) objectList).getValue());
//						add = false;
//						break;
//					}
//				}
//
//				if (add) {
//					boolean isAdd = true;
//					for (int i = 0; i < this.size(); i++) {
//						if (((UsageChartVO) objectList).getDate().equals(((UsageChartVO) this.get(i)).getDate())) {
//							super.add(i, objectList);
//							isAdd = false;
//							break;
//						}
//					}
//					if (isAdd) {
//						super.add(objectList);
//					}
//				}
//			} else {
//				return false;
//			}
//
//			return true;
//		}
//	}
//}
