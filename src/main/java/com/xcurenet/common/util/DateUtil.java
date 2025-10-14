package com.xcurenet.common.util;

import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class DateUtil {
	private static final DateTimeFormatter yyyyMMdd = DateTimeFormatter.ofPattern("yyyyMMdd");
//	private static final DateTimeFormatter yyyyMM = DateTimeFormatter.ofPattern("yyyyMM");


	public static LocalDate getDay(String str) {
		return LocalDate.parse(str,yyyyMMdd);
	}
	public static LocalDate getMonth(String str) {
		if(str.length() < 8) str = str.concat("01");
		return LocalDate.parse(str,yyyyMMdd);
	}

	public static int getHH(String str) {
		return Integer.parseInt(str);
	}

	public static String getDateStr(String str,LocalDate localDate) {
		if(Common.isEmpty(str) && str.length() == 0 ) return null;
		if(str.length() == 9 ) return localDate.format(yyyyMMdd);
		if(str.length() == 7 ) return localDate.format(yyyyMMdd).substring(0,6);
		else return null;
	}

	public static LocalDate maxDate(List<LocalDate> dates){
		return dates.stream().max(LocalDate::compareTo).get();
	}

	public static LocalDate minDate(List<LocalDate> dates){
		return dates.stream().min(LocalDate::compareTo).get();
	}

	public static LocalDate getMaxDate(String str,List<String> dates){
		return maxDate(toLocalDateList(str,dates));
	}

	public static LocalDate getMinDate(String str,List<String> dates){
		return  minDate(toLocalDateList(str,dates));
	}


	public static List<LocalDate> toLocalDateList(String str,List<String> dates){
		if(Common.isEmpty(dates) && dates.size() == 0 ) return null;
		else return  dates.stream().filter(m-> !Common.isEquals(m.trim(),"")).map(m -> getDate(str,m)).collect(Collectors.toList());
	}


	public static LocalDate getDate(String str,String value){
		if(Common.isEmpty(str) && str.length() == 0 ) return null;
		if( str.length() == 9 ) return getDay(value);
		if( str.length() == 7 ) return getMonth(value);
		else return null;
	}

	public static LocalDate convertToLocalDate(String dateStr) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		LocalDate date = LocalDate.parse(dateStr, formatter);
		return date;
	}


	public static String getYearMonthStringRange(String startDateStr,String endDateStr){
		LocalDate startDate = convertToLocalDate(startDateStr);
		LocalDate endDate = convertToLocalDate(endDateStr);
		if(Common.isNotEmpty(startDate) && Common.isNotEmpty(endDate)){
			return 	getYearMonthStringRange(startDate,endDate);
		}else return "";
	}

	public static String getYearMonthStringRange(LocalDate startDate, LocalDate endDate) {
		// 결과를 저장할 Set (중복 제거 및 순서 유지)
		Set<String> yearMonthSet = new LinkedHashSet<>();
		// 시작 날짜를 YearMonth로 변환
		YearMonth currentYearMonth = YearMonth.from(startDate);
		// 종료 날짜를 YearMonth로 변환
		YearMonth endYearMonth = YearMonth.from(endDate);

		// 시작 연월부터 종료 연월까지 반복
		while (!currentYearMonth.isAfter(endYearMonth)) {
			yearMonthSet.add(currentYearMonth.toString().replace("-", ""));
			currentYearMonth = currentYearMonth.plusMonths(1);
		}
		// 결과를 쉼표로 연결하여 반환
		return yearMonthSet.stream().sorted().collect(Collectors.joining(","));
	}


}
