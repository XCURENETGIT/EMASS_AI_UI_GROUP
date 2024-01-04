package com.xcurenet.common.util;

import com.jcraft.jsch.JSchException;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.parser.useragent.Client;
import com.xcurenet.common.parser.useragent.Parser;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.component.AttachFile;
import com.xcurenet.emass.message.service.EmsReDefined;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.joda.time.*;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.lang.reflect.Field;
import java.math.BigInteger;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Array;
import java.sql.SQLException;
import java.sql.Types;
import java.text.*;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;

@Slf4j
public class Common {

	public static final String UTF8 = "UTF-8";

	public static final String EUCKR = "EUC-KR";

	public static final byte[] EMPTY_BYTE_ARRAY = new byte[0];

	public static final int SIZEOF_SHORT = Short.SIZE / Byte.SIZE;

	public static final String EMPTY = "";

	public static final String EMPTY_LINE = "\n";

	public static final String SESSION_CREDENTIAL = "_USERCREDENTIAL_";

	public static final String SHA_256 = "SHA-256";

	public static final String SHA_512 = "SHA-512";

	public static final char[] HEXARRAY = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

	public static final String NO_DATA = "No Data";

	public static final String[] WEEK_NAME_KR = new String[] {"일", "월", "화", "수", "목", "금", "토"};

	public static final String[] WEEK_NAME_EN = new String[] {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

	public static final String TMP_PATH = "/users/apache/temp/";

	public static final int MAX_POST_SIZE = Integer.MAX_VALUE; // 1.9GB

	public static final String[] EXT_IMGS = new String[] {"asf", "avi", "bmp", "doc", "docx", "gif", "gul", "htm", "html", "hwp", "jpeg", "jpg", "link", "mp3", "mp4", "office", "pdf", "png", "ppt", "pptx", "rar", "text", "txt", "wav", "xls", "xlsx", "xml", "zip"};

	public static final byte FILL = 0x00;

	public static final String HEADER_CHECK = "x-requested-with";

	public static final String HEADER_WEB_VIEW = "com.xcurenet.lars";

	public static final String HEADER_AJAX = "XMLHttpRequest";
	
	public static final int MAX_VALUE = 10000; //엘라스틱 서치 최대 검색
	public static String number;

	public static final DateTimeFormatter DATETIMEMILLISSYMBOL = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

	public static final DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");

	public static final DateTimeFormatter yyyy_MM_dd_HH_mm_ss = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	public static String getWeekName(int week) {
		return WEEK_NAME_EN[week];
	}

	public static boolean isWindow() {
		return System.getProperty("os.name").toLowerCase().startsWith("windows");
	}

	public static void release(HttpSession session) {
		if (session != null && session.getAttribute(SESSION_CREDENTIAL) != null) {
			session.removeAttribute(SESSION_CREDENTIAL);
		}
		if (session != null) {
			session.invalidate();
		}
	}

	/**
	 * session adminId
	 *
	 * @param request
	 * @return
	 */
	public static String getAdminId(final HttpServletRequest request) {
		AdminVO admin = getAdmin(request);
		if (admin != null) {
			return Common.nvl(admin.getAdminId());
		}
		return null;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static String getAdminType(final HttpSession _session) {
		AdminVO admin = getAdmin(_session);
		if (admin != null) {
			return Common.nvl(admin.getAdminType());
		}
		return Common.EMPTY;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static String getFirstAdminYn(final HttpSession _session) {
		AdminVO admin = getAdmin(_session);
		if (admin != null) {
			return Common.nvl(admin.getFirstAdminYn());
		}
		return Common.EMPTY;
	}
	
	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static String getInfoFeedbackYn(final HttpSession _session) {
		AdminVO admin = getAdmin(_session);
		if (admin != null) {
			return Common.nvl(admin.getInfoFeedbackYn());
		}
		return Common.EMPTY;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static String getAdminId(final HttpSession _session) {
		AdminVO admin = getAdmin(_session);
		if (admin != null) {
			return Common.nvl(admin.getAdminId());
		}
		return Common.EMPTY;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static AdminVO getAdmin(final HttpServletRequest request) {
		if (request == null) return null;
		AdminVO admin = getAdmin(request.getSession(false));
		if (admin == null) admin = new AdminVO();
		return admin;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static AdminVO getAdmin(final HttpSession _session) {
		if (_session != null) {
			AdminVO admin = (AdminVO) _session.getAttribute(SESSION_CREDENTIAL);
			if (admin != null) {
				return admin;
			}
		}
		return null;
	}

	public static Locale getLocale(HttpSession session) {
		Locale locale = null;
		locale = (Locale) session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
		if (locale == null) {
			locale = Locale.KOREAN;
		}
		return locale;
	}

	public static Locale getLocale() {
		String locale = Config.getString("default.lang");
		Locale lo = null;
		if (locale.matches("en")) {
			lo = Locale.ENGLISH;
		} else if (locale.matches("kr")) {
			lo = Locale.KOREAN;
		} else {
			lo = Locale.KOREAN;
		}
		return lo;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static JSONObject getParam(final HttpServletRequest request) {
		if (request == null) return null;
		JSONObject result = new JSONObject();
		Map<?, ?> _param = request.getParameterMap();
		Enumeration<?> _enum = request.getParameterNames();
		while (_enum.hasMoreElements()) {
			String name = (String) _enum.nextElement();
			String val[] = (String[]) _param.get(name);
			result.put(name, Common.nvl(val[0]));
		}
		HttpSession _session = request.getSession(false);
		if (_session != null) {
			AdminVO admin = (AdminVO) _session.getAttribute(SESSION_CREDENTIAL);
			if (admin != null) {
				result.put("_ses_user_id", Common.nvl(admin.getAdminId()));
				result.put("_ses_user_name", Common.nvl(admin.getAdminName()));
				result.put("_ses_user_ip", admin.getLoginIp());
				result.put("_ses_user_type", Common.nvl(admin.getAdminType()));
			}
		}
		return result;
	}

	/**
	 * param to map
	 *
	 * @param request
	 * @return
	 */
	public static Map<String, Object> getParamMap(HttpServletRequest request) {
		if (request == null) return null;
		Map<String, Object> result = new HashMap<String, Object>();
		Map<?, ?> _param = request.getParameterMap();
		Enumeration<?> _enum = request.getParameterNames();
		while (_enum.hasMoreElements()) {
			String name = (String) _enum.nextElement();
			String val[] = (String[]) _param.get(name);
			if (!name.equals("gridData")) {
				result.put(name, val[0]);
			}
		}
		HttpSession _session = request.getSession(false);
		if (_session != null) {
			AdminVO admin = (AdminVO) _session.getAttribute(SESSION_CREDENTIAL);
			if (admin != null) {
				result.put("_ses_user_id", Common.nvl(admin.getAdminId()));
				result.put("_ses_user_name", Common.nvl(admin.getAdminName()));
				result.put("_ses_user_ip", admin.getLoginIp());
				result.put("_ses_user_type", Common.nvl(admin.getAdminType()));
			}
		}
		return result;
	}

	public static boolean isOrEquals(Object source, String[] target) {
		if (source == null) return false;
		boolean result = false;
		for (int i = 0; i < target.length; i++) {
			result = source.equals(Common.nvl(target[i]));
			if (result) break;
		}
		return result;
	}

	/**
	 * @param target
	 * @return
	 */
	public static boolean isOrEquals(Object source, Object... target) {
		if (source == null) return false;
		boolean result = false;
		for (int i = 0; i < target.length; i++) {
			result = source.equals(Common.nvl(target[i]));
			if (result) break;
		}
		return result;
	}

	/**
	 * @param target
	 * @return
	 */
	public static boolean isEquals(Object source, Object target) {
		return ((source == null) ? false : (target == null) ? true : source.equals(target));
	}

	/**
	 * @param target
	 * @return
	 */
	public static boolean isNotEquals(Object source, Object target) {
		return ((source == null) ? true : (target == null) ? false : !source.equals(target));
	}

	/**
	 * Java String isEmpty This Java String isEmpty shows how to check whether
	 * the given string is empty or not using isEmpty method of Java String
	 * class.
	 *
	 * @param target
	 * @return
	 */
	public static boolean isEmpty(Object target) {
		return nvl(target).isEmpty();
	}

	/**
	 * Java String isEmpty This Java String isEmpty shows how to check whether
	 * the given string is empty or not using isEmpty method of Java String
	 * class.
	 *
	 * @param target
	 * @return
	 */
	public static boolean isNotEmpty(Object target) {
		return !isEmpty(target);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static String nvl(Object target) {
		return nvl(target, Common.EMPTY);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static String nvl(Object target, String defaultStr) {
		String result = defaultStr;
		if (target != null) {
			if (!String.valueOf(target).toLowerCase().equals("null")) return String.valueOf(target);
		}
		return result;
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static String nvl4html(Object target) {
		return nvl4html(target, Common.EMPTY);
	}

	public static String nvl4html(Object target, String defaultStr) {
		String result = defaultStr;
		if (target != null) {
			if (!String.valueOf(target).toLowerCase().equals("null")) return StringEscapeUtils.escapeHtml(String.valueOf(target));
		}
		return result;
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static int nvz(Object target) {
		return nvz(target, 0);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static int nvz(Object target, int defaultNum) {
		int result = defaultNum;
		if (target != null) {
			if (!String.valueOf(target).toLowerCase().equals("null") && !String.valueOf(target).equals("")) {
				try {
					return Integer.parseInt(String.valueOf(target));
				} catch (Exception e) {
					return defaultNum;
				}
			}
		}
		return result;
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static short nvs(Object target) {
		return nvs(target, (short) 0);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static short nvs(Object target, short defaultNum) {
		short result = defaultNum;
		if (target != null) {
			if (!String.valueOf(target).toLowerCase().equals("null") && !String.valueOf(target).equals("")) return Short.parseShort(String.valueOf(target));
		}
		return result;
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static long nvn(Object target) {
		return nvn(target, 0L);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static long nvn(Object target, long defaultNum) {
		long result = defaultNum;
		if (target != null) {
			if (!String.valueOf(target).toLowerCase().equals("null") && !String.valueOf(target).equals("")) return Long.parseLong(String.valueOf(target));
		}
		return result;
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static float nvf(Object target) {
		return nvf(target, 0.0F);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static float nvf(Object target, float defaultNum) {
		if (target != null) {
			if (!String.valueOf(target).equalsIgnoreCase("null") && !String.valueOf(target).isEmpty()) return Float.parseFloat(String.valueOf(target));
		}
		return defaultNum;
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static double nvd(Object target) {
		return nvf(target, 0.0F);
	}

	/**
	 * Null to Empty String
	 *
	 * @param target
	 * @return
	 */
	public static double nvd(Object target, float defaultNum) {
		if (target != null) {
			if (!String.valueOf(target).equalsIgnoreCase("null") && !String.valueOf(target).isEmpty()) return Double.parseDouble(String.valueOf(target));
		}
		return defaultNum;
	}

	/**
	 * Trim All
	 *
	 * @param target
	 * @return
	 */
	public static String trimAll(Object target) {
		return nvl(target).replaceAll("\\s+", "");
	}

	/**
	 * 특정 문자열의 자릿수 만큼 원하는 문자열을 오른쪽에 채워 넣는다.
	 *
	 * @param nValue
	 * @param nLength
	 * @param nDefault
	 * @return
	 */
	public static String formatString(String nValue, int nLength, String nDefault) {
		String result = nValue;
		if (nValue.length() < nLength) {
			int i = nLength - nValue.length();
			for (int j = 0; j < i; j++) {
				result += nDefault;
			}
		}
		return result;
	}

	public static long getUnsignedInt(int n) {
		return n & 0xFFFFFFFFL;
	}

	private static final String PATTERN = "^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." + "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." + "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." + "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";

	public static boolean isValidIPV4(final String s) {
		Pattern pattern = Pattern.compile(PATTERN);
		Matcher matcher = pattern.matcher(s);
		return matcher.matches();
	}

	public static String inet_ntoa(long addr) {
		return inet_ntoa(nvl(addr));
	}

	public static String inet_ntoa(String addr) {
		long ip = Long.parseLong(addr);
		if (ip > 4294967295l || ip < 0) {
			log.error("INVALID IP ADDRESS {}", addr);
			return "0";
		}
		if (ip == 0) return "0";

		StringBuilder ipAddress = new StringBuilder();
		for (int i = 3; i >= 0; i--) {
			int shift = i * 8;
			ipAddress.append((ip & (0xff << shift)) >> shift);
			if (i > 0) {
				ipAddress.append(".");
			}
		}
		return ipAddress.toString();
	}

	public static Long inet_aton(String addr) {
		if (addr.equals("")) return 0L;
		long num = 0;
		try {
			String[] addrArray = addr.split("\\.");
			int cntAddr = addrArray.length;
			for (int i = 0; i < cntAddr; i++) {
				int power = 3 - i;
				num += ((Integer.parseInt(addrArray[i]) % 256 * Math.pow(256, power)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return num;
	}
	
	public static String ipDelZero(String ip) {
		if( Common.isEmpty(ip) ) return "";
		String[] ips = ip.split("\\.");
		String str = "";
		for (int i = 0; i < ips.length; i++) {
			str += Integer.parseInt(ips[i]);
			if( i < ips.length - 1 ) str += ".";
		}
		return str;
	}
	
	/**
	 * 지정된 자리수 만큼 왼쪽에 값을 채워 넣는다.
	 *
	 * @param str
	 * @param len
	 * @param addStr
	 * @return
	 */
	public static String lPad(Object str, int len, String addStr) {
		String result = "";
		if (str == null) result = "";
		else result = String.valueOf(str);

		int templen = len - result.length();
		for (int i = 0; i < templen; i++) {
			result = addStr + result;
		}
		return result;
	}

	public static String rPad(String str, int size, String fStr) {

		byte[] b = str.getBytes();
		int len = b.length;
		int tmp = size - len;
		for (int i = 0; i < tmp; i++) {
			str += fStr;
		}
		return str;
	}

	public static boolean isInteger(String str) {
		try {
			Integer.parseInt(str);
			return true;
		} catch (NumberFormatException nfe) {
		}
		return false;
	}

	public static String numberFormatter(String str) {
		if (str == null || str.equals("")) str = "0";
		NumberFormat nf = NumberFormat.getInstance();
		return nf.format(Double.valueOf(str));
	}

	public static String numberFormatter(Double str) {
		NumberFormat nf = NumberFormat.getInstance();
		return nf.format(str);
	}

	public static String numberFormatter(long str) {
		NumberFormat nf = NumberFormat.getInstance();
		return nf.format(str);
	}

	/**
	 * SNMP %(률) 계산
	 *
	 * @param fileSize
	 * @return
	 */
	public static String convertSnmpVal(int rate) {
		float rateF = rate;
		return Common.nvl((float) (Math.round((rateF / 100) * 100) / 100.0));
	}

	public static String convertFileSize(Object size) {
		return convertFileSize(nvn(size));
	}

	public static String convertSnmpSize(Object size) {
		return convertSnmpSize(nvn(size));
	}

	/**
	 * 용량계산
	 *
	 * @param byte
	 * @return
	 */
	public static String convertSnmpSize(long size) {
		if (size <= 0) return "0";
		final String[] units = new String[] {" KB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}

	/**
	 * 용량계산
	 *
	 * @param byte
	 * @return
	 */
	public static String convertFileSize(long size) {
		if (size <= 0) return "0 KB";
		final String[] units = new String[] {" Byte", " KB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}
	
	/**
	 * 용량계산
	 *
	 * @param byte
	 * @return
	 */
	public static String convertFileSize(String sizeStr) {
		if(Common.isEmpty(sizeStr)) return "-";
		
		double size = Double.parseDouble(sizeStr);
		if (size <= 0) return "0 KB";
		final String[] units = new String[] {" Byte", " KB", " MB", " GB", " TB"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}

	/**
	 * YYYYMMDD 형식의 문자열을 YYYY-MM-DD 형식으로 변경
	 *
	 * @param fromDate
	 * @return
	 */
	public static String formatDate(String fromDate) {
		if (fromDate != null && fromDate.length() == 8) {
			return fromDate.substring(0, 4) + "-" + fromDate.substring(4, 6) + "-" + fromDate.substring(6, 8);
		}
		return fromDate;
	}


	/**
	 * YYYYMMDD 형식의 문자열을 MM/DD 형식으로 변경
	 *
	 * @param fromDate
	 * @return
	 */
	public static String formatDate2(String fromDate) {
		if (fromDate != null && fromDate.length() == 8) {
			return fromDate.substring(4, 6) + "/" + fromDate.substring(6, 8);
		}
		return fromDate;
	}

	/**
	 * yyyyMMddHHmmss 형식의 문자열을 yyyy-MM-dd HH:mm:ss 형식으로 변경
	 *
	 * @param fromDate
	 * @return
	 */
	public static String formatDate3(String orgDate) throws Exception {
		DateTimeFormatter org = DateTimeFormat.forPattern("yyyyMMddHHmmss");
		DateTime date = DateTime.parse(orgDate.replaceAll("-", "").replaceAll(" ", ""), org);
		return yyyy_MM_dd_HH_mm_ss.print(date);
	}

	/**
	 * YYYYMMDD 형식의 문자열을 YYYY-MM 형식으로 변경
	 *
	 * @param fromDate
	 * @return
	 */
	public static String formatMonth(String fromDate) {
		if (fromDate != null && (fromDate.length() == 8 || fromDate.length() == 6)) {
			return fromDate.substring(0, 4) + "-" + fromDate.substring(4, 6);
		}
		return fromDate;
	}
	
	/**
	 * YYYYMMDD 형식의 문자열을 YYYY-MM 형식으로 변경
	 *
	 * @param fromDate
	 * @return
	 */
	public static String formatMonthStat(String fromDate) {
		if (fromDate != null && (fromDate.length() == 8 || fromDate.length() == 6)) {
			fromDate = fromDate.replaceAll("-", "");
			return fromDate.substring(0, 6);
		}
		return fromDate;
	}

	public static int parseIp(String address) {
		if (Common.isEmpty(address)) return 0;
		int result = 0;
		for (String part : address.split(Pattern.quote("."))) {
			result = result << 8;
			result |= Integer.parseInt(part);
		}
		return result;
	}

	/**
	 * 초를 시,분,초로 변환
	 *
	 * @param difference
	 * @return
	 */
	public static String getTimeFormat(long difference) {
		if (difference == 0 || difference < 0) return "-";

		if (TimeUnit.SECONDS.toHours(difference) > 0) return String.format("%02d:%02d:%02d", TimeUnit.SECONDS.toHours(difference), TimeUnit.SECONDS.toMinutes(difference) - TimeUnit.HOURS.toMinutes(TimeUnit.SECONDS.toHours(difference)), TimeUnit.SECONDS.toSeconds(difference) - TimeUnit.MINUTES.toSeconds(TimeUnit.SECONDS.toMinutes(difference)));
		else return String.format("%02d:%02d", TimeUnit.SECONDS.toMinutes(difference) - TimeUnit.HOURS.toMinutes(TimeUnit.SECONDS.toHours(difference)), TimeUnit.SECONDS.toSeconds(difference) - TimeUnit.MINUTES.toSeconds(TimeUnit.SECONDS.toMinutes(difference)));

		// final int[] TIME_UNIT = { 3600, 60, 1 };
		// final String[] TIME_UNIT_NAME = { ":", ":", "" };
		// String tmp = "";
		// for ( int i = 0 ; i < TIME_UNIT.length ; i++ )
		// {
		// if ( difference / TIME_UNIT[i] > 0 ) tmp += lPad ( ( difference /
		// TIME_UNIT[i] ), 2, "0" ) + TIME_UNIT_NAME[i];
		// difference %= TIME_UNIT[i];
		// }
		// if ( isEmpty ( tmp ) ) tmp = "0";
		// return tmp;
	}

	public static String getCurrentHour() throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("HH");
		return yyyyMMdd.print(System.currentTimeMillis());
	}

	public static String getCurrentFullHour() throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd HH");
		return yyyyMMdd.print(System.currentTimeMillis()); 
	}

	public static String getCurrentTime(String format) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern(format);
		return yyyyMMdd.print(System.currentTimeMillis());
	}

	public static String getCurrentDate() throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		return yyyyMMdd.print(System.currentTimeMillis());
	}

	public static String getCurrentDateF() throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd");
		return yyyyMMdd.print(System.currentTimeMillis());
	}

	public static String getCurrentTime() throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.fullDateTime();
		return yyyyMMdd.print(System.currentTimeMillis());
	}

	public static String getDateTimeFormat() throws Exception {
		return getDateTime(System.currentTimeMillis(), "yyyyMMddHHmmss");
	}

	// UTC 시간을 사용하는 DB에 데이터 입력시 ex:몽고db (시간설정불가)
	public static String getAsiaServerTime(){
		LocalDateTime nowDateTime = new LocalDateTime().now();
		nowDateTime = nowDateTime.plusHours(9);
		String format = "yyyyMMddHHmmss";
		DateTimeFormatter localDateTime = DateTimeFormat.forPattern(format);
		return localDateTime.print(nowDateTime);
	}

	public static String getDateTime(long time) throws Exception {
		return getDateTime(time, "yyyy-MM-dd HH:mm:ss");
	}

	public static String getDateTime(long time, String format) throws Exception {
		if (time == 0) return "-";
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern(format);
		return yyyyMMdd.print(time);
	}

	public static String getYesterdayDate() throws Exception {
		return plusDays(getCurrentDate(), -1);
	}


	public static String getTime() {
		try {
			return getDateTime(System.currentTimeMillis());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static long getTime(String time, String format) {
		DateFormat dateformat = new SimpleDateFormat(format);
		try {
			return dateformat.parse(time).getTime();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	public static String getBeforeDay(int beforeDate) {
		Calendar week = Calendar.getInstance();
		week.add(Calendar.DATE, -beforeDate);
		return new SimpleDateFormat("yyyy-MM-dd").format(week.getTime());
	}

	public static String getBeforeMonth(int beforeDate) {
		Calendar week = Calendar.getInstance();
		week.add(Calendar.MONTH, -beforeDate);
		return new SimpleDateFormat("yyyy-MM-dd").format(week.getTime());
	}

	public static String getBeforeYear(int beforeDate) {
		Calendar week = Calendar.getInstance();
		week.add(Calendar.YEAR, -beforeDate);
		return new SimpleDateFormat("yyyy-MM-dd").format(week.getTime());
	}

	public static String getYearFirstDay(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd");
		DateTimeFormatter MM = DateTimeFormat.forPattern("yyyy-");
		return MM.print(DateTime.parse(date, yyyyMMdd)) + "01-01";
	}

	public static String getMonthFirstDay(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd");
		DateTimeFormatter MM = DateTimeFormat.forPattern("yyyy-MM-");
		return MM.print(DateTime.parse(date, yyyyMMdd)) + "01";
	}

	public static long getFullTime(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
		return DateTime.parse(date, yyyyMMdd).getMillis();
	}

	public static long getTime(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		return DateTime.parse(date.replaceAll("-", ""), yyyyMMdd).getMillis();
	}

	public static String getYear(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTimeFormatter yyyy = DateTimeFormat.forPattern("yyyy");
		return yyyy.print(DateTime.parse(date.replaceAll("-", ""), yyyyMMdd));
	}

	public static String getMonth(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTimeFormatter MM = DateTimeFormat.forPattern("MM");
		return MM.print(DateTime.parse(date.replaceAll("-", ""), yyyyMMdd));
	}

	public static String getDay(String date) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTimeFormatter dd = DateTimeFormat.forPattern("dd");
		return dd.print(DateTime.parse(date.replaceAll("-", ""), yyyyMMdd));
	}
	
	public static int diffOfHours(String begin, String end) {
		DateTimeFormatter yyyyMMddHH = DateTimeFormat.forPattern("yyyyMMddHH");
		DateTime sdt = DateTime.parse(begin.replaceAll("-", ""), yyyyMMddHH);
		DateTime edt = DateTime.parse(end.replaceAll("-", ""), yyyyMMddHH);
		return Hours.hoursBetween(sdt, edt).getHours();
	}

	public static int diffOfDate(String begin, String end) {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTime sdt = DateTime.parse(begin.replaceAll("-", ""), yyyyMMdd);
		DateTime edt = DateTime.parse(end.replaceAll("-", ""), yyyyMMdd);
		Hours.hoursBetween(sdt, edt).getHours();
		return Days.daysBetween(sdt, edt).getDays();
	}

	public static int diffOfMonth(String begin, String end) {
		DateTimeFormatter yyyyMM = DateTimeFormat.forPattern("yyyyMM");
		DateTime sdt = DateTime.parse(begin.replaceAll("-", "").substring(0, 6), yyyyMM);
		DateTime edt = DateTime.parse(end.replaceAll("-", "").substring(0, 6), yyyyMM);
		return Months.monthsBetween(sdt, edt).getMonths();
	}

	public static String plusMonth(String orgDate, int plusMonth) {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTime date = DateTime.parse(orgDate.replaceAll("-", ""), yyyyMMdd);
		return yyyyMMdd.print(date.plusMonths(plusMonth));
	}

	public static String plusWeek(String orgDate, int plusWeek) {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTime date = DateTime.parse(orgDate.replaceAll("-", ""), yyyyMMdd);
		return yyyyMMdd.print(date.plusWeeks(plusWeek));
	}

	public static String plusDays(String orgDate, int plusDay) {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
		DateTime date = DateTime.parse(orgDate.replaceAll("-", ""), yyyyMMdd);
		return yyyyMMdd.print(date.plusDays(plusDay));
	}

	public static String plusDaysF(String orgDate, int plusDay) {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd");
		DateTime date = DateTime.parse(orgDate, yyyyMMdd);
		return yyyyMMdd.print(date.plusDays(plusDay));
	}

	public static String plusHour(String orgDate, int plusHour) throws Exception {
		return plusHour(orgDate, plusHour, "yyyyMMddHH");
	}

	public static String plusHour(String orgDate, int plusHour, String format) throws Exception {
		DateTimeFormatter yyyyMMddHH = DateTimeFormat.forPattern(format);
		DateTime date = DateTime.parse(orgDate.replaceAll("-", "").replaceAll(" ", ""), yyyyMMddHH);
		return yyyyMMddHH.print(date.plusHours(plusHour));
	}

	public static String plusHourFormat(String orgDate, int plusHour) throws Exception {
		DateTimeFormatter mmddhh = DateTimeFormat.forPattern("MM/dd HH");
		DateTimeFormatter yyyyMMddHH = DateTimeFormat.forPattern("yyyyMMddHH");
		DateTime date = DateTime.parse(orgDate.replaceAll("-", "").replaceAll(" ", ""), yyyyMMddHH);
		return mmddhh.print(date.plusHours(plusHour));
	}

	public static String plusMinute(String dt, int plusMinute) throws Exception {
		DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
		DateTime date = DateTime.parse(dt, yyyyMMddHHmmss);
		return yyyyMMddHHmmss.print(date.plusMinutes(plusMinute));
	}

	public static String sha1(String file) {
		String result = null;
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(new File(file));
			result = DigestUtils.sha1Hex(fis);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(fis);
		}
		return result;
	}

	public static String sha256(String data) {
		String result = null;
		try {
			
			result = DigestUtils.sha256Hex(data);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public static String sha512(String path) {
		String result = null;
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(new File(path));
			result = DigestUtils.sha512Hex(fis);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(fis);
		}
		return result;
	}

	/**
	 * Hash md5sum
	 *
	 * @param filePath
	 * @return
	 * @throws Exception
	 */
	public static String md5sum(String filePath) throws Exception {
		FileInputStream fis = null;
		StringBuffer sb = new StringBuffer();
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			fis = new FileInputStream(filePath);

			byte[] dataBytes = new byte[1024];
			int nread = 0;
			while ((nread = fis.read(dataBytes)) != -1) {
				md.update(dataBytes, 0, nread);
			}
			byte[] mdbytes = md.digest();
			for (int i = 0; i < mdbytes.length; i++) {
				sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16).substring(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(fis);
		}
		return sb.toString();
	}

	public static byte[] digest(final String algorithm, final InputStream is) throws IOException, NoSuchAlgorithmException {
		final MessageDigest digest = MessageDigest.getInstance(algorithm);
		final byte[] buf = new byte[4096];
		int n = 0;
		while ((n = is.read(buf)) != -1) {
			digest.update(buf, 0, n);
		}
		return digest.digest();
	}

	public static byte[] digest(final String algorithm, final byte[]... inputs) throws IOException, NoSuchAlgorithmException {
		final MessageDigest digest = MessageDigest.getInstance(algorithm);
		for (final byte[] input : inputs) {
			digest.update(input);
		}
		return digest.digest();
	}

	public static byte[] digest(final String algorithm, final String... inputs) throws NoSuchAlgorithmException {
		final MessageDigest digest = MessageDigest.getInstance(algorithm);
		for (final String input : inputs) {
			digest.update(input.getBytes());
		}
		return digest.digest();
	}

	public static String getExtension(final String name) {
		return FilenameUtils.getExtension(name);
	}

	public static String getExtImg(final String name) {
		String ext = getExtension(name).toLowerCase();
		for (int i = 0; i < EXT_IMGS.length; i++) {
			if (isEquals(EXT_IMGS[i], ext.toLowerCase())) return EXT_IMGS[i] + ".png";
		}
		return "none.png";
	}

	public static String makeFilepath(final String... paths) {
		String filepath = paths[0];
		for (int i = 1; i < paths.length; i++) {
			filepath = FilenameUtils.concat(filepath, paths[i]);
		}
		return FilenameUtils.normalize(filepath, true);
	}

	public static String removeInvalidName(String fileName) {
		String[] invalidName = {"\\\\", "/", ":", "[*]", "[?]", "\"", "<", ">", "[|]"};
		for (int i = 0; i < invalidName.length; i++) {
			fileName = fileName.replaceAll(invalidName[i], ".");
		}
		return fileName;
	}

	public static String getEncodingFileName(HttpServletRequest request, String name) {
		try {
			//return URLEncoder.encode(Common.nvl(name), Common.UTF8);
			Parser uaParser = new Parser();
			Client c = uaParser.parse(request.getHeader("User-Agent"));
			if (Common.isEquals(c.userAgent.family, "IE")) {
				return new String(Common.nvl(name).getBytes("KSC5601"), "ISO-8859-1");
			} else {
				return new String(Common.nvl(name).getBytes(Common.UTF8), "ISO-8859-1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Common.EMPTY;
	}

	public static String getEDCFileName(String ctime, String userId, String userName, String subject, String msgId) {
		if (Common.nvl(subject).length() > 30) subject = subject.substring(0, 30);
		return Common.changeInvalidName(String.format("%s - %s - %s [%s]", ctime, EmsReDefined.reUser(userId, userName), subject, msgId));
	}

	public static String changeInvalidName(String fileName) {
		if (isEmpty(fileName)) return fileName;
		return removeInvalidName(fileName.replaceAll("<", "(").replaceAll(">", ")").replaceAll("/", ".").replaceAll("\\?", "^"));
	}

	public static boolean mkdirs(final String path) {
		boolean flag = false;
		try {
			File _file = new File(path);
			if (!_file.isDirectory()) flag = _file.mkdirs();
			else flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	public static byte[] toHexToBytes(String s) {
		if ((s == null) || (s.length() == 0)) {
			return null;
		}
		int size = (int) Math.ceil(s.length() / 2.0D);
		String hex = StringUtils.leftPad(s, size * 2, "0");
		byte[] b = new byte[size];
		for (int i = 0; i < b.length; i++) {
			b[i] = ((byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16));
		}
		return b;
	}

	public static String toHexString(final long n, final int length) {
		return String.format("%0" + length + "x", n);
	}

	public static String toHexString(final byte[] b) {
		if (b == null) {
			return null;
		}

		final char[] hexChars = new char[b.length * 2];
		int v;
		for (int j = 0; j < b.length; j++) {
			v = b[j] & 0xFF;
			hexChars[j * 2] = HEXARRAY[v >>> 4];
			hexChars[j * 2 + 1] = HEXARRAY[v & 0x0F];
		}
		return new String(hexChars);
	}

	public static void sleep(final long millis) {
		try {
			Thread.sleep(millis);
		} catch (final InterruptedException e) {
		}
	}

	// IP Convert
	public static long inet_atol(final String ip) {
		final String[] ips = ip.split("\\.");
		return (Long.parseLong(ips[0]) << 24) + (Long.parseLong(ips[1]) << 16) + (Long.parseLong(ips[2]) << 8) + Long.parseLong(ips[3]);
	}

	public static String inet_ltoa(final long ip) {
		return String.format("%d.%d.%d.%d", (ip >> 24) & 0xFF, (ip >> 16) & 0xFF, (ip >> 8) & 0xFF, ip & 0xFF);
	}

	public static String inet_btoa(final byte[] ip) {
		return String.format("%d.%d.%d.%d", ip[0] & 0xFF, ip[1] & 0xFF, ip[2] & 0xFF, ip[3] & 0xFF);
	}

	public static long inet_btol(final byte[] ip) {
		return ((long) (ip[0] & 0xFF) << 24) + ((long) (ip[1] & 0xFF) << 16) + ((long) (ip[2] & 0xFF) << 8) + (ip[3] & 0xFF);
	}

	public static long inet_htol(final String ip) {
		return Long.parseLong(ip, 16);
	}

	public static byte[] toSizeBytes(final byte[] b, final int length) {
		return b != null ? add(toBytes(b.length, length), b) : null;
	}

	public static byte[] toSizeBytes(final String s, final int length) {
		return toSizeBytes(toBytes(s), length);
	}

	public static byte[] toBytes(final long n, final int length) {
		final byte[] b = new byte[length];
		for (int i = 0; i < length; i++) {
			b[i] = (byte) (n >> ((length - i - 1) * 8) & 0xFF);
		}
		return b;
	}

	public static byte[] toBytes(final String s) {
		if (s != null) {
			try {
				return s.getBytes(UTF8);
			} catch (final UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return new byte[0];
	}

	public static <T> Collection<T> add(final Collection<T> collection, final Collection<T> item) {
		if (item != null) {
			collection.addAll(item);
		}
		return collection;
	}

	public static <T> Collection<T> add(final Collection<T> collection, final T item) {
		if (item != null) {
			collection.add(item);
		}
		return collection;
	}

	public static byte[] add(final byte[] a, final byte[] b) {
		return add(a, b, EMPTY_BYTE_ARRAY);
	}

	public static byte[] add(final byte[] a, final byte[] b, final byte[] c) {
		final byte[] result = new byte[a.length + b.length + c.length];
		System.arraycopy(a, 0, result, 0, a.length);
		System.arraycopy(b, 0, result, a.length, b.length);
		System.arraycopy(c, 0, result, a.length + b.length, c.length);
		return result;
	}

	public static String join(List<String> collection, String separator) {
		if (collection == null) return EMPTY;
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < collection.size(); i++) {
			if ((i + 1) >= collection.size()) _sb.append(collection.get(i));
			else _sb.append(collection.get(i)).append(separator);
		}
		return _sb.toString();
	}

	public static String join_long(List<Long> collection, String separator) {
		if (collection == null) return EMPTY;
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < collection.size(); i++) {
			if ((i + 1) >= collection.size()) _sb.append(collection.get(i));
			else _sb.append(collection.get(i)).append(separator);
		}
		return _sb.toString();
	}


	public static String join(String [] collection, String separator) {
		if (collection == null) return EMPTY;
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < collection.length; i++) {
			if ((i + 1) >= collection.length) _sb.append(collection[i]);
			else _sb.append(collection[i]).append(separator);
		}
		return _sb.toString();
	}
	
	public static String joinObject(List<Object> collection, String separator) {
		if (collection == null) return EMPTY;
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < collection.size(); i++) {
			if ((i + 1) >= collection.size()) _sb.append(collection.get(i));
			else _sb.append(collection.get(i)).append(separator);
		}
		return _sb.toString();
	}

	public static String joinj(JSONArray collection, String separator) {
		if (collection == null) return EMPTY;
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < collection.size(); i++) {
			if ((i + 1) >= collection.size()) _sb.append(collection.get(i));
			else _sb.append(collection.get(i)).append(separator);
		}
		return _sb.toString();
	}
	
	public static String decodeText(final byte[] b, final int offset) {
		if (b != null && b.length >= offset + 2) {
			return toString(b, offset + 2, toShort(b, offset), UTF8);
		}
		return null;
	}

	public static byte[] getByteArray(JSONObject json, String key) {
		if (json == null || json.get(key) == null || !(json.get(key) instanceof JSONArray)) return new byte[0];
		JSONArray array = json.getJSONArray(key);
		if (array == null) return new byte[0];
		byte result[] = new byte[array.size()];
		for (int i = 0; i < array.size(); i++) {
			result[i] = (byte) array.getInt(i);
		}
		return result;
	}

	public static String toString(final byte[] b) {
		return toString(b, UTF8);
	}

	public static String toString(final byte[] b, final String charset) {
		if (b == null) {
			return null;
		}
		return toString(b, 0, b.length, charset);
	}

	public static String toString(final byte[] b, final int offset, final String charset) {
		return b != null ? toString(b, offset, b.length - offset, charset) : null;
	}

	public static String toString(final byte[] b, final int offset, final int len, final String charset) {
		try {
			if (b != null && b.length >= offset + len) {
				if (isEquals(charset.toLowerCase(), "cp-850")) {
					return new String(b, offset, len, "cp850");
				} else {
					return new String(b, offset, len, charset);
				}
			}
		} catch (final UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static List<String> toList(String str, String prefix) {
		String[] arr = toArray(str, prefix);
		List<String> result = new ArrayList<String>();
		for (String val : arr) {
			result.add(Common.nvl(val));
		}
		return result;
	}

	public static List<String> toArray(JSONArray list, String key) {
		if (list == null) return new ArrayList<String>();
		List<String> result = new ArrayList<String>();
		for (int i = 0; i < list.size(); i++) {
			result.add(Common.nvl(list.getJSONObject(i).get(key)));
		}
		return result;
	}

	public static String[] toArray(JSONArray list, String key, String prefix) {
		List<String> arrays = toArray(list, key);
		String[] result = new String[arrays.size()];
		for (int i = 0; i < arrays.size(); i++) {
			result[i] = arrays.get(i);
		}
		return result;
	}

	public static String[] toArray(final Enumeration<String> values) {
		List<String> as = new ArrayList<String>();
		while (values.hasMoreElements()) {
			as.add(values.nextElement());
		}
		String[] result = new String[as.size()];
		for (int i = 0; i < as.size(); i++) {
			result[i] = as.get(i);
		}
		return result;
	}

	/**
	 * 외 몇건 표시에 사용
	 * @param str
	 * @param prefix
	 * @param cnt
	 * @param comment
	 * @return
	 */
	public static String splitStrReduce(final String str, final String prefix, int cnt) {
		List<String> rs = new ArrayList<>();
		String[] arr = toArray(str, prefix);
		if (arr.length < cnt) cnt = arr.length;
		for (int i = 0; i < cnt; i++) {
			rs.add(arr[i]);
		}
		if (rs.size() < arr.length) {
			return join(rs, ",") + " " + Prop.propFormat("common.msg.etc_count", (arr.length - rs.size()));
		} else {
			return join(rs, ",");
		}
	}

	public static String[] toArray(final String str, final String prefix) {
		return toArray(str, prefix, true);
	}

	public static String[] toArray(final String str, final String prefix, final boolean exceptEmpty) {
		if (str == null) return new String[0];

		String[] tmp = str.split("\\" + prefix);
		List<String> as = new ArrayList<String>();
		for (int i = 0; i < tmp.length; i++) {
			String x = tmp[i];
			if (isNotEmpty(x) || !exceptEmpty) as.add(x);
		}
		String[] result = new String[as.size()];
		for (int i = 0; i < as.size(); i++) {
			result[i] = as.get(i);
		}
		return result;
	}
	
	public static Map<String, Object> toMap(Object obj){
		try {
			if(isEmpty(obj)) {
				return Collections.emptyMap();
			}
			
			Map<String, Object> map = new HashMap<>();
			Field[] fields = obj.getClass().getDeclaredFields();
			
			for(Field fl : fields) {
				fl.setAccessible(true);
				map.put(fl.getName(), fl.get(obj));
			}
			
			return map;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	public static List<Map<String, Object>> toMap(List<?> list){
		if(isEmpty(list)) {
			return Collections.emptyList();
		}
		
		List<Map<String, Object>> result = new ArrayList<>(list.size());
		for(Object obj:list) {
			result.add(toMap(obj));
		}
		
		return result;
	}

	public static JSONArray toJSONArray(String str, String split) {
		if (isEmpty(str)) return new JSONArray();

		JSONArray result = new JSONArray();
		String[] strs = str.split(split);
		for (int i = 0; i < strs.length; i++) {
			if (Common.isNotEmpty(strs[i])) result.add(strs[i]);
		}
		return result;
	}

	public static JSONArray toJSONArray(Object obj) {
		if (isEmpty(obj)) return new JSONArray();
		JSON json = JSONSerializer.toJSON(obj);
		if (json instanceof JSONArray) return (JSONArray) json;
		return new JSONArray();
	}

	public static JSONObject toJSONObject(Object obj) {
		if (isEmpty(obj)) return new JSONObject();
		JSON json = JSONSerializer.toJSON(obj);
		if (json instanceof JSONObject) return (JSONObject) json;
		return new JSONObject();
	}

	public static JSONArray toJson(Object object) throws Exception {
		List<?> list = (List<?>) object;
		JSONArray result = new JSONArray();
		JSONObject obj = null;
		String key = "";
		Iterator<?> iterator = null;
		Set<?> set = null;
		Map<?, ?> item = null;
		try {
			for (int i = 0; i < list.size(); i++) {
				item = (Map<?, ?>) list.get(i);
				if (item == null) continue;

				obj = new JSONObject();
				set = item.keySet();
				iterator = set.iterator();
				while (iterator.hasNext()) {
					key = (String) iterator.next();
					if (item.get(key) instanceof Byte) obj.put(key, item.get(key).toString());
					else if (item.get(key) instanceof Array) obj.put(key, getArrayVal((Array) item.get(key)));
					else obj.put(key, Common.nvl(item.get(key)));
				}
				result.add(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e.getMessage());
		} finally {
			key = "";
			iterator = null;
			set = null;
			item = null;
		}

		return result;
	}

	public static JSONArray getArrayVal(Array val) {
		if (val == null) return new JSONArray();
		try {
			if (Types.VARCHAR == val.getBaseType()) {
				return getValueSplit((String[]) val.getArray());
			} else if (Types.BIGINT == val.getBaseType()) {
				return getValueSplit((long[]) val.getArray());
			} else if (Types.INTEGER == val.getBaseType()) {
				return getValueSplit((int[]) val.getArray());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return new JSONArray();
	}

	public static JSONArray getValueSplit(long[] vals) {
		if (vals == null || vals.length == 0) return new JSONArray();
		JSONArray result = new JSONArray();
		for (int i = 0; i < vals.length; i++) {
			result.add(Common.nvn(vals[i]));
		}
		return result;
	}

	public static JSONArray getValueSplit(int[] vals) {
		if (vals == null || vals.length == 0) return new JSONArray();
		JSONArray result = new JSONArray();
		for (int i = 0; i < vals.length; i++) {
			result.add(Common.nvz(vals[i]));
		}
		return result;
	}

	public static JSONArray getValueSplit(Object[] vals) {
		if (vals == null || vals.length == 0) return new JSONArray();
		JSONArray result = new JSONArray();
		for (int i = 0; i < vals.length; i++) {
			result.add(Common.nvl(vals[i]));
		}
		return result;
	}

	public static String decodeText(final byte[] b) {
		return decodeText(b, 0);
	}

	public static int toShort(final byte[] bytes) {
		return toShort(bytes, 0, SIZEOF_SHORT);
	}

	public static int toShort(final byte[] bytes, final int offset) {
		return toShort(bytes, offset, SIZEOF_SHORT);
	}

	public static int toShort(final byte[] bytes, final int offset, final int length) {
		if (length != SIZEOF_SHORT || offset + length > bytes.length) {
			throw new RuntimeException();
		}
		int n = 0;
		n ^= bytes[offset] & 0xFF;
		n <<= 8;
		n ^= bytes[offset + 1] & 0xFF;
		return n;
	}

	public static double round(double d, int n) {
		return Math.round(d * Math.pow(10, n)) / Math.pow(10, n);
	}

	/**
	 * byte를 String으로 변환
	 *
	 *
	 * @param b
	 * @return
	 */
	public static String byteToString(byte[] b) {
		if (b == null) {
			return null;
		}
		return byteToString(b, 0, b.length);
	}

	public static String byteToString(byte[] b1, String sep, byte[] b2) {
		return new StringBuilder().append(byteToString(b1, 0, b1.length)).append(sep).append(byteToString(b2, 0, b2.length)).toString();
	}

	public static String byteToString(byte[] b, int off, int len) {
		if (b == null) {
			return null;
		}
		if (len == 0) return "";
		try {
			return new String(b, off, len, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			log.error("UTF-8 not supported?", e);
		}
		return null;
	}

	public static byte[] stringToBytes(String s) {
		try {
			return s.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			log.error("UTF-8 not supported?", e);
		}
		return null;
	}

	public static String escapeTag(String str) {
		return Common.nvl(str).replace("<", "&lt").replace(">", "&gt");
	}

	public static String escapeJson(String str) {
		return Common.nvl(str).replace("\\", "\\\\").replace("\'", "\\\'").replace("\"", "\\\"").replace("\r\n", "\\n").replace("\n", "\\n");
	}

	public static String escapeJavaScript(String str) {
		if (str.toLowerCase().indexOf("<script") > -1) {
			return str.replaceAll("<script", "&ltscript").replaceAll("<SCRIPT", "&ltscript").replaceAll("</script", "&lt/script").replaceAll("</SCRIPT", "&lt/script");
		}
		return str;
	}

	public static String lpad(String str, int len, String addStr) {
		String result = str;
		int templen = len - result.length();
		for (int i = 0; i < templen; i++) {
			result = addStr + result;
		}
		return result;
	}

	public static final AtomicInteger AUTO_SEQ = new AtomicInteger();

	public static int getNextSeq() {
		AUTO_SEQ.compareAndSet(0, 999999);
		return AUTO_SEQ.getAndDecrement();
	}

	public static String getRandomString() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}

	public static String getNextID(String... args) throws Exception {
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy_MM_dd_HH_mm_ss_SSS_");
		StringBuffer _sb = new StringBuffer();
		for (int i = 0; i < args.length; i++) {
			_sb.append(args[i]).append("_");
		}
		_sb.append(yyyyMMdd.print(System.currentTimeMillis()) + lPad(String.valueOf(getNextSeq()), 6, "0"));
		return _sb.toString();
	}

	public static String createUUID() {
		return UUID.randomUUID().toString();
	}

	public static JSONArray make24HourResult(JSONArray list, String startDate, String endDate) throws Exception {
		JSONArray result = new JSONArray();
		int diff = diffOfDate(startDate, endDate);
		for (int i = 0; i <= diff; i++) {
			String v_date = plusDays(startDate, i);
			for (int t = 0; t < 24; t++) {
				String v_hour = lpad(String.valueOf(t), 2, "0");
				String v_dt = v_date + v_hour;
				boolean addFlag = false;
				for (int j = 0; j < list.size(); j++) {
					JSONObject item = list.getJSONObject(j);
					String p_dt = item.getString("P_DT");
					if (v_dt.equals(p_dt)) {
						result.add(item.getLong("TOTAL"));
						addFlag = true;
						break;
					}
				}
				if (!addFlag) {
					result.add(0);
				}
			}
		}
		return result;
	}

	/**
	 * 특정 리스트의 총계/비율
	 *
	 * @param list
	 * @param key
	 * @return
	 */
	public static JSONArray setTotalRate(JSONArray list, String key) {
		long total = getTotal(list, key);
		for (int i = 0; i < list.size(); i++) {
			JSONObject obj = list.getJSONObject(i);
			long val = nvn(obj.get(key));
			String rate = getRate(total, val);
			obj.put(key + "_RATE", rate);
			list.set(i, obj);
		}
		return list;
	}

	public static long getTotal(JSONArray list, String key) {
		long total = 0L;
		for (int i = 0; i < list.size(); i++) {
			total += nvn(list.getJSONObject(i).get(key));
		}
		return total;
	}

	public static String calculatePercentage(int total, int available) {
		return String.format("%.1f", ((double) (total - available) / total) * 100);
	}

	/**
	 * 백분률
	 *
	 * @return
	 */
	public static String getRate(long total, long val) {
		double rate = (double) val / (double) total * 100;
		String dispPattern = "0.##";
		DecimalFormat form = new DecimalFormat(dispPattern);
		return form.format(rate);
	}

	public static byte[] htons(final short sValue, final int len) {
		byte[] baValue = new byte[len];
		Arrays.fill(baValue, FILL);
		ByteBuffer buf = ByteBuffer.wrap(baValue).order(ByteOrder.BIG_ENDIAN);
		return buf.putShort(sValue).array();
	}

	public static byte[] htonc(final char sValue, final int len) {
		ByteBuffer buf = ByteBuffer.allocate(len).order(ByteOrder.BIG_ENDIAN);
		buf.putChar(sValue);
		return buf.array();
	}

	public static byte[] hton(final byte sValue) {
		byte[] baValue = new byte[1];
		ByteBuffer buf = ByteBuffer.wrap(baValue).order(ByteOrder.BIG_ENDIAN);
		return buf.put(sValue).array();
	}

	public static byte[] htoni(final int sValue, final int len) {
		byte[] baValue = new byte[len];
		Arrays.fill(baValue, FILL);
		ByteBuffer buf = ByteBuffer.wrap(baValue).order(ByteOrder.BIG_ENDIAN);
		return buf.putInt(sValue).array();
	}

	public static byte[] htonl(final long sValue, final int len) {
		byte[] baValue = new byte[len];
		Arrays.fill(baValue, FILL);
		ByteBuffer buf = ByteBuffer.wrap(baValue).order(ByteOrder.BIG_ENDIAN);
		return buf.putLong(sValue).array();
	}

	public static byte[] htonstr(final String sValue, final int len) {
		byte[] baValue = new byte[len];
		Arrays.fill(baValue, FILL);
		ByteBuffer buf = ByteBuffer.wrap(baValue).order(ByteOrder.BIG_ENDIAN);
		buf.put(sValue.getBytes());
		return baValue;
	}

	public static short ntohs(final byte[] value) {
		ByteBuffer buf = ByteBuffer.wrap(value);
		return buf.getShort();
	}

	public static short ntohsu(final byte[] value) {
		ByteBuffer buf = ByteBuffer.wrap(value).order(ByteOrder.LITTLE_ENDIAN);
		return buf.getShort();
	}

	public static int ntohi(final byte[] value) {
		ByteBuffer buf = ByteBuffer.wrap(value).order(ByteOrder.BIG_ENDIAN);
		return buf.getInt();
	}

	public static long ntohl(final byte[] value) {
		byte[] br = new byte[8];
		br[0] = 0;
		br[1] = 0;
		br[2] = value[0];
		br[3] = value[1];
		br[4] = value[2];
		br[5] = value[3];
		br[6] = value[4];
		br[7] = value[5];
		ByteBuffer buf = ByteBuffer.wrap(br).order(ByteOrder.BIG_ENDIAN);
		return buf.getLong();
	}

	public static long getLong(byte[] buffer, int position) {
		return (buffer[position++] & 255L) << 0 | (buffer[position++] & 255L) << 8 | (buffer[position++] & 255L) << 16 | (buffer[position++] & 255L) << 24 | (buffer[position++] & 255L) << 32 | (buffer[position++] & 255L) << 40 | (buffer[position++] & 255L) << 48 | (buffer[position++] & 255L) << 56;
	}

	public static String time_t(final byte[] value) {
		ByteBuffer buf = ByteBuffer.wrap(value).order(ByteOrder.BIG_ENDIAN);
		try {
			return getDateTime(buf.getLong() * 1000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return EMPTY;
	}

	public static long toLong(byte[] b) {
		ByteBuffer buf = ByteBuffer.wrap(b).order(ByteOrder.BIG_ENDIAN);
		return buf.getLong();
	}

	public static byte[] reverse(byte[] byteArr) {
		ArrayUtils.reverse(byteArr);
		return byteArr;
	}

	public static String ntohstr(final byte[] value) {
		return Common.nvl(Common.toString(value)).trim();
	}

	public static String ntohstr_zero(final byte[] value) {
		if (value == null) return null;
		if (value.length == 0) return null;
		StringBuilder sb = new StringBuilder();
		for (int j = 0; j < value.length; j++) {
			if (value[j] > 0) sb.append((char) value[j]);
			else break;
		}
		return sb.toString();
	}

	public static String ntohc(final byte[] param) {
		if (param == null) return null;
		if (param.length == 0) return null;
		return Integer.toString(param[0]);
	}

	public static short toUnsigned(final byte b) {
		return (short) (b & 0xff);
	}

	public static short swap(final short x) {
		return (short) ((x << 8) | ((x >> 8) & 0xff));
	}

	public static char swap(final char x) {
		return (char) ((x << 8) | ((x >> 8) & 0xff));
	}

	public static int swap(final int x) {
		return (swap((short) x) << 16) | (swap((short) (x >> 16)) & 0xffff);
	}

	public static long swap(final long x) {
		return ((long) swap((int) (x)) << 32) | (swap((int) (x >> 32)) & 0xffffffffL);
	}

	public static float swap(final float x) {
		return Float.intBitsToFloat(swap(Float.floatToRawIntBits(x)));
	}

	public static double swap(final double x) {
		return Double.longBitsToDouble(swap(Double.doubleToRawLongBits(x)));
	}

	public static byte[] fill(final int len) {
		byte[] baValue = new byte[len];
		Arrays.fill(baValue, FILL);
		return baValue;
	}

	/**
	 * Get an unsigned byte from the current position of the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the byte from
	 * @return an unsigned byte contained in a short
	 */
	public static short getUnsignedByte(ByteBuffer bb) {
		return getUnsignedByte(bb, 0);
	}

	/**
	 * Get an unsigned byte from the specified offset in the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the byte from
	 * @param offset the offset to get the byte from
	 * @return an unsigned byte contained in a short
	 */
	public static short getUnsignedByte(ByteBuffer bb, int offset) {
		return ((short) (bb.get(offset) & (short) 0xff));
	}

	/**
	 * Put an unsigned byte into the specified ByteBuffer at the current
	 * position
	 *
	 * @param bb ByteBuffer to put the byte into
	 * @param v the short containing the unsigned byte
	 */
	public static void putUnsignedByte(ByteBuffer bb, short v) {
		putUnsignedByte(bb, v, 0);
	}

	/**
	 * Put an unsigned byte into the specified ByteBuffer at the specified
	 * offset
	 *
	 * @param bb ByteBuffer to put the byte into
	 * @param v the short containing the unsigned byte
	 * @param offset the offset to insert the unsigned byte at
	 */
	public static void putUnsignedByte(ByteBuffer bb, short v, int offset) {
		bb.put(offset, (byte) (v & 0xff));
	}

	/**
	 * Get an unsigned short from the current position of the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the byte from
	 * @return an unsigned short contained in a int
	 */
	public static int getUnsignedShort(ByteBuffer bb) {
		return getUnsignedShort(bb, 0);
	}

	/**
	 * Get an unsigned short from the specified offset in the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the short from
	 * @param offset the offset to get the short from
	 * @return an unsigned short contained in a int
	 */
	public static int getUnsignedShort(ByteBuffer bb, int offset) {
		return (bb.getShort(offset) & 0xffff);
	}

	/**
	 * Put an unsigned short into the specified ByteBuffer at the current
	 * position
	 *
	 * @param bb ByteBuffer to put the short into
	 * @param v the int containing the unsigned short
	 */
	public static void putUnsignedShort(ByteBuffer bb, int v) {
		putUnsignedShort(bb, v, 0);
	}

	/**
	 * Put an unsigned short into the specified ByteBuffer at the specified
	 * offset
	 *
	 * @param bb ByteBuffer to put the short into
	 * @param v the int containing the unsigned short
	 * @param offset the offset to insert the unsigned short at
	 */
	public static void putUnsignedShort(ByteBuffer bb, int v, int offset) {
		bb.putShort(offset, (short) (v & 0xffff));
	}

	/**
	 * Get an unsigned int from the current position of the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the int from
	 * @return an unsigned int contained in a long
	 */
	public static long getUnsignedInt(ByteBuffer bb) {
		return getUnsignedInt(bb, 0);
	}

	/**
	 * Get an unsigned int from the specified offset in the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the int from
	 * @param offset the offset to get the int from
	 * @return an unsigned int contained in a long
	 */
	public static long getUnsignedInt(ByteBuffer bb, int offset) {
		return (bb.getInt(offset) & 0xffffffffL);
	}

	/**
	 * Put an unsigned int into the specified ByteBuffer at the current position
	 *
	 * @param bb ByteBuffer to put the int into
	 * @param v the long containing the unsigned int
	 */
	public static void putUnsignedInt(ByteBuffer bb, long v) {
		putUnsignedInt(bb, v, 0);
	}

	/**
	 * Put an unsigned int into the specified ByteBuffer at the specified offset
	 *
	 * @param bb ByteBuffer to put the int into
	 * @param v the long containing the unsigned int
	 * @param offset the offset to insert the unsigned int at
	 */
	public static void putUnsignedInt(ByteBuffer bb, long v, int offset) {
		bb.putInt(offset, (int) (v & 0xffffffffL));
	}

	/**
	 * Get an unsigned long from the current position of the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the long from
	 * @return an unsigned long contained in a BigInteger
	 */
	public static BigInteger getUnsignedLong(ByteBuffer bb) {
		return getUnsignedLong(bb, 0);
	}

	/**
	 * Get an unsigned long from the specified offset in the ByteBuffer
	 *
	 * @param bb ByteBuffer to get the long from
	 * @param offset the offset to get the long from
	 * @return an unsigned long contained in a BigInteger
	 */
	public static BigInteger getUnsignedLong(ByteBuffer bb, int offset) {
		byte[] v = new byte[8];
		for (int i = 0; i < 8; ++i) {
			v[i] = bb.get(offset + i);
		}
		return new BigInteger(1, v);
	}

	/**
	 * Put an unsigned long into the specified ByteBuffer at the current
	 * position
	 *
	 * @param bb ByteBuffer to put the long into
	 * @param v the BigInteger containing the unsigned long
	 */
	public static void putUnsignedLong(ByteBuffer bb, BigInteger v) {
		putUnsignedLong(bb, v, 0);
	}

	/**
	 * Put an unsigned long into the specified ByteBuffer at the specified
	 * offset
	 *
	 * @param bb ByteBuffer to put the long into
	 * @param v the BigInteger containing the unsigned long
	 * @param offset the offset to insert the unsigned long at
	 */
	public static void putUnsignedLong(ByteBuffer bb, BigInteger v, int offset) {
		bb.putLong(offset, v.longValue());
	}

	public static String getRuntime(String command) throws Exception {
		if (command == null) throw new Exception("command is not null");

		StringBuffer _sb = new StringBuffer();
		Process process = null;
		BufferedReader br = null;
		OutputStream out = null;
		try {
			process = Runtime.getRuntime().exec(command);
			out = process.getOutputStream();
			out.write("1".getBytes());
			out.flush();
			br = new BufferedReader(new InputStreamReader(process.getInputStream(), "euc-kr"));
			String szLine;
			while ((szLine = br.readLine()) != null) {
				_sb.append(szLine).append("\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (process != null) process.waitFor();
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (process != null) process.destroy();
			} catch (Exception e) {
				e.printStackTrace();
			}
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(br);
		}
		return _sb.toString();
	}

	public static String commandRunner(final String command) throws IOException {
		StringBuilder result = new StringBuilder();
		if(isWindow()){
			SFTPUtil util = new SFTPUtil();
			try {
				util.init(Config.DB_IP, Config.DB_USER, Config.DB_PASSWORD, 22);
				result.append(util.getCommand(command));
			} catch (JSchException e) {
				throw new RuntimeException(e);
			} finally {
				util.disconnection();
			}
		} else {
			ProcessBuilder processBuilder = new ProcessBuilder("bash", "-c", command);
			Process process = processBuilder.start();
			try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));) {
				String line;
				while ((line = reader.readLine()) != null) {
					result.append(line).append("\n");
				}
			} finally {
				process.destroy();
			}
		}
		return result.toString();
	}





	public static String getRpcMessage(HttpServletRequest request, int code) {
		if (code >= 100000000) return "Read Record Error 2";
		else if (code == 1) return "UACS is Disabled";
		else if (code == 2) return "Rulemaker is processing the previous message";
		else if (code == 3) return "Rules that have been created previously has not been applied";
		else if (code == 4) return "Load a Key is failed";
		else if (code == 5) return "Rule File Decryption is failed";
		else if (code == 99999) return "Making Rule is failed";
		else if (code == 20001) return "Memory Allocation Error 1";
		else if (code == 20002) return "Memory Allocation Error 2";
		else if (code == 20003) return "Open a Rule File is failed";
		else if (code == 20004) return "a Rule file size is zero";
		else if (code == 20005) return "Memory Reallocation Error 1";
		else if (code == 20006) return "Read Record Error 1";
		else if (code == 20007) return "Memory Reallocation Error 2";
		else if (code == 20008) return "Memory Reallocation Error 3";
		else if (code == 20009) return "Memory allocation is failed(Pass IP Area)";
		else if (code == 20010) return "Memory allocation is failed(Block IP Area)";
		else if (code == 20011) return "MD5 URL Rule Count is over 1";
		else if (code == 20012) return "MD5 URL Rule Count is over 2";
		else if (code == 20013) return "REGX URL Rule Count is over 1";
		else if (code == 20014) return "REGX URL Rule Count is over 2";
		else if (code == 21001) return "Category(Parsing Error 1)";
		else if (code == 21002) return "Category(Wrong ID)";
		else if (code == 21003) return "Category(Name is null)";
		else if (code == 22001) return "Pass IP Area(Parsing Error 1)";
		else if (code == 22002) return "Pass IP Area(Wrong ID)";
		else if (code == 22003) return "Pass IP Area(Parsing Error 2)";
		else if (code == 22004) return "Pass IP Area(Parsing Error 3)";
		else if (code == 22005) return "Pass IP Area(Parsing Error 4)";
		else if (code == 23001) return "Block IP Area(Parsing Error 1)";
		else if (code == 23002) return "Block IP Area(Wrong ID)";
		else if (code == 23003) return "Block IP Area(Parsing Error 2)";
		else if (code == 23004) return "Block IP Area(Parsing Error 3)";
		else if (code == 23005) return "Block IP Area(Parsing Error 4)";
		else if (code == 24001) return "DIP(Parsing Error 1)";
		else if (code == 24002) return "DIP(Wrong ID)";
		else if (code == 24003) return "DIP(Parsing Error 2)";
		else if (code == 24004) return "DIP(Parsing Error 3)";
		else if (code == 24005) return "DIP(Parsing Error 4)";
		else if (code == 24006) return "DIP(Parsing Error 5)";
		else if (code == 24007) return "DIP(Parsing Error 6)";
		else if (code == 25001) return "URL(Parsing Error 1)";
		else if (code == 25002) return "URL(Wrong ID)";
		else if (code == 25003) return "URL(Parsing Error 2)";
		else if (code == 25004) return "URL(Parsing Error 3. MD5)";
		else if (code == 25005) return "URL(Add Error 1. MD5)";
		else if (code == 25006) return "URL(Add Error 2. MD5)";
		else if (code == 25007) return "URL(Regx URL Over-length)";
		else if (code == 25008) return "URL(Unknown Encoding Type)";
		else if (code == 26001) return "URLDB(Parsing Error 1)";
		else if (code == 26002) return "URLDB(Wrong ID)";
		else if (code == 26003) return "URLDB(Parsing Error 2)";
		else if (code == 26004) return "URLDB(Wrong Depth 1)";
		else if (code == 26005) return "URLDB(Depth is zero 1)";
		else if (code == 26006) return "URLDB(Depth Outbound 1)";
		else if (code == 26007) return "URLDB(Depth is zero 2)";
		else if (code == 26008) return "URLDB(Depth Outbound 2)";
		else if (code == 26009) return "URLDB(Depth is zero 3)";
		else if (code == 26010) return "URLDB(Depth Outbound 3)";
		else if (code == 26011) return "URLDB(Duplication 1)";
		else if (code == 26012) return "URLDB(Duplication 2)";
		else if (code == 26013) return "URLDB(Duplication 3)";
		else if (code == 26014) return "URLDB(Add Failed 1)";
		else if (code == 26015) return "URLDB(Duplication 4)";
		else if (code == 26016) return "URLDB(Duplication 5)";
		else if (code == 26017) return "URLDB(Duplication 6)";
		else if (code == 26018) return "URLDB(Add Failed 2)";
		else if (code == 27001) return "DID(Parsing Error 1)";
		else if (code == 27002) return "DID(Wrong ID)";
		else if (code == 28001) return "BPORT(Parsing Error 1)";
		else if (code == 28002) return "BPORT(Wrong ID)";
		else if (code == 28003) return "BPORT(Parsing Error 2)";
		else if (code == 28004) return "BPORT(Parsing Error 3)";
		else if (code == 28005) return "BPORT(Port value is wrong)";
		else if (code == -1) return request == null ? Prop.propFormat("java.rpc.defined1") : Prop.propFormat("java.rpc.defined1", request);
		else if (code == -2) return request == null ? Prop.propFormat("java.rpc.defined2") : Prop.propFormat("java.rpc.defined2", request);
		else if (code == -3) return request == null ? Prop.propFormat("java.rpc.defined3") : Prop.propFormat("java.rpc.defined3", request);
		else if (code == -4) return request == null ? Prop.propFormat("java.rpc.defined4") : Prop.propFormat("java.rpc.defined4", request);
		else if (code == -5) return request == null ? Prop.propFormat("java.rpc.defined5") : Prop.propFormat("java.rpc.defined5", request);
		else if (code == -6) return request == null ? Prop.propFormat("java.rpc.defined6") : Prop.propFormat("java.rpc.defined6", request);
		else if (code == -7) return request == null ? Prop.propFormat("java.rpc.defined7") : Prop.propFormat("java.rpc.defined7", request);
		else return "";
	}

	public static String makeMoneyType(String dblMoneyString) {
		return makeMoneyType(nvn(dblMoneyString));
	}

	public static String makeMoneyType(long dblMoneyString) {
		return makeMoneyType((double) dblMoneyString);
	}

	public static String makeMoneyType(double dblMoneyString) {
		String moneyString = new Double(dblMoneyString).toString();
		String format = "#,##0";
		DecimalFormat df = new DecimalFormat(format);
		DecimalFormatSymbols dfs = new DecimalFormatSymbols();
		dfs.setGroupingSeparator(',');
		df.setGroupingSize(3);
		df.setDecimalFormatSymbols(dfs);
		return (df.format(Double.parseDouble(moneyString))).toString();
	}

	public static byte[] toByteArray(Object obj) {
		byte[] bytes = null;
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(bos);
			oos.writeObject(obj);
			oos.flush();
			oos.close();
			bos.close();
			bytes = bos.toByteArray();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
		return bytes;
	}
	
	public static byte[] decryptAfterDecompression(String path) {
		return decryptAfterDecompression(path, null);
	}

	public static byte[] decryptAfterDecompression(String path, String harPath) {
		if (Common.isEmpty(path)) return null;

		byte[] result = null;
		ByteArrayOutputStream out = null;
		GZIPInputStream bodyStream = null;
		InputStream in = null;
		try {
			if (isWindow()) {
				SFTPUtil ftp = new SFTPUtil();
				InputStream ins = null;
				File f = null;
				FileOutputStream fout = null;
				try {
					ftp.init(Config.DB_IP, Config.DB_USER, Config.DB_PASSWORD, 22);
					ins = ftp.download(path.substring(0, path.lastIndexOf('/')), new File(path).getName());
					f = new File("/users/apache/temp/" + new File(path).getName());
					fout = new FileOutputStream(f);
					IOUtils.copy(ins, fout);

					CryptoCommon crypto = new CryptoCommon();
					ins = crypto.decrypt(new FileInputStream(f));
					bodyStream = new GZIPInputStream(ins);
					out = new ByteArrayOutputStream();
					IOUtils.copy(bodyStream, out);
					result = out.toByteArray();
				} catch (EOFException e) {
					log.warn("file gzip error - path : {}", path);
					e.printStackTrace();
				} catch (JSchException e) {
					e.printStackTrace();
				} finally {
					ftp.disconnection();
					IOUtils.closeQuietly(ins);
					IOUtils.closeQuietly(fout);
					if (!f.delete()) f.deleteOnExit();
				}
			} else {
				AttachFile af = new AttachFile(path, harPath);
				if( af.exist()){
					in = af.open();
				}
				
				if (in != null) {
					CryptoCommon crypto = new CryptoCommon();
					bodyStream = new GZIPInputStream(crypto.decrypt(in));
					out = new ByteArrayOutputStream();
					IOUtils.copy(bodyStream, out);
					result = out.toByteArray();
				} else {
					log.warn("file not found {}", path);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(bodyStream);
		}
		return result;
	}

	public static byte[] toByteArrayGzip(String path, String harPath) {
		if (Common.isEmpty(path)) return null;
		byte[] result = null;
		ByteArrayOutputStream out = null;
		InputStream in = null;
		GZIPInputStream bodyStream = null;
		try {
			if ( Common.isNotEmpty(path)) in = getHdfsAttach(path, harPath);

			if (in != null) {
				bodyStream = new GZIPInputStream(in);
				out = new ByteArrayOutputStream();
				IOUtils.copy(bodyStream, out);
				result = out.toByteArray();
			} else {
				log.warn("file not found - path:{}, harPath:{}", path, harPath);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(bodyStream);
		}
		return result;
	}

	public static InputStream getHdfsAttach(String path, String harPath) {
		CryptoCommon crypto = new CryptoCommon();
		try {
			AttachFile af = new AttachFile(path, harPath);
			if (af.exist()) {
				return crypto.decrypt(af.open());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static boolean executeCommand(final String cmd) {
		log.info("EXECUTE COMMAND START : " + cmd);
		boolean result = true;
		Process process = null;
		try {
			process = Runtime.getRuntime().exec(cmd);
			process.waitFor();
		} catch (final Exception e) {
			e.printStackTrace();
			result = false;
		} finally {
			if (process != null) process.destroy();
		}
		log.info("EXECUTE COMMAND END : " + cmd);
		return result;
	}

	public static boolean executeCommandNoWait(final String cmd) {
		log.info("EXECUTE COMMAND START : " + cmd);
		boolean result = true;
		Process process = null;
		try {
			process = Runtime.getRuntime().exec(cmd);
			process.getErrorStream().close();
			process.getInputStream().close();
			process.getOutputStream().close();
			process.waitFor();
		} catch (final Exception e) {
			e.printStackTrace();
			result = false;
		} finally {
			if (process != null) process.destroy();
		}
		log.info("EXECUTE COMMAND END : " + cmd);
		return result;
	}

	public static boolean executorAwaitTermination(final ExecutorService es, final int seconds) {
		es.shutdown();
		try {
			if (!es.awaitTermination(seconds, TimeUnit.SECONDS)) {
				es.shutdownNow();
				if (!es.awaitTermination(10, TimeUnit.SECONDS)) {
					return false;
				}
			}
			return true;
		} catch (final InterruptedException e) {
		}
		return false;
	}

	public static void chmod(final String mod, final String path) {
		try {
			runScript("chmod " + mod + " " + path);
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
	
	public static String decodeUnicode(String uni) {
		StringBuffer str = new StringBuffer();
		for (int i = uni.indexOf("\\u"); i > -1; i = uni.indexOf("\\u")) {// euc-kr(%u), utf-8(//u)
			str.append(uni.substring(0, i));
			str.append(String.valueOf((char) Integer.parseInt(uni.substring(i + 2, i + 6), 16)));
			uni = uni.substring(i + 6);
		}
		str.append(uni);
		return str.toString();
	}


	public static void main(String[] args) throws Exception {
		
		/*String dt = "20171114_180801.919_vi_ptt_571091100_pre_00.json";
		
		DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd_HHmmss.SSS");
		DateTime xx = DateTime.parse(dt.substring(0, 19), yyyyMMdd);
		System.out.println(getDateTime(xx.getMillis(), "yyyyMMddHHmmssSSS"));*/

		//Properties x = loadProperties(Common.class.getResource("/com/env/env.properties").getPath());
		//System.out.println(x);
		//System.out.println( Common.ipDelZero("023.222.001.055"));
		String str = "\uc548\ub155\ud558\uc138\uc694, \uac1c\ubc1c QA \uc870\uc6c5\uc785\ub2c8\ub2e4. \ucd5c\uad11\ud5cc\ub2d8. \uae08\uc77c \uc624\uc804 \uad6c\ub450\ub85c \ub9d0\uc500\ub4dc\ub838\ub358 2L4SX (\uc0c1\ud310 rev. \uc774\uc804 3stack) HTOL \uc790\uc7ac confirm \ubd80\ud0c1\ub4dc\ub9bd\ub2c8\ub2e4. \uac01 \uc2dc\ub8cc\ub4e4\uc5d0 \ud6c4\uc18d \ubd88\ub7c9\uc774 \uc788\ub294\uc9c0\ub3c4 \ud655\uc778 \ubc0f Bin3 (Function) \uc2dc\ub8cc\uc5d0 \ub300\ud574\uc11c\ub294 fail log \ud655\ubcf4 \ubd80\ud0c1\ub4dc\ub9bd\ub2c8\ub2e4. \uc6b0\uc120 1\ucc28\uc801\uc73c\ub85c \ud558\uae30\uc640 \uac19\uc774 \ubd88\ub7c9\uc2dc\ub8cc \uad6c\ubd84\ud558\uc600\uace0 \uc2dc\ub8cc \ub85c\ub529\uc740 \uc5ec\uc0ac\uc6d0\uc774 \ud558\uae30 \ud45c \uc21c\uc11c\ub85c \ub85c\ub529 \uc608\uc815\uc785\ub2c8\ub2e4. \uadf8\ub9ac\uace0 PGM \uad00\ub828 \ud558\uae30 \uc0ac\ud56d\uc5d0 \ub300\ud574 \ucd94\uac00\ub85c \ud655\uc778 \ubd80\ud0c1\ub4dc\ub9bd\ub2c8\ub2e4. (1) BPC_DK \ud56d\ubaa9\ub4e4\uacfc \uc77c\ubc18 DK \ud56d\ubaa9 \ucc28\uc774\uc810 (2) Pre \ud56d\ubaa9\ub4e4\uacfc \uc77c\ubc18 \ud56d\ubaa9 \ucc28\uc774\uc810 (2) Logic \uc774\ud6c4 do all data \ubc1b\uc744 \uc218 \uc788\ub3c4\ub85d PGM \uc870\uce58\ubd80\ud0c1\ub4dc\ub9bd\ub2c8\ub2e4. (3) \ucd1d test item\uc740 1200\uac1c, \ud604\uc7ac Simax\uc5d0\uc11c \ud655\uc778\ub418\ub294 Test item \uac2f\uc218\ub294 800\uac1c \uc815\ub3c4\uc778\ub370 \ubaa8\ub4e0 data\ub97c simax\uc5d0 \ub2e4 \ubfcc\ub824\uc904 \uc218\ub294 \uc5c6\ub294 \uac83\uc778\uc9c0 \ud655\uc778 \ubd80\ud0c1\ub4dc\ub9ac\uba70 \ubd88\uac00\ub2a5\uc2dc \ucd5c\uc801\ud654 \ud544\uc694\ud569\ub2c8\ub2e4. \u203b Confim \ud544\uc694 \uc2dc\ub8cc \ubd88\ub7c9 \ubaa8\ub4dc \ub3d9\ubc18 \ubd88\ub7c9 \uc2dc\ub8cc\ubc88\ud638 Chip ID (2stack \uae30\uc900 ) Bin3 LVCC_FUNC_M3_270_NOR READ_VERID_I2C fail (3V\ub85c hard\uc131 fail) \ud6c4\uc18d \ubd88\ub7c9 \ud655\uc778 \ud544\uc694 #1047 Chip ID read fail Bin414 HV_HW_IDS_VDDA18 (\uc124\ube44 compliance 9999A \ud45c\uae30 \ub428) LVCC_DBIST_RAM_STEP1_PART \ud6c4\uc18d \ud655\uc778 \ud544\uc694 #933 NZ1VA-W07-114-140 #967 NZ1VA-W07-096-107 LVCC_FUNC_FRS_120F #969 NZ1VA-W07-100-104 LVCC_DBIST_RAM_STEP3_PART \ud6c4\uc18d \ud655\uc778 \ud544\uc694 #1008 NZ1W1-W01-117-126 #1011 NZ1W1-W01-111-110 Bin206 LV_TEST_PATTERN_ZERO TEST pattern \uad00\ub828 LVCC_FUNC_FRS_120F #826 NZ1VC-W02-106-133 #836 NZ1VC-W02-112-118 #991 NZ1W1-W01-107-115 Bin40 PRE_BD_1BIT \ud6c4\uc18d \ubd88\ub7c9 \ud655\uc778 \ud544\uc694 #841 NZ1VC-W02-115-138 \u203b \ub85c\ub529 \uc21c\uc11c DUT1 DUT2 DUT3 DUT4 1\ubc88 1047 826 836 991 2\ubc88 933 967 969 1008 3\ubc88 1011 841 \u3000 \u3000 \uac10\uc0ac\ud569\ub2c8\ub2e4.";
		System.out.println(decodeUnicode(str));
	}

	public static boolean runScript(final String command) {
		log.info("RUN SCRIPT START : " + command);
		boolean result = true;
		CommandLine oCmdLine = CommandLine.parse(command);
		DefaultExecutor exec = new DefaultExecutor();
		try {
			exec.execute(oCmdLine);
		} catch (ExecuteException e) {
			e.printStackTrace();
			result = false;
		} catch (IOException e) {
			e.printStackTrace();
			result = false;
		}
		log.info("RUN SCRIPT END : " + command);
		return result;
	}

	public static String dos2unix(final BufferedReader read) {
		StringBuffer _sb = new StringBuffer();
		try {
			String line;
			while ((line = read.readLine()) != null) {
				_sb.append(line).append("\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(read);
		}
		return _sb.toString();
	}

	public static void dos2unix(final String path) {
		File relFile = new File(path);
		if (relFile.exists()) {
			BufferedReader read = null;
			FileWriter fwri = null;
			try {
				StringBuffer _sb = new StringBuffer();
				read = new BufferedReader(new FileReader(relFile));
				String line;
				while ((line = read.readLine()) != null) {
					_sb.append(line).append("\n");
				}
				fwri = new FileWriter(relFile);
				fwri.write(convert(_sb.toString()));
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				IOUtils.closeQuietly(read);
				IOUtils.closeQuietly(fwri);
			}
		}
	}

	public static String convert(String in) {
		StringBuffer out = new StringBuffer();
		char c;
		for (int i = 0; i < in.length(); i++) {
			c = in.charAt(i);
			if (c != '\r') {
				out.append(c);
			}
		}
		return out.toString();
	}

	public static Properties loadProperties(String path) {
		Properties props = null;
		FileInputStream fis = null;
		try {
			props = new Properties();
			fis = new FileInputStream(path);
			props.load(fis);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(fis);
		}
		return props;
	}

	public void copy(InputStream input, OutputStream output) throws IOException {
		IOUtils.copy(input, output);
	}

	public static String formatNum(long number) {
		String[] suffix = new String[] {"K", "M", "B", "T"};
		long size = (number != 0) ? (int) Math.log10(number) : 0;
		if (size >= 3) {
			while (size % 3 != 0) {
				size = size - 1;
			}
		}
		return (size >= 3) ? +(Math.round((number / Math.pow(10, size)) * 100) / 100.0d) + suffix[(int) ((size / 3) - 1)] : +number + "";
	}
	
	public static String getIPversion ( String ip )
	{
		String result = "";
		InetAddress address = null;
		try {
			address = InetAddress.getByName(ip);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			return result;
		}
		if (address instanceof Inet6Address) {
			result = "6";
		} else if (address instanceof Inet4Address) {
			result = "4";
		}
		return result;
	}
	
	public static long strIpToLong ( String ip )
	{
		InetAddress tmpIp = null;
		long result = 0;
		try {
			tmpIp = InetAddress.getByName(ip);
			byte[] octets = tmpIp.getAddress();
			for (byte octet : octets) {
				result <<= 8;
				result |= octet & 0xff;
			}
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static long sum(List<Long> list) {
		if(list==null) return 0L;
		long sum = 0;
		for (long i : list)
			sum = sum + i;
		return sum;
	}




	/**
	 * 한글, 영어, 숫자, : 외 나머지 제거 
	 * @param str
	 * @return
	 */
	public static String replaceChar(String str) {
		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z:\\s]";
		str = str.replaceAll(match, "");
		return str;
	}
	
	
	/**
	 * Solr 쿼리 입력에 대한 key, value 값 추출 후 value 리턴
	 * +subject:(테스트 mulgama) temp:ttttttttt body:가나다라 attach:(aaa bbb)
	 * @param str
	 * @param result
	 * @return
	 */
	public static String keyValue(String str, String result) {
		if (str.trim().isEmpty()) return result;
		try {
			String keyTmp = str.substring(0, str.lastIndexOf(':'));
			String key = keyTmp.lastIndexOf(' ') == -1 ? keyTmp : keyTmp.substring(keyTmp.lastIndexOf(' '));
			String value = str.substring(str.lastIndexOf(':') + 1);
			keyTmp = keyTmp.lastIndexOf(' ') == -1 ? "" : keyTmp.substring(0, keyTmp.lastIndexOf(' '));
			if(Common.isOrEquals(key.trim(), "subject", "body", "attach", "attachname", "attachname_str", "ocr_attach")) result += value.trim() + " ";
			if(Common.isOrEquals(key.trim(), "+subject", "+body", "+attach", "+attachname", "+attachname_str", "+ocr_attach")) result += value.trim() + " ";
			if(Common.isOrEquals(key.trim(), "-subject", "-body", "-attach", "-attachname", "-attachname_str", "-ocr_attach")) result += value.trim() + " ";
			return keyValue(keyTmp, result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
public static String getDateDay(String date, String dateType) throws Exception {
		
		String day = "" ;
		
		SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
		Date nDate = dateFormat.parse(date) ;
		
		Calendar cal = Calendar.getInstance() ;
		cal.setTime(nDate);
		
		int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
		
		switch(dayNum){
			case 1:
				day = "일";
				break ;
			case 2:
				day = "월";
				break ;
			case 3:
				day = "화";
				break ;
			case 4:
				day = "수";
				break ;
			case 5:
				day = "목";
				break ;
			case 6:
				day = "금";
				break ;
			case 7:
				day = "토";
				break ;
				 
		}
		return day ;
	}



}
