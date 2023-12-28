package com.xcurenet.emass.message.service.impl;

import com.xcurenet.EmassproApplication;
import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.admin.service.impl.AdminServiceImpl;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import edu.emory.mathcs.backport.java.util.Collections;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.SortClause;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.aggregations.*;
import org.elasticsearch.search.aggregations.bucket.range.RangeAggregationBuilder;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.bucket.terms.TermsAggregationBuilder;
import org.elasticsearch.search.sort.SortOrder;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.core.AggregationsContainer;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.mapping.IndexCoordinates;
import org.springframework.data.elasticsearch.core.query.NativeSearchQueryBuilder;
import org.springframework.data.elasticsearch.core.query.Query;
import org.springframework.data.elasticsearch.core.query.UpdateQuery;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.sql.Date;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Log4j2
@Service("solrEdcService")
public class SolrEdcServiceImpl implements SolrEdcService {
	private static final int COMMIT_WITH_IN_MS = 1000;
	public static String JOIN_READ = " +checked.readId:%s";
	public static String JOIN_UNREAD = " -checked.readId:%s";

	@Autowired
	@Qualifier("elasticsearchTemplate")
	private ElasticsearchOperations operation;

	@Resource(name = "authorityService")
	private AuthorityService authorityService;

	@Resource(name = "configAdminService")
	private ConfigAdminService configAdminService;

	@Autowired
	private AdminUserGroupService adminUserGroupService;

	@Autowired
	private AdminServiceImpl adminServiceImpl;

	@Override
	public SolrClient getSolrServer() {
		return null;
	}

	@Override
	public SearchHits<SolrEdcVO> getList(SolrQuery sq) throws SolrServerException, IOException {
		String bodysnippet = "N";
		//solr parameter information
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
			log.info("[QUERY] {}", sq.getQuery());
			if (Common.isNotEmpty(sq.getFilterQueries())) log.debug("[FILTER_QUERY] {}", StringUtils.join(sq.getFilterQueries(), ' '));
		} catch (Exception e) {
		}

		TimeUtil.start();
		if (sq.getFields() == null) {
			String defaultFields = "date_hh,date_yyyy,date_yyyymm,date_yyyymmdd,ml_confd_class,ml_confd_feedback,ml_confd_prob,msgid,cid,srcip,sport,dstip,dport,svc,svc1,svc2,svc3,ltime,ctime,ctime_yyyy,ctime_yyyymm,ctime_yyyymmdd,ctime_hh,size,body_size,usr_id,usr_ip,userkey,user,userid,name,subject,host,path,xmsgkey,sender,sname,recvs,recvs_name,to,cc,bcc,tname,cocd,conm,suborgcd,suborgnm,busicd,businm,deptcd,deptnm,jikgubcd,jikgubnm,ip_cocd,ip_conm,ip_busicd,ip_businm,ip_deptcd,ip_deptnm,allofus,attached,direction,direction_svc,kwd,kwds,inside,work,attachname,attachsize,attachhash,attachtype,attachcnt,pi_total,read_time,xrootmtr,protocol,epmsg_type,user_str,pi_SN,pi_FN,pi_DN,pi_CN,pi_EC,pi_ID,pi_EF,pi_DRM,pi_MN,pi_AN,pi_CRN,pi_SSN,pi_PN,pi_EMEI,pi_BRN,pi_CPN,pi_MCN";
			if (Config.isOCR) defaultFields = defaultFields + ",ocr_attach_cnt";
			if (Common.isEquals(bodysnippet, "Y")) defaultFields = defaultFields + ",body_snippet";
			sq.setFields(defaultFields);
		}
		log.debug("[Fields] {}", sq.getFields());
		sq.setParam("wt", "json");

		/* set 필터 쿼리 */
		String filterQuery =  (null != sq.getFilterQueries())? String.join(" ", sq.getFilterQueries()) : "";

		log.info("page : {}  rows : {}", getPage(sq), sq.getRows());
		Query searchQuery = new NativeSearchQueryBuilder()
				.withFields(Common.toArray(sq.getFields(), ","))
				.withQuery(QueryBuilders.queryStringQuery(sq.getQuery() + " " + filterQuery).fields(getDefaultSearchField(sq)))
				//.withFilter(QueryBuilders.queryStringQuery(filterQuery))
				.withPageable(PageRequest.of(getPage(sq), sq.getRows(), getSort(sq)))
				.withAggregations(getAggregations(sq))
				.withAggregations(getAggregationsByPivot(sq))
				.withTrackTotalHits(true)
				.build();

		SearchHits<SolrEdcVO> hits = operation.search(searchQuery, SolrEdcVO.class);
		try {
			printQueryLog(sq, hits);
		} catch (Exception e) {
			log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", 0, TimeUtil.print());
		}
		return hits;
	}

	private Map<String, Float> getDefaultSearchField(SolrQuery sq) {
		String defaultSearchFields = Common.nvl(sq.get("qf"));
		List<String> list = Common.toList(defaultSearchFields, " ");
		Map<String, Float> fields = new HashMap<>();
		for (String field : list) {
			fields.put(field, 0.1f);
		}
		log.info("default search filter : {}", fields);
		return fields;
	}

	public static void main(String[] args) throws SolrServerException, IOException {
		ConfigurableApplicationContext context = SpringApplication.run(EmassproApplication.class, args);
		SolrCheckedService service = context.getBean(SolrCheckedService.class);

		service.setRead("20231227122850.XIKI2SHW6U3QNBWHSXOYI74FSEUNBZJF", "mink");


//		String query = "+ctime:[20231022000000 TO 20231222235959] -pi_total:0 +(pi_SN:[ 1 TO *] pi_CN:[ 1 TO *] pi_DN:[ 1 TO *] pi_FN:[ 1 TO *] pi_PN:[ 1 TO *])";
//
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(query);
//		sq.setStart(0);
//		sq.setRows(0);
//		sq.set("aggregation.field", "user_str");
//		sq.set("aggregation.sub.fields", "pi_SN", "pi_PN", "pi_DN", "pi_FN", "pi_CN");
//		sq.set("aggregation.limit", 100);
//		sq.setParam("piAnalysisYn", "Y");
//
//		log.info("Solr Query : {}", sq);
//		SearchHits<SolrEdcVO> hits = service.getList(sq);
//		log.info("ce.getList(sq) : {}", hits);
//		log.info("getAggregations : {} ", hits.getAggregations().aggregations() );
//		SolrEdcMessageVO vo = new SolrEdcMessageVO(hits, null);
//
//		log.info("SOLR : {}", vo);

		context.close();
	}

	private int getPage(SolrQuery sq) {
		if (sq.getRows() == 0) sq.setRows(100);
		if (null == sq.getStart()) sq.setStart(0);
		return sq.getStart() / sq.getRows();
	}


	private void print(AggregationsContainer<?> aggregations) {
		if (aggregations == null) return;
		Aggregations agg = (Aggregations) aggregations.aggregations();
		for (Map.Entry<String, Aggregation> map : agg.asMap().entrySet()) {
			Terms terms = agg.get(map.getValue().getName());
			for (Terms.Bucket bucket : terms.getBuckets()) {
				log.info("{}  {} {}", terms.getName(), bucket.getKey(), bucket.getDocCount());
			}
		}
	}


	/**
	 * Solr Facet convert Elastic Search Term Aggregation
	 *
	 * @param sq Solr Query
	 * @return spring data Aggregations
	 */
	private List<AbstractAggregationBuilder<?>> getAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();
		if(Common.isEquals(sq.get("piAnalysisYn"), "Y"))  return getPiAnalysisAggregations(sq);
		if ( null == sq.getFacetFields() && null == sq.get("facet.field")) return aggregations;

		if((null != sq.get("group") && Common.isEquals("true",sq.get("group")))) {
			aggregations = getGroupAggregations(sq);
		}else {
			for (String field : sq.getFacetFields()) {
				AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(field)
						.field(field)
						.order(BucketOrder.count(false))
						.size(maxCount(sq.getFacetLimit()))
						.minDocCount(sq.getFacetMinCount());
						 aggregations.add(termsAggregation);
			}
		}
		return aggregations;
	}


	private List<AbstractAggregationBuilder<?>> getGroupAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();
		String mainField = Common.nvl(sq.get("group.field"));
		for (String field : sq.getFacetFields()) {
			AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(mainField)
					.field(mainField)
					.order(BucketOrder.count(false))
					.size(maxCount(sq.getFacetLimit()))
					.minDocCount(sq.getFacetMinCount());
					if(!Common.isEmpty(sq.get("facet.ranges"))) {
						List<String> ranges = Common.toList(sq.get("facet.ranges"), ",");
						termsAggregation = termsAggregation.subAggregation(addRanges(field, ranges));
					} else if((null != sq.get("facet.sum") && Common.isEquals("true",sq.get("facet.sum")))) {
						String key = sq.get("facet.field");
						termsAggregation = termsAggregation.subAggregation(AggregationBuilders.sum(key).field(key));
					} else if((null != sq.get("facet.detail") && Common.isEquals("true",sq.get("facet.detail")))) {
						/*그룹 디테일 검색 */
						int offset = (!Common.isEmpty(sq.get("facet.offset"))) ? Common.nvz(sq.get("facet.offset")) : 0; // default 0;
						int size = (!Common.isEmpty(sq.get("facet.size"))) ? Common.nvz(sq.get("facet.size")) : 1; // default 1

						if((!Common.isEmpty(sq.get("facet.sort")))){
						termsAggregation  = termsAggregation.subAggregation(AggregationBuilders.topHits(field).size(size).from(offset).sort("ctime", SortOrder.DESC));
						}else{
							termsAggregation  = termsAggregation.subAggregation(AggregationBuilders.topHits(field).size(size).from(offset).sort("ctime", SortOrder.ASC));
						}

					}else{
						/* 그룹 검색 1개씩 묶음*/
						termsAggregation  = termsAggregation.subAggregation(AggregationBuilders.topHits(field).size(1).from(0).sort("ctime", SortOrder.ASC));
					}
					aggregations.add(termsAggregation);
		}
		return aggregations;
	}

	private List<AbstractAggregationBuilder<?>> getPiAnalysisAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();

		String mainField = Common.nvl(sq.get("aggregation.field"));
		AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(mainField)
				.field(mainField)
				.order(BucketOrder.count(false))
				.size(maxCount(Common.nvz(sq.get("aggregation.limit"))));

		String[] fields = sq.getParams("aggregation.sub.fields");
		for (String field : fields) {
			termsAggregation.subAggregation(AggregationBuilders.sum(field).field(field));
		}
		aggregations.add(termsAggregation);
		return aggregations;
	}


	private RangeAggregationBuilder addRanges(String key,List<String> ranges){
		/* ranges */
		RangeAggregationBuilder rangeBuilder = AggregationBuilders.range(key).field(key);
		long val1 = 0;
		long val2 = 0;

		int idx = 0;
		for(int k = 0;k < ranges.size();k++){
			if(idx == ranges.size()-1) {
				val1 = (Common.nvz(ranges.get(idx-1)));
				val2 = (Common.nvz(ranges.get(idx)));
			}else {
				val1 = (Common.nvz(ranges.get(idx)));
				val2 = (Common.nvz(ranges.get(idx + 1)));
			}
			rangeBuilder = rangeBuilder.addRange(val1, val2);
			idx++;
		}

		return  rangeBuilder;
	}


	/**
	 * Solr Facet pivot convert Elastic Search Aggregation
	 *
	 * @param sq Solr Query
	 * @return spring data Aggregations
	 */
	private List<AbstractAggregationBuilder<?>> getAggregationsByPivot(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();
		if(Common.isEquals(sq.get("piAnalysisYn"), "Y")) return aggregations;
		List<String> pivots = Common.toList(sq.get("facet.pivot"), ",");
		if (pivots.size() > 1) {
			//f."+yAxis+".facet.limit
			AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(pivots.get(0))
					.field(pivots.get(0))
					.order(BucketOrder.count(false))
					.size(maxCount(Common.nvz(sq.get("f." + pivots.get(0) + ".facet.limit"))))
					.minDocCount(Common.nvz(sq.getFacetMinCount(), 1))
					.subAggregation(AggregationBuilders.terms(pivots.get(1))
							.field(pivots.get(1))
							.size(maxCount(Common.nvz(sq.get("f." + pivots.get(1) + ".facet.limit"))))
							.minDocCount(Common.nvz(sq.getFacetMinCount(), 1)));
			aggregations.add(termsAggregation);
		}
		return aggregations;
	}


	/**
	 * Solr sort convert spring data sort
	 *
	 * @param sq Solr Query
	 * @return spring data sort
	 */
	private Sort getSort(SolrQuery sq) {
		Sort sort = null;
		List<SortClause> sorts = sq.getSorts();
		for (SortClause s : sorts) {
			if (sort == null) {
				if (s.getOrder() == SolrQuery.ORDER.desc) sort = Sort.by(s.getItem()).descending();
				else sort = Sort.by(s.getItem()).ascending();
			} else {
				if (s.getOrder() == SolrQuery.ORDER.desc) sort.and(Sort.by(s.getItem()).descending());
				else sort.and(Sort.by(s.getItem()).ascending());
			}
		}
		return sort;
	}

	private int maxCount(int cnt) {
		return cnt > 0 ? cnt : Integer.MAX_VALUE;
	}

	private void printQueryLog(SolrQuery sq, SearchHits<SolrEdcVO> resp) {
		StringBuilder sb = new StringBuilder();
		if (MDC.get("x_menuId") != null) sb.append(MDC.get("x_menuId")).append(" ");
		sb.append("SUMMARY ").append("total : ").append(resp.getTotalHits()).append(" start : ").append(Common.nvl(sq.getStart())).append(" rows : ").append(Common.nvl(sq.getRows())).append(" ");
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
		SearchHits<SolrEdcVO> resp = getList(sq);
		sq.clear();
		return new MessengerEdcGroupVO(resp, adminId, detail, original);
	}

	@Override
	public MessengerGroupUserVO getMessengerGroupUserList(SolrQuery sq, String adminId) throws IOException, SolrServerException {
		setAuthoritys(sq, adminId);
		SearchHits<SolrEdcVO> resp = getList(sq);
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
		for (ConfigAdminVO configAdminVO : conf) {
			if (configAdminVO.getConfId().equals("body.snippet.sum.use")) {
				bodysnippetVal = configAdminVO.getVal();
				break;
			}
		}
		sq.setParam("bodysnippet", bodysnippetVal);
		setAuthoritys(sq, adminId);

		String serverTime = getServerTime();
		SearchHits<SolrEdcVO> resp = getList(sq);

		SolrEdcMessageVO solrEdcMessageVO = new SolrEdcMessageVO(resp, adminId);
		solrEdcMessageVO.setSearchTime(serverTime);
		solrEdcMessageVO.setExcuteQuery(sq.getQuery());
		solrEdcMessageVO.setEmass(new EmsReDefined(solrEdcMessageVO.getEmass(), readYn, consentNo, adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId)).reDefined(adminId, conf));

		if (readYn != null && readYn.isEmpty()) {
			//읽음 여부 필드 값 추가
			//solrEdcMessageVO.setEmass(solrCheckedService.findReadList(solrEdcMessageVO.getEmass(), adminId));
		}

		sq.clear();
		return solrEdcMessageVO;
	}

	@Override
	public void setFeedback(final String msgId, final String ml_confd_feedback) throws ElasticsearchException, IOException {
		int feedBack = Common.nvz(ml_confd_feedback, 9);
		String index = "edc_"+(Common.nvl(msgId).substring(0,6));
		Map<String, Object> params = new HashMap<>();
		params.put("feedback",feedBack);



		IndexCoordinates indexCoordinates = IndexCoordinates.of(index);
		operation.update(
				UpdateQuery.builder(msgId)
						.withScriptType(org.springframework.data.elasticsearch.core.ScriptType.INLINE)
						.withScript("ctx._source.ml_confd_feedback = params.feedback")
						.withLang("painless")
						.withParams(params)
						.withAbortOnVersionConflict(true)
						.withDocAsUpsert(false)
						.build(),indexCoordinates
		);
	}


	//SK 하이닉스 비밀여부, 비밀 확률 solr update 로직
	@Override
	public boolean setSecretInfo(final String sourceKey, final String securityYn, final String securityPct, final Map<String, List<parseJsonFile>> sortList) throws SolrServerException, IOException {
		return false;
	}

	@SuppressWarnings("unchecked")
	@Override
	public SolrEdcMessageVO setOverlap(SolrEdcMessageVO solrVo) throws SolrServerException, IOException {
		List<SolrEdcVO> result = new ArrayList<>();

		//조회 된 결과에서 중복 데이터 제거
		List<SolrEdcVO> emass = solrVo.getEmass().stream().filter(distinctBykey(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());
		//조회 결과에서 중복되는 데이터만 추출
		List<SolrEdcVO> allOverlap = solrVo.getEmass().stream().filter(distinctBykey2(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());

		//중복 처리를 위한 정렬
		emass = overlapSortData(emass);
		allOverlap = overlapSortData(allOverlap);

		int idx = 0; //중복 데이터 find 할때 범위 축소를 위한 Index

		for (SolrEdcVO obj : emass) {
			List<SolrEdcVO> overlapData = setOverLapCnt(allOverlap, obj, idx); //중복 제거한 데이터 List 에서 데이터 별로 중복 데이터 find

			if (overlapData.isEmpty()) { //중복 데이터 없을시
				result.add(obj);
			} else if (!overlapData.isEmpty()) { //중복 데이터 있을 시
				result.add(setReaderMsg(overlapData, obj)); //중복 데이터와 전체 크기를 비교하여 제일 큰 데이터를 대표 메시지로 선정하여 최종 결과 List에 추가

				idx += overlapData.size(); //존재 하는 중복 데이터 만큼 Index 증가하여 다음 중복 데이터 find
			}
		}

		//기존 정렬 방식 (ctime 내림차순) 으로 재 정렬
		result.sort((first, second) -> second.getCtime().compareTo(first.getCtime()));

		solrVo.setEmass(result);

		return solrVo;
	}

	private String getServerTime() {
		try {
			return Common.getDateTimeFormat();
		} catch (Exception e) {
			log.error("[ERROR] {}", e.getMessage());
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
	 * 중복 제거된 데이터 별로 중복 데이터 List 에서 서비스별 제목과 발신자가 동일한 데이터 추출
	 * 이때 제목과 발신자는 reDefined 된 문자열로 비교
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
				} else break; //중복 데이터 List 는 졍렬 된 상태이기 때문에 break
			}
		}

		return result;
	}

	/**
	 * 중복된 데이터와 중복 데이터를 구한 기준 데이터 전체 크기 비교
	 * 전체 크기가 가장 큰 데이터를 대표 메시지
	 *
	 * @param emass -> 중복 데이터
	 * @param base  -> 중복 데이터가 존재하는 최근 데이터
	 * @return
	 */
	private SolrEdcVO setReaderMsg(List<SolrEdcVO> emass, SolrEdcVO base) {
		SolrEdcVO reader = base;

		//중복 데이터 List를 전체 크기로 내림차순 정렬
		emass.sort((first, second) -> Long.compare(second.getSize(), first.getSize()));

		//내림차순 정렬 후 첫번째 데이터와만 크기 비교 후 대표 메시지 선정
		SolrEdcVO tmp = emass.get(0);
		if (tmp.getSize() > base.getSize()) {
			emass.set(0, reader);
			reader = tmp;
		}

		emass.sort((first, second) -> second.getCtime().compareTo(first.getCtime()));

		reader.setOverlap(Common.toMap(emass));

		return reader;
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
		return false;
	}

	public static Map<Date, List<parseJsonFile>> groupingByMlFeedbackTime(List<parseJsonFile> feedbackList) {
		return feedbackList.stream().collect(Collectors.groupingBy(parseJsonFile::getMlFeedbackTime));
	}

	private Map<String, List<parseJsonFile>> groupingBySecurityYn(List<parseJsonFile> ChangefeedbackList) {
		return ChangefeedbackList.stream().collect(Collectors.groupingBy(parseJsonFile::getSecurityYn));
	}




}
