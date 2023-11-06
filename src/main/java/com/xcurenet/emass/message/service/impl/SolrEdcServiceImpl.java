package com.xcurenet.emass.message.service.impl;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.SortClause;
import org.apache.solr.client.solrj.SolrRequest.METHOD;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrInputDocument;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.admin.service.impl.AdminServiceImpl;
import com.xcurenet.common.solr.SolrConnection;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.service.EmsReDefined;
import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.service.MessengerGroupUserVO;
import com.xcurenet.emass.message.service.SolrCheckedService;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.interestUser.service.AdminUserGroupService;

import edu.emory.mathcs.backport.java.util.Collections;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Service("solrEdcService")
public class SolrEdcServiceImpl implements SolrEdcService {

	private static final int COMMIT_WITH_IN_MS = 1000;

	public static final String JOIN_READ = " +{!join from=msgid fromIndex=checked to=msgid}id:%s";
	public static final String JOIN_UNREAD = " -{!join from=msgid fromIndex=checked to=msgid}id:%s";

	@Resource(name = "emassSolrClient")
	private SolrConnection emassSolrClient;

	@Resource(name = "checkedSolrClient")
	private SolrConnection checkedSolrClient;

	@Resource(name = "authorityService")
	private AuthorityService authorityService;

	@Resource(name = "configAdminService")
	private ConfigAdminService configAdminService;

	@Autowired
	private SolrCheckedService solrCheckedService;

	@Autowired
	private AdminUserGroupService adminUserGroupService;

	@Autowired
	private AdminServiceImpl adminServiceImpl;

	@Override
	public SolrClient getSolrServer() {
		return emassSolrClient.getSolrServer();
	}

	@Override
	public QueryResponse getList(SolrQuery sq) throws SolrServerException, IOException {
		String bodysnippet = "N";
		// solr parameter information
		Iterator<String> params = sq.getParameterNamesIterator();
		while (params.hasNext()) {
			String name = params.next();
			String value = sq.get(name);

			if (Common.isEquals(name, "bodysnippet")) bodysnippet = value;

			log.debug("{} : {}", name, value);
		}

		try {
			String sort = sq.getSortField();
			if (Common.isEmpty(sort)) {
				sq.setSort(SortClause.desc("ctime"));
				sq.addSort(SortClause.desc("msgid"));
			}
			log.debug("[SORT] : {}", sq.getSortField());
			log.debug("[QUERY] {}", sq.getQuery());
			if (Common.isNotEmpty(sq.getFilterQueries())) log.debug("[FILTER_QUERY] {}", StringUtils.join(sq.getFilterQueries(), ' '));
		} catch (Exception e) {
		}

		TimeUtil.start();
		if (sq.getFields() == null) {
			String defaultFields = "date_hh,date_yyyy,date_yyyymm,date_yyyymmdd,ml_confd_class,ml_confd_feedback,ml_confd_prob,msgid,cid,srcip,sport,dstip,dport,svc,svc1,svc2,svc3,ltime,ctime,ctime_yyyy,ctime_yyyymm,ctime_yyyymmdd,ctime_hh,size,body_size,usr_id,usr_ip,user,userid,name,subject,host,path,xmsgkey,sender,sname,recvs,recvs_name,to,cc,bcc,tname,cocd,conm,suborgcd,suborgnm,busicd,businm,deptcd,deptnm,jikgubcd,jikgubnm,ip_cocd,ip_conm,ip_busicd,ip_businm,ip_deptcd,ip_deptnm,allofus,attached,direction,direction_svc,kwd,kwds,inside,work,attachname,attachsize,attachhash,attachtype,attachcnt,pi_total,read_time,xrootmtr,protocol,epmsg_type";
			defaultFields = "date_hh,date_yyyy,date_yyyymm,date_yyyymmdd,ml_confd_class,ml_confd_feedback,ml_confd_prob,msgid,cid,srcip,sport,dstip,dport,svc,svc1,svc2,svc3,ltime,ctime,ctime_yyyy,ctime_yyyymm,ctime_yyyymmdd,ctime_hh,size,body_size,usr_id,usr_ip,user,userid,name,subject,host,path,xmsgkey,sender,sname,recvs,recvs_name,to,cc,bcc,tname,cocd,conm,suborgcd,suborgnm,busicd,businm,deptcd,deptnm,ip_deptcd,ip_deptnm,jikgubcd,jikgubnm,ip_cocd,ip_conm,ip_busicd,ip_businm,allofus,attached,direction,direction_svc,kwd,kwds,inside,work,attachname,attachsize,attachhash,attachtype,attachcnt,body_snippet,pi_total,xrootmtr,protocol,epmsg_type";

			if (Config.isOCR) defaultFields = defaultFields + ",ocr_attach_cnt";
			if (Common.isEquals(bodysnippet, "Y")) defaultFields = defaultFields + ",body_snippet";

			sq.setFields(defaultFields);
		}
		log.debug("[Fields] {}", sq.getFields());
		sq.setParam("wt", "json");
		QueryResponse resp = getSolrServer().query(sq, METHOD.POST);

		try {
			if (resp.getResults() != null) {
				// log.info("[QUERY_RESULT] TOTAL_COUNT : {}, START : {}, ROWS : {}, QUERY_TIME
				// : {}, QTime : {}", resp.getResults().getNumFound(),
				// Common.nvl(sq.getStart()), Common.nvl(sq.getRows()), TimeUtil.print(),
				// resp.getQTime());
				printQueryLog(sq, resp);
			} else if (resp.getStatus() != 0) {
				log.info(resp.getRequestUrl());
			} else {
				log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", 0, TimeUtil.print());
			}
		} catch (Exception e) {
			log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", 0, TimeUtil.print());
		}
		return resp;
	}

	private void printQueryLog(SolrQuery sq, QueryResponse resp) {
		StringBuilder sb = new StringBuilder();
		if (MDC.get("x_menuId") != null) sb.append(MDC.get("x_menuId")).append(" ");
		sb.append("SOLR_QUERY ").append("total : ").append(resp.getResults().getNumFound()).append(" start : ").append(Common.nvl(sq.getStart())).append(" rows : ").append(Common.nvl(sq.getRows())).append(" qtime : ").append(resp.getQTime()).append(" ");
		sb.append("query : ").append(sq.getQuery()).append(" ");
		if (Common.isNotEmpty(sq.getFilterQueries())) sb.append("filter : ").append(StringUtils.join(sq.getFilterQueries(), ' ')).append(" ");
		sb.append("fields : ").append(sq.getFields());
		log.info("{}", sb.toString());
	}

	@Override
	public SolrEdcMessageVO getEmassMessage(final SolrQuery sq, final String adminId) throws IOException, SolrServerException {
		return getEmassMessage(sq, adminId, null, null);
	}

	@Override
	public MessengerEdcGroupVO getMessengerGroupList(final SolrQuery sq, final String adminId) throws SolrServerException, IOException {
		return getMessengerGroupList(sq, adminId, false);
	}

	@Override
	public MessengerEdcGroupVO getMessengerGroupList(final SolrQuery sq, final String adminId, final boolean detail) throws SolrServerException, IOException {
		return getMessengerGroupList(sq, adminId, detail, false);
	}

	@Override
	public MessengerEdcGroupVO getMessengerGroupList(final SolrQuery sq, final String adminId, final boolean detail, final boolean original) throws SolrServerException, IOException {
		setAuthoritys(sq, adminId);
		QueryResponse resp = getList(sq);
		sq.clear();
		return new MessengerEdcGroupVO(resp, adminId, detail, original);
	}

	@Override
	public MessengerGroupUserVO getMessengerGroupUserList(SolrQuery sq, String adminId) throws IOException, SolrServerException {
		setAuthoritys(sq, adminId);
		QueryResponse resp = getList(sq);
		sq.clear();
		return new MessengerGroupUserVO(resp);
	}

	@Override
	public SolrEdcMessageVO getEmassMessage(SolrQuery sq, String adminId, String readYn, String consentNo) throws IOException, SolrServerException {
		if (Common.isNotEmpty(readYn) && Common.isNotEmpty(adminId)) {
			if (Common.isEquals(readYn, "Y")) {
				sq.addFilterQuery(String.format(JOIN_READ, adminId));
			} else {
				sq.addFilterQuery(String.format(JOIN_UNREAD, adminId));
			}
		}

		List<ConfigAdminVO> conf = configAdminService.getConfAdminOption(adminId);
		String bodysnippetVal = "N";
		for (int i = 0; i < conf.size(); i++) {
			if (conf.get(i).getConfId().equals("body.snippet.sum.use")) {

				bodysnippetVal = conf.get(i).getVal();
				break;
			}
		}
		sq.setParam("bodysnippet", bodysnippetVal);
		setAuthoritys(sq, adminId);

		String serverTime = getServerTime();
		QueryResponse resp = getList(sq);

		SolrEdcMessageVO solrEdcMessageVO = new SolrEdcMessageVO(resp, adminId);
		solrEdcMessageVO.setSearchTime(serverTime);
		solrEdcMessageVO.setExcuteQuery(sq.getQuery());
		solrEdcMessageVO.setEmass(new EmsReDefined(solrEdcMessageVO.getEmass(), readYn, consentNo, adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId)).reDefined(adminId, conf));

		if (readYn != null && readYn.equals("")) {
			solrEdcMessageVO.setEmass(solrCheckedService.findReadList(solrEdcMessageVO.getEmass(), adminId));
		}

		sq.clear();
		return solrEdcMessageVO;
	}

	@Override
	public void setFeedback(final String msgId, final String ml_confd_feedback) throws SolrServerException, IOException {
		SolrClient server = emassSolrClient.getSolrServer();
		SolrInputDocument doc = new SolrInputDocument();
		doc.addField("msgid", msgId);

		HashMap<String, Object> value = new HashMap<>();
		value.put("set", Common.nvz(ml_confd_feedback, 9));
		doc.addField("ml_confd_feedback", value);
		server.add(doc, COMMIT_WITH_IN_MS);
	}

	// SK 하이닉스 비밀여부, 비밀 확률 solr update 로직
	@Override
	public boolean setSecretInfo(final String sourceKey, final String securityYn, final String securityPct, final Map<String, List<parseJsonFile>> sortList) throws SolrServerException, IOException {

		List<parseJsonFile> sortMsgIdList = new ArrayList<>();
		String securityResult = "";
		boolean result = false;
		Double securityDouble = Double.valueOf(securityPct);

		Double m;
		String m1 = "";
		List<Double> l1 = new ArrayList<Double>();
		List<String> l2 = new ArrayList<String>();
		Double pctDouble = null;
		String pctStr = "";

		sortMsgIdList = sortList.get(sourceKey);

		if (sortMsgIdList.size() > 1) { // msgId에 여러 파일이 있을 때

			for (int i = 0; i < sortMsgIdList.size(); i++) {
				System.out.println("get:" + sortMsgIdList.get(i));
				m = sortMsgIdList.get(i).getSecurityPct();
				m1 = sortMsgIdList.get(i).getSecurityYn();
				l1.add(m);
				l2.add(m1);
			}

			boolean isCY = l2.contains("Y");
			if (l2.contains("Y")) {
				securityResult = "1";
			} else {
				securityResult = "0";
			}

			Collections.sort(l1, Collections.reverseOrder());

			pctDouble = l1.get(0);
			pctStr = String.valueOf(pctDouble);
		} else {
			if (securityYn.equals("Y")) {
				securityResult = "1";
			} else if (securityYn.equals("N")) {
				securityResult = "0";
			} else {
				securityResult = "-1";
			}
		}

		try {
			try {
				SolrClient server = emassSolrClient.getSolrServer();
				SolrInputDocument doc = new SolrInputDocument();

				doc.addField("msgid", sourceKey);
				HashMap<String, Object> value = new HashMap<>();
				HashMap<String, Object> value1 = new HashMap<>();
				HashMap<String, Object> value2 = new HashMap<>();

				value.put("set", Common.nvz(securityResult, -1));
				doc.addField("ml_confd_class", value);
				if (sortMsgIdList.size() > 1) {
					value1.put("set", pctStr);
				} else {
					value1.put("set", securityPct);
				}
				doc.addField("ml_confd_prob", value1);

				value2.put("set", 0);
				doc.addField("ml_confd_feedback", value2);
				server.add(doc, COMMIT_WITH_IN_MS);

				return true;
			} catch (Exception e) {
				log.error(e.getMessage());
				return false;
			}

		} catch (Exception e) {
			result = false;
		}

		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public SolrEdcMessageVO setOverlap(SolrEdcMessageVO solrVo) throws SolrServerException, IOException {
		List<SolrEdcVO> result = new ArrayList<>();

		// 조회 된 결과에서 중복 데이터 제거
		List<SolrEdcVO> emass = solrVo.getEmass().stream().filter(distinctBykey(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());
		// 조회 결과에서 중복되는 데이터만 추출
		List<SolrEdcVO> allOverlap = solrVo.getEmass().stream().filter(distinctBykey2(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());

		// 중복 처리를 위한 정렬
		emass = overlapSortData(emass);
		allOverlap = overlapSortData(allOverlap);

		int idx = 0; // 중복 데이터 find 할때 범위 축소를 위한 Index

		for (SolrEdcVO obj : emass) {
			List<SolrEdcVO> overlapData = setOverLapCnt(allOverlap, obj, idx); // 중복 제거한 데이터 List 에서 데이터 별로 중복 데이터 find

			if (overlapData.size() == 0) { // 중복 데이터 없을시
				result.add(obj);
			} else if (overlapData.size() > 0) { // 중복 데이터 있을 시
				result.add(setReaderMsg(overlapData, obj)); // 중복 데이터와 전체 크기를 비교하여 제일 큰 데이터를 대표 메시지로 선정하여 최종 결과 List에 추가

				idx += overlapData.size(); // 존재 하는 중복 데이터 만큼 Index 증가하여 다음 중복 데이터 find
			}
		}

		// 기존 정렬 방식 (ctime 내림차순) 으로 재 정렬
		result.sort((first, second) -> second.getCtime().compareTo(first.getCtime()));

		solrVo.setEmass(result);

		return solrVo;
	}

	private String getServerTime() {
		try {
			return Common.getDateTimeFormat();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private void setAuthoritys(SolrQuery sq, String adminId) {
		if (Common.isNotEmpty(adminId)) {
			String adminType = "S";
			if (!Common.isOrEquals(adminId, "*")) {
				adminType = adminServiceImpl.getAdmin(adminId).getAdminType();
			}

			String ceoReadYn = Config.getString("ceo.readyn");

			if (Common.isEquals(adminType, "C")) {
				sq.addFilterQuery("+ceo:Y");
			} else if (!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y"))) {
				sq.addFilterQuery("-ceo:Y");
			}
			sq.addFilterQuery("-svc:QEKH");
			JSONObject param = new JSONObject();
			param.put("adminId", adminId);
			param.put("queryType", Config.getString("query.type", "A"));
			List<AuthorityVO> authoritys = authorityService.getAdminAuthority(param);
			for (AuthorityVO authority : authoritys) {
				if (authority.getCnt() > 0) {
					sq.addFilterQuery(authority.getQuery());
				}
			}
			if (log.isInfoEnabled()) {
				StringBuilder sb = new StringBuilder();
				if (sq.getFilterQueries() != null) {
					for (int i = 0; i < sq.getFilterQueries().length; i++) {
						sb.append(sq.getFilterQueries()[i]).append(" ");
					}
				}
			}
		}
	}

	/**
	 * 중복 제거된 데이터 별로 중복 데이터 List 에서 서비스별 제목과 발신자가 동일한 데이터 추출 이때 제목과 발신자는 reDefined 된
	 * 문자열로 비교
	 *
	 * @param emass   -> 중복 데이터 List
	 * @param base    -> 중복 제거된 데이터 별 Object
	 * @param findIdx -> 이미 찾은 중복 데이터 갯수 ( skip 할 Index 값 )
	 * @return
	 */
	private List<SolrEdcVO> setOverLapCnt(List<SolrEdcVO> emass, SolrEdcVO base, int findIdx) {
		List<SolrEdcVO> result = new ArrayList<>();

		for (int i = findIdx; i < emass.size(); i++) {
			SolrEdcVO data = emass.get(i);

			if (Common.isEquals(data.getSvcNm(), base.getSvcNm())) {
				if (Common.isEquals(data.getSubject(), base.getSubject()) && Common.isEquals(data.getSender(), base.getSender())) {
					if (Common.isNotEquals(data.getMsgid(), base.getMsgid())) result.add(data);
				} else break; // 중복 데이터 List 는 졍렬 된 상태이기 때문에 break
			}
		}

		return result;
	}

	/**
	 * 중복된 데이터와 중복 데이터를 구한 기준 데이터 전체 크기 비교 전체 크기가 가장 큰 데이터를 대표 메시지
	 *
	 * @param emass -> 중복 데이터
	 * @param base  -> 중복 데이터가 존재하는 최근 데이터
	 * @return
	 */
	private SolrEdcVO setReaderMsg(List<SolrEdcVO> emass, SolrEdcVO base) {
		SolrEdcVO reader = base;

		// 중복 데이터 List를 전체 크기로 내림차순 정렬
		emass.sort((first, second) -> Long.compare(second.getSize(), first.getSize()));

		// 내림차순 정렬 후 첫번째 데이터와만 크기 비교 후 대표 메시지 선정
		SolrEdcVO tmp = emass.get(0);
		if (tmp.getSize() > base.getSize()) {
			emass.set(0, reader);
			reader = tmp;
		}

		emass.sort((first, second) -> second.getCtime().compareTo(first.getCtime()));

		reader.setOverlap(Common.toMap(emass));

		return reader;
	}

	public static void main(String[] args) throws SolrServerException, IOException {

		ApplicationContext context = new ClassPathXmlApplicationContext("com/spring/context-*.xml");
		SolrConnection sc = (SolrConnection) context.getBean("emassSolrClient");
		ConfigAdminService cas = (ConfigAdminService) context.getBean("configAdminService");
		AdminUserGroupService augs = (AdminUserGroupService) context.getBean("adminUserGroupService");

		String query = "+ctime:[20210906000000 TO 20210913235959]";
		SolrQuery sq = new SolrQuery();
		sq.setFields("date_hh,date_yyyy,date_yyyymm,date_yyyymmdd,ml_confd_class,ml_confd_feedback,ml_confd_prob,msgid,cid,srcip,sport,dstip,dport,svc,svc1,svc2,svc3,ltime,ctime,ctime_yyyy,ctime_yyyymm,ctime_yyyymmdd,ctime_hh,size,body_size,usr_id,usr_ip,user,userid,name,subject,host,path,xmsgkey,sender,sname,recvs,recvs_name,to,cc,bcc,tname,cocd,conm,suborgcd,suborgnm,busicd,businm,deptcd,deptnm,jikgubcd,jikgubnm,ip_cocd,ip_conm,ip_busicd,ip_businm,allofus,attached,direction,direction_svc,kwd,kwds,inside,work,attachname,attachsize,attachhash,attachtype,attachcnt,pi_total,read_time,xrootmtr,protocol,epmsg_type");
		sq.setQuery(query);
		sq.setRows(100);
		sq.setSort(SortClause.desc("ctime"));
		sq.addSort(SortClause.desc("msgid"));
		QueryResponse resp = sc.getSolrServer().query(sq, METHOD.POST);

		List<ConfigAdminVO> conf = cas.getConfAdminOption("sysadmin");
		SolrEdcMessageVO solrEdcMessageVO = new SolrEdcMessageVO(resp, "sysadmin");
		solrEdcMessageVO.setExcuteQuery(sq.getQuery());

		solrEdcMessageVO.setEmass(new EmsReDefined(solrEdcMessageVO.getEmass(), "Y", "", augs.getAdminUserGroupSimpleAdminList("sysadmin")).reDefined("sysadmin", conf));

		((ConfigurableApplicationContext) context).close();

	}

	private <T> Predicate<T> distinctBykey(Function<? super T, ?>... keyExtractors) {
		final Map<List<?>, Boolean> seen = new ConcurrentHashMap<>();
		return t -> {
			final List<?> keys = Arrays.stream(keyExtractors).map(ke -> ke.apply(t)).collect(Collectors.toList());

			return seen.putIfAbsent(keys, true) == null;
		};
	}

	private <T> Predicate<T> distinctBykey2(Function<? super T, Object>... keyExtractors) {
		final Map<List<?>, Boolean> seen = new ConcurrentHashMap<>();
		return t -> {
			final List<?> keys = Arrays.stream(keyExtractors).map(ke -> ke.apply(t)).collect(Collectors.toList());

			return seen.putIfAbsent(keys, true) != null;
		};

	}

	private <T> Predicate<T> ndistinctBykey(Function<? super T, Object> keyExtractor) {
		Map<Object, Boolean> map = new HashMap<>();
		return t -> (map.putIfAbsent(keyExtractor.apply(t), true)) != null;
	}

	private List<SolrEdcVO> overlapSortData(List<SolrEdcVO> data) {
		Collections.sort(data, new Comparator<SolrEdcVO>() {
			int ret = 0;

			@Override
			public int compare(SolrEdcVO first, SolrEdcVO second) {
				if ((first.getSvcNm()).compareTo(second.getSvcNm()) > 0) {
					ret = 1;
				}
				if ((first.getSvcNm()).compareTo(second.getSvcNm()) == 0) {
					if ((first.getSubject()).compareTo(second.getSubject()) > 0) {
						ret = 1;
					} else if ((first.getSubject()).compareTo(second.getSubject()) == 0) {
						if ((first.getSender()).compareTo(second.getSender()) > 0) {
							ret = 1;
						} else if ((first.getSender()).compareTo(second.getSender()) == 0) {
							ret = 0;
						} else if ((first.getSender()).compareTo(second.getSender()) < 0) {
							ret = -1;
						}
					} else if ((first.getSubject()).compareTo(second.getSubject()) < 0) {
						ret = -1;
					}
				}
				if ((first.getSvcNm()).compareTo(second.getSvcNm()) < 0) {
					ret = -1;
				}
				return ret;
			}
		});

		return data;
	}

	@Override
	public boolean updateSolrFeedbackData(List<parseJsonFile> feedbackList) {
		log.info("Solr Feedback Update Process Start");

		List<parseJsonFile> ChangefeedbackList = new ArrayList<>();
		List<String> securityYnList = new ArrayList<>(); // 비밀여부
		List<Double> securityPctList = new ArrayList<>(); // 확률

		String msgId = "";
		String attachName, mlSecurityYN, mlFeedbackYN = ""; // mlFeedbackYN은 선택한 피드백 radio button 값(2 / 9 / 1 / 0) 에 따른 피드백 여부 값 (9,1,-1)
		Double mlFeedbackProb;
		Date mlFeedbackTime = null;

		for (int i = 0; i < feedbackList.size(); i++) {
			msgId = feedbackList.get(i).getMsgId();
			attachName = feedbackList.get(i).getAttachName();
			mlSecurityYN = feedbackList.get(i).getSecurityYn();
			mlFeedbackYN = feedbackList.get(i).getMlFeedbackYN();
			mlFeedbackProb = feedbackList.get(i).getSecurityPct();
			mlFeedbackTime = feedbackList.get(i).getMlFeedbackTime();

			if (mlFeedbackTime != null && mlSecurityYN.equals("0")) { // 피드백 여부를 확인해서 피드백이 진행 되었고 그게 0이면 비밀->대외비인 케이스인 경우이므로 확률의 의미 없어지므로 0으로 처리...?
				mlFeedbackProb = 0.0;
			}

			ChangefeedbackList.add(new parseJsonFile(msgId, attachName, mlSecurityYN, mlFeedbackYN, mlFeedbackProb, mlFeedbackTime));
		}

		for (int i = 0; i < ChangefeedbackList.size(); i++) {
			mlSecurityYN = ChangefeedbackList.get(i).getSecurityYn();
			mlFeedbackProb = ChangefeedbackList.get(i).getSecurityPct();

			if (mlSecurityYN.equals("1")) { // 비밀문서 확률 sort을 위한 비밀 문서만 필터링
				securityPctList.add(mlFeedbackProb);
				securityYnList.add(mlSecurityYN);
			}
		}

		Collections.sort(securityPctList, Collections.reverseOrder()); // sort한 securityPctList

		try {
			SolrClient server = emassSolrClient.getSolrServer();
			SolrInputDocument doc = new SolrInputDocument();

			doc.addField("msgid", msgId);
			HashMap<String, Object> value = new HashMap<>();
			HashMap<String, Object> value1 = new HashMap<>();
			HashMap<String, Object> value2 = new HashMap<>();

			if (securityYnList.size() > 0) { // y있을떄
				value.put("set", 1);
				doc.addField("ml_confd_class", value);
				value1.put("set", securityPctList.get(0));
				doc.addField("ml_confd_prob", value1);
				value2.put("set", Integer.parseInt(mlFeedbackYN));
				doc.addField("ml_confd_feedback", value2);
			} else {
				value.put("set", 0);
				doc.addField("ml_confd_class", value);
				value1.put("set", -1.0);
				doc.addField("ml_confd_prob", value1);
				value2.put("set", Integer.parseInt(mlFeedbackYN));
				doc.addField("ml_confd_feedback", value2);
			}

			server.add(doc, COMMIT_WITH_IN_MS);

			return true;
		} catch (Exception e) {
			log.error(e.getMessage());
			return false;
		}
	}

	public static Map<Date, List<parseJsonFile>> groupingByMlFeedbackTime(List<parseJsonFile> feedbackList) {
		return feedbackList.stream().collect(Collectors.groupingBy(parseJsonFile::getMlFeedbackTime));
	}

	private Map<String, List<parseJsonFile>> groupingBySecurityYn(List<parseJsonFile> ChangefeedbackList) {
		return ChangefeedbackList.stream().collect(Collectors.groupingBy(parseJsonFile::getSecurityYn));
	}
}
