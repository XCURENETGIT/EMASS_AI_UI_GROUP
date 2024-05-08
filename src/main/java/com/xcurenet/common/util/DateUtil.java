package com.xcurenet.common.util;

import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
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






}
