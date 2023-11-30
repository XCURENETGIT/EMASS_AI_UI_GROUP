package com.xcurenet.common.util.elasticsearch;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.adminFilter.service.AdminFilterService;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import com.xcurenet.interestUser.service.AdminUserGroupVO;
import com.xcurenet.user.service.UserService;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.lucene.search.join.ScoreMode;
import org.elasticsearch.core.TimeValue;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.histogram.DateHistogramInterval;
import org.elasticsearch.search.aggregations.metrics.TopHitsAggregationBuilder;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.sort.SortBuilder;
import org.elasticsearch.search.sort.SortBuilders;
import org.elasticsearch.search.sort.SortOrder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;


@Slf4j
@Data
@Configuration
/* 엘라스틱 서치에 사용할 쿼리 유틸  */
public class ElasticSearchQueryUtils {

	/* timeout value*/

	@Value("${els.timeout}")
	private int timeout;

	@Resource
	private AdminService adminService;
	@Resource
	private AdminUserGroupService adminUserGroupService;
	@Resource
	private AuthorityService authorityService;
	@Resource
	private UserService userService;
	@Resource
	private AdminFilterService adminFilterService;

	public ElasticSearchParam elasticSearchParam;

	public String query;
	public StringBuilder queryBuffer;
	public List<SortBuilder<?>> sortInfo;

	private List<Map<String, Object>> authQueryCompanyRelated;
	private List<Map<String, Object>> authQueryEtcRelated;
	private boolean ceoSearch;



	public ElasticSearchQueryUtils() {
		query = "";
		queryBuffer = new StringBuilder();
	}


	public void setQuery() {
		this.query = queryBuffer.toString().trim();
		queryBuffer = new StringBuilder();
	}

	public void setAppendQuery() {
		this.query = query + queryBuffer.toString().trim();
		queryBuffer = new StringBuilder();
	}

	public String getQuery() {
		return query;
	}

	private ElasticSearchQueryUtils addQuery(String query) {
		this.queryBuffer.append(ElasticSearchCommon.OPEN_PARENTHESES)
				.append(query)
				.append(ElasticSearchCommon.CLOSE_PARENTHESES);
		return this;
	}


	public void setSort(String sort){
		sortInfo = new ArrayList<>();
		if( Common.isEmpty(sort)){ // default
			sortInfo.add(SortBuilders.fieldSort("ctime").order(SortOrder.DESC));
//                                 sortInfo.add(SortBuilders.fieldSort("msgid").order(SortOrder.DESC));
		}

//        String [] sorts = sort.split(" ");
//        if( sorts.length > 1 || !Common.isEmpty(sorts[1])) {
//            if (Common.isEquals(sorts[1], "desc")) {
//                sortInfo.add(SortBuilders.fieldSort(sorts[0]).order(SortOrder.DESC));
//                sortInfo.add(SortBuilders.fieldSort("msgid").order(SortOrder.DESC));
//            } else {
//                sortInfo.add(SortBuilders.fieldSort(sorts[0]).order(SortOrder.ASC));
//                sortInfo.add(SortBuilders.fieldSort("msgid").order(SortOrder.ASC));
//            }
//        }

	}


	/**
	 //     * 서비스 타입 쿼리
	 //     *
	 //     * @param serviceTypes
	 //     * @return
	 //     */

	public void setDetailQuery(String str) {
		queryBuffer.append(ElasticSearchCommon.SPACE).append(str);
	}

	/***
	 * 검색
	 * @param searchStr
	 * @return
	 */
	public ElasticSearchQueryUtils setSearchQuery(String searchStr) {
		if (Common.isEmpty(searchStr)) return this;

		if(searchStr.indexOf(ElasticSearchCommon.COMMA) > -1){
			searchStr = searchStr.replace(",",ElasticSearchCommon.OR_QUERY);
		}

		return addQuery(String.format("%s",searchStr));
	}

	/***
	 *
	 * yAxis 검색 필드
	 * @param query
	 * @return
	 */

	public void setyField(String field) {
		field = field.concat(ElasticSearchCommon.COLON);
		this.queryBuffer.insert(0,field);
	}


	/***
	 *
	 * 메시징 검색 필드
	 */
	public void setSearchField(String[] fields,String searchQuery){
		int idx = 0;
		for(String field : fields){
			this.queryBuffer
					.append(field)
					.append(ElasticSearchCommon.COLON)
					.append(searchQuery);
			if(idx < fields.length-1) {
				this.queryBuffer.append(ElasticSearchCommon.OR_QUERY);
			}
			idx++;
		}
		makeParentheses();
	}


	/***
	 *
	 * 쿼리 그룹 짓기 (검색영역,서비스 쿼리 등등..)
	 */
	public void addQueryGroup(String flag,String Type,String typeValues){
		StringBuilder tempBuilder = new StringBuilder();
		tempBuilder.append(Type)
				.append(ElasticSearchCommon.COLON)
				.append(typeValues);
		tempBuilder = makeParentheses(tempBuilder);
		tempBuilder.insert(0,ElasticSearchCommon.SPACE.concat(flag));
		this.queryBuffer.append(tempBuilder);
	}


	/***
	 *
	 * 쿼리 그룹 짓기 (검색영역,서비스 쿼리 등등..)
	 */
	public void addQueryGroup(String flag,String[] Types,String typeValues){
		int idx = 0;
		StringBuilder tempBuilder = new StringBuilder();
		for(String type : Types) {
			if(idx >= 1) tempBuilder.append(ElasticSearchCommon.OR_QUERY);
			tempBuilder.append(type)
					.append(ElasticSearchCommon.COLON)
					.append(typeValues);
			idx++;
		}
		tempBuilder = makeParentheses(tempBuilder);
		tempBuilder.insert(0,ElasticSearchCommon.SPACE.concat(flag));
		this.queryBuffer.append(tempBuilder);
	}

	/***
	 *  argments에 괄호 감싸기
	 * @param argments
	 * @return
	 */
	private String makeParentheses(String[] argments) {
		StringBuilder tempSb = new StringBuilder();
		int idx = 0;
		for(String arg : argments){
			tempSb.append(ElasticSearchCommon.OPEN_PARENTHESES);
			tempSb.append(arg);
			tempSb.append(ElasticSearchCommon.CLOSE_PARENTHESES);
			if(idx < argments.length-1) {
				tempSb.append(ElasticSearchCommon.OR_QUERY);
			}
			idx++;
		}
		return tempSb.toString();
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


	/***
	 *  현재 queryBuffer 에 괄호를 만든다.
	 */
	private void makeParentheses() {
		this.queryBuffer.insert(0,ElasticSearchCommon.OPEN_PARENTHESES);
		this.queryBuffer.insert(queryBuffer.length()-1,ElasticSearchCommon.CLOSE_PARENTHESES);
	}

	/***
	 *  현재 StringBuilder 에 괄호를 만든다.
	 */
	private StringBuilder makeParentheses(StringBuilder stringBuilder) {
		stringBuilder.insert(0,ElasticSearchCommon.OPEN_PARENTHESES);
		stringBuilder.insert(stringBuilder.length()-1,ElasticSearchCommon.CLOSE_PARENTHESES);
		return stringBuilder;
	}

	/***
	 *  특수문자 filter 하여 replace
	 */

	private Map<String,Object> parameterFilter(Map<String,Object> param) {
		Map<String,Object> filterMap = param;
		filterMap.entrySet().stream().forEach((k) -> {
			k.setValue(k.getValue().toString().replaceAll("/", "\\\\/"));
		});
		return filterMap;
	}


//    /**
//     * 서비스 그룹 쿼리
//     *
//     * @param serviceGroups
//     * @return
//     */
//    public SolrCreateQuery setServiceGroup(String serviceGroups) {
//        if (Common.isEmpty(serviceGroups)) return this;
//        if(serviceGroups.length() == 1 ) return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_GROUP, createOrQuery(serviceGroups)));
//        else if(serviceGroups.length() == 3 ) return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_12, createOrQuery(serviceGroups)));
//        else return this;
//    }
//
//    /**
//     * 서비스 타입 쿼리
//     *
//     * @param serviceTypes
//     * @return
//     */
//    public SolrCreateQuery setServiceType(String serviceTypes) {
//        if (Common.isEmpty(serviceTypes)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_TYPE, createOrQuery(serviceTypes)));
//    }
//
//    /**
//     * 서비스 쿼리( 서비스 타입 3자리로 넘어오는 경우 )
//     *
//     * @param services
//     * @return
//     */
//    public SolrCreateQuery setService(String services) {
//        if (Common.isEmpty(services)) return this;
//        String[] param = Common.toArray(services, ",");
//        String service3 = "";
//        String service4 = "";
//        StringBuffer serviceQueryStr = new StringBuffer();
//
//        for(int i=0; i < param.length; i++) {
//            if(param.length > 0 && param[i].length() == 3) {
//                service3 += param[i] + ",";
//            }else {
//                service4 += param[i] + ",";
//            }
//        }
//
//        if(Common.isEmpty(service3) && Common.isEmpty(service4)) return this;
//
//        if(Common.isNotEmpty(service4) && service4.contains("EMMAX")) {
//            serviceQueryStr.append(String.format("%s%s:(EMMA*) ",EXCEPT_QUERY, SERVICE));
//            service4 = service4.replaceAll("EMMAX", "");
//            if(Common.isEquals(service4,",")) {
//                service4 = "";
//            }
//        }
//
//        if(Common.isNotEmpty(service3)) {
//            if(Common.isNotEmpty(service4)) {
//                serviceQueryStr.append(String.format("%s(",AND_QUERY));
//                serviceQueryStr.append(String.format("%s%s:%s", SPACE, SERVICE_12, createOrQuery(service3.substring(0, service3.lastIndexOf(',')))));
//                serviceQueryStr.append(String.format(" %s%s:%s", SPACE, SERVICE, createOrQueryAppend(service4.substring(0, service4.lastIndexOf(',')), SPECIAL_CHAR)));
//                serviceQueryStr.append(String.format(")" ));
//
//            } else {
//                serviceQueryStr.append(String.format("%s%s:%s", AND_QUERY, SERVICE_12, createOrQuery(service3.substring(0, service3.lastIndexOf(',')))));
//            }
//        } else if(Common.isNotEmpty(service4)) {
//            serviceQueryStr.append(String.format(" %s%s:%s", AND_QUERY, SERVICE, createOrQueryAppend(service4.substring(0, service4.lastIndexOf(',')), SPECIAL_CHAR)));
//        }
//
//        return addQuery(serviceQueryStr.toString());
//    }
//
//    /**
//     * 서비스 쿼리( 서비스 타입 3자리로 넘어오는 경우 )
//     *
//     * @param services
//     * @return
//     */
//    public SolrCreateQuery setService12(String services) {
//        if (Common.isEmpty(services)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, SERVICE_12, createOrQuery(services)));
//    }
//
//    /**
//     * 정보 분류 쿼리
//     *
//     * @param infoTypes
//     * @return
//     */
//    public SolrCreateQuery setInfoType(String infoTypes) {
//        if (Common.isEmpty(infoTypes)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, INFOTYPE, createOrQueryInfoFeedback(infoTypes)));
//    }
//
//    /**
//     * 피드백 쿼리
//     *
//     * @param feedbacks
//     * @return
//     */
//    public SolrCreateQuery setFeedback(String feedbacks) {
//        if (Common.isEmpty(feedbacks)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, FEEDBACK, createOrQueryInfoFeedback(feedbacks)));
//    }
//
//    /**
//     * 판정 확률 쿼리
//     *
//     * @param probs
//     * @return
//     */
//    public SolrCreateQuery setProb(String probs) {
//        if (Common.isEmpty(probs)) return this;
//        return addQuery(String.format("%s(%s)", AND_QUERY, createOrQueryProb(probs)));
//    }
//
//    /**
//     * sk 문서 분류 쿼리
//     *
//     * @param infoTypes
//     * @return
//     */
//    public SolrCreateQuery setSkInfoType(String skInfoTypes) {
//        if (Common.isEmpty(skInfoTypes)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, SKINFOTYPE, createOrQueryInfoFeedback(skInfoTypes)));
//    }
//
//    /**
//     * sk 피드백 쿼리
//     *
//     * @param feedbacks
//     * @return
//     */
//    public SolrCreateQuery setSkFeedback(String skFeedbacks) {
//        if (Common.isEmpty(skFeedbacks)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, SKFEEDBACK, createOrQueryInfoFeedback(skFeedbacks)));
//    }
//
//    /**
//     * sk 비밀 확률 쿼리
//     *
//     * @param probs
//     * @return
//     */
//    public SolrCreateQuery setSkProb(String skProbs) {
//        if (Common.isEmpty(skProbs)) return this;
//        return addQuery(String.format("%s(%s)", AND_QUERY, createOrQuerySkProb(skProbs)));
//    }
//
//    /**
//
//     /**
//     * 사업장 쿼리
//     *
//     * @param busicds
//     * @return
//     */
//    public SolrCreateQuery setBusicd(String busicds, String busi_not) {
//        if (Common.isEmpty(busicds)) return this;
//        String queryType = Config.getString("query.type", "A"); // 인사정보기준 + IP 기준 사업장 정보
//        StringBuffer query = new StringBuffer();
//        String [] busicd = Common.toArray(busicds, ",");
//        String busicd_strs = "";
//
//        if( Common.isEquals(queryType, "B")) { //인사정보 기준 사업장 정보
//            for (int i = 0; i < busicd.length; i++) {
//                if(Common.isEquals(busicd[i], "C00-00")){
//                    query.append(String.format("(%s%s:%s) ", AND_QUERY, BUSICD, busicd[i]));
//                }else{
//                    busicd_strs += busicd[i]+SPACE;
//                }
//            }
//            if(Common.isNotEmpty(busicd_strs)) query.append(String.format("%s:(%s) ", BUSICD, busicd_strs));
//
//        } else if( Common.isEquals(queryType, "C")) { // IP 기준 사업장 정보
//            for (int i = 0; i < busicd.length; i++) {
//                if(Common.isEquals(busicd[i], "C00-00")){
//                    query.append(String.format("(%s%s:%s) ", AND_QUERY, IP_BUSICD, busicd[i]));
//                }else{
//                    busicd_strs += busicd[i]+SPACE;
//                }
//            }
//            if(Common.isNotEmpty(busicd_strs)) query.append(String.format("%s:(%s) ", IP_BUSICD, busicd_strs));
//
//        } else { // queryType = A 또는 그외 기본값
//            for (int i = 0; i < busicd.length; i++) {
//                if(Common.isEquals(busicd[i], "C00-00")){
//                    query.append(String.format("(%s%s:%s %s%s:%s) ", AND_QUERY, BUSICD, busicd[i], AND_QUERY, IP_BUSICD, busicd[i]));
//                }else{
//                    busicd_strs += busicd[i]+SPACE;
//                }
//            }
//
//            if(Common.isNotEmpty(busicd_strs)) query.append(String.format("%s:(%s) %s:(%s) ", BUSICD, busicd_strs, IP_BUSICD, busicd_strs));
//        }
//        if(Common.isEquals(busi_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, query.toString()));
//        else return addQuery(String.format("%s(%s)", AND_QUERY, query.toString()));
//    }
//
//    /**
//     * 부서 쿼리
//     *
//     * @param deptcds
//     * @return
//     */
//    public SolrCreateQuery setDeptcd(String deptcds, String dept_not) {
//        if (Common.isEmpty(deptcds)) return this;
//
//        StringBuffer query = new StringBuffer();
//        String [] deptCd = Common.toArray(deptcds, ",");
//        String deptCd_strs = "";
//
//        for (int i = 0; i < deptCd.length; i++) {
//            if(Common.isEquals(deptCd[i], "C00-00")){
//                query.append(String.format("(%s%s:%s %s%s:%s) ", AND_QUERY, DEPTCD, deptCd[i], AND_QUERY, IP_DEPTCD, deptCd[i]));
//            }else{
//                deptCd_strs += deptCd[i]+SPACE;
//            }
//        }
//
//        if(Common.isNotEmpty(deptCd_strs)) query.append(String.format("%s:(%s) %s:(%s) ", DEPTCD, deptCd_strs, IP_DEPTCD, deptCd_strs));
//
//        if(Common.isEquals(dept_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, query.toString()));
//        else return addQuery(String.format("%s(%s)", AND_QUERY,query.toString()));
//    }
//    /**
//     * 대외비 쿼리
//     *
//     * @param epmsg_type
//     * @return
//     */
//    public SolrCreateQuery setEpmsgType(String epmsg_type) {
//        if (Common.isEmpty(epmsg_type)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, EPMSG_TYPE, createOrQuery(epmsg_type,",")));
//
//    }
//
//    /**
//     * 발신자 쿼리
//     *
//     * @param sender
//     * @return
//     */
//    public SolrCreateQuery setSender(String sender, String senders_not, String senders_upperCase) {
//        if (Common.isEmpty(sender)) return this;
//
//        StringBuffer queryStr = new StringBuffer();
//
//        if(Common.isEquals(senders_upperCase, "Y")) {
//            queryStr.append(String.format("%s%s:%s", AND_QUERY, SENDER_UPPER, createOrQueryAsteriskAll(sender))).append(SPACE);
//        } else if(Common.isEquals(Config.getString("receiver.sender.uppercase"), "Y")) {
//
//            for (int i = 0; i < SENDER_NOTUPPER.length; i++) {
//                if (sender.startsWith("\"") && sender.endsWith("\"")) queryStr.append(String.format("%s:%s", SENDER_NOTUPPER[i], sender)).append(SPACE);
//                else queryStr.append(String.format("%s:%s", SENDER_NOTUPPER[i], createOrQueryAsteriskAll(sender))).append(SPACE);
//            }
//        } else {
//            for (int i = 0; i < SENDER.length; i++) {
//                if (sender.startsWith("\"") && sender.endsWith("\"")) queryStr.append(String.format("%s:%s", SENDER[i], sender)).append(SPACE);
//                else queryStr.append(String.format("%s:%s", SENDER[i], createOrQueryAsteriskAll(sender))).append(SPACE);
//            }
//        }
//
//
//
//        if(Common.isEquals(senders_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, queryStr.toString()));
//        else return addQuery(String.format("%s(%s)", AND_QUERY, queryStr.toString()));
//    }
//
//    /**
//     * 수신자 쿼리
//     *
//     * @param sender
//     * @return
//     */
//    // 수/발신 쿼리 내용 추가 해야함
//    public SolrCreateQuery setReciver(String receive_option, String receivers, String receivers_not, String receivers_upperCase, String m_to, String m_to_not, String m_cc, String m_cc_not, String m_bcc, String m_bcc_not) {
//        if (Common.isEmpty(receive_option) && Common.isEmpty(receivers)) return this;
//        if (Common.isEquals(receive_option, "detail") && Common.isEmpty(m_to) && Common.isEmpty(m_cc) && Common.isEmpty(m_bcc)) return this;
//
//
//        if (Common.isEmpty(receive_option)) {
//            StringBuffer queryStr = new StringBuffer();
//
//            if(Common.isEquals(receivers_upperCase, "Y")) {
//                queryStr.append(String.format("%s%s:%s", AND_QUERY, RECEIVER_UPPER, createOrQueryAsteriskAll(receivers))).append(SPACE);
//            } else if(Common.isEquals(Config.getString("receiver.sender.uppercase"), "Y")) {
//
//                for (int i = 0; i < RECEIVER_NOTUPPER.length; i++) {
//                    if (receivers.startsWith("\"") && receivers.endsWith("\"")) queryStr.append(String.format("%s:%s", RECEIVER_NOTUPPER[i], receivers)).append(SPACE);
//                    else queryStr.append(String.format("%s:%s", RECEIVER_NOTUPPER[i], createOrQueryAsteriskAll(receivers))).append(SPACE);
//                }
//            } else {
//                for (int i = 0; i < RECEIVER.length; i++) {
//                    if (receivers.startsWith("\"") && receivers.endsWith("\"")) queryStr.append(String.format("%s:%s", RECEIVER[i], receivers)).append(SPACE);
//                    else queryStr.append(String.format("%s:%s", RECEIVER[i], createOrQueryAsteriskAll(receivers))).append(SPACE);
//                }
//            }
//
//            if (Common.isEquals(receivers_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, queryStr.toString()));
//            else return addQuery(String.format("%s(%s)", AND_QUERY, queryStr.toString()));
//        } else {
//            StringBuffer queryStr = new StringBuffer();
//
//            if(Common.isNotEmpty(m_to)) {
//                StringBuffer toStr = new StringBuffer();
//                if (m_to.startsWith("\"") && m_to.endsWith("\"")) toStr.append(String.format("%s:%s %s:%s", TO, m_to, TNAME, m_to)).append(SPACE);
//                else toStr.append(String.format("%s:%s %s:%s", TO, createOrQueryAsteriskAll(m_to), TNAME, createOrQueryAsteriskAll(m_to))).append(SPACE);
//                if (Common.isEquals(m_to_not, "Y")) queryStr.append(String.format("%s(%s) ", EXCEPT_QUERY, toStr.toString()));
//                else queryStr.append(String.format("%s(%s) ", AND_QUERY, toStr.toString()));
//            }
//
//            if(Common.isNotEmpty(m_cc)) {
//                StringBuffer ccStr = new StringBuffer();
//                if (m_cc.startsWith("\"") && m_cc.endsWith("\"")) ccStr.append(String.format("%s:%s %s:%s", CC, m_cc, CNAME, m_cc)).append(SPACE);
//                else ccStr.append(String.format("%s:%s %s:%s", CC, createOrQueryAsteriskAll(m_cc), CNAME, createOrQueryAsteriskAll(m_cc))).append(SPACE);
//                if (Common.isEquals(m_cc_not, "Y")) queryStr.append(String.format("%s(%s) ", EXCEPT_QUERY, ccStr.toString()));
//                else queryStr.append(String.format("%s(%s) ", AND_QUERY, ccStr.toString()));
//            }
//
//            if(Common.isNotEmpty(m_bcc)) {
//                StringBuffer bccStr = new StringBuffer();
//                if (m_bcc.startsWith("\"") && m_bcc.endsWith("\"")) bccStr.append(String.format("%s:%s %s:%s", BCC, m_bcc, BNAME, m_bcc)).append(SPACE);
//                else bccStr.append(String.format("%s:%s %s:%s", BCC, createOrQueryAsteriskAll(m_bcc), BNAME, createOrQueryAsteriskAll(m_bcc))).append(SPACE);
//                if (Common.isEquals(m_bcc_not, "Y")) queryStr.append(String.format("%s(%s) ", EXCEPT_QUERY, bccStr.toString()));
//                else queryStr.append(String.format("%s(%s) ", AND_QUERY, bccStr.toString()));
//            }
//            return addQuery(queryStr.toString());
//        }
//    }
//
//    public SolrCreateQuery setRcvJikgub(String rcvJikgub,String recv_jikgub_not) {
//        if(Common.isEquals(recv_jikgub_not, "Y")) {
//            return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, RECV_JIKGUBCD, createOrQueryAppend(rcvJikgub, SPECIAL_CHAR)));
//        }
//        if (Common.isEmpty(rcvJikgub)) return this;
//        return addQuery(String.format("%s%s:%s", AND_QUERY, RECV_JIKGUBCD, createOrQueryAppend(rcvJikgub, SPECIAL_CHAR)));
//    }
//
//    public SolrCreateQuery setUrl(String url, String url_not) {
//        if (Common.isEmpty(url)) return this;
//
//        StringBuffer queryStr = new StringBuffer();
//        queryStr.append(String.format("%s:%s", HOST, createOrQueryAsterisk(url))).append(SPACE);
//        queryStr.append(String.format("%s:%s", HOST_STR, createOrQueryAsterisk(url))).append(SPACE);
//
//        if(Common.isEquals(url_not, "Y")) return addQuery(String.format("%s(%s)", EXCEPT_QUERY, queryStr.toString()));
//        else return addQuery(String.format("%s(%s)", AND_QUERY, queryStr.toString()));
//    }
//
//    public SolrCreateQuery setAttach(String attachYn, String attachs) {
//        return setAttach(attachYn, attachs, "");
//    }
//    /**
//     * 첨부파일 쿼리
//     *
//     * @param attachYn
//     * @param attachs
//     * @return
//     */
//    public SolrCreateQuery setAttach(String attachYn, String attachs, String attachYn_not) {
//        return setAttach(attachYn, attachs, "", "N", "N");
//    }
//
//    public SolrCreateQuery setAttach(String attachYn, String attachs, String attachYn_not, String realAttYn, String drmYn) {
//        if (Common.isEmpty(attachYn)) return this;
//
//        StringBuffer queryStr = new StringBuffer();
//        StringBuffer drmQueryStr = new StringBuffer();
//        StringBuffer realyAttQueryStr = new StringBuffer();
//
//        queryStr.append(String.format("%s%s:%s ", AND_QUERY, ATTACH_YN, attachYn));
//
//        //첨부가 있는 경우에만 실제 존재 및 drm 기능 확인
//        if(Common.isEquals(attachYn, "Y")){
//
//            if (Common.isEquals(realAttYn, "Y")) realyAttQueryStr.append(String.format("%s%s:%s", AND_QUERY, ATTACH_EXIST_CNT, "[ 1 TO * ]"));
//            else if (Common.isEquals(realAttYn, "N")) realyAttQueryStr.append(String.format("%s%s:%s", AND_QUERY, ATTACH_EXIST_CNT, "0"));
//
//            if (Common.isEquals(drmYn, "Y")) drmQueryStr.append(String.format("%s%s:%s", AND_QUERY, DRM, "*"));
//            else if (Common.isEquals(drmYn, "N")) drmQueryStr.append(String.format("%s%s:%s", EXCEPT_QUERY, DRM, "*"));
//        }
//
//        if (Common.isNotEmpty(attachs)) {
//            if( Common.isEquals(attachYn_not, "Y")) queryStr.append(String.format("%s%s:%s", EXCEPT_QUERY, ATTACHTYPE, createOrQuery(attachs.toLowerCase(), "|")));
//            else queryStr.append(String.format("%s%s:%s", AND_QUERY, ATTACHTYPE, createOrQuery(attachs.toLowerCase(), "|")));
//        }
//
//        queryStr.append(SPACE).append(drmQueryStr.toString()).append(SPACE).append(realyAttQueryStr.toString());
//        return addQuery(queryStr.toString());
//    }
//
//    /**
//     * 예약어 쿼리
//     *
//     * @param kwdYn
//     * @param kwds
//     * @return
//     */
//    public SolrCreateQuery setKwd(String kwdYn, String kwds, String keywordYn_not) {
//        if (Common.isEmpty(kwdYn)) return this;
//
//        StringBuffer queryStr = new StringBuffer();
//        queryStr.append(String.format("%s%s:%s ", AND_QUERY, KEYWORD_YN, kwdYn));
//
//        if (Common.isNotEmpty(kwds)) {
//            if(Common.isEquals(keywordYn_not, "Y")) queryStr.append(String.format("%s%s:%s", EXCEPT_QUERY, KEYWORD, createOrQuery(kwds, ", ")));
//            else queryStr.append(String.format("%s%s:%s", AND_QUERY, KEYWORD, createOrQuery(kwds, ", ")));
//        }
//        return addQuery(queryStr.toString());
//    }
//
//    /**
//     * 패턴 검출 쿼리
//     *
//     * @param kwdYn
//     * @param kwds
//     * @return
//     */
//    public SolrCreateQuery setPi(String piYn, String pis) {
//        if (Common.isEmpty(piYn)) return this;
//
//        StringBuilder queryStr = new StringBuilder();
//        if (Common.isEquals(piYn, "Y")) queryStr.append(String.format("%s%s:[1 TO *] ", AND_QUERY, PI_TOTAL));
//        else if (Common.isEquals(piYn, "N")) queryStr.append(String.format("%s%s:0 ", AND_QUERY, PI_TOTAL));
//
//        if (Common.isNotEmpty(pis)) {
//            if( pis.contains("@")) {
//                queryStr.append(String.format("%s%s", AND_QUERY, createOrQueryRegexpCount(pis, "|")));
//            } else {
//                queryStr.append(String.format("%s%s:%s", AND_QUERY, PI, createOrQuery(pis, "|")));
//            }
//        }
//
//        return addQuery(queryStr.toString());
//    }
//
//    private String createOrQueryRegexpCount(String params, String separator) {
//        String[] param = Common.toArray(params, separator);
//
//        StringBuilder result = new StringBuilder();
//        result.append("(");
//
//        for (int i = 0; i < param.length; i++) {
//            String[] svc = Common.toArray(param[i], "%");
//            result.append("pi_" + svc[0] + ":");
//
//            String[] val = Common.toArray(svc[1], "@");
//            if( val[0].equals("B") ) result.append("[ " + val[1] + " TO " + val[2] + " ]");
//            else if( val[0].equals("L") ) result.append("[ " + val[1] + " TO * ]");
//            else result.append("[ * TO " + val[1] + " ]");
//
//            if (i != param.length - 1) result.append(SPACE);
//        }
//        result.append(")");
//
//        return result.toString();
//    }
//
//    /**
//     * 관심 사용자 그룹 쿼리
//     * @param interGroup
//     * @param userGroup_not
//     * @return
//     */
//    public SolrCreateQuery setInterestUserGroup(String interGroup, String interGroup_not) {
//        adminUserGroupService = SpringContextUtil.getBean(AdminUserGroupService.class);
//        List<AdminUserGroupVO> users = adminUserGroupService.getAdminUserGroupSimpleList(interGroup);
//        if (users.size() == 0) return this;
//
//        if(Common.isEquals(interGroup_not, "Y")) addQuery(EXCEPT_QUERY+"(");
//        else addQuery(AND_QUERY+"(");
//
//        for(AdminUserGroupVO user : users) {
//            String userId = user.getUserId();
//            if (userId != null) addQuery("(userid:\"" + userId.toLowerCase() + "\")");
//        }
//        addQuery(")");
//
//        return this;
//    }
//
//    /**
//     * 서비스 그룹 조건
//     * @param svc1
//     * @param svc1_not
//     * @return
//     */
//    public SolrCreateQuery setSvc1(String svc1, String svc1_not) {
//        if (Common.isEmpty(svc1) && Common.isEmpty(svc1_not)) return this;
//
//        if (Common.isNotEmpty(svc1)) addFilterQuery(String.format("%s%s:(%s)", AND_QUERY, SERVICE_GROUP, svc1));
//        if (Common.isNotEmpty(svc1_not)) addFilterQuery(String.format("%s%s:(%s)", EXCEPT_QUERY, SERVICE_GROUP, svc1_not));
//
//        return this;
//    }
//
//

//
//    /**
//     * 관심 사용자 발신 메일 쿼리
//     *
//     * @param users
//     * @return
//     */
//    public SolrCreateQuery setInterestUserGroupSendMail(String interGroup) {
//        adminUserGroupService = SpringContextUtil.getBean(AdminUserGroupService.class);
//        List<AdminUserGroupVO> users = adminUserGroupService.getAdminUserGroupSimpleList(interGroup);
//        if (users == null) return this;
//
//        for(AdminUserGroupVO user : users) {
//            String emailStr = user.getUserEmail();
//            if (emailStr != null) {
//                String emailQuery = "";
//                String [] emails = Common.toArray(emailStr, ",");
//                for (String email : emails) {
//                    emailQuery += "\"" + email.trim() + "\" ";
//                }
//                if (Common.isNotEmpty(emailQuery)) {
//                    addQuery("+sender_str:(" + emailQuery + ")");
//                }
//            }
//            String ipStr = user.getUserIp();
//            if (ipStr != null) {
//                String ipQuery = "";
//                String [] ips = Common.toArray(ipStr, ",");
//                for (String ip : ips) {
//                    ipQuery += "\"" + ip.trim() + "\" ";
//                }
//                if (Common.isNotEmpty(ipQuery)) {
//                    addQuery("+sender_str:(" + ipQuery + ")");
//                }
//            }
//        }
//
//        addQuery("+direction:O"); // 발신 서비스 쿼리 추가 해야 함...
//        return this;
//    }
//
//    public SolrCreateQuery setUserGroupSeq(String userGroupSeq, String userGroupSeq_not) {
//        if(Common.isEmpty(userGroupSeq)) return this;
//        userService = SpringContextUtil.getBean(UserService.class);
//        List<UserGroupVO> users = userService.getUserGroupUserList(userGroupSeq);
//        if (users.size() == 0) {
//            addQuery("+srcip:notfound_userGroup");
//            return this;
//        }
//        if(Common.isEquals(userGroupSeq_not, "Y")) addQuery(EXCEPT_QUERY+"(");
//        else addQuery(AND_QUERY+"(");
//
//        for (UserGroupVO user : users) {
//            if (user == null) continue;
//            String userId = user.getUserId();
//
//            if (userId != null) addQuery("(userid:" + userId + ")");
//        }
//        addQuery(")");
//
//        return this;
//    }
//
//    public SolrCreateQuery setWork(String work) {
//        if (Common.isEmpty(work)) return this;
//
//        return addQuery(String.format("%s%s:%s", AND_QUERY, WORK, work));
//    }
//
//    public SolrCreateQuery setDrmYn(String drmYn) {
//        if (Common.isEmpty(drmYn)) return this;
//        if( Common.isEquals(drmYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, DRM, "*"));
//        else if( Common.isEquals(drmYn, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, DRM, "*"));
//        else return this;
//    }
//
//    public SolrCreateQuery setSctYn(String sctYn) {
//        if (Common.isEmpty(sctYn)) return this;
//        if( Common.isEquals(sctYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, SCT, "*"));
//        else if( Common.isEquals(sctYn, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, SCT, "*"));
//        else return this;
//    }
//    /**
//     * Knox 첨부 사용 여부 쿼리
//     * @param bodyImg
//     * @return
//     */
//    public SolrCreateQuery setKnox(String bodyImg) {
//        String queryStr ="";
//        String name ="BODY";
//        queryStr += "\"" +  name + "\"";
//        if (Common.isEmpty(bodyImg)) return this;
//        if( Common.isEquals(bodyImg, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, ATTACH_SPACE, queryStr));
//        else if( Common.isEquals(bodyImg, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, ATTACH_SPACE, queryStr));
//        else return this;
//    }
//    /**
//     * ocr 첨부 사용 여부 쿼리
//     * @param OCRYn
//     * @return
//     */
//    public SolrCreateQuery setOcr(String OCRYn) {
//        String queryStr = "[1 TO *]";
//        if (Common.isEmpty(OCRYn)) return this;
//        if( Common.isEquals(OCRYn, "Y")) return addQuery(String.format("%s%s:%s", AND_QUERY, OCR_ATTACH_CNT, queryStr));
//        else if( Common.isEquals(OCRYn, "N")) return addQuery(String.format("%s%s:%s", EXCEPT_QUERY, OCR_ATTACH_CNT, queryStr));
//        else return this;
//    }
//    /**
//     * 수신자 구분 쿼리
//     * @param allofus
//     * @returnㅎ
//     */
//    public SolrCreateQuery setAllofus(String allofus) {
//        if (Common.isEmpty(allofus)) return this;
//        return addQuery(String.format("%s%s:(%s)", AND_QUERY, ALLOFUS, allofus.replaceAll("\\|", " ")));
//    }
//
//    /**
//     * 사이즈 쿼리
//     *
//     * @param minMsgsize
//     * @param maxMsgsize
//     * @param size_condition
//     * @return
//     */
//    public SolrCreateQuery setMessageSize(String minMsgsize, String maxMsgsize, String size_condition) {
//        return setMessageSize(minMsgsize, maxMsgsize, size_condition, "");
//    }
//    /**
//     * 사이즈 쿼리
//     *
//     * @param minMsgsize
//     * @param maxMsgsize
//     * @param size_condition
//     * @param sizeType
//     * @return
//     */
//    public SolrCreateQuery setMessageSize(String minMsgsize, String maxMsgsize, String size_condition, String sizeType) {
//        if (Common.isOrEquals(minMsgsize, "", "0") && Common.isOrEquals(size_condition, "", "L")) return this;
//        if (Common.isOrEquals(minMsgsize, "", "0") && Common.isOrEquals(maxMsgsize, "", "0") && Common.isEquals(size_condition, "B")) return this;
//        if (Common.isOrEquals(minMsgsize, "", "0") && Common.isEquals(size_condition, "S")) return this;
//
//        String queryStr = "";
//        if (size_condition.equals("B") || size_condition.equals("")) {
//            queryStr = "[" + minMsgsize + " TO " + maxMsgsize + "]";
//        } else if (size_condition.equals("L")) queryStr = "[" + minMsgsize + " TO * ]";
//        else if (size_condition.equals("S")) queryStr = "[ * TO " + minMsgsize + "]";
//
//        if(Common.isEquals(sizeType, "B")) return addQuery(String.format("%s%s:%s", AND_QUERY, BODY_SIZE, queryStr));
//        else if(Common.isEquals(sizeType, "A")) return addQuery(String.format("%s%s:%s", AND_QUERY, ATTACH_SIZE, queryStr));
//        else return addQuery(String.format("%s%s:%s", AND_QUERY, SIZE, queryStr));
//    }
//
//    /**
//     * 동의서 쿼리
//     *
//     * @param consentIp
//     * @param consentEmail
//     * @return
//     */
//    public SolrCreateQuery setConsent(String consentUserId) {
//        if (Common.isEmpty(consentUserId)) return this;
//
//        return addQuery(String.format("%s(%s:%s)", AND_QUERY, USER_ID, "\"" + consentUserId + "\""));
//    }
//
//    public SolrCreateQuery setDirection(String receiveSend) {
//        if (Common.isEmpty(receiveSend)) return this;
//
//        return addQuery(String.format("%s%s:%s", AND_QUERY, DIRECTION_SVC, receiveSend));
//    }
//
//    public SolrCreateQuery setSearchTime(String searchTime){
//        if (Common.isEmpty(searchTime)) return this;
//
//        return addQuery(String.format("%s%s:[* TO %s]", AND_QUERY, LTIME, searchTime));
//    }
//
//    public SolrCreateQuery setReadYn(String readYn, String adminId) {
//        if (Common.isEmpty(readYn)) return this;
//        String str = "";
//        if (Common.isEquals(readYn, "Y")) str = String.format(JOIN_READ, adminId);
//        else if (Common.isEquals(readYn, "N")) str = String.format(JOIN_UNREAD, adminId);
//        return addQuery(str);
//    }
//
//    /*
//     * //예약 알람 키 호출 public SolrQuery createAlarmQuery( String alarmSeq ){
//     * //alarmSeq로 MySQL에서 데이터 불러옴 //createAlarmQuery( vo ) 호출 } //예약 알람 처리
//     * public SolrQuery createAlarmQuery( AdminAlarmVO vo){ }
//     */
//
//    // 조건 필터 키 호출
//    public SolrQuery createFilterQuery(String filterSeq) throws Exception {
//        adminFilterService = SpringContextUtil.getBean(AdminFilterService.class);
//        AdminFilterVO filter = adminFilterService.getAdminFilter(Common.nvn(filterSeq));
//        return createFilterQuery(filter);
//    }
//
//    // 조건 필터 처리
//    public SolrQuery createFilterQuery(AdminFilterVO vo) throws Exception {
//        if( Common.isEquals(vo.getFilterType(), "Q")) {
//            JSONArray conditions = new JSONArray();
//            JSONObject condition = new JSONObject();
//            condition.put("query", vo.getConditions());
//            conditions.add(condition);
//            return makeQuery(conditions, Common.nvl(vo.getAdminId())).setDateQuery(vo.getUserDtCd(), vo.getStartDt(), vo.getEndDt()).setQuery();
//        }else {
//            return makeQuery(Common.toJSONArray(vo.getConditions()), Common.nvl(vo.getAdminId())).setDateQuery(vo.getUserDtCd(), vo.getStartDt(), vo.getEndDt()).setQuery();
//        }
//    }
//
//    // 조건 처리
//    public SolrQuery createQuery(JSONObject param, String adminId) throws Exception {
//        return createQuery(param, adminId, "");
//    }
//
//    // 조건 처리
//    public SolrQuery createQuery(JSONObject param, String adminId, String searchTime) throws Exception {
//        //String filterName = Common.nvl(param.get("filterName")); // 필터명
//        //String p_filter_seq = Common.nvl(param.get("p_filter_seq")); // 상위필터seq(필터저장위치)
//        //String consentEmail = Common.nvl(param.get("consentEmail")); // 동의서 Id
//        String consentUserId = Common.nvl(param.get("consentUserId")); // 동의서 Id
//        //String folderSeq = Common.nvl(param.get("folderSeq")); // 폴더 seq
//        //String folderName = Common.nvl(param.get("folderName")); // 폴더명
//
//        String addSvcGroup = Common.nvl(param.get("addSvcGroup")); // 선택 서비스
//
//        consentNo = Common.nvl(param.get("consentNo"));
//        JSONArray conditions = Common.toJSONArray(param.get("conditions"));
//
//        // JSONArray conditions = param.getJSONArray("conditions");
//        return makeQuery(conditions, consentUserId, adminId, searchTime).setServiceGroup(addSvcGroup).setQuery();
//    }
//
//    // 조건 처리
//    public SolrQuery createQuery(String query) throws Exception {
//        return addQuery(query).setQuery();
//    }
//
//    public SolrCreateQuery makeQuery(JSONArray conditions, String consentUserId, String adminId, String searchTime) throws Exception {
//        setConsent(consentUserId);
//        return makeQuery(conditions, adminId, searchTime);
//    }
//    public SolrCreateQuery makeQuery(JSONArray conditions, String adminId) throws Exception {
//        return makeQuery(conditions, adminId,"");
//    }
//
//    public SolrCreateQuery makeQuery(JSONArray conditions, String adminId, String searchTime) throws Exception {
//        for (int i = 0; i < conditions.size(); i++) {
//            JSONObject condition = conditions.getJSONObject(i);
//            String sort = Common.nvl(condition.get("sort")); //정렬
//            String period = Common.nvl(condition.get("period")); // 기간 옵션
//            String startDt = Common.nvl(condition.get("startDt")); // 검색 시작일
//            String endDt = Common.nvl(condition.get("endDt")); // 검색 종료일
//
//            String startDateSelect = Common.nvl(condition.get("startDateSelect")); //
//            int startTimeSelect = Common.nvz(condition.get("startTimeSelect")); //
//            String endDateSelect = Common.nvl(condition.get("endDateSelect")); //
//            int endTimeSelect = Common.nvz(condition.get("endTimeSelect")); //
//
//            String searchStr = Common.nvl(condition.get("searchStr")); // 검색어
//            String searchField = Common.nvl(condition.get("searchField")); // 검색어
//            String senders = Common.nvl(condition.get("senders")); // 발신자
//            String senders_not = Common.nvl(condition.get("senders_not")); //발신자 부정
//            String senders_upperCase = Common.nvl(condition.get("senders_upperCase")); //발신자 대/소문자 구분
//
//            String receive_option = Common.nvl(condition.get("receive_option")); //수신자 상세
//            String receivers = Common.nvl(condition.get("receivers")); // 수신자
//            String receivers_not = Common.nvl(condition.get("receivers_not")); //수진자 부정
//            String receivers_upperCase = Common.nvl(condition.get("receivers_upperCase")); //수신자 대/소문자 구분 ( 수신자 세분화 - 전체 일때만 해당 )
//
//            String m_to = Common.nvl(condition.get("m_to")); // 받는사람
//            String m_to_not = Common.nvl(condition.get("m_to_not")); //받는사람 부정
//            String m_cc = Common.nvl(condition.get("m_cc")); // 참조
//            String m_cc_not = Common.nvl(condition.get("m_cc_not")); //참조 부정
//            String m_bcc = Common.nvl(condition.get("m_bcc")); // 숨은참조
//            String m_bcc_not = Common.nvl(condition.get("m_bcc_not")); //숨은참조 부정
//            String rcvJikgub = Common.nvl(condition.get("rcvJikgub")); // 수신자 직급
//            String recv_jikgub_not = Common.nvl(condition.get("recv_jikgub_not")); //사업장 부정
//
//            if(Common.isNotEmpty(condition.get("rcvTo"))) {
//                m_to = Common.nvl(condition.get("rcvTo"));
//            }
//            if(Common.isNotEmpty(condition.get("rcvCc"))) {
//                m_cc = Common.nvl(condition.get("rcvCc"));
//            }
//            if(Common.isNotEmpty(condition.get("rcvBcc"))) {
//                m_bcc = Common.nvl(condition.get("rcvBcc"));
//            }
//            if(Common.isNotEmpty(condition.get("rcvTo_not"))) {
//                m_to_not = Common.nvl(condition.get("rcvTo_not"));
//            }
//            if(Common.isNotEmpty(condition.get("rcvCc_not"))) {
//                m_cc_not = Common.nvl(condition.get("rcvCc_not"));
//            }
//            if(Common.isNotEmpty(condition.get("rcvBcc_not"))) {
//                m_bcc_not = Common.nvl(condition.get("rcvBcc_not"));
//            }
//
//            String allOfus = Common.nvl(condition.get("allOfus")); // 수신자 중 외부인
//            String busi = Common.nvl(condition.get("busi")); // 사업장
//            String busi_not = Common.nvl(condition.get("busi_not")); //사업장 부정
//
//            String dept = Common.nvl(condition.get("dept")).replaceAll("\\|", ","); // 부서
//            String dept_not = Common.nvl(condition.get("dept_not")); //부서 부정
//
//            String url = Common.nvl(condition.get("url")).replaceAll("\n", " "); //url
//            String url_not = Common.nvl(condition.get("url_not")); //url 부정
//
//            String readYn = Common.nvl(condition.get("readYn")); // 읽음여부
//            String receiveSend = Common.nvl(condition.get("receiveSend")); // 수/발신
//            String serviceType = Common.nvl(condition.get("serviceType")); // 서비스타입
//            String infoTypes = Common.nvl(condition.get("infoType")); // 정보 분류 타입
//            String feedbacks = Common.nvl(condition.get("feedbackType")); // 피드백 타입
//            String probs = Common.nvl(condition.get("probType")); // 판정확률 타입
//
//            String skInfoTypes = Common.nvl(condition.get("skInfoType")); // SK 문서 분류 타입
//            String skFeedbacks = Common.nvl(condition.get("skFeedbackType")); // SK 비밀 피드백 타입
//            String skProbs = Common.nvl(condition.get("skProbType")); // SK 비밀확률 타입
//
//            String bodyImg = Common.nvl(condition.get("bodyImg")); // Knox 본문 내 이미지
//            String OCRYn = Common.nvl(condition.get("OCRYn"));  // OCR 여부
//
//            String interGroup = Common.nvl(condition.get("interGroup")); // 관심 사용자 그룹
//            String interGroup_not = Common.nvl(condition.get("interGroup_not")); //관심 사용자 그룹 부정
//
//            String attachYn = Common.nvl(condition.get("attachYn")); // 첨부여부
//            String attachVal = Common.nvl(condition.get("attachVal")); // 첨부 확장자
//            String attachYn_not = Common.nvl(condition.get("attachYn_not")); //첨부 부정
//
//            //String attachStr = Common.nvl(condition.get("attachStr")); // 첨부 확장자
//            String keywordYn = Common.nvl(condition.get("keywordYn")); // 키워드 여부
//            //String keywordVal = Common.nvl(condition.get("keywordVal"));// 키워드
//            String keywordStr = Common.nvl(condition.get("keywordStr"));// 키워드
//            String keywordYn_not = Common.nvl(condition.get("keywordYn_not")); //예약어 부정
//
//            String regexpYn = Common.nvl(condition.get("regexpYn")); // 패턴 검출 여부
//            String regexpVal = Common.nvl(condition.get("regexpVal")); // 패턴
//            //String regexpStr = Common.nvl(condition.get("regexpStr")); // 패턴
//            String sizeStartVal = Common.nvl(condition.get("sizeStartVal")); // 메시지시작크기
//            String sizeEndVal = Common.nvl(condition.get("sizeEndVal")); // 메시지종료크기
//            String sizeOption = Common.nvl(condition.get("sizeOption")); // 메시지조건옵션(B:범위,L:이상,S:이하)
//            String sizeType = Common.nvl(condition.get("sizeType")); // 메시지조건타입('':전체,B:본문,A:첨부)
//            String ctimeWork = Common.nvl(condition.get("ctimeWork")); // 메시지조건옵션(B:범위,L:이상,S:이하)
//            String userGroupSeq = Common.nvl(condition.get("userGroupSeq")); // 사용자 그룹 조건
//            String userGroupSeq_not = Common.nvl(condition.get("userGroupSeq_not")); //사용자 그룹 부정
//
//            String drmYn = Common.nvl(condition.get("drmYn")); // drm 검출 여부
//            String realAttYn = Common.nvl(condition.get("realAttYn")); // drm 검출 여부
//            String sctYn = Common.nvl(condition.get("sctYn")); // sct 여부
//            String query = Common.nvl(condition.get("query")); //고급 쿼리 검색(데이터 있는경우 우선 적용)
//
//            String svc1 = Common.nvl(condition.get("svc1")); //서비스 그룹
//            String svc1_not = Common.nvl(condition.get("svc1_not")); //서비스 제외 그룹
//
//            String epmsg_type =Common.nvl(condition.get("epmsgType")); //대외비
//
//            if( Common.isNotEmpty(query)) {
//                finalReadYn = "";
//                setSearchField(searchField);
//                setSort(sort);
//                addQuery(query);
//                setSvc1(svc1, svc1_not);
//                return this;
//            }
//            if (i == conditions.size() - 1) {
//                // 기간 쿼리는 마지막에 한번만 생성함
//                if(Common.isNotEmpty(startDateSelect)) {
//                    addDateQuery(startDateSelect, startTimeSelect, endDateSelect, endTimeSelect);
//                }else {
//                    addDateQuery(period, startDt, endDt);
//                }
//                setSort(sort);
//            }
//            setSearchStr(searchStr, searchField);
//            setSearchField(searchField);
//            setService(serviceType);
//            setInfoType(infoTypes);
//            setFeedback(feedbacks);
//            setProb(probs);
//            setSkInfoType(skInfoTypes);
//            setSkFeedback(skFeedbacks);
//            setSkProb(skProbs);
//            setDirection(receiveSend);
//            setBusicd(busi, busi_not);
//            setDeptcd(dept, dept_not);
//            setEpmsgType(epmsg_type);
//            setSender(senders, senders_not, senders_upperCase);
//            setReciver(receive_option, receivers, receivers_not, receivers_upperCase, m_to, m_to_not, m_cc, m_cc_not, m_bcc, m_bcc_not);
//            setRcvJikgub(rcvJikgub,recv_jikgub_not);
//            setUrl(url, url_not);
//            setAttach(attachYn, attachVal, attachYn_not, realAttYn, drmYn);
//            setKwd(keywordYn, keywordStr, keywordYn_not);
//            setPi(regexpYn, regexpVal);
//            setWork(ctimeWork);
//            setAllofus(allOfus);
//            setMessageSize(sizeStartVal, sizeEndVal, sizeOption, sizeType);
//            setUserGroupSeq(userGroupSeq, userGroupSeq_not);
//            setInterestUserGroup(interGroup, interGroup_not);
//            setSvc1(svc1, svc1_not);
//            setKnox(bodyImg);
//            setOcr(OCRYn);
//            //setDrmYn(drmYn);
//            setSctYn(sctYn);
//
//            finalReadYn = readYn;
//        }
//
//        if( Common.isNotEmpty(searchTime)){
//            setSearchTime(searchTime);
//        }
//        return this;
//    }


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
		else if (str.endsWith(ElasticSearchCommon.SPECIAL_CHAR)) return str;
		else if (str.endsWith(ElasticSearchCommon.OR_QUERY)) return str;
		else if (str.endsWith("\"")) return str;
		else return str + ElasticSearchCommon.SPECIAL_CHAR;
	}



	public SearchSourceBuilder initSearchSource(Map<String,Object> searchParam,String adminId) {
		  SearchSourceBuilder result = null;
            switch (Common.nvl(searchParam.get(ElasticSearchCommon.SEARCH_TYPE))) {
                /* 검색 타입 조건 */
				case ElasticSearchCommon.SEARCH_TYPE_MESSAGE: //메세지 검색시
					result = initMessageSearchSource(searchParam, adminId);
					break;
	            case ElasticSearchCommon.SEARCH_TYPE_MESSENGER: //메세징 리스트 검색시
		            result = initMessengerSearchSource(searchParam, adminId);
		            break;
	            case ElasticSearchCommon.SEARCH_TYPE_MESSENGER_GROUP: //메세징 그룹 검색
		            result = initMessengerGroupSearchSource(searchParam, adminId);
		            break;
	            case ElasticSearchCommon.SEARCH_TYPE_MESSENGER_TOTAL: //메세징 토탈 쿼리 날리기
		            result = initMessageTotalSearchSource(searchParam, adminId);
		            break;
	            case ElasticSearchCommon.SEARCH_TYPE_MESSENGER_DETAIL: //메세징 상세 조회
		            result = initMessageDetailSearchSource(searchParam, adminId);
		            break;
                case ElasticSearchCommon.SEARCH_TYPE_STATISTIC: // 통계 검색시
					result = initStatisticSearchSource(searchParam,adminId); // 검색 소스 준비
                    break;
                case ElasticSearchCommon.SEARCH_TYPE_ANALYSIS: // 분석 검색시
					result = initAnalysisSearchSource(searchParam,adminId); // 검색 소스 준비
                    break;
                case ElasticSearchCommon.SEARCH_TYPE_ANALYSIS_DETAIL: // 분석 검색시
					result = initAnalysisDetailSearchSource(searchParam,adminId); // 검색 소스 준비
                    break;
	            case ElasticSearchCommon.SEARCH_TYPE_COLLECTION: //생성형 AI,.. 검색
		            result = initCollectionSearchSource(searchParam,adminId);
		            break;
            }

			return result;
	}



	/***
	 *  통계 검색 소스 준비
	 * setStatisticQueryReady
	 * @param setStatisticQueryReady
	 * @param searchParam
	 */
	public void setStatisticQueryParamReady(Map<String,Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();
		elasticSearchParam.setSearchParameters(searchParam);

		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

		/* 검색 offset , limit 설정  */
		int offset = 0;
		int limit = 0;

		offset = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("offset"))));
		limit =  (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("limit"))));

//&&Common.isEmpty(elasticSearchParam.getSearchParameters().get("interGroupId"))
		/* yField 설정 */
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("yAxis"))) {
			setyField(Common.nvl(elasticSearchParam.getSearchParameters().get("yAxis")));
		}

		/* rowKey만 존재 */
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("rowKey"))) {
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("rowKey")));
		}
		/* 관심사용자 검색시 */
		else if(Common.isEmpty(elasticSearchParam.getSearchParameters().get("rowKey")) && !Common.isEmpty(elasticSearchParam.getSearchParameters().get("interGroupId"))) {
			/*setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("interGroupId")));*/
		} else{
			/*아무런 검색조건 없을시*/
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH));
		}

		/* 아무런 rowKey & colkey  조건이 없을시 */
		if(Common.isEmpty(elasticSearchParam.getSearchParameters().get("rowKey")) && Common.isEmpty(elasticSearchParam.getSearchParameters().get("colKey"))){
			limit = 0;
		}

		/* detail Query 존재시*/
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("detailQuery"))) {
			setDetailQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("detailQuery")));
		}


		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("interGroup"))) {
			adminUserGroupService = SpringContextUtil.getBean(AdminUserGroupService.class);
			List<AdminUserGroupVO> users = adminUserGroupService.getAdminUserGroupSimpleList((String) elasticSearchParam.getSearchParameters().get("interGroup"));
		   	if (users.size() == 0) return;
			String userStr =  users.stream().map(m-> m.getUserId().toLowerCase()).collect(Collectors.joining(","));
			String[] userArr = userStr.split(",");
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.USER_USERID,makeParentheses(userArr));
		}


		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());

		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setXAxis(Common.nvl(elasticSearchParam.getSearchParameters().get("xAxis")));
		this.elasticSearchParam.setYAxis(Common.nvl(elasticSearchParam.getSearchParameters().get("yAxis")));
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDate")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDate")));
		this.elasticSearchParam.setColId(Common.nvl(elasticSearchParam.getSearchParameters().get("colId")));
		this.elasticSearchParam.setSearchType(Common.nvl(elasticSearchParam.getSearchParameters().get(ElasticSearchCommon.SEARCH_TYPE)));
		this.elasticSearchParam.setSearchAggregations(Common.nvl(elasticSearchParam.getSearchParameters().get("colKey")));
		this.elasticSearchParam.setSearched_xAxis(Common.nvl(elasticSearchParam.getSearchParameters().get("searched_xAxis")));


		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", getSortInfo());
		log.debug("[QUERY] {}", getQuery());

	}


	/***
	 *  통계 검색 소스 빌드
	 * @param initStatisticSearchSource
	 * @return
	 */
	public SearchSourceBuilder initStatisticSearchSource(Map<String,Object> searchParam,String adminId){

		SearchSourceBuilder searchSourceBuilder = null; // SearchSourceBuilder 리턴용

		setStatisticQueryParamReady(searchParam); // 통계용 파라미터 준비

		try {

			RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate()); // date range
			QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query); // 쿼리 스트링 저장
			BoolQueryBuilder complateQuery = new BoolQueryBuilder(); // complateQuery에서 최종적으로 쿼리 조합


			Boolean isRowKeyCol = (("rowKey").equals(Common.nvl(elasticSearchParam.getColId()))) ? true : false; // 선택한 컬럼이 주 key 영역?
			Boolean isTotalCol = (("total").equals(Common.nvl(elasticSearchParam.getColId()))) ? true : false; // 선택한 컬럼이 total 영역?

			/* 시간별 디테일 검색일 경우 추가 date range 처리 */
			if (ElasticSearchCommon.CTIME_HH.equals(elasticSearchParam.getSearched_xAxis()) && !isRowKeyCol && !isTotalCol) {
				BoolQueryBuilder boolQueryBuilder = new BoolQueryBuilder();
				int hour = Common.nvz(elasticSearchParam.getSearchAggregations().replaceAll("[^0-9]", ""));

				LocalDateTime ldtFrom = ElasticSearchCommon.stringToLocalDateTime(elasticSearchParam.getStartDate().substring(0, 8) + String.format("%02d", hour) + elasticSearchParam.getStartDate().substring(10, 14));
				LocalDateTime ldtTo = ElasticSearchCommon.stringToLocalDateTime(elasticSearchParam.getEndDate().substring(0, 8) + String.format("%02d", hour) + elasticSearchParam.getEndDate().substring(10, 14));
				int diffDay = (int) ChronoUnit.DAYS.between(ldtFrom, ldtTo);
				for (int d = 0; d <= diffDay; d++) {
					String fromStr = ElasticSearchCommon.localdateTimeToString(ldtFrom.withHour(hour));
					String toStr = ElasticSearchCommon.localdateTimeToString(ldtFrom.withHour(hour + 1).minusSeconds(1));
					boolQueryBuilder.should(new RangeQueryBuilder("ctime").from(fromStr).to(toStr));
					ldtFrom = ldtFrom.plusDays(1);
				}

				complateQuery.filter(boolQueryBuilder); // 시간별 디테일 date range 필터 추가

			} else {
				// default date range 필터 추가
				complateQuery.filter(rangeQuery);
			}


			/*################ 권한 관련 ##################################################################*/
			// set 권한 리스트
			setAuthoritysFilter(adminId);
			BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
			BoolQueryBuilder ceoQuery = getCeoFilterQuery();
			/*##########################################################################################*/

			if(Arrays.stream(ElasticSearchCommon.ARRAY_FIELD).anyMatch( s -> s.equals(Common.nvl(elasticSearchParam.getYAxis()))) && elasticSearchParam.getSearchParameters().get("detail") != null) {
				String nestedPath = "";
				if(elasticSearchParam.getYAxis().indexOf("attach") > -1) nestedPath = "attach";
				else if(elasticSearchParam.getYAxis().indexOf("pi") > -1) nestedPath = "pi";
				else nestedPath = elasticSearchParam.getYAxis();


				// 권한 filter 추가
				if(null != authComQuery) complateQuery.must(authComQuery);
				if(null != ceoQuery)  complateQuery.must(ceoQuery);
				complateQuery.must(secondQuery);

				NestedQueryBuilder nestedQueryBuilder = QueryBuilders.nestedQuery(nestedPath,secondQuery, ScoreMode.Avg);
				complateQuery.must(nestedQueryBuilder);
			}else {
				// 권한 filter 추가
				if(null != authComQuery) complateQuery.must(authComQuery);
				if(null != ceoQuery) complateQuery.must(ceoQuery);
				complateQuery.must(secondQuery);  // 사용할 쿼리 merge 완료
			}

			searchSourceBuilder = new SearchSourceBuilder()
					.from(elasticSearchParam.getFrom())
					.size(elasticSearchParam.getTo())
					.query(complateQuery)
					.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
					.sort(elasticSearchParam.getSorts())
					.aggregation(initAggregation(elasticSearchParam.getYAxis(), getElasticSearchParam().getXAxis()))
					.timeout(new TimeValue(60, TimeUnit.SECONDS));

			// searchSourceBuilder build 완료
		}catch (NullPointerException e){
			e.printStackTrace();
		}

		return searchSourceBuilder;
	}

/*
    메세징모아보기*/
	public void setMessengerGroupParamReady(Map<String,Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();
		if(!Common.isEmpty(searchParam.get("conditions"))){
			Map<String,Object> tempMap = (Map<String, Object>) searchParam.get("conditions");
			List<Map<String,Object>> tempList = (List<Map<String, Object>>) tempMap.get("conditions");
			tempList.get(0).put("limit", searchParam.get("limit"));
			tempList.get(0).put("offset", searchParam.get("offset"));
			elasticSearchParam.setSearchParameters(tempList.get(0));
		}


		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

		/* 검색 offset , limit 설정  */
		int offset = 0;
		int limit = 0;

		offset = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("offset"))));
		limit =  (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("limit"))));


		/* serviceType 설정 */
		if(!Common.isEmpty(ElasticSearchCommon.SERVICE_SVC12)) {
			setyField(Common.nvl(ElasticSearchCommon.SERVICE_SVC12));
		}

		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("serviceType"))) {
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("serviceType")));
		}else{
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH));
		}

		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());

		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDt")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDt")));



		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", getSortInfo());
		log.debug("[QUERY] {}", getQuery());

	}


	public SearchSourceBuilder initMessengerGroupSearchSource(Map<String, Object> searchParam, String adminId) {
		SearchSourceBuilder searchSourceBuilder = null;

		setMessengerParamReady(searchParam);
		try {
			RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
			QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query); // 쿼리 스트링 저장
			BoolQueryBuilder complateQuery = new BoolQueryBuilder();

			complateQuery.filter(rangeQuery);
			complateQuery.must(secondQuery);

			/*################ 권한 관련 ##################################################################*/
			// set 권한 리스트
			setAuthoritysFilter(adminId);
			BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
			BoolQueryBuilder ceoQuery = getCeoFilterQuery();

			// 권한 filter 추가
			if(null != authComQuery) complateQuery.must(authComQuery);
			if(null != ceoQuery) complateQuery.must(ceoQuery);
			/*##########################################################################################*/


			TopHitsAggregationBuilder topHitsAggregationBuilder = new TopHitsAggregationBuilder("docs")
					.from(0)
					.size(1)
					.sort("ctime",SortOrder.DESC)
					.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields());


			AggregationBuilder pi_aggregation = AggregationBuilders.terms("xrootMtr").field("xrootMtr").minDocCount(1);
			pi_aggregation.subAggregation(topHitsAggregationBuilder);

			searchSourceBuilder = new SearchSourceBuilder()
					.from(elasticSearchParam.getFrom())
					.size(elasticSearchParam.getTo())
					.query(complateQuery)
					.aggregation(pi_aggregation)
					.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
					.sort(elasticSearchParam.getSorts())
					.timeout(new TimeValue(60, TimeUnit.SECONDS));


			// searchSourceBuilder build 완료
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

		return searchSourceBuilder;

	}
	/*

/***
		 * 메시지 검색 쿼리 준비
		 * setMessageSearchQueryReady
		 * @param setMessageSearchQueryReady
		 * @param searchParam
		 */
	public void setMessageSearchQueryReady(Map<String,Object> searchParam) {
		clearQuery(); // 쿼리 초기화
		elasticSearchParam = new ElasticSearchParam();

		if(!Common.isEmpty(searchParam.get("filterData"))){
			Map<String,Object> tempMap = (Map<String, Object>) searchParam.get("filterData");
			List<Map<String,Object>> tempList = (List<Map<String, Object>>) tempMap.get("conditions");
			searchParam.remove("filterData");
			tempList.get(0).putAll(searchParam);
			elasticSearchParam.setSearchParameters(parameterFilter(tempList.get(0)));
		}

		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));


		/* 검색 offset , limit 설정  */
		int offset = 0;
		int limit = 0;
		offset = (int) Math.round(Double.valueOf(Common.nvl(searchParam.get("offset"))));
		limit =  (int) Math.round(Double.valueOf(Common.nvl(searchParam.get("limit"))));



		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("searchStr"))){
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("searchStr")));
		}else if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("query"))) {
			//고급쿼리 (일단 보류)
//            String allSearch = makeParentheses(ElasticSearchCommon.ALL_SEARCH);
//            setSearchQuery(allSearch.concat(ElasticSearchCommon.SPACE).concat(Common.nvl(elasticSearchParam.getSearchParameters().get("query"))));
		}else{
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH)); // 검색어 없을시 전체 검색어 입력
		}

		/* 고급 쿼리의 경우*/


		/* 검색 쿼리 */
		String searchQuery = this.queryBuffer.toString();


		/*################## 검색조건 ####################*/
		/* 검색 영역 */  // 쿼리 생성 예) (attach.name:(*:*) OR attach.text:(*:*))
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("searchField"))) {
			this.queryBuffer.setLength(0);
			String[] fields = Common.nvl(elasticSearchParam.getSearchParameters().get("searchField")).split(",");
			setSearchField(fields,searchQuery);
		}
		/* 서비스 타입 값 지정*/ // 생성 예) AND (service.svc:(MP3) OR (MIM) OR (WKR))
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("serviceType"))) {
			String[] serviceTypes = Common.nvl(elasticSearchParam.getSearchParameters().get("serviceType")).split(",");
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.SERVICE_SVC,makeParentheses(serviceTypes));
		}
		/*############################################*/


		/*############################################*/

		/*################## 시간 ####################*/
		/* 근무시간 */
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("ctimeWork"))) addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.DAY_WORK,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("ctimeWork"))));

		/*############################################*/

		/*################## 사용자 ####################*/
		// 수/발신 구분
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("receiveSend"))) addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.DIRECTION,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("receiveSend"))));


		//AND 발신자 검색
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("senders")) && Common.isEmpty(elasticSearchParam.getSearchParameters().get("senders_not"))) {
			String[] senders = Common.nvl(elasticSearchParam.getSearchParameters().get("senders")).split(",");
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.SENDER,makeParentheses(senders));
		}else if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("senders_not"))){  //NOT 발신자 검색
			String[] senders = Common.nvl(elasticSearchParam.getSearchParameters().get("senders_not")).split(",");
			addQueryGroup(ElasticSearchCommon.NOT_QUERY,ElasticSearchCommon.SENDER,makeParentheses(senders));
		}


		//수신자 전체 검색 to,cc,bcc
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("receivers"))) {
			String[] receivers = ElasticSearchCommon.RECEIVERS;
			addQueryGroup(ElasticSearchCommon.AND_QUERY,receivers,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("receivers"))));
		}

		// 수신자 구분
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("allOfus"))) {
			String[] allOfuses = Common.nvl(elasticSearchParam.getSearchParameters().get("allOfus")).split(",");
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.ALLOFUS,makeParentheses(allOfuses));
		}

		// 사용자 그룹
		// 관심 사용자 그룹

		/*################## 조직 ####################*/
		// AND 사업장
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("busi")) && Common.isEmpty(elasticSearchParam.getSearchParameters().get("busi_not"))) {
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.USER_BUSICD,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("busi"))));
		}else if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("busi_not"))){    // NOT 사업장
			addQueryGroup(ElasticSearchCommon.NOT_QUERY,ElasticSearchCommon.USER_BUSICD,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("busi_not"))));
		}

		// AND 부서
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("dept")) && Common.isEmpty(elasticSearchParam.getSearchParameters().get("dept_not"))) {
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.USER_DEPTCD,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("dept"))));
		}else if((!Common.isEmpty(elasticSearchParam.getSearchParameters().get("dept_not")))){   // NOT 부서
			addQueryGroup(ElasticSearchCommon.NOT_QUERY,ElasticSearchCommon.USER_DEPTCD,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("dept_not"))));
		}

		/*################## 기타 ####################*/
		// AND URL
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("url")) && Common.isEmpty(elasticSearchParam.getSearchParameters().get("url_not"))) {
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.HTTP_PATH,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("url"))));
		}else if((!Common.isEmpty(elasticSearchParam.getSearchParameters().get("url_not")))){   // NOT URL
			addQueryGroup(ElasticSearchCommon.NOT_QUERY,ElasticSearchCommon.HTTP_PATH,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("url_not"))));
		}

		// AND READYN  읽음여부 체크 Y,N,ALL
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("readYn"))){
			//  addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.READER,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("readYn"))));
		}


		// AND 첨부여부
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("attachYn"))) {
			String flag = ("Y").equals(Common.nvl(elasticSearchParam.getSearchParameters().get("attachYn"))) ? ElasticSearchCommon.NOT_QUERY  : ElasticSearchCommon.AND_QUERY;
			addQueryGroup(flag,ElasticSearchCommon.ATTACHCNT,makeParentheses("0"));
			// 첨부 확장자 찾기
			if(Common.isEquals("Y",elasticSearchParam.getSearchParameters().get("attachYn")) && !Common.isEmpty(elasticSearchParam.getSearchParameters().get("attachVal"))){
				String extFlag = ("Y").equals(Common.nvl(elasticSearchParam.getSearchParameters().get("attachYn_not"))) ? ElasticSearchCommon.NOT_QUERY  : ElasticSearchCommon.AND_QUERY;
				addQueryGroup(extFlag,ElasticSearchCommon.ATTACH_EXT,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("attachVal"))));
			}
			// 실제 존재여부
			if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("realAttYn"))){
				String existFlag = ("Y").equals(Common.nvl(elasticSearchParam.getSearchParameters().get("realAttYn"))) ? ElasticSearchCommon.NOT_QUERY  : ElasticSearchCommon.AND_QUERY;
				addQueryGroup(existFlag,ElasticSearchCommon.ATTACH_EXIST,makeParentheses("0"));
			}
		}

		// OCRYn
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("OCRYn"))) {
			//  addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.OCR_ATTACHCNT,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("OCRYn"))));
		}

		// drmYn
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("drmYn"))) {
			// drm 체크 Y,N,ALL
			addQueryGroup(ElasticSearchCommon.AND_QUERY,ElasticSearchCommon.ATTACH_DRM,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("drmYn"))));
		}

		// 예약어 관련
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("keywordYn"))) {
			// keyword  체크 Y,N,ALL
		}

		// 패턴 관련
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("regexpYn"))) {
			// keyword  체크 Y,N,ALL
		}

		// 크기 관련

		/*################## Detail(고급) Query ####################*/


		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());
		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDt")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDt")));
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setSearchType(Common.nvl(elasticSearchParam.getSearchParameters().get(ElasticSearchCommon.SEARCH_TYPE)));

		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", elasticSearchParam.getSorts());
		log.debug("[QUERY] {}", getQuery());


	}


	/***
	 *  메시지 검색 소스 빌드
	 * @param initMessageSearchSource
	 * @return
	 */
	public SearchSourceBuilder initMessageSearchSource(Map<String,Object> searchParam,String adminId)  {
		SearchSourceBuilder searchSourceBuilder = null;

			/* 권한 관련*/
			setMessageSearchQueryReady(searchParam); // 파라미터 준비

			RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
			QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query);

			BoolQueryBuilder complateQuery = new BoolQueryBuilder();
			complateQuery.filter(rangeQuery);

			/*################ 권한 관련 ##################################################################*/
			// set 권한 리스트
		    setAuthoritysFilter(adminId);
		    BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
		    BoolQueryBuilder ceoQuery = getCeoFilterQuery();

			// 권한 filter 추가
		    if(null != ceoQuery) complateQuery.must(authComQuery);
			if(null != ceoQuery) complateQuery.must(ceoQuery);

			/*##########################################################################################*/

			complateQuery.must(secondQuery);
			searchSourceBuilder = new SearchSourceBuilder()
						.from(elasticSearchParam.getFrom())
						.size(elasticSearchParam.getTo())
						.query(complateQuery)
						.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
						.sort(elasticSearchParam.getSorts())
						.timeout(new TimeValue(60, TimeUnit.SECONDS));


		return searchSourceBuilder;
	}

	/**
	 * xAxis 집계 쿼리 설정
	 * @param type
	 * @param mainAggs
	 * @return
	 */
	public AggregationBuilder initAggregation (String yAxis, String xAxis){
		AggregationBuilder aggregationBuilder = null;

		/* 화면단 xAxis Str -> 엘라스틱 서치 검색용 Str  */
		String xfield = Common.nvl(ElasticSearchCommon.XFIELD.get(xAxis));

		//YAxis 가 배열필드일 경우
		boolean YAxisNested =  Arrays.stream(ElasticSearchCommon.ARRAY_FIELD).anyMatch(s -> s.equals(Common.nvl(yAxis)));

		switch (xAxis){
			case ElasticSearchCommon.CTIME_HH :  // 시간별  (1시간)
				aggregationBuilder = AggregationBuilders.dateHistogram(xfield).field(xfield).calendarInterval(DateHistogramInterval.hours(1)).minDocCount(1);
				break;
			case  ElasticSearchCommon.CTIME_YYYYMMDD :  // 일별 (1일)
				 aggregationBuilder = AggregationBuilders.dateHistogram(xfield).field(xfield).calendarInterval(DateHistogramInterval.days(1)).minDocCount(1);
				break;
			case ElasticSearchCommon.CTIME_YYYYMM : // 월별 (한달)
				aggregationBuilder = AggregationBuilders.dateHistogram(xfield).field(xfield).calendarInterval(DateHistogramInterval.MONTH).minDocCount(1);
				break;
			default:     // 사업장,회사,부서,수/발신,직급
				aggregationBuilder = AggregationBuilders.terms(xfield).field(xfield).minDocCount(1);
				break;
		}

		if(YAxisNested) {
			String nestedPath = "";
			if(yAxis.indexOf("attach") > -1) nestedPath = "attach";
			else if(yAxis.indexOf("pi") > -1) nestedPath = "pi";
			else nestedPath = yAxis;
			aggregationBuilder.subAggregation(AggregationBuilders.nested("nested_"+yAxis, nestedPath).subAggregation(AggregationBuilders.terms(yAxis).field(yAxis).minDocCount(1)));

		}else {
			aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis).minDocCount(1));
		}

		return aggregationBuilder;

	}

	/***
	 * 쿼리 초기화
	 */
	private void clearQuery() {
		this.query = "";
		this.queryBuffer.setLength(0);

	}


	/* search after 검색 소스 보존*/
//
//    //5000.....
//    long totCnt = 0;  // 총 카운트
//        TimeUtil.start(); // 검색 시간 측정
//    Object[] searchAfter = null;
//        try {
//        //searchAfter 검색 ====================================================================================
//        while (true) {
//            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder()
//                    .from(100)
//                    .size()
//                    .query(QueryBuilders.queryStringQuery(queryReady.getQuery()))
//                    .fetchSource(queryReady.getIncludeFields(), queryReady.getExcludeFields())
//                    .sort(queryReady.getSorts())
//                    .timeout(new TimeValue(60, TimeUnit.SECONDS));
//
//            if (searchAfter != null) searchSourceBuilder.searchAfter(searchAfter);
//
//            SearchRequest searchRequest = new SearchRequest(queryReady.getIndices()).source(searchSourceBuilder);
//            SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
//
//            SearchHit[] hits = searchResponse.getHits().getHits();
//
//            totCnt = totCnt + hits.length;
//            ObjectMapper mapper = new ObjectMapper();
//            for (SearchHit hit : hits) {
//                Map<String, Object> map = hit.getSourceAsMap();
//                if (map.size() > 0)  result.add(mapper.convertValue(map, Emass.class));
//            }
//            if (hits.length > 0) {
//                SearchHit lastHitDocument = hits[hits.length - 1];
//                searchAfter = lastHitDocument.getSortValues();
//            } else {
//                break;
//            }
//        }
//        //searchAfter 검색 종료 ================================================================================
//        log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", totCnt, TimeUtil.print());
//    } catch (IOException e) {
//        e.printStackTrace();
//    }


	/***
	 *  분석 소스 빌드
	 * @param setanalysisSearchQueryReady
	 * @return
	 */
	public void setanalysisSearchQueryReady(Map<String,Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();
		elasticSearchParam.setSearchParameters(searchParam);

		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));


		/* 검색 offset , limit 설정  */
		int offset = 0;
		int limit = 0;
		offset = (int) Math.round(Double.valueOf(Common.nvl(searchParam.get("offset"))));
		limit =  (int) Math.round(Double.valueOf(Common.nvl(searchParam.get("limit"))));

		/* yField 설정 */
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("yAxis"))) {
			setyField(Common.nvl(elasticSearchParam.getSearchParameters().get("yAxis")));
		}

		/* rowKey 존재할시 검색조건 추가 */
		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("rowKey"))) {
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("rowKey")));
		}else{
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH));
		}

		/* 아무런 rowKey & colkey  조건이 없을시 */
		if(Common.isEmpty(elasticSearchParam.getSearchParameters().get("rowKey")) && Common.isEmpty(elasticSearchParam.getSearchParameters().get("colKey"))){
			limit = 0;
		}

		/* set Query */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());

		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setSearchType(Common.nvl(elasticSearchParam.getSearchParameters().get(ElasticSearchCommon.SEARCH_TYPE)));
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setXAxis("user.id");
		this.elasticSearchParam.setYAxis("pi.id");
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDate")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDate")));
		this.elasticSearchParam.setExcludeFields(null);

		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", elasticSearchParam.getSorts());
		log.debug("[QUERY] {}", getQuery());

	}

	public void setCollectionQueryParamReady(Map<String,Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();

		if(!Common.isEmpty(searchParam.get("conditions"))){
			Map<String,Object> tempMap = (Map<String, Object>) searchParam.get("conditions");
			List<Map<String,Object>> tempList = (List<Map<String, Object>>) tempMap.get("conditions");
			searchParam.remove("conditions");
			tempList.get(0).putAll(searchParam);
			elasticSearchParam.setSearchParameters(tempList.get(0));
		}

		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

		/* 검색 offset , limit 설정  */
		int offset = 0;
		int limit = 0;

		offset = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("offset"))));
		limit =  (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("limit"))));

		/* serviceType 설정 */
		if (!Common.isEmpty(ElasticSearchCommon.SERVICE_SVC12)) {
			setyField(Common.nvl(ElasticSearchCommon.SERVICE_SVC12));
		}

		if (!Common.isEmpty(elasticSearchParam.getSearchParameters().get("serviceType"))) {
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("serviceType")));
		} else {
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH));
		}


		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();
		System.out.println(getQuery());


		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());

		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDt")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDt")));


		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", getSortInfo());
		log.debug("[QUERY] {}", getQuery());


	}

	public SearchSourceBuilder initCollectionSearchSource(Map<String,Object> searchParam,String adminId){


		SearchSourceBuilder searchSourceBuilder = null;

		setCollectionQueryParamReady(searchParam);
		try {
			RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
			QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query); // 쿼리 스트링 저장
			BoolQueryBuilder complateQuery = new BoolQueryBuilder();

			complateQuery.filter(rangeQuery);
			/*################ 권한 관련 ##################################################################*/
			// set 권한 리스트
			setAuthoritysFilter(adminId);
			BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
			BoolQueryBuilder ceoQuery = getCeoFilterQuery();

			// 권한 filter 추가
			if(null != ceoQuery) complateQuery.must(ceoQuery);
			if(null != authComQuery) complateQuery.must(authComQuery);
			/*##########################################################################################*/

			complateQuery.must(secondQuery);

			searchSourceBuilder = new SearchSourceBuilder()
					.from(elasticSearchParam.getFrom())
					.size(elasticSearchParam.getTo())
					.query(complateQuery)
					.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
					.sort(elasticSearchParam.getSorts())
					.timeout(new TimeValue(timeout, TimeUnit.SECONDS));


			// searchSourceBuilder build 완료
		}catch (NullPointerException e){
			e.printStackTrace();
		}

		return searchSourceBuilder;
	}




	public SearchSourceBuilder initMessengerSearchSource(Map<String, Object> searchParam, String adminId) {

		SearchSourceBuilder searchSourceBuilder = null;


		setMessengerParamReady(searchParam);
			RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
			QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query); // 쿼리 스트링 저장
			BoolQueryBuilder complateQuery = new BoolQueryBuilder();

			complateQuery.filter(rangeQuery);
			complateQuery.must(secondQuery);

		/*################ 권한 관련 ##################################################################*/
		// set 권한 리스트
		setAuthoritysFilter(adminId);
		BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
		BoolQueryBuilder ceoQuery = getCeoFilterQuery();

		// 권한 filter 추가
		if(null != authComQuery) complateQuery.must(authComQuery);
		if(null != ceoQuery) complateQuery.must(ceoQuery);
		/*##########################################################################################*/

			searchSourceBuilder = new SearchSourceBuilder()
					.from(elasticSearchParam.getFrom())
					.size(elasticSearchParam.getTo())
					.query(complateQuery)
					.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
					.sort(elasticSearchParam.getSorts())
					.timeout(new TimeValue(timeout, TimeUnit.SECONDS));


		return searchSourceBuilder;
	}

	public void setMessengerParamReady(Map<String, Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();

		if (!Common.isEmpty(searchParam.get("conditions"))) {
			Map<String, Object> tempMap = (Map<String, Object>) searchParam.get("conditions");
			List<Map<String, Object>> tempList = (List<Map<String, Object>>) tempMap.get("conditions");
			tempList.get(0).put("limit", searchParam.get("limit"));
			tempList.get(0).put("offset", searchParam.get("offset"));
			elasticSearchParam.setSearchParameters(tempList.get(0));
		}
		log.info("***searcdhParan: "+ elasticSearchParam.getSearchParameters().get("searchStr"));


		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

		/* 검색 offset , limit 설정  */
		int offset = 0;
		int limit = 0;


		offset = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("offset"))));
		limit = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("limit"))));


		/* serviceType 설정 */
		if (!Common.isEmpty(ElasticSearchCommon.SERVICE_SVC12)) {
			setyField(Common.nvl(ElasticSearchCommon.SERVICE_SVC12));
		}

		if (!Common.isEmpty(elasticSearchParam.getSearchParameters().get("serviceType"))) {
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("serviceType")));
		} else {
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH));
		}

		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());

		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDt")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDt")));


		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", getSortInfo());
		log.debug("[QUERY] {}", getQuery());

	}

	public SearchSourceBuilder initMessageDetailSearchSource(Map<String, Object> searchParam, String adminId) {
		SearchSourceBuilder searchSourceBuilder = null; // SearchSourceBuilder 리턴용

		setMessengerDetailQueryReady(searchParam);

		RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
		QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query); // 쿼리 스트링 저장
		BoolQueryBuilder complateQuery = new BoolQueryBuilder();

		complateQuery.filter(rangeQuery);
		complateQuery.must(secondQuery);

		/*################ 권한 관련 ##################################################################*/
		// set 권한 리스트
		setAuthoritysFilter(adminId);
		BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
		BoolQueryBuilder ceoQuery = getCeoFilterQuery();

		// 권한 filter 추가
		if(null != authComQuery) complateQuery.must(authComQuery);
		if(null != ceoQuery) complateQuery.must(ceoQuery);
		/*##########################################################################################*/


		searchSourceBuilder = new SearchSourceBuilder()
				.from(elasticSearchParam.getFrom())
				.query(complateQuery)
				.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
				.sort(elasticSearchParam.getSorts())
				.timeout(new TimeValue(timeout, TimeUnit.SECONDS));

		return searchSourceBuilder;
	
	
	}

	private void setMessengerDetailQueryReady(Map<String, Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();

		if (!Common.isEmpty(searchParam.get("conditions"))) {
			Map<String, Object> tempMap = (Map<String, Object>) searchParam.get("conditions");
			List<Map<String, Object>> tempList = (List<Map<String, Object>>) tempMap.get("conditions");
			tempList.get(0).put("xRootMtr", searchParam.get("xRootMtr"));
			tempList.get(0).put("offset", searchParam.get("offset"));
			elasticSearchParam.setSearchParameters(tempList.get(0));
		}

		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

		/* 검색 offset  */
		int offset = 0;

		offset = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("offset"))));

		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("searchStr"))){
			setSearchQuery(Common.nvl(elasticSearchParam.getSearchParameters().get("searchStr")));
		}else{
			setSearchQuery(Common.nvl(ElasticSearchCommon.ALL_SEARCH)); // 검색어 없을시 전체 검색어 입력
		}

		/* 검색 쿼리 */
		String searchQuery = this.queryBuffer.toString();

		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("searchField"))) {
			this.queryBuffer.setLength(0);
			String[] fields = Common.nvl(elasticSearchParam.getSearchParameters().get("searchField")).split(" ");
			setSearchField(fields,searchQuery);
		}

//		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("searchField"))) {
//			setyField(Common.nvl(ElasticSearchCommon.BODY_SNIPPET));
//		}

		//xRootMtr
		if (!Common.isEmpty(elasticSearchParam.getSearchParameters().get("xRootMtr"))) {
			addQueryGroup(ElasticSearchCommon.AND_QUERY, ElasticSearchCommon.XROOTMTR, makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("xRootMtr"))));
		}

		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());

		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setFrom(offset);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDt")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDt")));


		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", getSortInfo());
		log.debug("[QUERY] {}", getQuery());
	}

	public SearchSourceBuilder initMessageTotalSearchSource(Map<String, Object> searchParam, String adminId) {
		SearchSourceBuilder searchSourceBuilder = null; // SearchSourceBuilder 리턴용

		setMessengerTotalQueryReady(searchParam);

		RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
		QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query); // 쿼리 스트링 저장
		BoolQueryBuilder complateQuery = new BoolQueryBuilder();

		complateQuery.filter(rangeQuery);
		complateQuery.must(secondQuery);

		/*################ 권한 관련 ##################################################################*/
		// set 권한 리스트
		setAuthoritysFilter(adminId);
		BoolQueryBuilder authComQuery = getCompanyAuthFilterQuery();
		BoolQueryBuilder ceoQuery = getCeoFilterQuery();

		// 권한 filter 추가
		if(null != authComQuery) complateQuery.must(authComQuery);
		if(null != ceoQuery) complateQuery.must(ceoQuery);
		/*##########################################################################################*/


		searchSourceBuilder = new SearchSourceBuilder()
				.from(elasticSearchParam.getFrom())
				.size(elasticSearchParam.getTo())
				.query(complateQuery)
				.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
				.sort(elasticSearchParam.getSorts())
				.timeout(new TimeValue(timeout, TimeUnit.SECONDS));

		return searchSourceBuilder;
	}

	private void setMessengerTotalQueryReady(Map<String, Object> searchParam) {
		elasticSearchParam = new ElasticSearchParam();

		elasticSearchParam.setSearchParameters(searchParam);

		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

		int limit = 0;
		limit = (int) Math.round(Double.valueOf(Common.nvl(elasticSearchParam.getSearchParameters().get("limit"))));

		//xRootMtr
		if (!Common.isEmpty(elasticSearchParam.getSearchParameters().get("xRootMtr"))) {
			addQueryGroup(ElasticSearchCommon.SPACE, ElasticSearchCommon.XROOTMTR, makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("xRootMtr"))));
		}


		setQuery();


		log.info("엘라스틱 서치 MessengerTotalQuery_String (테스트) ===> " + getQuery());
		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setTo(limit);
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDt")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDt")));
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setSearchType(Common.nvl(elasticSearchParam.getSearchParameters().get(ElasticSearchCommon.SEARCH_TYPE)));

		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", elasticSearchParam.getSorts());
		log.debug("[QUERY] {}", getQuery());

	}
	public SearchSourceBuilder initAnalysisSearchSource(Map<String,Object> searchParam,String adminId) {

		SearchSourceBuilder searchSourceBuilder = null; // SearchSourceBuilder 리턴용

		setanalysisSearchQueryReady(searchParam); // 분석용 파라미터 준비

		RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
		QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query);

		RangeQueryBuilder piSNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PISN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piCNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PICN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piDNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PIDN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piFNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PIFN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piPNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PIPN).gte((searchParam.get("piCount")));


		BoolQueryBuilder piRangeQueries = QueryBuilders.boolQuery()
				.should(piSNRangeQuery)
				.should(piCNRangeQuery)
				.should(piDNRangeQuery)
				.should(piFNRangeQuery)
				.should(piPNRangeQuery)
				.minimumShouldMatch(1);


		/* 쿼리 merge */
		BoolQueryBuilder complateQuery = new BoolQueryBuilder();
		complateQuery.filter(rangeQuery);
		complateQuery.must(secondQuery);
		complateQuery.must(piRangeQueries);



		/* Aggregations */
	/*	AggregationBuilder  pi_aggregation = AggregationBuilders.terms(elasticSearchParam.getXAxis()).field(elasticSearchParam.getXAxis()).minDocCount(1);
		pi_aggregation.subAggregation(AggregationBuilders.terms(elasticSearchParam.getYAxis()).field(elasticSearchParam.getYAxis()).minDocCount(1));
*/

		AggregationBuilder piAggregation = AggregationBuilders
				.terms("stat")
				.field(elasticSearchParam.getXAxis())
				.minDocCount(1)
				.subAggregation(
						AggregationBuilders
								.nested("nested_pi", "pi")
								.subAggregation(
										AggregationBuilders
												.terms("stat2")
												.field(elasticSearchParam.getYAxis())
								)
				);

		searchSourceBuilder = new SearchSourceBuilder()
				.from(elasticSearchParam.getFrom())
				.size(elasticSearchParam.getTo())
				.query(complateQuery)
				.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
				.sort(elasticSearchParam.getSorts())
				.aggregation(piAggregation)
				.timeout(new TimeValue(timeout, TimeUnit.SECONDS));
		return searchSourceBuilder;
	}

	public SearchSourceBuilder initAnalysisDetailSearchSource(Map<String, Object> searchParam,String adminId) {

		SearchSourceBuilder searchSourceBuilder = null;

		setanalysisDetailSearchQueryReady(searchParam); // 파라미터 준비

		RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(elasticSearchParam.getStartDate()).lte(elasticSearchParam.getEndDate());
		QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(query);
		RangeQueryBuilder piSNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PISN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piCNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PICN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piDNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PIDN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piFNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PIFN).gte((searchParam.get("piCount")));
		RangeQueryBuilder piPNRangeQuery = QueryBuilders.rangeQuery(ElasticSearchCommon.PIPN).gte((searchParam.get("piCount")));


		BoolQueryBuilder piRangeQueries = QueryBuilders.boolQuery()
				.should(piSNRangeQuery)
				.should(piCNRangeQuery)
				.should(piDNRangeQuery)
				.should(piFNRangeQuery)
				.should(piPNRangeQuery)
				.minimumShouldMatch(1);


		/* 쿼리 merge */
		BoolQueryBuilder complateQuery = new BoolQueryBuilder();
		complateQuery.filter(rangeQuery);
		complateQuery.must(secondQuery);
		complateQuery.must(piRangeQueries);



		searchSourceBuilder = new SearchSourceBuilder()
				.from(elasticSearchParam.getFrom())
				.query(complateQuery)
				.fetchSource(elasticSearchParam.getIncludeFields(), elasticSearchParam.getExcludeFields())
				.sort(elasticSearchParam.getSorts())
				.timeout(new TimeValue(timeout, TimeUnit.SECONDS));

		return searchSourceBuilder;
	}

	private void setanalysisDetailSearchQueryReady(Map<String, Object> searchParam) {
		clearQuery(); // 쿼리 초기화
		elasticSearchParam = new ElasticSearchParam();

		elasticSearchParam.setSearchParameters(searchParam);

		/* sort 관련 */
		setSort("");
		List<SortBuilder<?>> sortBuilderList = getSortInfo();
		log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));


		/* 검색 쿼리 */
		String searchQuery = this.queryBuffer.toString();

		System.out.println(elasticSearchParam.getSearchParameters().get("user_str"));

		if(!Common.isEmpty(elasticSearchParam.getSearchParameters().get("user_str"))) {
			addQueryGroup(ElasticSearchCommon.SPACE,ElasticSearchCommon.USER_ID,makeParentheses(Common.nvl(elasticSearchParam.getSearchParameters().get("user_str"))));
		}


		/* set Query (항상 쿼리 조합 최하단에 위치) */
		setQuery();

		log.info("엘라스틱 서치 Query_String (테스트) ===> " + getQuery());
		this.elasticSearchParam.setIndices(new String[]{ElasticSearchCommon.EDC_MESSAGE_INDEX});
		this.elasticSearchParam.setSorts(sortBuilderList);
		this.elasticSearchParam.setIncludeFields(ElasticSearchCommon.SEARCH_FIELD);
		this.elasticSearchParam.setStartDate(Common.nvl(elasticSearchParam.getSearchParameters().get("startDate")));
		this.elasticSearchParam.setEndDate(Common.nvl(elasticSearchParam.getSearchParameters().get("endDate")));
		this.elasticSearchParam.setExcludeFields(null);
		this.elasticSearchParam.setSearchType(Common.nvl(elasticSearchParam.getSearchParameters().get(ElasticSearchCommon.SEARCH_TYPE)));

		log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
		log.debug("[SORT] : {}", elasticSearchParam.getSorts());
		log.debug("[QUERY] {}", getQuery());

	}


	private void setAuthoritysFilter(String adminId) {
		/* adminType  S:시스템 운용자, M:모니터링 운용자, D:장비 상태 모니터링 운용자 */
		this.authQueryCompanyRelated = new ArrayList<>();
		this.authQueryEtcRelated = new ArrayList<>();
		this.ceoSearch = false;

		if (Common.isNotEmpty(adminId)) {
			String adminType = "S"; // default

			if (!Common.isOrEquals(adminId, "*")) {
				adminType = adminService.getAdmin(adminId).getAdminType();
			}

			String[] ceo = ElasticSearchCommon.CEO; // ceo 검색필드 불러오기
			String ceoReadYn = Config.getString("ceo.readyn");
			if (Common.isEquals(adminType, "C")) {
				this.ceoSearch = false;
			} else if (!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y"))) {
				this.ceoSearch = true;
			}

			/* 검색하는 운용자의 검색 회사,사업장 권한 확인 */
			JSONObject param = new JSONObject();
			param.put("adminId", adminId);
			param.put("queryType", Config.getString("query.type", "A"));
			List<AuthorityVO> authFilter =  authorityService.getAdminAuthority(param);

			for (AuthorityVO authorityVO : authFilter) {
				Map<String,Object> tempMap = new HashMap<>();
				String[] types = ElasticSearchCommon.AUTH_FIELD_MAP.get(authorityVO.getType());
				for(String type : types) {
					tempMap.put("type", type);
					String[] codes = null;
					if(Common.isEmpty(authorityVO.getCodes())) codes = new String[]{""};
					else codes = (authorityVO.getCodes().split(",").length >= 1) ? authorityVO.getCodes().split(",") : new String[]{""};
					tempMap.put("values", codes);
				}
				if(ElasticSearchCommon.COMPANY_RELATED.indexOf(authorityVO.getType()) > -1)  { //회사관련 코드
					this.authQueryCompanyRelated.add(tempMap);
				}else{
					this.authQueryEtcRelated.add(tempMap);
				}
			}
			//로그 enabled시 쿼리 로그
			if (log.isInfoEnabled()) { }
		}

	}




	/* 회사 권한 관련 (회사,사업장) 필터 */
	private BoolQueryBuilder getCompanyAuthFilterQuery( ) {
		BoolQueryBuilder result = null;
		if(authQueryCompanyRelated.size() >= 1) {
			result = new BoolQueryBuilder();
			for (Map<String, Object> authCom : authQueryCompanyRelated) {
				result.should(QueryBuilders.termsQuery((String) authCom.get("type"), (String[]) authCom.get("values")));
			}
		}
		result.minimumShouldMatch(1);
		return result;
	}

	/* 기타 필터 (서비스,패턴,그룹)* 임시 주석 */
	private BoolQueryBuilder getEtcAuthFilterQuery(){
		BoolQueryBuilder result = null;
		if(authQueryEtcRelated.size() >= 1) {
			//			for(Map<String,Object> authEtc : authQueryEtcRelated) {
//				result.should(QueryBuilders.termsQuery((String) authEtc.get("type"), (String[]) authEtc.get("values")));
//			}
//			complateQuery.minimumShouldMatch(1);
		}
		return null;
	}

	/* ceo 필터 */
	private BoolQueryBuilder getCeoFilterQuery( ) {
		BoolQueryBuilder result = null;
		if(!this.ceoSearch) {
			result = new BoolQueryBuilder();
			result.should(QueryBuilders.matchQuery("user.ceo", "N"));
			result.should(QueryBuilders.matchQuery("sender.ceo", "false"));
			result.should(QueryBuilders.matchQuery("to.ceo", "false"));
			result.should(QueryBuilders.matchQuery("cc.ceo", "false"));
			result.should(QueryBuilders.matchQuery("bcc.ceo", "false"));
			result.minimumShouldMatch(1);
		}
		return result;

	}


	
}
