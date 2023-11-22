//package com.xcurenet.emass.analysis.service;
//
//import java.util.List;
//
//import com.xcurenet.common.util.Common;
//import com.xcurenet.emass.message.service.SolrEdcVO;
//
//
//public class ServiceCodeCheck {
//
//	public static String getContentsName(SolrEdcVO edcVO) {
//		String content = "";
//		String subject = edcVO.getSubject();
//		if(subject != null) {
//			int len;
//			if((len = subject.indexOf("FW:")) > -1) {
//				subject = subject.substring(len + 3);
//			}
//			if((len = subject.indexOf("RE:")) > -1) {
//				subject = subject.substring(len + 3);
//			}
//			subject = subject.length() < 10 ? subject : subject.substring(0, 10) + "...";
//		}
//		switch(edcVO.getSvc().substring(0, 1)) {
//		case "M" :
//			content = getContents(edcVO.getSender(), " - ", subject);
//			break;
//		case "W" :
//			content = getContents(edcVO.getSender(), " - ", subject);
//			break;
//		case "C" :
//			content = getContents(edcVO.getHost(), edcVO.getPath());
//			break;
//		case "S" :
//			content = getContents(edcVO.getHost(), edcVO.getPath());
//			break;
//		case "V" :
//			content = getContents(edcVO.getHost(), edcVO.getPath());
//			break;
//		case "Q" :
//			content = getContents(edcVO.getHost(), edcVO.getPath());
//			break;
//		case "F" :
//			if(edcVO.getSvc().contains("FFT")) {
//				content = getContents(edcVO.getDstip());
//			} else {
//				content = getContents(edcVO.getHost(), edcVO.getPath());
//			}
//			break;
//		case "Z" :
//			switch(edcVO.getSvc()) {
//			case "ZTN" :
//				content = getContents(edcVO.getDstip());
//				break;
//			case "ZXT" :
//				content = getContents(edcVO.getDstip());
//				break;
//			case "ZRL" :
//				content = getContents(edcVO.getDstip());
//				break;
//			case "ZNP" :
//				content = getContents(edcVO.getDstip());
//				break;
//			case "ZPC" :
//				content = getContents(edcVO.getDstip());
//				break;
//			}
//			break;
//		case "U" :
//			content = edcVO.getHost() + edcVO.getPath();
//			break;
//		case "E" :
//			if(edcVO.getSvc().contains("EMM")) {
//				content = getContents(edcVO.getSender(), " - ", subject);
//			} else {
//				content = getContents(edcVO.getHost(), edcVO.getPath());
//			}
//			break;
//		}
//
//		return content;
//	}
//
//	public static String getSender(String svc, String ip, String mailid) {
//		String content = "";
//		switch(svc.substring(0, 1)) {
//		case "M" :
//		case "W" :
//			if(Common.isEmpty(ip)) {
//				content = mailid;
//			} else {
//				content = getContents(ip, " (", mailid, ")");
//			}
//			break;
//		case "C" :
//			content = ip;
//			break;
//		case "S" :
//			content = ip;
//			break;
//		case "V" :
//			content = ip;
//			break;
//		case "Q" :
//			content = ip;
//			break;
//		case "F" :
//			content = ip;
//			break;
//		case "Z" :
//			switch(svc) {
//			case "ZTN" :
//				content = ip;
//				break;
//			case "ZXT" :
//				content = ip;
//				break;
//			case "ZRL" :
//				content = ip;
//				break;
//			case "ZNP" :
//				content = ip;
//				break;
//			case "ZPC" :
//				content = ip;
//				break;
//			}
//			break;
//		case "U" :
//			content = ip;
//			break;
//		case "E" :
//			if(svc.substring(0, 3).contains("EMM")) {
//				if(Common.isEmpty(ip)) {
//					content = mailid;
//				} else {
//					content = getContents(ip, " (", mailid, ")");
//				}
//			} else {
//				content = ip;
//			}
//			break;
//		}
//
//		return content;
//	}
//
//	public static String getSankeySender(String svc, String ip, String mailid) {
//		String content = "";
//		switch(svc.substring(0, 1)) {
//		case "M" :
//		case "W" :
//			content = mailid;
//			break;
//		case "C" :
//			content = ip;
//			break;
//		case "S" :
//			content = ip;
//			break;
//		case "V" :
//			content = ip;
//			break;
//		case "Q" :
//			content = ip;
//			break;
//		case "F" :
//			content = ip;
//			break;
//		case "Z" :
//			switch(svc) {
//			case "ZTN" :
//				content = ip;
//				break;
//			case "ZXT" :
//				content = ip;
//				break;
//			case "ZRL" :
//				content = ip;
//				break;
//			case "ZNP" :
//				content = ip;
//				break;
//			case "ZPC" :
//				content = ip;
//				break;
//			}
//			break;
//		case "U" :
//			content = ip;
//			break;
//		case "E" :
//			if(svc.substring(0, 3).contains("EMM")) {
//				content = mailid;
//			} else {
//				content = ip;
//			}
//			break;
//		}
//
//		return content;
//	}
//
//	public static long getUnitValue(SolrEdcVO edcVO, String item) {
//		long value = 0;
//		String firstServiceCode = edcVO.getSvc().substring(0, 1);
//		String SecondServiceCode = edcVO.getSvc().substring(0, 2);
//		String ThirdServiceCode = edcVO.getSvc().substring(0, 2);
//		switch(item) {
//		case "outMail" :
//			if(firstServiceCode.equals("P") || firstServiceCode.equals("I") || firstServiceCode.equals("W")) {
//				value = 1;
//			}
//			break;
//		case "inMail" :
//			if(firstServiceCode.equals("P") || firstServiceCode.equals("I") || firstServiceCode.equals("M") || ThirdServiceCode.equals("EMM")) {
//				value = 1;
//			}
//			break;
//		case "fileSize" :
//			List<Long> sizes = edcVO.getAttachsize();
//			if(sizes == null) {
//				value = 0;
//			} else {
//				for (Long size : sizes) {
//					value += size;
//				}
//			}
//			break;
//		case "ftp" :
//			if(SecondServiceCode.equals("FF")) {
//				value = edcVO.getSize();
//			}
//			break;
//		case "totalSize" :
//			value = edcVO.getSize();
//			break;
//		}
//		return value;
//	}
//
//	public static long getUnitValue(UsageChartSchedulerVO usageChartSchedulerVO, String item) {
//		long value = 0;
//		switch(item) {
//		case "outMail" :
//			value = usageChartSchedulerVO.getOutMail();
//			break;
//		case "inMail" :
//			value = usageChartSchedulerVO.getInMail();
//			break;
//		case "fileSize" :
//			value = usageChartSchedulerVO.getFileSize();
//			break;
//		case "ftp" :
//			value = usageChartSchedulerVO.getFtp();
//			break;
//		case "totalSize" :
//			value = usageChartSchedulerVO.getTotalSize();
//			break;
//		}
//		return value;
//	}
//
//	private static String getContents(String... messages) {
//		StringBuilder sb = new StringBuilder();
//		for (String message : messages) {
//			sb.append(message);
//		}
//		return sb.toString();
//	}
//
//}
