package com.xcurenet.emass.message.component;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.emass.adminFilter.service.AdminFilterService;
import com.xcurenet.emass.adminFilter.service.AdminFilterVO;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import com.xcurenet.interestUser.service.AdminUserGroupVO;
import com.xcurenet.user.service.UserGroupVO;
import com.xcurenet.user.service.UserService;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.SortClause;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Slf4j
@Data
public class SolrCreateQuery {

	private AdminUserGroupService adminUserGroupService;
	private UserService userService;


	private AdminFilterService adminFilterService;

	public SolrQuery sq;
	public StringBuilder queryBuffer;
	public StringBuilder periodQueryBuffer;

	private static DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");

	private static final String SPACE = " ";
	//private static final String COMMA = ", ";
	private static final String SPECIAL_CHAR = "*";
	private static final String OR_PREFIX = " ";

	public static final String AND_QUERY = "+";
	public static final String EXCEPT_QUERY = "-";

	public static final String CTIME = "ctime";
	public static final String INFOTYPE = "ml_confd_class";
	public static final String FEEDBACK = "ml_confd_feedback";
	public static final String PROB = "ml_confd_prob";
	public static final String SKINFOTYPE = "ml_confd_class";
	public static final String SKFEEDBACK = "ml_confd_feedback";
	public static final String SKPROB = "ml_confd_prob";

	public static final String SERVICE = "svc";
	public static final String SERVICE_GROUP = "svc1";
	public static final String SERVICE_TYPE = "svc2";
	public static final String SERVICE_12 = "svc12";
	public static final String BUSICD = "busicd";
	public static final String IP_BUSICD = "ip_busicd";
	public static final String DEPTCD = "deptcd";
	public static final String JIKGUBCD = "jikgubcd";
	public static final String IP_DEPTCD = "ip_deptcd";
	public static final String USERKEY = "userkey";
	public static final String EPMSG_TYPE = "epmsg_type";
	public static final String[] SENDER = {"sender_str", "sname", "srcip","userkey"};
	public static final String SENDER_UPPER = "sender_str";
	public static final String[] SENDER_NOTUPPER = {"sender", "sname", "srcip"};
	public static final String[] RECEIVER = {"recvs", "recvs_name", "dstip"};
	public static final String[] RECEIVER_NOTUPPER = {"to", "tname", "cc", "cname", "bcc", "bname", "recvs_name", "dstip"};
	public static final String RECEIVER_UPPER = "recvs";
	public static final String TO = "to";
	public static final String TNAME = "tname";
	public static final String CC = "cc";
	public static final String CNAME = "cname";
	public static final String BCC = "bcc";
	public static final String BNAME = "bname";
	public static final String RECV_JIKGUBCD = "recvs_poid";
	public static final String HOST = "host";
	public static final String HOST_STR = "host_str";
	public static final String ATTACH_YN = "attached";
	public static final String ATTACHNAME = "attachname";
	public static final String KWDS_ATTACHNAME = "kwds_attachname";
	public static final String ATTACHTYPE = "attachtype";
	public static final String KEYWORD_YN = "kwd";
	public static final String KEYWORD = "kwds";
	public static final String PI_TOTAL = "pi_total";
	public static final String PI = "pi";
	public static final String USER_ID = "userid";
	public static final String SEARCH_HISTORY_USER_ID = "user.id";
	public static final String SEARCH_HISTORY_KEYWORD_STR = "keyword_str";
	public static final String SEARCH_HISTORY_DEPTCD = "user.deptCd";
	public static final String SEARCH_HISTORY_BUSICD = "user.busiCd";
	public static final String USER_STR = "user_str";
	public static final String NAME = "name";
	public static final String DIRECTION_SVC = "direction_svc";
	public static final String WORK = "work";
	public static final String DRM = "pi_DRM";
	public static final String ATTACH_EXIST_CNT = "attachexistcnt";
	public static final String ATTACH_CNT = "attachcnt";
	public static final String SCT = "pi_sct";
	public static final String ALLOFUS = "allofus";
	public static final String LTIME = "ltime";
	public static final String ATTACH_SPACE = "attachspace";
	public static final String OCR_ATTACH_CNT = "ocr_attach_cnt";

	public static final String SIZE = "size";
	public static final String BODY_SIZE = "body_size";
	public static final String ATTACH_SIZE = "attachsize";
	public static final String ATTACH_MAX_SIZE = "attachsizeSum";
	public static final String REPROCESS = "reprocess";

	public static final String JOIN_READ = " +checked.readId:%s";
	public static final String JOIN_UNREAD = " -checked.readId:%s";

	private static final String OCR_FIELD = " ocr_attach";
	private String finalReadYn;
	private String consentNo;

	private String regexPattern;

	public String[] SEARCH_FIELD = {"msgid",
			"kwds_body", "kwds_subject", "kwds_attach",
			"subject",
			"body",
			"attach",
			"attachname", "attachname_str", "kwds_attachname", // 첨부파일명
			"host", "host_str", // host
			"path", "query", // url
			"srcip", "dstip", // 출발지 IP, 목적지 IP
			"body_snippet",
			"sender", "sender_str", "sname", "recvs", "recvs_name", "to", "cc", "bcc", "usr_id", // 보낸사람, 받는사람
			"xrootmtr",
			"user", "user_str", "userid", "name" //사용자
	};

	private String[] INEQUALITY_SIGN = {"+","-","|"};



	private static Map<String,String> BRACKET_MAP = Map.of(
			"{", "}",
			"[", "]"
			);

	private static Map<String,String> PARENTHESES = Map.of(
			"(", ")"
	);

	public SolrCreateQuery() {
		sq = new SolrQuery();
		queryBuffer = new StringBuilder();
		periodQueryBuffer = new StringBuilder();
	}

	public SolrQuery setQuery() {
		sq.setQuery(periodQueryBuffer.toString().trim() + SPACE + queryBuffer.toString().trim());
		sq.setParam("defType", "edismax");
		sq.setParam("regexPattern",getRegexPattern());

		//sq.setSort(SortClause.desc("ctime"));
		queryBuffer = new StringBuilder();
		return sq;
	}

	public String getQuery() {
		return sq.getQuery();
	}

	private SolrCreateQuery addQuery(String query) {
		this.queryBuffer.append(query).append(SPACE);
		return this;
	}

	private SolrCreateQuery addFilterQuery(String query) {
		sq.addFilterQuery(query);
		return this;
	}

	private SolrCreateQuery addPeriodQuery(String query) {
		this.periodQueryBuffer.append(query).append(SPACE);
		return this;
	}

	public SolrCreateQuery setSort(String sort){
		if( Common.isEmpty(sort)){
			sq.setSort(SortClause.desc ( "ctime" ));
			sq.addSort(SortClause.desc ("msgid"));
			return this;
		}
		String [] sorts = sort.split(" ");
		if( sorts.length < 1 || Common.isEmpty(sorts[1])) return this;
		if( Common.isEquals(sorts[1], "desc")){
			sq.setSort(SortClause.desc ( sorts[0] ));
			sq.addSort(SortClause.desc ("msgid"));
		}else{
			sq.setSort(SortClause.asc ( sorts[0] ));
			sq.addSort(SortClause.asc ("msgid"));
		}
		return this;
	}

	/**
	 * 검색 영역을 설정한다.(field 설정)
	 */
	@Deprecated
	public SolrCreateQuery setSelectSearchFields(String... search_fields) {

		if (search_fields.length <= 1 && Common.isEmpty(search_fields[0])) {
			sq.setParam("sqf", StringUtils.join(this.SEARCH_FIELD, " "));
		} else {
			sq.setParam("sqf", StringUtils.join(search_fields, " "));
		}
		return this;
	}

	/**
	 * 검색 영역을 설정한다.(field 설정)
	 */
	private SolrCreateQuery setSearchField(String search_field) {
		String dfString = StringUtils.join(this.SEARCH_FIELD, " ");
		if (Config.isOCR) {
			dfString += OCR_FIELD;
		}
		sq.setParam("qf", dfString);
		return this;
	}

	/**
	 * 기간 쿼리(전체 기간)
	 */
	public SolrCreateQuery setDateQuery(String period, String startDt, String endDt) throws Exception {
		periodQueryBuffer = new StringBuilder();
		return addDateQuery(period, startDt, endDt);
	}

	/**
	 * 기간 쿼리(전체 기간)
	 */
	public SolrCreateQuery addDateQuery(String period, String startDt, String endDt) throws Exception {
		if (Common.isEmpty(startDt) || Common.isEmpty(endDt)) return this;
		if (Common.isEquals(period, "2")) {
			String now = Common.getCurrentDate();

			startDt = Common.plusDays(now, (Common.nvz(startDt) * -1)) + "000000";
			endDt = Common.plusDays(now, (Common.nvz(endDt) * -1)) + "235959";
		} else if (Common.isEquals(period, "3") || Common.isEquals(period, "4")) {
			return setDateQuery("1", startDt, endDt);
		}
		return addPeriodQuery(String.format("%s%s:[%s TO %s]", AND_QUERY, CTIME, startDt.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", ""), endDt.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")));
	}

	/**
	 * 기간 쿼리(전체 기간)
	 */
	public SolrCreateQuery addDateQuery(String startDateSelect, int startTimeSelect, String endDateSelect, int endTimeSelect) throws Exception {
		if(Common.isEmpty(startDateSelect) || Common.isEmpty(endDateSelect)) return this;

		String startDt = getStartDt(startDateSelect, startTimeSelect);
		String endDt = getEndDt(endDateSelect, endTimeSelect);
		return addDateQuery("1", startDt, endDt);
	}

	/**
	 * 검색어 쿼리
	 */
	public SolrCreateQuery setSearchStr(String searchStr) {
		if (Common.isEmpty(searchStr)) return this;

		return addQuery(String.format("%s(%s)", AND_QUERY, getSearchQuery(searchStr)));
	}

	/**
	 * 검색어 쿼리
	 */
	public SolrCreateQuery setSearchStr(String searchStr, String searchField) {
		if (Common.isEmpty(searchStr)) return this;

		if(searchStr.indexOf("\\") > -1 && searchStr.length() == 1) {
			if(searchStr.indexOf("\\") == searchStr.lastIndexOf("\\")) return this;
		}


		if (Common.isEmpty(searchField)) return addQuery(String.format("%s(%s)", AND_QUERY, getSearchQuery(searchStr)));
		else {
			searchField = searchField.replaceAll(",", " ");
			String[] fields = searchField.split(" ");
			StringBuilder query = new StringBuilder();
			for (String field : fields) {
				query.append(String.format("%s:(%s) ", field, getSearchQuery(searchStr)));
			}

			return addQuery(String.format("%s(%s)", AND_QUERY,query));
		}
	}


	public SolrCreateQuery setSearchHistoryUserStr(String userStr) {
		if (Common.isEmpty(userStr)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SEARCH_HISTORY_USER_ID, createOrQuery(userStr)));
	}

	public SolrCreateQuery setSearchHistoryKeywordStr(String keyword) {
		if (Common.isEmpty(keyword)) return this;
		return addQuery(String.format("%s%s:\"%s\"", AND_QUERY, SEARCH_HISTORY_KEYWORD_STR, keyword));
	}

	public SolrCreateQuery setName(String name) {
		if (Common.isEmpty(name)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, USER_ID, createOrQuery(name)));
	}

	public SolrCreateQuery setDeptcd(String deptcd) {
		if (Common.isEmpty(deptcd)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, DEPTCD, createOrQuery(deptcd)));
	}

	public SolrCreateQuery setSearchHistoryDeptcd(String deptcd) {
		if (Common.isEmpty(deptcd)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SEARCH_HISTORY_DEPTCD, createOrQuery(deptcd)));
	}

	public SolrCreateQuery setSearchHistoryBusicd(String busicd) {
		if (Common.isEmpty(busicd)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SEARCH_HISTORY_BUSICD, createOrQuery(busicd)));
	}

	public SolrCreateQuery setBusicd(String busicd) {
		if (Common.isEmpty(busicd)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, BUSICD, createOrQuery(busicd)));
	}



	/**
	 * 서비스 그룹 쿼리
	 */
	public SolrCreateQuery setServiceGroup(String serviceGroups) {
		if (Common.isEmpty(serviceGroups)) return this;
		if(serviceGroups.length() == 1 ) return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_GROUP, createOrQuery(serviceGroups)));
		else if(serviceGroups.length() == 3 ) return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_12, createOrQuery(serviceGroups)));
		else return this;
	}
	/**
	 * 서비스 타입 쿼리
	 */
	public SolrCreateQuery setServiceType(String serviceTypes) {
		if (Common.isEmpty(serviceTypes)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_TYPE, createOrQuery(serviceTypes)));
	}

	/**
	 * 서비스 쿼리( 서비스 타입 3자리로 넘어오는 경우 )
	 */
	public SolrCreateQuery setService(String services) {
		if (Common.isEmpty(services)) return this;
		String[] param = Common.toArray(services, ",");
		StringBuilder service3 = new StringBuilder();
		StringBuilder service4 = new StringBuilder();
		StringBuilder serviceQueryStr = new StringBuilder();
		for (String s : param) {
			if (s.length() == 3) {
				service3.append(s).append(",");
			} else {
				service4.append(s).append(",");
			}
		}
		if(Common.isEmpty(service3.toString()) && Common.isEmpty(service4.toString())) return this;
		if(Common.isNotEmpty(service4.toString()) && service4.toString().contains("EMMAX")) {
			serviceQueryStr.append(String.format("%s%s:(EMMA*) ",EXCEPT_QUERY, SERVICE));
			service4 = new StringBuilder(service4.toString().replaceAll("EMMAX", ""));
			if(Common.isEquals(service4.toString(),",")) {
				service4 = new StringBuilder();
			}
		}

		if(Common.isNotEmpty(service3.toString())) {
			if(Common.isNotEmpty(service4.toString())) {
				serviceQueryStr.append(String.format("%s(",AND_QUERY));
				serviceQueryStr.append(String.format("%s%s:%s", SPACE, SERVICE_12, createOrQuery(service3.substring(0, service3.toString().lastIndexOf(',')))));
				serviceQueryStr.append(String.format(" %s%s:%s", SPACE, SERVICE, createOrQueryAppend(service4.substring(0, service4.toString().lastIndexOf(',')), SPECIAL_CHAR)));
				serviceQueryStr.append(")" );

			} else {
				serviceQueryStr.append(String.format("%s%s:%s", AND_QUERY, SERVICE_12, createOrQuery(service3.substring(0, service3.toString().lastIndexOf(',')))));
			}
		} else if(Common.isNotEmpty(service4.toString())) {
			serviceQueryStr.append(String.format(" %s%s:%s", AND_QUERY, SERVICE, createOrQueryAppend(service4.substring(0, service4.toString().lastIndexOf(',')), SPECIAL_CHAR)));
		}

		return addQuery(serviceQueryStr.toString());
	}

	/**
	 * 서비스 쿼리( 서비스 타입 3자리로 넘어오는 경우 )
	 */
	public SolrCreateQuery setService12(String services) {
		if (Common.isEmpty(services)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_12, createOrQuery(services)));
	}



	/***
	 *  argment에 괄호 감싸기
	 * @param argment
	 * @return
	 */
	private String makeParentheses(String argment) {
		StringBuilder tempSb = new StringBuilder();
		tempSb.append(ElasticSearchCommon.OPEN_PARENTHESES);
		tempSb.append(argment);
		tempSb.append(ElasticSearchCommon.CLOSE_PARENTHESES);
		return tempSb.toString();
	}


	/**
	 * 정보 분류 쿼리
	 */
	public SolrCreateQuery setInfoType(String infoTypes) {
		if (Common.isEmpty(infoTypes)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, INFOTYPE, createOrQueryInfoFeedback(infoTypes)));
	}

	/**
	 * 피드백 쿼리
	 */
	public SolrCreateQuery setFeedback(String feedbacks) {
		if (Common.isEmpty(feedbacks)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, FEEDBACK, createOrQueryInfoFeedback(feedbacks)));
	}

	/**
	 * 판정 확률 쿼리
	 */
	public SolrCreateQuery setProb(String probs) {
		if (Common.isEmpty(probs)) return this;
		return addQuery(String.format("%s(%s)", AND_QUERY, createOrQueryProb(probs)));
	}

	/**
	 * sk 문서 분류 쿼리
	 */
	public SolrCreateQuery setSkInfoType(String skInfoTypes) {
		if (Common.isEmpty(skInfoTypes)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SKINFOTYPE, createOrQueryInfoFeedback(skInfoTypes)));
	}

	/**
	 * sk 피드백 쿼리
	 */
	public SolrCreateQuery setSkFeedback(String skFeedbacks) {
		if (Common.isEmpty(skFeedbacks)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, SKFEEDBACK, createOrQueryInfoFeedback(skFeedbacks)));
	}

	/**
	 * sk 비밀 확률 쿼리
	 */
	public SolrCreateQuery setSkProb(String skProbs) {
		if (Common.isEmpty(skProbs)) return this;
		return addQuery(String.format("%s(%s)", AND_QUERY, createOrQuerySkProb(skProbs)));
	}

	/**

	 /**
	 * 사업장 쿼리
	 */
	public SolrCreateQuery setBusicd(String busicds, String busi_not) {
		if (Common.isEmpty(busicds)) return this;
		String queryType = Config.getString("query.type", "A"); // 인사정보기준 + IP 기준 사업장 정보
		StringBuffer query = new StringBuffer();
//		String [] busicd = Common.toArray(busicds, ",");
		String [] busicd = busicds.split(",");
		StringBuilder busicd_strs = new StringBuilder();

		if( Common.isEquals(queryType, "B")) { //인사정보 기준 사업장 정보
			for (int i = 0; i < busicd.length; i++) {
				if(Common.isEquals(busicd[i], "C00-00")){
					query.append(String.format("(%s%s:%s) ", AND_QUERY, BUSICD, busicd[i]));
				}else{
					busicd_strs.append("("+busicd[i]).append(")");
				}
			}
			if(Common.isNotEmpty(busicd_strs.toString())) query.append(String.format("%s:(%s) ", BUSICD, busicd_strs.toString()));

		} else if( Common.isEquals(queryType, "C")) { // IP 기준 사업장 정보
			query.append("+");
			for (int i = 0; i < busicd.length; i++) {
				if(Common.isEquals(busicd[i], "C00-00")){
					query.append(String.format("(%s%s:%s) ", AND_QUERY, IP_BUSICD, busicd[i]));
				}else{
					busicd_strs.append(busicd[i]).append(SPACE);
				}
			}
			if(Common.isNotEmpty(busicd_strs.toString())) query.append(String.format("%s:(%s) ", IP_BUSICD, busicd_strs.toString()));

		} else { // queryType = A 또는 그외 기본값
			for (int i = 0; i < busicd.length; i++) {
				if(Common.isEquals(busicd[i], "C00-00")){
					query.append(String.format("(%s%s:%s %s%s:%s) ", AND_QUERY, BUSICD, busicd[i], AND_QUERY, IP_BUSICD, busicd[i]));
				}else{
					busicd_strs.append("(").append(busicd[i]).append(")").append(SPACE);
				}
			}

			if(Common.isNotEmpty(busicd_strs.toString())) query.append(String.format("%s:(%s) %s:(%s) ", BUSICD, busicd_strs.toString(), IP_BUSICD, busicd_strs.toString()));
		}
		if(Common.isEquals(busi_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, query.toString()));
		else return addQuery(String.format("%s(%s)", AND_QUERY, query.toString()));
	}

	/**
	 * 부서 쿼리
	 */
	public SolrCreateQuery setDeptcd(String deptcds, String dept_not) {
		if (Common.isEmpty(deptcds)) return this;

		StringBuilder query = new StringBuilder();
		String [] deptCd = Common.toArray(deptcds, ",");
		StringBuilder deptCd_strs = new StringBuilder();
		StringBuilder sb = new StringBuilder();
		for (String s : deptCd){
			sb.append("(").append(s).append(")");
		}

		for (int i = 0; i < deptCd.length; i++) {
			if(Common.isEquals(deptCd[i], "C00-00")){
				System.out.println(deptCd[i]);
				query.append(String.format("(%s%s:%s %s%s:%s) ", AND_QUERY, DEPTCD, deptCd[i], AND_QUERY, IP_DEPTCD, deptCd[i]));
			}else{
				deptCd_strs.append(sb).append(SPACE);
			}
		}

		if(Common.isNotEmpty(deptCd_strs.toString())) query.append(String.format("%s:(%s) %s:(%s) ", DEPTCD, deptCd_strs.toString(), IP_DEPTCD, deptCd_strs.toString()));

		if(Common.isEquals(dept_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, query.toString()));
		else return addQuery(String.format("%s(%s)", AND_QUERY,query.toString()));
	}

	public SolrCreateQuery setJikgub(String jikgub, String jikgub_not) {
		if(Common.isEquals(jikgub_not, "Y")) {
			return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, JIKGUBCD, createOrQuery(jikgub_not)));
		}
		if (Common.isEmpty(jikgub)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, JIKGUBCD, createOrQuery(jikgub)));
	}


	/**
	 * 대외비 쿼리
	 */
	public SolrCreateQuery setEpmsgType(String epmsg_type) {
		if (Common.isEmpty(epmsg_type)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, EPMSG_TYPE, createOrQuery(epmsg_type,",")));

	}

	/**
	 * 발신자 쿼리
	 */
	public SolrCreateQuery setSender(String sender, String senders_not, String senders_upperCase) {
		if (Common.isEmpty(sender)) return this;

		StringBuffer queryStr = new StringBuffer();

		if(Common.isEquals(senders_upperCase, "Y")) {
			queryStr.append(String.format("%s%s:%s", AND_QUERY, SENDER_UPPER, createOrQueryAsteriskAll(sender))).append(SPACE);
		} else if(Common.isEquals(Config.getString("receiver.sender.uppercase"), "Y")) {

			for (int i = 0; i < SENDER_NOTUPPER.length; i++) {
				if (sender.startsWith("\"") && sender.endsWith("\"")) queryStr.append(String.format("%s:%s", SENDER_NOTUPPER[i], sender)).append(SPACE);
				else queryStr.append(String.format("%s:%s", SENDER_NOTUPPER[i], createOrQuery(sender))).append(SPACE);
			}
		} else {
			for (int i = 0; i < SENDER.length; i++) {
				if (sender.startsWith("\"") && sender.endsWith("\"")) queryStr.append(String.format("%s:%s", SENDER[i], sender)).append(SPACE);
				else queryStr.append(String.format("%s:%s", SENDER[i], createOrQuery(sender))).append(SPACE);
			}
		}



		if(Common.isEquals(senders_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, queryStr.toString()));
		else return addQuery(String.format("%s(%s)", AND_QUERY, queryStr.toString()));
	}

	/**
	 * 수신자 쿼리
	 */
	// 수/발신 쿼리 내용 추가 해야함
	public SolrCreateQuery setReciver(String receive_option, String receivers, String receivers_not, String receivers_upperCase, String m_to, String m_to_not, String m_cc, String m_cc_not, String m_bcc, String m_bcc_not) {
		if (Common.isEmpty(receive_option) && Common.isEmpty(receivers)) return this;
		if (Common.isEquals(receive_option, "detail") && Common.isEmpty(m_to) && Common.isEmpty(m_cc) && Common.isEmpty(m_bcc)) return this;


		if (Common.isEmpty(receive_option)) {
			StringBuffer queryStr = new StringBuffer();

			if(Common.isEquals(receivers_upperCase, "Y")) {
				queryStr.append(String.format("%s%s:%s", AND_QUERY, RECEIVER_UPPER, createOrQuery(receivers))).append(SPACE);
			} else if(Common.isEquals(Config.getString("receiver.sender.uppercase"), "Y")) {

				for (int i = 0; i < RECEIVER_NOTUPPER.length; i++) {
					if (receivers.startsWith("\"") && receivers.endsWith("\"")) queryStr.append(String.format("%s:%s", RECEIVER_NOTUPPER[i], receivers)).append(SPACE);
					else queryStr.append(String.format("%s:%s", RECEIVER_NOTUPPER[i], createOrQuery(receivers))).append(SPACE);
				}
			} else {
				for (int i = 0; i < RECEIVER.length; i++) {
					if (receivers.startsWith("\"") && receivers.endsWith("\"")) queryStr.append(String.format("%s:%s", RECEIVER[i], receivers)).append(SPACE);
					else queryStr.append(String.format("%s:%s", RECEIVER[i], createOrQuery(receivers))).append(SPACE);
				}
			}

			if (Common.isEquals(receivers_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, queryStr.toString()));
			else return addQuery(String.format("%s(%s)", AND_QUERY, queryStr.toString()));
		} else {
			StringBuffer queryStr = new StringBuffer();

			if(Common.isNotEmpty(m_to)) {
				StringBuffer toStr = new StringBuffer();
				if (m_to.startsWith("\"") && m_to.endsWith("\"")) toStr.append(String.format("%s:%s %s:%s", TO, m_to, TNAME, m_to)).append(SPACE);
				else toStr.append(String.format("%s:%s %s:%s", TO, createOrQueryAsteriskAll(m_to), TNAME, createOrQueryAsteriskAll(m_to))).append(SPACE);
				if (Common.isEquals(m_to_not, "Y")) queryStr.append(String.format("%s(%s) ", EXCEPT_QUERY, toStr.toString()));
				else queryStr.append(String.format("%s(%s) ", AND_QUERY, toStr.toString()));
			}

			if(Common.isNotEmpty(m_cc)) {
				StringBuffer ccStr = new StringBuffer();
				if (m_cc.startsWith("\"") && m_cc.endsWith("\"")) ccStr.append(String.format("%s:%s %s:%s", CC, m_cc, CNAME, m_cc)).append(SPACE);
				else ccStr.append(String.format("%s:%s %s:%s", CC, createOrQueryAsteriskAll(m_cc), CNAME, createOrQueryAsteriskAll(m_cc))).append(SPACE);
				if (Common.isEquals(m_cc_not, "Y")) queryStr.append(String.format("%s(%s) ", EXCEPT_QUERY, ccStr.toString()));
				else queryStr.append(String.format("%s(%s) ", AND_QUERY, ccStr.toString()));
			}

			if(Common.isNotEmpty(m_bcc)) {
				StringBuffer bccStr = new StringBuffer();
				if (m_bcc.startsWith("\"") && m_bcc.endsWith("\"")) bccStr.append(String.format("%s:%s %s:%s", BCC, m_bcc, BNAME, m_bcc)).append(SPACE);
				else bccStr.append(String.format("%s:%s %s:%s", BCC, createOrQueryAsteriskAll(m_bcc), BNAME, createOrQueryAsteriskAll(m_bcc))).append(SPACE);
				if (Common.isEquals(m_bcc_not, "Y")) queryStr.append(String.format("%s(%s) ", EXCEPT_QUERY, bccStr.toString()));
				else queryStr.append(String.format("%s(%s) ", AND_QUERY, bccStr.toString()));
			}
			return addQuery(queryStr.toString());
		}
	}

	public SolrCreateQuery setRcvJikgub(String rcvJikgub,String recv_jikgub_not) {
		if(Common.isEquals(recv_jikgub_not, "Y")) {
			return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, RECV_JIKGUBCD, createOrQuery(rcvJikgub)));
		}
		if (Common.isEmpty(rcvJikgub)) return this;
		return addQuery(String.format("%s%s:%s", AND_QUERY, RECV_JIKGUBCD, createOrQuery(rcvJikgub)));
	}

	public SolrCreateQuery setUrl(String url, String url_not) {
		if (Common.isEmpty(url)) return this;
		url = removeSpecialCharacters(url);
		StringBuffer queryStr = new StringBuffer();

		queryStr.append(String.format("%s:%s", HOST, createOrQueryAsteriskAll(url))).append(SPACE);
		queryStr.append(String.format("%s:%s", HOST_STR, createOrQueryAsteriskAll(url))).append(SPACE);

		if(Common.isEquals(url_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, queryStr.toString()));
		else return addQuery(String.format("%s(%s)", AND_QUERY, queryStr.toString()));
	}

	public static String removeSpecialCharacters(String input) {
		String regex = "([+\\-\\&\\|!\\(\\)\\{\\}\\[\\]\\^\"~\\*\\?:\\/\\\\])";
		return input.replaceAll(regex, "");
	}


	public SolrCreateQuery setAttach(String attachYn, String attachs) {
		return setAttach(attachYn, attachs, "");
	}
	/**
	 * 첨부파일 쿼리
	 */
	public SolrCreateQuery setAttach(String attachYn, String attachs, String attachYn_not) {
		return setAttach(attachYn, attachs, "", "N", "N");
	}

	public SolrCreateQuery setAttach(String attachYn, String attachs, String attachYn_not, String realAttYn, String drmYn) {
		if (Common.isEmpty(attachYn)) return this;

		StringBuffer queryStr = new StringBuffer();
		StringBuffer drmQueryStr = new StringBuffer();
		StringBuffer realyAttQueryStr = new StringBuffer();

		queryStr.append(String.format("%s%s:%s ", AND_QUERY, ATTACH_YN, attachYn));

		//첨부가 있는 경우에만 실제 존재 및 drm 기능 확인
		if(Common.isEquals(attachYn, "Y")){

			if (Common.isEquals(realAttYn, "Y")) realyAttQueryStr.append(String.format("%s%s:%s", AND_QUERY, ATTACH_EXIST_CNT, ">0"));
			else if (Common.isEquals(realAttYn, "N")) realyAttQueryStr.append(String.format("%s%s:%s ", AND_QUERY, ATTACH_EXIST_CNT, "0"));


			if (Common.isEquals(drmYn, "Y")) drmQueryStr.append(String.format("%s%s:%s", AND_QUERY, DRM, ">0"));
			else if (Common.isEquals(drmYn, "N")) drmQueryStr.append(String.format("%s%s:%s", EXCEPT_QUERY, DRM, ">0"));
		}

		if (Common.isNotEmpty(attachs)) {
			if( Common.isEquals(attachYn_not, "Y")) queryStr.append(String.format("%s%s:%s", EXCEPT_QUERY, ATTACHTYPE, createOrQuery(attachs.toLowerCase(), "|")));
			else queryStr.append(String.format("%s%s:%s", AND_QUERY, ATTACHTYPE, createOrQuery(attachs.toLowerCase(), "|")));
		}

		queryStr.append(SPACE).append(drmQueryStr.toString()).append(SPACE).append(realyAttQueryStr.toString());
		return addQuery(queryStr.toString());
	}

	/**
	 * 예약어 쿼리
	 */
	public SolrCreateQuery setKwd(String kwdYn, String kwds, String keywordYn_not) {
		if (Common.isEmpty(kwdYn)) return this;

		StringBuffer queryStr = new StringBuffer();
		queryStr.append(String.format("%s%s:%s ", AND_QUERY, KEYWORD_YN, kwdYn));
		kwds = removeSpecialCharacters(kwds);

		if (Common.isNotEmpty(kwds)) {
			if(Common.isEquals(keywordYn_not, "Y")){
				queryStr.append(EXCEPT_QUERY);
				queryStr.append("(");
				queryStr.append(String.format("%s%s:%s", "", KEYWORD, createOrQuery(kwds, ", ")));
				queryStr.append(String.format("%s%s:%s", " ", KWDS_ATTACHNAME, createOrQuery(kwds, ", ")));
				queryStr.append(")");
			}
			else{
				queryStr.append(AND_QUERY);
				queryStr.append("(");
				queryStr.append(String.format("%s%s:%s", "", KEYWORD, createOrQuery(kwds, ", ")));
				queryStr.append(String.format("%s%s:%s", " ", KWDS_ATTACHNAME, createOrQuery(kwds, ", ")));
				queryStr.append(")");
			}
		}
		return addQuery(queryStr.toString());
	}

	/**
	 * 패턴 검출 쿼리
	 */
	public SolrCreateQuery setPi(String piYn, String pis) {
		if (Common.isEmpty(piYn)) return this;

		StringBuilder queryStr = new StringBuilder();
		if (Common.isEquals(piYn, "Y")) queryStr.append(String.format("%s%s:[1 TO *] ", AND_QUERY, PI_TOTAL));
		else if (Common.isEquals(piYn, "N")) queryStr.append(String.format("%s%s:0 ", AND_QUERY, PI_TOTAL));

		if (Common.isNotEmpty(pis)) {
			if( pis.contains("@")) {
				queryStr.append(String.format("%s", createOrQueryRegexpCount(pis, "|")));
			} else {
				queryStr.append(String.format("%s:%s", PI, createOrQuery(pis, "|")));
			}
		}

		return addQuery(queryStr.toString());
	}

	private String createOrQueryRegexpCount(String params, String separator) {
		String[] param = Common.toArray(params, separator);

		StringBuilder result = new StringBuilder();
		result.append(AND_QUERY);
		result.append("(");

		for (int i = 0; i < param.length; i++) {
			String[] svc = Common.toArray(param[i], "%");
			result.append("pi_" + svc[0] + ":");

			String[] val = Common.toArray(svc[1], "@");
			if( val[0].equals("B") ) result.append("[ " + val[1] + " TO " + val[2] + " ]");
			else if( val[0].equals("L") ) result.append("[ " + val[1] + " TO * ]");
			else result.append("[ 1 TO " + val[1] + " ]");

			if (i != param.length - 1) result.append(SPACE);
		}
		result.append(")");

		return result.toString();
	}

	/**
	 * 관심 사용자 그룹 쿼리
	 */
	public SolrCreateQuery setInterestUserGroup(String interGroup, String interGroup_not) {
		if (Common.isEmpty(interGroup)) return this;
		adminUserGroupService = SpringContextUtil.getBean(AdminUserGroupService.class);
		List<AdminUserGroupVO> users = adminUserGroupService.getAdminUserGroupSimpleList(interGroup);
		if (users.isEmpty()) {
			addQuery(AND_QUERY+"userid:\"not_found_user\"");
			return this;
		}

		if(Common.isEquals(interGroup_not, "Y")) addQuery(EXCEPT_QUERY+"(");
		else addQuery(AND_QUERY+"(");

		for(AdminUserGroupVO user : users) {
			String userId = user.getUserId();
			if (userId != null) addQuery("(userid:\"" + userId.toLowerCase() + "\")");
		}
		addQuery(")");

		return this;
	}

	/**
	 * 서비스 그룹 조건
	 */
	public SolrCreateQuery setSvc1(String svc1, String svc1_not) {
		if (Common.isEmpty(svc1) && Common.isEmpty(svc1_not)) return this;

		if (Common.isNotEmpty(svc1)) addFilterQuery(String.format("%s%s:(%s)", AND_QUERY, SERVICE_GROUP, svc1));
		if (Common.isNotEmpty(svc1_not)) addFilterQuery(String.format("%s%s:(%s)", EXCEPT_QUERY, SERVICE_GROUP, svc1_not));

		return this;
	}


	/**
	 * 현재 사용하지 않음
	 */
	@Deprecated
	public SolrCreateQuery setAllInterestUserGroup(String adminId, String interGroup_not) {
		adminUserGroupService = SpringContextUtil.getBean(AdminUserGroupService.class);
		List<AdminUserGroupVO> users = adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId);
		if (users == null) return this;

		for(AdminUserGroupVO user : users) {
			String emailStr = user.getUserEmail();
			String ipStr = user.getUserIp();
			String userId = user.getUserId();

			if (emailStr != null || ipStr != null || userId != null) {
				if(Common.isEquals(interGroup_not, "Y")) addQuery(EXCEPT_QUERY+"(");
				else addQuery(AND_QUERY+"(");
			}

			if(userId != null) {
				addQuery("userid:" + userId );
			}

			if (emailStr != null) {
				String emailQuery = "";
				String [] emails = Common.toArray(emailStr, ",");
				for (String email : emails) {
					emailQuery += "\"" + email.trim() + "\" ";
				}
				if (Common.isNotEmpty(emailQuery)) {
					addQuery("sender_str:(" + emailQuery + ")");
					addQuery("recvs:(" + emailQuery + ")");
					addQuery("user_str:(" + emailQuery + ")");
				}
			}
			if (ipStr != null) {
				String ipQuery = "";
				String [] ips = Common.toArray(ipStr, ",");
				for (String ip : ips) {
					ipQuery += "\"" + ip.trim() + "\" ";
				}
				if (Common.isNotEmpty(ipQuery)) {
					addQuery("recvs:(" + ipQuery + ")");
					addQuery("srcip:(" + ipQuery + ")");
					addQuery("dstip:(" + ipQuery + ")");
				}
			}
			if (emailStr != null || ipStr != null || userId != null) {
				addQuery(")");
			}
		}

		return this;
	}

	/**
	 * 관심 사용자 발신 메일 쿼리
	 */
	public SolrCreateQuery setInterestUserGroupSendMail(String interGroup) {
		adminUserGroupService = SpringContextUtil.getBean(AdminUserGroupService.class);
		List<AdminUserGroupVO> users = adminUserGroupService.getAdminUserGroupSimpleList(interGroup);
		if (users == null) return this;

		for(AdminUserGroupVO user : users) {
			String emailStr = user.getUserEmail();
			if (emailStr != null) {
				String emailQuery = "";
				String [] emails = Common.toArray(emailStr, ",");
				for (String email : emails) {
					emailQuery += "\"" + email.trim() + "\" ";
				}
				if (Common.isNotEmpty(emailQuery)) {
					addQuery("+sender_str:(" + emailQuery + ")");
				}
			}
			String ipStr = user.getUserIp();
			if (ipStr != null) {
				String ipQuery = "";
				String [] ips = Common.toArray(ipStr, ",");
				for (String ip : ips) {
					ipQuery += "\"" + ip.trim() + "\" ";
				}
				if (Common.isNotEmpty(ipQuery)) {
					addQuery("+sender_str:(" + ipQuery + ")");
				}
			}
		}

		addQuery("+direction:O"); // 발신 서비스 쿼리 추가 해야 함...
		return this;
	}

	public SolrCreateQuery setUserGroupSeq(String userGroupSeq, String userGroupSeq_not) {
		if(Common.isEmpty(userGroupSeq)) return this;
		userService = SpringContextUtil.getBean(UserService.class);
		List<UserGroupVO> users = userService.getUserGroupUserList(userGroupSeq);
		if (users.size() == 0) {
			addQuery("+srcip:notfound_userGroup");
			return this;
		}
		if(Common.isEquals(userGroupSeq_not, "Y")) addQuery(EXCEPT_QUERY+"(");
		else addQuery(AND_QUERY+"(");

		for (UserGroupVO user : users) {
			if (user == null) continue;
			String userId = user.getUserId();

			if (userId != null) addQuery("(userid:" + userId + ")");
		}
		addQuery(")");

		return this;
	}

	public SolrCreateQuery setWork(String work) {
		if (Common.isEmpty(work)) return this;
		if(work.equals("R")) work = work.concat(",H");
		return addQuery(String.format("%s%s:%s", AND_QUERY, WORK, createOrQuery(work)));
	}

	public SolrCreateQuery setDrmYn(String drmYn) {
		if (Common.isEmpty(drmYn)) return this;
		if( Common.isEquals(drmYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, DRM, "*"));
		else if( Common.isEquals(drmYn, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, DRM, "*"));
		else return this;
	}

	public SolrCreateQuery setSctYn(String sctYn) {
		if (Common.isEmpty(sctYn)) return this;
		if( Common.isEquals(sctYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, SCT, "*"));
		else if( Common.isEquals(sctYn, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, SCT, "*"));
		else return this;
	}


	public SolrCreateQuery setReProcessYn(String reprocessYn) {
		if (Common.isEmpty(reprocessYn)) return this;
		if (Common.isEquals(reprocessYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, REPROCESS, "1"));
		else if (Common.isEquals(reprocessYn, "N")) return addQuery(String.format("%s%s:%s", AND_QUERY, REPROCESS, "0"));
		else return this;
	}

	/**
	 * Knox 첨부 사용 여부 쿼리
	 * @param bodyImg
	 * @return
	 */
	public SolrCreateQuery setKnox(String bodyImg) {
		String queryStr ="";
		String name ="BODY";
		queryStr += "\"" +  name + "\"";
		if (Common.isEmpty(bodyImg)) return this;
		if( Common.isEquals(bodyImg, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, ATTACH_SPACE, queryStr));
		else if( Common.isEquals(bodyImg, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, ATTACH_SPACE, queryStr));
		else return this;
	}
	/**
	 * ocr 첨부 사용 여부 쿼리
	 * @param OCRYn
	 * @return
	 */
	public SolrCreateQuery setOcr(String OCRYn) {
		String queryStr = ">0";
		if (Common.isEmpty(OCRYn)) return this;
		if( Common.isEquals(OCRYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, OCR_ATTACH_CNT, queryStr));
		else if( Common.isEquals(OCRYn, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, OCR_ATTACH_CNT, queryStr));
		else return this;
	}
	/**
	 * 수신자 구분 쿼리
	 * @param allofus
	 * @returnㅎ
	 */
	public SolrCreateQuery setAllofus(String allofus) {
		if (Common.isEmpty(allofus)) return this;
		return addQuery(String.format("%s%s:(%s)", AND_QUERY, ALLOFUS, allofus.replaceAll("\\|", " ")));
	}

	/**
	 * 사이즈 쿼리
	 *
	 * @param minMsgsize
	 * @param maxMsgsize
	 * @param size_condition
	 * @return
	 */
	public SolrCreateQuery setMessageSize(String minMsgsize, String maxMsgsize, String size_condition) {
		return setMessageSize(minMsgsize, maxMsgsize, size_condition, "");
	}
	/**
	 * 사이즈 쿼리
	 *
	 * @param minMsgsize
	 * @param maxMsgsize
	 * @param size_condition
	 * @param sizeType
	 * @return
	 */
	public SolrCreateQuery setMessageSize(String minMsgsize, String maxMsgsize, String size_condition, String sizeType) {
		if (Common.isOrEquals(minMsgsize, "", "0") && Common.isOrEquals(size_condition, "", "L")) return this;
		if (Common.isOrEquals(minMsgsize, "", "0") && Common.isOrEquals(maxMsgsize, "", "0") && Common.isEquals(size_condition, "B")) return this;
		if (Common.isOrEquals(minMsgsize, "", "0") && Common.isEquals(size_condition, "S")) return this;

		String queryStr = "";
		if (size_condition.equals("B") || size_condition.equals("")) {
			queryStr = "[" + minMsgsize + " TO " + maxMsgsize + "]";
		} else if (size_condition.equals("L")) queryStr = "[" + minMsgsize + " TO * ]";
		else if (size_condition.equals("S")) queryStr = "[ * TO " + minMsgsize + "]";

		if(Common.isEquals(sizeType, "B")) return addQuery(String.format("%s%s:%s", AND_QUERY, BODY_SIZE, queryStr));
		else if(Common.isEquals(sizeType, "A")) return addQuery(String.format("%s%s:%s", AND_QUERY, ATTACH_SIZE, queryStr));
		else if(Common.isEquals(sizeType, "T")) return addQuery(String.format("%s%s:%s", AND_QUERY, ATTACH_MAX_SIZE, queryStr));
		else return addQuery(String.format("%s%s:%s", AND_QUERY, SIZE, queryStr));
	}

	/**
	 * 동의서 쿼리
	 */
	public SolrCreateQuery setConsent(String consentUserId) {
		if (Common.isEmpty(consentUserId)) return this;

		return addQuery(String.format("%s(%s:%s)", AND_QUERY, USER_ID, "\"" + consentUserId + "\""));
	}

	public SolrCreateQuery setDirection(String receiveSend) {
		if (Common.isEmpty(receiveSend)) return this;

		return addQuery(String.format("%s%s:%s", AND_QUERY, DIRECTION_SVC, receiveSend));
	}

	public SolrCreateQuery setSearchTime(String searchTime){
		if (Common.isEmpty(searchTime)) return this;

		return addQuery(String.format("%s%s:[* TO %s]", AND_QUERY, LTIME, searchTime));
	}

	public SolrCreateQuery setReadYn(String readYn, String adminId) {
		if (Common.isEmpty(readYn)) return this;
		String str = "";
		if (Common.isEquals(readYn, "Y")) str = String.format(JOIN_READ, adminId);
		else if (Common.isEquals(readYn, "N")) str = String.format(JOIN_UNREAD, adminId);
		return addQuery(str);
	}

	/*
	 * //예약 알람 키 호출 public SolrQuery createAlarmQuery( String alarmSeq ){
	 * //alarmSeq로 MySQL에서 데이터 불러옴 //createAlarmQuery( vo ) 호출 } //예약 알람 처리
	 * public SolrQuery createAlarmQuery( AdminAlarmVO vo){ }
	 */

	// 조건 필터 키 호출
	public SolrQuery createFilterQuery(String filterSeq) throws Exception {
		adminFilterService = SpringContextUtil.getBean(AdminFilterService.class);
		AdminFilterVO filter = adminFilterService.getAdminFilter(Common.nvn(filterSeq));
		return createFilterQuery(filter);
	}

	// 조건 필터 처리
	public SolrQuery createFilterQuery(AdminFilterVO vo) throws Exception {
		if( Common.isEquals(vo.getFilterType(), "Q")) {
			JSONArray conditions = new JSONArray();
			JSONObject condition = new JSONObject();
			condition.put("query", vo.getConditions());
			conditions.add(condition);
			return makeQuery(conditions, Common.nvl(vo.getAdminId())).setDateQuery(vo.getUserDtCd(), vo.getStartDt(), vo.getEndDt()).setQuery();
		}else {
			return makeQuery(Common.toJSONArray(vo.getConditions()), Common.nvl(vo.getAdminId())).setDateQuery(vo.getUserDtCd(), vo.getStartDt(), vo.getEndDt()).setQuery();
		}
	}

	// 조건 처리
	public SolrQuery createQuery(JSONObject param, String adminId) throws Exception {
		return createQuery(param, adminId, "");
	}

	// 조건 처리
	public SolrQuery  createQuery(JSONObject param, String adminId, String searchTime) throws Exception {
		//String filterName = Common.nvl(param.get("filterName")); // 필터명
		//String p_filter_seq = Common.nvl(param.get("p_filter_seq")); // 상위필터seq(필터저장위치)
		//String consentEmail = Common.nvl(param.get("consentEmail")); // 동의서 Id
		String consentUserId = Common.nvl(param.get("consentUserId")); // 동의서 Id
		//String folderSeq = Common.nvl(param.get("folderSeq")); // 폴더 seq
		//String folderName = Common.nvl(param.get("folderName")); // 폴더명

		String addSvcGroup = Common.nvl(param.get("addSvcGroup")); // 선택 서비스

		consentNo = Common.nvl(param.get("consentNo"));
		JSONArray conditions = Common.toJSONArray(param.get("conditions"));



		// JSONArray conditions = param.getJSONArray("conditions");
		return makeQuery(conditions, consentUserId, adminId, searchTime).setServiceGroup(addSvcGroup).setQuery();
	}

	// 조건 처리
	public SolrQuery createQuery(String query) throws Exception {
		return addQuery(query).setQuery();
	}

	public SolrCreateQuery makeQuery(JSONArray conditions, String consentUserId, String adminId, String searchTime) throws Exception {
		setConsent(consentUserId);
		return makeQuery(conditions, adminId, searchTime);
	}
	public SolrCreateQuery makeQuery(JSONArray conditions, String adminId) throws Exception {
		return makeQuery(conditions, adminId,"");
	}

	public SolrCreateQuery makeQuery(JSONArray conditions, String adminId, String searchTime) throws Exception {
		for (int i = 0; i < conditions.size(); i++) {
			JSONObject condition = conditions.getJSONObject(i);
			String sort = Common.nvl(condition.get("sort")); //정렬
			String period = Common.nvl(condition.get("period")); // 기간 옵션
			String startDt = Common.nvl(condition.get("startDt")); // 검색 시작일
			String endDt = Common.nvl(condition.get("endDt")); // 검색 종료일

			String startDateSelect = Common.nvl(condition.get("startDateSelect")); //
			int startTimeSelect = Common.nvz(condition.get("startTimeSelect")); //
			String endDateSelect = Common.nvl(condition.get("endDateSelect")); //
			int endTimeSelect = Common.nvz(condition.get("endTimeSelect")); //

			String searchStr = Common.nvl(condition.get("searchStr")); // 검색어
			String searchField = Common.nvl(condition.get("searchField")); // 검색어
			String senders = Common.nvl(condition.get("senders")); // 발신자
			String senders_not = Common.nvl(condition.get("senders_not")); //발신자 부정
			String senders_upperCase = Common.nvl(condition.get("senders_upperCase")); //발신자 대/소문자 구분

			String receive_option = Common.nvl(condition.get("receive_option")); //수신자 상세
			String receivers = Common.nvl(condition.get("receivers")); // 수신자
			String receivers_not = Common.nvl(condition.get("receivers_not")); //수진자 부정
			String receivers_upperCase = Common.nvl(condition.get("receivers_upperCase")); //수신자 대/소문자 구분 ( 수신자 세분화 - 전체 일때만 해당 )

			String m_to = Common.nvl(condition.get("m_to")); // 받는사람
			String m_to_not = Common.nvl(condition.get("m_to_not")); //받는사람 부정
			String m_cc = Common.nvl(condition.get("m_cc")); // 참조
			String m_cc_not = Common.nvl(condition.get("m_cc_not")); //참조 부정
			String m_bcc = Common.nvl(condition.get("m_bcc")); // 숨은참조
			String m_bcc_not = Common.nvl(condition.get("m_bcc_not")); //숨은참조 부정
			String rcvJikgub = Common.nvl(condition.get("rcvJikgub")); // 수신자 직급
			String recv_jikgub_not = Common.nvl(condition.get("recv_jikgub_not")); //사업장 부정

			if(Common.isNotEmpty(condition.get("rcvTo"))) {
				m_to = Common.nvl(condition.get("rcvTo"));
			}
			if(Common.isNotEmpty(condition.get("rcvCc"))) {
				m_cc = Common.nvl(condition.get("rcvCc"));
			}
			if(Common.isNotEmpty(condition.get("rcvBcc"))) {
				m_bcc = Common.nvl(condition.get("rcvBcc"));
			}
			if(Common.isNotEmpty(condition.get("rcvTo_not"))) {
				m_to_not = Common.nvl(condition.get("rcvTo_not"));
			}
			if(Common.isNotEmpty(condition.get("rcvCc_not"))) {
				m_cc_not = Common.nvl(condition.get("rcvCc_not"));
			}
			if(Common.isNotEmpty(condition.get("rcvBcc_not"))) {
				m_bcc_not = Common.nvl(condition.get("rcvBcc_not"));
			}

			String allOfus = Common.nvl(condition.get("allOfus")); // 수신자 중 외부인
			String busi = Common.nvl(condition.get("busi")); // 사업장
			String busi_not = Common.nvl(condition.get("busi_not")); //사업장 부정

			String dept = Common.nvl(condition.get("dept")).replaceAll("\\|", ","); // 부서
			String dept_not = Common.nvl(condition.get("dept_not")); //부서 부정

			String jikgub = Common.nvl(condition.get("jikgub")).replaceAll("\\|", ","); // 직급
			String jikgub_not = Common.nvl(condition.get("jikgub_not")); //직급 부정

			String url = Common.nvl(condition.get("url")).replaceAll("\n", " "); //url
			String url_not = Common.nvl(condition.get("url_not")); //url 부정


			String readYn = Common.nvl(condition.get("readYn")); // 읽음여부
			String receiveSend = Common.nvl(condition.get("receiveSend")); // 수/발신
			String serviceType = Common.nvl(condition.get("serviceType")); // 서비스타입
			String infoTypes = Common.nvl(condition.get("infoType")); // 정보 분류 타입
			String feedbacks = Common.nvl(condition.get("feedbackType")); // 피드백 타입
			String probs = Common.nvl(condition.get("probType")); // 판정확률 타입

			String skInfoTypes = Common.nvl(condition.get("skInfoType")); // SK 문서 분류 타입
			String skFeedbacks = Common.nvl(condition.get("skFeedbackType")); // SK 비밀 피드백 타입
			String skProbs = Common.nvl(condition.get("skProbType")); // SK 비밀확률 타입

			String bodyImg = Common.nvl(condition.get("bodyImg")); // Knox 본문 내 이미지
			String OCRYn = Common.nvl(condition.get("OCRYn"));  // OCR 여부

			String interGroup = Common.nvl(condition.get("interGroup")); // 관심 사용자 그룹
			String interGroup_not = Common.nvl(condition.get("interGroup_not")); //관심 사용자 그룹 부정

			String attachYn = Common.nvl(condition.get("attachYn")); // 첨부여부
			String attachVal = Common.nvl(condition.get("attachVal")); // 첨부 확장자
			String attachYn_not = Common.nvl(condition.get("attachYn_not")); //첨부 부정

			String body_snippet = Common.nvl(condition.get("body_snippet")); //바디

			//String attachStr = Common.nvl(condition.get("attachStr")); // 첨부 확장자
			String keywordYn = Common.nvl(condition.get("keywordYn")); // 키워드 여부
			//String keywordVal = Common.nvl(condition.get("keywordVal"));// 키워드
			String keywordStr = Common.nvl(condition.get("keywordStr"));// 키워드
			String keywordYn_not = Common.nvl(condition.get("keywordYn_not")); //예약어 부정

			String regexpYn = Common.nvl(condition.get("regexpYn")); // 패턴 검출 여부
			String regexpVal = Common.nvl(condition.get("regexpVal")); // 패턴
			//String regexpStr = Common.nvl(condition.get("regexpStr")); // 패턴
			String sizeStartVal = Common.nvl(condition.get("sizeStartVal")); // 메시지시작크기
			String sizeEndVal = Common.nvl(condition.get("sizeEndVal")); // 메시지종료크기
			String sizeOption = Common.nvl(condition.get("sizeOption")); // 메시지조건옵션(B:범위,L:이상,S:이하)
			String sizeType = Common.nvl(condition.get("sizeType")); // 메시지조건타입('':전체,B:본문,A:첨부)
			String ctimeWork = Common.nvl(condition.get("ctimeWork")); // 메시지조건옵션(B:범위,L:이상,S:이하)
			String userGroupSeq = Common.nvl(condition.get("userGroupSeq")); // 사용자 그룹 조건
			String userGroupSeq_not = Common.nvl(condition.get("userGroupSeq_not")); //사용자 그룹 부정

			String drmYn = Common.nvl(condition.get("drmYn")); // drm 검출 여부
			String realAttYn = Common.nvl(condition.get("realAttYn")); // drm 검출 여부
			String sctYn = Common.nvl(condition.get("sctYn")); // sct 여부
			String reprocessYn = Common.nvl(condition.get("reprocessYn")); // 재처리 여부
			String query = Common.nvl(condition.get("query")); //고급 쿼리 검색(데이터 있는경우 우선 적용)


			String svc1 = Common.nvl(condition.get("svc1")); //서비스 그룹
			String svc1_not = Common.nvl(condition.get("svc1_not")); //서비스 제외 그룹

			String epmsg_type =Common.nvl(condition.get("epmsgType")); //대외비

			String regexPattern = Common.nvl(condition.get("regexPattern")); //정규패턴식 검색

			if( Common.isNotEmpty(query)) {
				finalReadYn = "";
				setSearchField(searchField);
				setSort(sort);
				addQuery(query);
				setSvc1(svc1, svc1_not);
				return this;
			}
			if (i == conditions.size() - 1) {
				// 기간 쿼리는 마지막에 한번만 생성함
				if(Common.isNotEmpty(startDateSelect)) {
					addDateQuery(startDateSelect, startTimeSelect, endDateSelect, endTimeSelect);
				}else {
					addDateQuery(period, startDt, endDt);
				}
				setSort(sort);
			}
			setSearchStr(searchStr, searchField);

			setSearchField(searchField); // default 검색 영역
			setSelectSearchFields(searchField); //선택한 검색 영역

			setService(serviceType);
			setInfoType(infoTypes);
			setFeedback(feedbacks);
			setProb(probs);
			setSkInfoType(skInfoTypes);
			setSkFeedback(skFeedbacks);
			setSkProb(skProbs);
			setDirection(receiveSend);
			setBusicd(busi, busi_not);
			setDeptcd(dept, dept_not);
			setJikgub(jikgub, jikgub_not);
			setEpmsgType(epmsg_type);
			setSender(senders, senders_not, senders_upperCase);
			setReciver(receive_option, receivers, receivers_not, receivers_upperCase, m_to, m_to_not, m_cc, m_cc_not, m_bcc, m_bcc_not);
			setRcvJikgub(rcvJikgub,recv_jikgub_not);
			setUrl(url, url_not);
			setAttach(attachYn, attachVal, attachYn_not, realAttYn, drmYn);
			setKwd(keywordYn, keywordStr, keywordYn_not);
			setPi(regexpYn, regexpVal);
			setWork(ctimeWork);
			setAllofus(allOfus);
			setMessageSize(sizeStartVal, sizeEndVal, sizeOption, sizeType);
			setUserGroupSeq(userGroupSeq, userGroupSeq_not);
			setInterestUserGroup(interGroup, interGroup_not);
			setSvc1(svc1, svc1_not);
			setKnox(bodyImg);
			setOcr(OCRYn);
			//setDrmYn(drmYn);
			setReProcessYn(reprocessYn);
			setSctYn(sctYn);
			setRegexPattern(regexPattern);

			finalReadYn = readYn;
		}

		if( Common.isNotEmpty(searchTime)){
			setSearchTime(searchTime);
		}
		return this;
	}




	public String getStartDt(String startDateSelect, int startTimeSelect) {
		String result = "";
		DateTime startDt = new DateTime(DateTimeZone.forID("Asia/Seoul"));
		if (startDateSelect.equals("Y")) result = String.format("%s%02d0000", yyyyMMdd.print(startDt.minusDays(1)), startTimeSelect);
		else if (startDateSelect.equals("T")) result = String.format("%s%02d0000", yyyyMMdd.print(DateTime.now()), startTimeSelect);
		else if (startDateSelect.equals("W")) result = String.format("%s%02d0000", yyyyMMdd.print(startDt.minusDays(7)), startTimeSelect);
		else if (startDateSelect.equals("M")) result = String.format("%s%02d0000", yyyyMMdd.print(startDt.minusMonths(1)), startTimeSelect);
		return result;
	}

	private String getEndDt(String endDateSelect, int endTimeSelect) {
		String result = "";
		DateTime endDt = new DateTime(DateTimeZone.forID("Asia/Seoul"));
		if (endDateSelect.equals("Y")) result = String.format("%s%02d5959", yyyyMMdd.print(endDt.minusDays(1)), endTimeSelect);
		else if (endDateSelect.equals("T")) result = String.format("%s%02d5959", yyyyMMdd.print(DateTime.now()), endTimeSelect);
		else if (endDateSelect.equals("W")) result = String.format("%s%02d5959", yyyyMMdd.print(endDt.minusDays(7)), endTimeSelect);
		else if (endDateSelect.equals("M")) result = String.format("%s%02d0000", yyyyMMdd.print(endDt.minusMonths(1)), endTimeSelect);

		return result;
	}

	private String getSearchQuery(String query) {
		if( query.startsWith("|")) query = query.substring(1);

		query = specialCharsValid(query);
		query = getTempQuery(query);
		// 특수문자 처리
		query = specialCharsCheck(query);
		StringBuilder sb = new StringBuilder();
		if (!query.contains("|") && !query.contains("+") && !query.contains("-") & !query.contains(" ")) {
			StringBuilder queryStr = new StringBuilder();
			String[] terms = query.split(" ");
			for (String term : terms) {
			     /*특수문자 처리*/
				term = ("\"").concat(term).concat("\"");
				queryStr.append(appendSpecialchar(term)).append(" ");
			}
			sb.append(queryStr.toString().trim().replaceAll(" ", " ").replaceAll("__", " "));
		} else {
			StringBuilder querySb = new StringBuilder();
			String[] terms = query.split(" ");
			for (int i = 0; i < terms.length; i++) {

				if (terms[i].equals("|")) {
					terms[i] = OR_PREFIX;
				}else if (i > 0 && terms[i - 1].equals(OR_PREFIX) || terms[i].startsWith("+") || terms[i].startsWith("-")) {
				}else if (i < terms.length - 1 && !terms[i + 1].equals("|")) {
					terms[i] = ("\"").concat(terms[i]).concat("\"");
				}else if (!terms[i].startsWith("+") && !terms[i].startsWith("-")) {
					terms[i] = ("\"").concat(terms[i]).concat("\"");
				}

				querySb.append(appendSpecialchar(terms[i])).append(" ");
			}
			sb.append(querySb.toString().trim().replaceAll(" ", " ").replaceAll("__", " "));
		}

		String result = sb.toString().replace(OR_PREFIX, " ").replace("__", " ").replace("  ", " ").trim();

		// 연산자 처리
		result = inequalitySignProc(result);
		return result;
	}


	public String specialCharsValid(String str){
		String result = str;
		if(result.indexOf("/") > -1) {
			if(result.indexOf("/") == result.lastIndexOf("/")) result =  result.replace(result, ("\"").concat(result).concat( "\""));
		}
		result = result.replaceAll("([+])\\1+","+").replaceAll("([|])\\1+","|").replaceAll("(-)\\1+","-"); // 연속2개입력시

		return result;
	}

	public String specialCharsCheck(String str){
		String result = str;
		/* 특수문자 처리 */
		result  =  result.replaceAll("[[\\\\]=/&:><!^~/[\"]\\{\\}]", "\\\\"+"$0");
		return result;
	}


	public String inequalitySignProc(String str) {
		String result = str;
		StringBuilder tempSb = new StringBuilder();
		tempSb.append(result);

		int idx = 0;
		char[] chars =  result.toCharArray();
		for(char c : chars) {
			if( Arrays.stream(INEQUALITY_SIGN).filter(s -> s.equals(String.valueOf(c))).count() > 0) {
				if(idx+1 == chars.length) {
					tempSb.setCharAt(idx,' ');
				}else {
					String cstr = String.valueOf(chars[idx+1]);
					if(String.valueOf(chars[idx+1]).equals(" ") ||  Arrays.stream(INEQUALITY_SIGN).filter(s -> s.equals(String.valueOf(cstr))).count() > 0) {
						tempSb.setCharAt(idx,' ');
					}
				}
			}
			idx++;
		}

		return tempSb.toString();
	}

	/**
	 * 공백 구분 임시 쿼리 생성
	 *
	 * @param query
	 * @return
	 */
	private String getTempQuery(String query) {
		StringBuilder result = new StringBuilder();
		StringBuilder tmp = new StringBuilder();
		for (int i = 0; i < query.length(); i++) {
			char q = query.charAt(i);
			if (q == '|') {
				if (!Character.isWhitespace(query.charAt(i - 1))) {
					tmp.append(" ");
				}
				tmp.append(q).append(" ");
			} else {
				tmp.append(q);
			}
		}
		query = tmp.toString();
		query = query.replaceAll("( )+", " ");
		String[] terms = query.split(" ");
		for (int i = 0; i < terms.length; i++) {
			String t = terms[i].trim();
			result.append(" ").append(t);
			if (t.indexOf("\"") > -1 && !t.endsWith("\"")) {
				for (int j = i + 1; j < terms.length; j++) {
					String tx = terms[j].trim();
					result.append("__").append(terms[j].trim());
					i++;
					if (tx.endsWith("\"")) break;
				}
			}
		}
		return result.toString().trim();
	}

	private String appendSpecialchar(String str) {
		if (Common.isEmpty(str.trim())) return str;
		else if (str.endsWith(SPECIAL_CHAR)) return str;
		else if (str.endsWith(OR_PREFIX)) return str;
		else if (str.endsWith("\"")) return str;
		else {
//			for (String item : SPECIALCHARS) {
//				if (str.contains(item)) {
//					str = str.replaceAll(item, "");
//				}
//			}
			return str;
		}
	}

	private String createOrQueryAsterisk(String params) {

		return createOrQuery(params, " ", "*");
	}

	private String createOrQueryAsteriskAll(String params) {

		return createOrQueryReceiver(params, " ", "*");
	}

	private String createOrQuery(String params) {

		return createOrQuery(params, ",", "");
	}

	private String createOrQuery(String params, String separator) {
		return createOrQuery(params, separator, "");
	}

	private String createOrQuery(String params, String separator, String addString) {
		String[] param = Common.toArray(params, separator);

		StringBuilder result = new StringBuilder();
		result.append("(");
		for (int i = 0; i < param.length; i++) {
			result.append(makeParentheses(param[i])).append(addString);
			if (i != param.length - 1) result.append(SPACE);
		}
		result.append(")");

		return result.toString();
	}

	private String createOrQueryReceiver(String params, String separator, String addString) {
		String[] param = Common.toArray(params, separator);

		StringBuilder result = new StringBuilder();
		result.append("(");
		for (int i = 0; i < param.length; i++) {
			result.append(addString).append(param[i]).append(addString);
			if (i != param.length - 1) result.append(SPACE);
		}
		result.append(")");

		return result.toString();
	}

	private String createOrQueryInfoFeedback(String params) {
		String[] param = Common.toArray(params, ",");

		StringBuilder result = new StringBuilder();
		result.append("(");
		for (int i = 0; i < param.length; i++) {
			if( param[i].equals("1234") ) {
				for (int j = 0; j < param[i].length(); j++) {
					result.append("\"").append(param[i].substring(j, j+1)).append("\"").append(SPACE);
				}
			} else {
				result.append("\"").append(param[i]).append("\"");
				if (i != param.length - 1) result.append(SPACE);
			}
		}
		result.append(")");

		return result.toString();
	}

	private String createOrQueryProb(String params) {
		String[] param = Common.toArray(params, ",");
		StringBuilder result = new StringBuilder();
		for (String str : param) {
			String[] sp = str.split("\\|");
			result.append(String.format("%s:[%s TO %s}", PROB, sp[0], sp[1])).append(SPACE);
		}
		return result.toString();
	}

	private String createOrQuerySkProb(String params) {
		String[] param = Common.toArray(params, ",");
		StringBuilder result = new StringBuilder();
		for (String str : param) {
			String[] sp = str.split("\\|");
			result.append(String.format("%s:[%s TO %s}", PROB, sp[0], sp[1])).append(SPACE);
		}
		return result.toString();
	}

	public static void main(String[] args) {
		int s = 5;
		if( ( s>=0  && s<=5) && s!=5) {
			System.out.println("5");
		}
	}

	private String createOrQueryAppend(String params, String appendString) {
		String[] param = Common.toArray(params, ",");

		StringBuilder result = new StringBuilder();
		result.append("(");
		for (int i = 0; i < param.length; i++) {
			result.append(param[i]).append(appendString);
			if (i != param.length - 1) result.append(SPACE);
		}
		result.append(")");

		return result.toString();
	}
}
