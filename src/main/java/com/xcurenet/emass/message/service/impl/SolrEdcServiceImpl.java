package com.xcurenet.emass.message.service.impl;


import com.xcurenet.EmassproApplication;
import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.admin.service.impl.AdminServiceImpl;
import com.xcurenet.common.elasticsearch.ElasticsearchConfig;
import com.xcurenet.common.snmp.get.GetSnmp;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.DateUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.emass.searchHistory.vo.SearchHistoryGroupVO;
import com.xcurenet.emass.searchHistory.vo.SearchHistoryVO;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import edu.emory.mathcs.backport.java.util.Collections;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.util.EntityUtils;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.SortClause;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.client.Request;
import org.elasticsearch.client.Response;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.*;
import org.elasticsearch.script.Script;
import org.elasticsearch.search.aggregations.*;
import org.elasticsearch.search.aggregations.bucket.range.RangeAggregationBuilder;
import org.elasticsearch.search.aggregations.bucket.terms.IncludeExclude;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.bucket.terms.TermsAggregationBuilder;
import org.elasticsearch.search.aggregations.metrics.ValueCountAggregationBuilder;
import org.elasticsearch.search.aggregations.pipeline.BucketSortPipelineAggregationBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.sort.FieldSortBuilder;
import org.elasticsearch.search.sort.SortOrder;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.core.AggregationsContainer;
import org.springframework.data.elasticsearch.core.ElasticsearchRestTemplate;
import org.springframework.data.elasticsearch.core.IndexOperations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.mapping.IndexCoordinates;
import org.springframework.data.elasticsearch.core.query.*;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.sql.Date;
import java.time.Duration;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
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

	public static String All_JOIN_READ = " +checked.readId:*";

	public static String defaultIndex = "edc_*";

	public static IndexCoordinates defaultHistoryIndex = IndexCoordinates.of("ems_search_history_*");

	@Resource
	private ElasticsearchConfig elasticsearchConfig;
	private ElasticsearchRestTemplate operation; // 저수준 & 고수준 connector  (client 메서드 접근 가능)


		@Resource(name = "authorityService")
	private AuthorityService authorityService;

	@Resource(name = "configAdminService")
	private ConfigAdminService configAdminService;

	@Autowired
	private AdminUserGroupService adminUserGroupService;



	@Autowired
	private AdminServiceImpl adminServiceImpl;
	private AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation;


	String defaultFields = "_score,reprocess,date_hh,date_yyyy,date_yyyymm,date_yyyymmdd,ml_confd_class,ml_confd_feedback,ml_confd_prob,msgid,cid,srcip,sport,dstip,dport,svc,svc1,svc2,svc3,ltime,ctime,ctime_yyyy,ctime_yyyymm,ctime_yyyymmdd,ctime_hh,size,body_size,usrId,usr_ip,userkey,user,userid,name,subject,host,path,xmsgkey,sender,sname,recvs,recvs_name,to,cc,bcc,tname,cocd,conm,suborgcd,suborgnm,busicd,businm,deptcd,deptnm,jikgubcd,jikgubnm,ip_cocd,ip_conm,ip_busicd,ip_businm,ip_deptcd,ip_deptnm,allofus,attached,attachname_str,direction,direction_svc,kwd,kwds,inside,work,attachname,attachname_str,attachsize,attachhash,attachtype,attachcnt,pi_total,read_time,xrootmtr,protocol,epmsg_type,user_str,pi_amount.pi_SN,pi_amount.pi_FN,pi_amount.pi_DN,pi_amount.pi_CN,pi_amount.pi_EC,pi_amount.pi_ID,pi_amount.pi_EF,pi_amount.pi_DRM,pi_amount.pi_MN,pi_amount.pi_AN,pi_amount.pi_CRN,pi_amount.pi_SSN,pi_amount.pi_IMEI,pi_amount.pi_PN,pi_amount.pi_EMEI,pi_amount.pi_BRN,pi_amount.pi_CPN,pi_amount.pi_MCN,svc12,checked,kwds_subject,sabun,recvs_info";


	@Override
	public SolrClient getSolrServer() {
		return null;
	}

	@Override
	public SearchHistoryGroupVO getSearchHistoryList(SolrQuery sq) throws SolrServerException, IOException {
		if(Common.isEmpty(operation)) operation = elasticsearchConfig.elasticsearchTemplate();

		log.info("[QUERY] {}", sq.getQuery());
		String filterQuery = (null != sq.getFilterQueries()) ? String.join(" ", sq.getFilterQueries()) : "";
		Query searchQuery = new NativeSearchQueryBuilder()
				.withFields(Common.toArray(sq.getFields(), ","))
				.withQuery(QueryBuilders.queryStringQuery(sq.getQuery() + " " + filterQuery).fields(getDefaultSearchField(sq)))
				.withPageable(PageRequest.of(getPage(sq), sq.getRows()))
//				.withSorts( getSort(sq.getSorts()))
				.withAggregations(getAggregations(sq))
				.withAggregations(getAggregationsByPivot(sq))
				.withTrackTotalHits(true)
				.build();


		/* 정렬 */
		List<SortClause> sorts = sq.getSorts();
		if (!Common.isEmpty(sorts)) {
			Sort sort = null;
			for (SortClause s : sorts) {
				SortOrder sortOrder = (Common.isEquals(s.getOrder(), SortOrder.DESC)) ? SortOrder.DESC : SortOrder.ASC;
				if (s.getOrder() == SolrQuery.ORDER.desc) sort = Sort.by(s.getItem()).descending();
				else sort = Sort.by(s.getItem()).ascending();
				searchQuery.addSort(sort);
			}
		}

		SearchHits<SearchHistoryVO> hits = operation.search(searchQuery, SearchHistoryVO.class, defaultHistoryIndex);
		return new SearchHistoryGroupVO(hits);
	}



	/**
	 * ElasticSearch 공용검색
	 * EMASS Content 모든 검색은 해당 메소드를 이용
	 *
	 * @param sq 쿼리
	 * @return SearchHits<SolrEdcVO>
	 * @throws SolrServerException
	 * @throws IOException
	 */
	/**
	 * ElasticSearch 공용검색
	 * EMASS Content 모든 검색은 해당 메소드를 이용
	 *
	 * @param sq 쿼리
	 * @return SearchHits<SolrEdcVO>
	 * @throws SolrServerException
	 * @throws IOException
	 */
	@Override
	public SearchHits<SolrEdcVO> getList(SolrQuery sq) throws SolrServerException, IOException {
		if (Common.isEmpty(operation)) operation = elasticsearchConfig.elasticsearchTemplate();
		SearchHits<SolrEdcVO> searchHits = null;
		try {
			TimeUtil.start();
			setElasticSearchQuery(sq); // sq 객체 쿼리 조합

			log.debug("page : {}  rows : {}", getPage(sq), sq.getRows());
			List<Object> searchAfter = null;
			if (Common.isNotEmpty(sq.get("searchAfter"))) {
				searchAfter = new ArrayList<>();
				Collections.addAll(searchAfter, Common.toArray(sq.get("searchAfter"), ","));
			}

			NativeSearchQuery searchQuery = customSearchRequest(sq,searchAfter);
			if (Common.isEquals(sq.get("group"), "true")) searchHits = aggsSearch(searchQuery, sq); // 집계검색
			else searchHits = searchAfter(searchQuery, sq, searchAfter); //일반검색 (페이징)


			log.info("검색된 갯수 : {}", searchHits.getSearchHits().size());
			printQueryLog(sq, searchHits);
		} catch (ElasticsearchException e) {
			log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", 0, TimeUtil.print());
		} catch (Exception e) {
			log.error("", e);
		}

		return searchHits;
	}


	/* 쿼리 메서드 정리 */
	public NativeSearchQuery customSearchRequest(SolrQuery sq,List<Object> searchAfter){
		/* 쿼리 조합을 위한 boolQuery */
		BoolQueryBuilder boolQuery = new BoolQueryBuilder();

		/* set 필터 쿼리 */
		String filterQuery = (null != sq.getFilterQueries()) ? String.join(" ", sq.getFilterQueries()) : "";

		/* 검색 대상 필드 설정 */
		List<String> fields = (Common.isNotEmpty(sq.get("sqf"))) ? getSearchField(sq.get("sqf")) : getDefaultSearchField(sq.get("qf"));

		/* queryStringQuery + 검색 필드 지정 */
		QueryStringQueryBuilder queryBuilder = QueryBuilders
				.queryStringQuery(sq.getQuery() + " " + filterQuery)
				.fields(fields.stream().distinct().collect(Collectors.toMap(f -> f, f -> 1.0f)));

		/* 유사 문서 쿼리 설정 moreLikeThis */
		recommendQuery(queryBuilder, boolQuery, sq);

		/* 최종 조합 쿼리 (쿼리 조합 순서 변경 금지 ) */
		boolQuery.should(queryBuilder);
		BoolQueryBuilder complateQuery = QueryBuilders.boolQuery().must(boolQuery);
		/* 수,발신자 조회시 */
		if (!Common.isEmpty(sq.get("q"))) complateQuery.should(buildRecvAndSend(sq.get("q"))).minimumShouldMatch(1);
		String[] include_fields = (Common.isNotEmpty(sq.getFields())) ? sq.getFields().split(",") : new String[]{""};
		NativeSearchQuery searchQuery = new NativeSearchQueryBuilder()
				.withSourceFilter(new FetchSourceFilter(include_fields,null))
				.withQuery(complateQuery)
				.withAggregations(getAggregations(sq))
				.withAggregations(getAggregationsByPivot(sq))
				.withTrackTotalHits(true)
				.withTrackScores((Common.isEquals(sq.get("track_scores"), "true")) ? true : false)
				.withSearchAfter(searchAfter)
				.withTimeout(Duration.ofSeconds(100))
				.build();
		/* 정렬 */
		List<SortClause> sorts = sq.getSorts();
		if (!Common.isEmpty(sorts)) {
			Sort searchSort;
			for (SortClause s : sorts) {
				if (s.getOrder() == SolrQuery.ORDER.desc) searchSort = Sort.by(s.getItem()).descending();
				else searchSort = Sort.by(s.getItem()).ascending();
				searchQuery.addSort(searchSort);
			}
		}
		return searchQuery;
	}


	/**
	 * 유사도 검색 쿼리
	 * @param queryBuilder
	 * @param boolQuery
	 * @param sq
	 */
	public void recommendQuery(QueryStringQueryBuilder queryBuilder, BoolQueryBuilder boolQuery, SolrQuery sq) {
		if (Common.isEmpty(sq.getMoreLikeThisFields())) return;
		BoolQueryBuilder recommendQuery = QueryBuilders.boolQuery();
		int minTermFreq = Common.nvz(sq.get("minTermFreq"), 1);
		int maxQueryTerms = Common.nvz(sq.get("maxQueryTerms"), 20);
		int minDocFreq = Common.nvz(sq.get("minDocFreq"), 1);
		if (!Common.isEmpty(sq.getMoreLikeThisFields()) && !Common.isEmpty(sq.get("id"))) { // 유사 문서 추천
			recommendQuery.should(QueryBuilders.moreLikeThisQuery(sq.getMoreLikeThisFields(), null, new MoreLikeThisQueryBuilder.Item[]{new MoreLikeThisQueryBuilder.Item(null, sq.get("id"))})
					.minTermFreq(minTermFreq)
					.minDocFreq(minDocFreq)
					.maxQueryTerms(maxQueryTerms));
			queryBuilder.fields(new HashMap<>() {{
				put("svc", 0.1f);
			}});
			boolQuery.should(recommendQuery).minimumShouldMatch("0<-3%"); // 유사도 0%는 제외
		}else if (!Common.isEmpty(sq.getMoreLikeThisFields()) && !Common.isEmpty(sq.get("text"))){
			recommendQuery.must(QueryBuilders.moreLikeThisQuery(sq.getMoreLikeThisFields(), sq.getParams("text"), null)
					.minTermFreq(minTermFreq)
					.minDocFreq(minDocFreq)
					.maxQueryTerms(maxQueryTerms));
			queryBuilder.fields(new HashMap<>() {{
				put("svc", 0.1f);
			}});
			boolQuery.must(recommendQuery).minimumShouldMatch("0<-3%"); // 유사도 0%는 제외

		}
	}

	/**
	 * setQuery
	 *
	 * @param sq
	 */
	public void setElasticSearchQuery(SolrQuery sq) {
		if (Common.isEmpty(sq.getSortField())) setDefaultSortField(sq); // sortField 없을시 default
		printSqObjLog(sq); // log 출력
		setSearchField(sq);
		sq.setParam("wt", "json");
	}

	/**
	 * setSearchField
	 *
	 * @param sq
	 */
	public void setSearchField(SolrQuery sq) {
		String bodysnippet = getBodySnippet(sq); //bodysnippet 사용정보
		if (sq.getFields() == null) {
			String tempDefaultFields = defaultFields;
			if (Config.isOCR) tempDefaultFields = tempDefaultFields + ",ocr_attach_cnt";
			if (Common.isEquals(bodysnippet, "Y")) tempDefaultFields = tempDefaultFields + ",body_snippet";
			sq.setFields(tempDefaultFields);
		}
	}


	/**
	 * 기본 sort 필드 (기본 2개여야함)
	 *
	 * @param sq
	 */
	public void setDefaultSortField(SolrQuery sq) {
		sq.setSort(SortClause.desc("ctime"));
		sq.setSort(SortClause.desc("msgid"));
	}




	/**
	 * Print Search Sq Search Object log
	 *
	 * @param sq
	 */
	public void printSqObjLog(SolrQuery sq) {
		log.debug("[SORT] : {}", sq.getSortField());
		log.debug("[QUERY] {}", sq.getQuery());
		if (Common.isNotEmpty(sq.getFilterQueries())) {
			log.debug("[FILTER_QUERY] {}", StringUtils.join(sq.getFilterQueries(), ' '));
		}
		log.debug("[Fields] {}", sq.getFields());
	}


	/***
	 * BodySnippet
	 * @param sq
	 * @return
	 */
	public String getBodySnippet(SolrQuery sq) {
		String bodysnippet = "N";
		Iterator<String> params = sq.getParameterNamesIterator();
		while (params.hasNext()) {
			String name = params.next();
			String value = sq.get(name);
			if (Common.isEquals(name, "bodysnippet")) bodysnippet = value;
			log.debug("{} : {}", name, value);
		}
		return bodysnippet;
	}

	//집계검색
	public SearchHits<SolrEdcVO> aggsSearch(Query searchQuery, SolrQuery sq) {
		searchQuery.setPageable(PageRequest.of(getPage(sq), sq.getRows()));

		IndexCoordinates indexCoordinates = createIndex(sq);
		log.debug("검색 인덱스 확인 : {}",Arrays.toString(indexCoordinates.getIndexNames()));

		return operation.search(searchQuery, SolrEdcVO.class, indexCoordinates);
	}

	//일반검색
	public SearchHits<SolrEdcVO> searchAfter(Query searchQuery, SolrQuery sq, List<Object> searchAfter) {
		log.info("searchAfter : {}", searchAfter);
		searchQuery.setPageable(PageRequest.of(0, sq.getRows()));

		IndexCoordinates indexCoordinates = createIndex(sq);
		log.debug("검색 인덱스 확인 : {}",Arrays.toString(indexCoordinates.getIndexNames()));
		return operation.search(searchQuery, SolrEdcVO.class, indexCoordinates);
	}

	public IndexCoordinates createIndex(SolrQuery sq) {
		if (!Common.isEmpty(sq.get("indics"))) {
			return IndexCoordinates.of(sq.get("indics"));
		}
		String stDateStr = sq.get("stDateStr");
		String etDateStr = sq.get("etDateStr");

		if (Common.isEmpty(stDateStr) || Common.isEmpty(etDateStr)) {
			return IndexCoordinates.of(defaultIndex + "_*");
		}
		String[] indics;

		String dateRange = DateUtil.getYearMonthStringRange(stDateStr, etDateStr);
		indics = Arrays.stream(dateRange.split(","))
				.map(m -> defaultIndex + "_" + m)
				.toArray(String[]::new);

		return IndexCoordinates.of(indics);
	}


	/* 수발신자 조회시  */
	public BoolQueryBuilder buildRecvAndSend(String query) {
		BoolQueryBuilder existsQueryBuilder = QueryBuilders.boolQuery();
		if (query.contains("sname") || query.contains("tname") || query.contains("cname") || query.contains("bname") || query.contains("userid")) {
			if (query.contains("sname")) {
				existsQueryBuilder.should(QueryBuilders.existsQuery("sname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("srcip"));
			}
			if (query.contains("tname")) {
				existsQueryBuilder.should(QueryBuilders.existsQuery("tname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("dstip"));
			}
			if (query.contains("cname")) {
				existsQueryBuilder.should(QueryBuilders.existsQuery("cname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("dstip"));
			}
			if (query.contains("bname")) {
				existsQueryBuilder.should(QueryBuilders.existsQuery("bname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("dstip"));
			}
			if (query.contains("userid")) {
				existsQueryBuilder.should(QueryBuilders.existsQuery("sname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("tname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("cname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("bname"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("srcip"));
				existsQueryBuilder.should(QueryBuilders.existsQuery("dstip"));
			}

		}
		return existsQueryBuilder;
	}


	/* 정규식 패턴 필드 설정 */
	public BoolQueryBuilder buildRegexQuery(List<String> list, String regexPattern) {
		BoolQueryBuilder regexQuery = QueryBuilders.boolQuery();
		for (String s : list) {
			regexQuery.should(QueryBuilders.regexpQuery(s, regexPattern.replace("\\\\", "\\")));
		}

		return regexQuery;
	}

	public HighlightBuilder buildHighlight(List<String> list, HighlightBuilder highlightBuilder) {
		for (String s : list) highlightBuilder.field(s);
		return highlightBuilder;
	}


	@Override
	public SolrEdcVO getSelectOne(String msgId, boolean isUnknownDocument) {
		org.springframework.data.elasticsearch.core.query.Query searchQuery = new NativeSearchQueryBuilder().withQuery(QueryBuilders.termQuery("msgid", msgId)).withTimeout(Duration.ofSeconds(100)).build();
		String index = (!isUnknownDocument) ? String.format("%s_w_%s", "edc", msgId.substring(0, 6)) : String.format("%s_u_%s", "edc", msgId.substring(0, 6));
		IndexOperations indexoperations = operation.indexOps(IndexCoordinates.of(index));
		SolrEdcVO solrEdcVO = null;
		if (indexoperations.exists()) solrEdcVO = operation.searchOne(searchQuery, SolrEdcVO.class, indexoperations.getIndexCoordinates()).getContent();


		return solrEdcVO;
	}

	public Long getTotalCnt(String query) {
		org.springframework.data.elasticsearch.core.query.Query searchQuery = new NativeSearchQueryBuilder()
				.withQuery(QueryBuilders.queryStringQuery(query))
				.withTrackTotalHits(true)
				.withTimeout(Duration.ofSeconds(100)).build();
		IndexOperations indexoperations = operation.indexOps(IndexCoordinates.of("edc_*"));
		return operation.search(searchQuery, SolrEdcVO.class, indexoperations.getIndexCoordinates()).getTotalHits();
	}


	private List<String> getSearchField(String str) {
		return Common.toList(str, ",");
	}

	private List<String> getDefaultSearchField(String str) {
		return Common.toList(str, ",");
	}

	private Map<String, Float> getDefaultSearchField(SolrQuery sq) {
		String defaultSearchFields = Common.nvl(sq.get("qf"));
		List<String> list = Common.toList(defaultSearchFields, ",");
		Map<String, Float> fields = new HashMap<>();
		for (String field : list) {
			fields.put(field, 0.1f);
		}
		log.info("default search filter : {}", fields);
		return fields;
	}

	public List<String> getselectSearchField(SolrQuery sq) {
		String selectSearchField = Common.nvl(sq.get("sqf"));
		return Common.toList(selectSearchField, " ");
	}


	public static void main(String[] args) throws SolrServerException, IOException {
		ConfigurableApplicationContext context = SpringApplication.run(EmassproApplication.class, args);
		GetSnmp service = context.getBean(GetSnmp.class);
		JSONArray array = service.getIifTrafficTable("10.200.10.67");
		log.info("SNMP Result : {}", array);

//		SolrCheckedService service = context.getBean(SolrCheckedService.class);
//
//		service.setRead("20231227122850.XIKI2SHW6U3QNBWHSXOYI74FSEUNBZJF", "mink");


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
		if (Common.isEquals(sq.get("piAnalysisYn"), "Y")) return getPiAnalysisAggregations(sq);
		if (Common.isEquals(sq.get("gwAttached"), "Y")) return getGwAttachedAggregations(sq);
		if (Common.isEquals(sq.get("abnlYn"), "Y")) return getAbnlAggregations(sq);
		if (Common.isEquals(sq.get("facetCount"), "Y")) return getCountAggregations(sq);
		if (Common.isEquals(sq.get("dashboard_attach"), "Y")) return getDashboardAttachedAggregations(sq);
		if (null == sq.getFacetFields() && null == sq.get("facet.field")) return aggregations;

		if ((null != sq.get("group") && Common.isEquals("true", sq.get("group")))) {
			aggregations = getGroupAggregations(sq);
		} else {
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

	/* group facet */
	private List<AbstractAggregationBuilder<?>> getGroupAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();

		/* main */
		String mainField = Common.nvl(sq.get("group.field"));
		int mainFacetLimit = sq.getFacetLimit();
		int mainFacetMinCount = sq.getFacetMinCount();

		/* sub */
		SortOrder order = Common.isEmpty(sq.get("facet.sort")) ? SortOrder.ASC : SortOrder.DESC;
		String key = sq.get("facet.field");
		int offset = Common.nvz(sq.get("facet.offset"), 0);
		int limit = Common.nvz(sq.get("facet.limit"), 100);

		String[] fields = mainField.split(",");


		for (String field : sq.getFacetFields()) {
			AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = initMainAggregationBuilders(Common.isNotEmpty(sq.get("facet.include")),fields,mainFacetMinCount);


			/* sub terms 필드는 1개만*/
			if (fields.length == 1 && !Common.isEmpty(sq.get("facet.stats")))
				termsAggregation.subAggregation(AggregationBuilders.terms(fields[0]).field(fields[0]).subAggregation(AggregationBuilders.stats(sq.get("facet.stats")).field(sq.get("facet.stats"))));
			else if (fields.length > 1 && !Common.isEmpty(sq.get("facet.stats")))
				termsAggregation.subAggregation(AggregationBuilders.terms(fields[1]).field(fields[1]).subAggregation(AggregationBuilders.stats(sq.get("facet.stats")).field(sq.get("facet.stats"))));
			else if (fields.length > 1) termsAggregation.subAggregation(AggregationBuilders.terms(fields[1]).field(fields[1]));

			if (!Common.isEmpty(sq.get("facet.ranges"))) {
				List<String> ranges = Common.toList(sq.get("facet.ranges"), ",");
				termsAggregation.subAggregation(addRanges(field, ranges));
			} else if (sq.get("facet.sum") != null && Common.isEquals("true", sq.get("facet.sum"))) {
				termsAggregation.subAggregation(AggregationBuilders.sum(key).field(key));
				BucketSortPipelineAggregationBuilder paging = PipelineAggregatorBuilders.bucketSort("paging", List.of(new FieldSortBuilder(key).order(order))).from(offset).size(limit);
				termsAggregation.subAggregation(paging);
			} else if (sq.get("facet.list") != null && Common.isEquals("true", sq.get("facet.list"))) {
				/* 대화방 목록 (그룹) */
				limit = Common.nvz(sq.get("facet.group"), 100);
				//	BucketSortPipelineAggregationBuilder paging = PipelineAggregatorBuilders.bucketSort("paging", null).from(offset).size(limit);

				if (sq.get("checked.readId") != null) {
					termsAggregation.subAggregation(AggregationBuilders.terms(field).field(field).subAggregation(AggregationBuilders.terms(sq.get("checked.readId")).field(sq.get("checked.readId"))));
					aggregations.add(AggregationBuilders.cardinality("checked_bucket_total").field(mainField));
				} else {
					termsAggregation.subAggregation(AggregationBuilders.terms(field).field(field).subAggregation(AggregationBuilders.topHits(field.concat("_top")).size(100).from(0).sort("ctime", SortOrder.DESC)));
					aggregations.add(AggregationBuilders.cardinality("bucket_total").field(mainField));
				}
				//	termsAggregation.subAggregation(paging);


			} else if (sq.get("facet.detail") != null && Common.isEquals("true", sq.get("facet.detail"))) {
				/* 대화 상세 내역 */
				int size = (!Common.isEmpty(sq.get("facet.size"))) ? Common.nvz(sq.get("facet.size")) : 1; // default 1
				termsAggregation = termsAggregation.subAggregation(AggregationBuilders.topHits(field).size(size).from(0).sort("ctime", SortOrder.ASC));
			}
//			else {
//				 BucketSortPipelineAggregationBuilder paging = PipelineAggregatorBuilders.bucketSort("paging", List.of(new FieldSortBuilder(key).order(order))).from(offset).size(limit);
//				 termsAggregation.subAggregation(paging);
//			}


			aggregations.add(termsAggregation);
		}
		return aggregations;
	}

	public AbstractAggregationBuilder<TermsAggregationBuilder> initMainAggregationBuilders(final boolean includeInUse,final String[] fields,int mainFacetMinCount){
		if(includeInUse) {
			/* include 사용 */
			return AggregationBuilders
					.terms(fields[0])
					.field(fields[0])
					.includeExclude(new IncludeExclude(".*", null))
					.order(BucketOrder.count(false))
					.size(maxCount(10000))
					.minDocCount(mainFacetMinCount);
		}else{
			/* include 미사용 */
			return AggregationBuilders
					.terms(fields[0])
					.field(fields[0])
					.order(BucketOrder.count(false))
					.size(maxCount(10000))
					.minDocCount(mainFacetMinCount);
		}

	}
	private List<AbstractAggregationBuilder<?>> getAbnlAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> pivotAggregations = new ArrayList<>();

		String[] abnlList = sq.getParams("group.field");
		String srcip =  Common.nvl(sq.get("facet.field"));
		String limit =  Common.nvl(sq.get("aggregation.limit"));
		AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(srcip.concat(Common.ANALYSIS_PIVOT_AGGS_SUFFIX))
				.field(srcip)
				.order(BucketOrder.count(false))
				.minDocCount(1)
				.size(maxCount(Common.nvz(limit)));
		for (String piSubField : abnlList) {
			termsAggregation.subAggregation(AggregationBuilders.filter(piSubField, new BoolQueryBuilder().must(QueryBuilders.existsQuery(piSubField)))).minDocCount(1);
		}
		pivotAggregations.add(termsAggregation);

		return pivotAggregations;
	}

	private List<AbstractAggregationBuilder<?>> getGwAttachedAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> pivotAggregations = new ArrayList<>();

		String attachType = Common.nvl(sq.get("group.field"));
		String subField =  Common.nvl(sq.get("facet.field"));
		String limit =  Common.nvl(sq.get("aggregation.limit"));
		AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(Common.ANALYSIS_GW_ATTACH_AGGS_SUFFIX)
				.field(attachType)
				.order(BucketOrder.count(false))
				.minDocCount(1)
				.size(maxCount(Common.nvz(limit)));
		termsAggregation.subAggregation(AggregationBuilders.count(subField+"_count").field(subField));
		termsAggregation.subAggregation(AggregationBuilders.histogram(subField+"_histogram").field(subField).interval(1048576).minDocCount(1)); // 10MB
		pivotAggregations.add(termsAggregation);

		return pivotAggregations;
	}

	private List<AbstractAggregationBuilder<?>> getDashboardAttachedAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> pivotAggregations = new ArrayList<>();

		String attachType = Common.nvl(sq.get("group.field"));
		String subField =  Common.nvl(sq.get("facet.field"));

		AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(Common.ANALYSIS_DASHBOARD_ATTACH_AGGS_SUFFIX)
				.field(attachType)
				.order(BucketOrder.count(false))
				.minDocCount(1)
				.shardSize(5200)
				.size(maxCount(Common.nvz(1000)));
		List<String> ranges = Common.toList(sq.get("facet.ranges"), ",");
		termsAggregation.subAggregation(addRangesNew(subField, ranges));
		pivotAggregations.add(termsAggregation);

		return pivotAggregations;
	}

	private List<AbstractAggregationBuilder<?>> getPiAnalysisAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();

		String mainField = Common.nvl(sq.get("aggregation.field"));
		AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(mainField)
				.field(mainField)
				.order(BucketOrder.count(false))
				.minDocCount(1)
				.size(maxCount(Common.nvz(sq.get("aggregation.limit"))));

		String[] fields = sq.getParams("aggregation.sub.fields");
		int piCount = Common.nvz(sq.get("aggregation.piCount"));

		if (Common.isEquals(sq.get("aggregation.piType"), "sum")) {   // aggregation.piType
			for (String piSubField : fields) {
				Script script = new Script(String.format("doc.containsKey('%s') && doc['%s'].size() != 0", piSubField, piSubField));
				termsAggregation.subAggregation(AggregationBuilders.sum(piSubField).script(script));
			}
		} else { //메세지 내 검출 수
			for (String piSubField : fields) {
				Script script = new Script(String.format("doc['%s'].stream().max(Long::compare).orElse(-1)  >= %s", piSubField, piCount));
				termsAggregation.subAggregation(AggregationBuilders.filter(piSubField, new BoolQueryBuilder()
						.must(QueryBuilders.existsQuery(piSubField))
						.must(new ScriptQueryBuilder(script))));
			}
		}
		aggregations.add(termsAggregation);


		return aggregations;
	}

	private List<AbstractAggregationBuilder<?>> getCountAggregations(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregationBuilders = new ArrayList<>();

		String[] countList = sq.getParams("facet.field");
		for (String field : countList) {
			ValueCountAggregationBuilder aggregation = AggregationBuilders.count(field).field(field);
			aggregationBuilders.add(aggregation);
		}

		return aggregationBuilders;
	}


	private RangeAggregationBuilder addRanges(String key, List<String> ranges) {
		/* ranges */
		RangeAggregationBuilder rangeBuilder = AggregationBuilders.range(key).field(key);
		long val1 = 0;
		long val2 = 0;

		int idx = 0;
		for (int k = 0; k < ranges.size(); k++) {
			if (idx == ranges.size() - 1) {
				val1 = (Common.nvz(ranges.get(idx - 1)));
				val2 = (Common.nvz(ranges.get(idx)));
			} else {
				val1 = (Common.nvz(ranges.get(idx)));
				val2 = (Common.nvz(ranges.get(idx + 1)));
			}
			rangeBuilder = rangeBuilder.addRange(val1, val2);
			idx++;
		}

		return rangeBuilder;
	}

	/**
	 * Range Aggregation Query
	 *
	 * @param key
	 * @param ranges
	 * @return
	 */
	private RangeAggregationBuilder addRangesNew(String key, List<String> ranges) {
		RangeAggregationBuilder rangeBuilder = AggregationBuilders.range(key).field(key);

		for (int k = 0; k < ranges.size() - 1; k++) {
			long val1 = Long.parseLong(ranges.get(k));         // Start value (in bytes)
			long val2 = Long.parseLong(ranges.get(k + 1));     // End value (in bytes)

			// Convert bytes to MB
			long startMB = val1 / 1024 / 1024;  // Start value in MB
			long endMB = val2 / 1024 / 1024;    // End value in MB

			// Set range name in MB with "_" instead of spaces
			String rangeName = startMB + "MB_" + endMB + "MB";  // Name with "_" as separator

			// Add range with MB key
			if (val1 == 0) {
				rangeBuilder = rangeBuilder.addRange(rangeName, val1, val2+1);
			} else {
				rangeBuilder = rangeBuilder.addRange(rangeName, val1+1, val2+1);
			}
		}

		long lastVal = Long.parseLong(ranges.get(ranges.size() - 1));
		long lastMB = lastVal / 1024 / 1024;  // Convert last value to MB
		rangeBuilder = rangeBuilder.addRange(lastMB + "MB_over", lastVal, Long.MAX_VALUE);
		return rangeBuilder;
	}


	/**
	 * Solr Facet pivot convert Elastic Search Aggregation
	 *
	 * @param sq Solr Query
	 * @return spring data Aggregations
	 */
	private List<AbstractAggregationBuilder<?>> getAggregationsByPivot(SolrQuery sq) {
		List<AbstractAggregationBuilder<?>> aggregations = new ArrayList<>();
		if (Common.isEquals(sq.get("piAnalysisYn"), "Y")) return aggregations;
		List<String> pivots = Common.toList(sq.get("facet.pivot"), ",");
		if (pivots.size() > 0) {
			//f."+yAxis+".facet.limit
			Iterator iter = pivots.iterator();
			AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation = AggregationBuilders.terms(pivots.get(0))
					.field(String.valueOf(iter.next()))
					.order(BucketOrder.count(false))
					.size(maxCount(Common.nvz(sq.get("f." + pivots.get(0) + ".facet.limit"))))
					.minDocCount(Common.nvz(sq.getFacetMinCount(), 1));

			while (iter.hasNext()) {
				String aggsField = String.valueOf(iter.next());
				termsAggregation.subAggregation(AggregationBuilders.terms(aggsField)
						.field(aggsField)
						.size(maxCount(Common.nvz(sq.get("f." + aggsField + ".facet.limit"))))
						.minDocCount(Common.nvz(sq.getFacetMinCount(), 1)));
			}
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
//	private SortBuilder getSort(List<SortClause> sorts) {
//		if(Common.isEmpty(sorts)) return null;
//
//		SortBuilder sortBuilder = null;
//		SortBuilders sortBuilders = new SortBuilders();
//		for (SortClause s : sorts) {
//			SortOrder sortOrder = (Common.isEquals(s.getOrder(), SortOrder.DESC)) ? SortOrder.DESC : SortOrder.ASC;
//			 sortBuilders.fieldSort(s.getItem()).order(sortOrder);
//		}
//
//		return sortBuilders;
//

//		Sort sort = null;
//
//		Sort complateSort = null;
//		List<SortClause> sorts = sq.getSorts();
//		for (SortClause s : sorts) {
//			if (sort == null) {
//				if (s.getOrder() == SolrQuery.ORDER.desc) sort = Sort.by(s.getItem()).descending();
//				else sort = Sort.by(s.getItem()).ascending();
//			} else {
//				if (s.getOrder() == SolrQuery.ORDER.desc)  complateSort = sort.and(Sort.by(s.getItem()).descending());
//				else complateSort = sort.and(Sort.by(s.getItem()).ascending());
//			}
//		}
//
//		complateSort = sort;
//
//		return complateSort;
//	}
	private int maxCount(int cnt) {
		if (cnt == 25) return Integer.MAX_VALUE; //Solr Facet Limit가 25가 Default라서 25값인경우 MAX로 전달
		return cnt > 0 ? cnt : Integer.MAX_VALUE;
	}

	private void printQueryLog(SolrQuery sq, SearchHits<SolrEdcVO> resp) {
		StringBuilder sb = new StringBuilder();
		if (MDC.get("x_menuId") != null) sb.append(MDC.get("x_menuId")).append(" ");
		sb.append("SUMMARY ").append("total : ").append(resp.getTotalHits()).append(" start : ").append(Common.nvl(sq.getStart())).append(" rows : ").append(Common.nvl(sq.getRows())).append(" ");
		
		sb.append("qtime : ").append(TimeUtil.print()).append(" ");
		
		sb.append("query : ").append(sq.getQuery()).append(" ");
		if (Common.isNotEmpty(sq.getFilterQueries())) sb.append(StringUtils.join(sq.getFilterQueries(), ' ')).append(" ");
		log.info("{}", sb.toString());
		log.debug("fields : {}", sq.getFields());
	}

	@Override
	public SolrEdcMessageVO getEmassMessage(final SolrQuery sq, final String adminId) throws IOException, SolrServerException {
		return getEmassMessage(sq, adminId, null, null);
	}

	@Override
	public SolrEdcMessageVO getEmassMessage(final SolrQuery sq, final String adminId, final String readYn, final String consentNo) throws IOException, SolrServerException {
		return getEmassMessage(sq, adminId, readYn, consentNo,null);
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
	public MessengerGroupSvcVO getCollectionMessageSvc(SolrQuery sq, String adminId) throws IOException, SolrServerException {
		setAuthoritys(sq, adminId);
		SearchHits<SolrEdcVO> resp = getList(sq);
		sq.clear();
		return new MessengerGroupSvcVO(resp);
	}

	@Override
	public MessengerGroupUserVO getGenerativeGroupUserList(SolrQuery sq, String adminId) throws IOException, SolrServerException {
		setAuthoritys(sq, adminId);
		SearchHits<SolrEdcVO> resp = getList(sq);
		sq.clear();
		return new MessengerGroupUserVO(resp);
	}

	@Override
	public SolrEdcMessageVO getEmassMessage(SolrQuery sq, String adminId, String readYn, String consentNo, String adminAllRead) throws IOException, SolrServerException {
		if (Common.isNotEmpty(readYn) && Common.isNotEmpty(adminId)) {
			String firstAdminYn = adminServiceImpl.getAdmin(adminId).getFirstAdminYn();
			String adminReadId = adminId;
			if (Common.isNotEmpty(adminAllRead) && Common.isEquals(firstAdminYn, "Y") && Common.isEquals(adminAllRead, "Y")) adminReadId = "*";
			if (Common.isEquals(readYn, "Y")) {
				sq.addFilterQuery(String.format(JOIN_READ, adminReadId));
			} else {
				sq.addFilterQuery(String.format(JOIN_UNREAD, adminReadId));
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

/*		if (readYn != null && readYn.isEmpty()) {
			//읽음 여부 필드 값 추가
			//solrEdcMessageVO.setEmass(solrCheckedService.findReadList(solrEdcMessageVO.getEmass(), adminId));
			setReadYn(sq,adminId);
		}*/

		String serverTime = getServerTime();
		SearchHits<SolrEdcVO> resp = getList(sq);

		SolrEdcMessageVO solrEdcMessageVO = new SolrEdcMessageVO(resp, adminId);
		solrEdcMessageVO.setSearchTime(serverTime);
		solrEdcMessageVO.setExcuteQuery(sq.getQuery());
		solrEdcMessageVO.setEmass(new EmsReDefined(solrEdcMessageVO.getEmass(), readYn, consentNo, adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId)).reDefined(adminId, conf));

		if (readYn != null && readYn.isEmpty()) {
			//읽음 여부 필드 값 추가
			//solrEdcMessageVO.setEmass(solrCheckedService.findReadList(solrEdcMessageVO.getEmass(), adminId));
			/*	query += String.format("+checked.readId:%s", adminId);*/
		}

		sq.clear();
		return solrEdcMessageVO;
	}

	@Override
	public void setFeedback(final String msgId, final String ml_confd_feedback) throws ElasticsearchException, IOException {
		int feedBack = Common.nvz(ml_confd_feedback, 9);
		String index = "edc_w_" + (Common.nvl(msgId).substring(0, 6));
		Map<String, Object> params = new HashMap<>();
		params.put("feedback", feedBack);


		IndexCoordinates indexCoordinates = IndexCoordinates.of(index);
		operation.update(
				UpdateQuery.builder(msgId)
						.withScriptType(org.springframework.data.elasticsearch.core.ScriptType.INLINE)
						.withScript("ctx._source.ml_confd_feedback = params.feedback")
						.withLang("painless")
						.withParams(params)
						.withAbortOnVersionConflict(true)
						.withDocAsUpsert(false)
						.build(), indexCoordinates
		);
	}


	//SK 하이닉스 비밀여부, 비밀 확률 solr update 로직
	@Override
	public boolean setSecretInfo(final String sourceKey, final String securityYn, final String securityPct, final Map<String, List<parseJsonFile>> sortList) throws SolrServerException, IOException {
		return false;
	}


	@Override
	public List<SolrEdcVO> setOverlap(List<SolrEdcVO> solrVo) throws SolrServerException, IOException {
		List<SolrEdcVO> result = new ArrayList<>();

		//조회 된 결과에서 중복 데이터 제거
		List<SolrEdcVO> emass = solrVo.stream().filter(distinctBykey(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());
		//조회 결과에서 중복되는 데이터만 추출
		List<SolrEdcVO> allOverlap = solrVo.stream().filter(distinctBykey2(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());

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

		return result;
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

	private static String modifyQuery(String inputQuery) {
		StringBuilder modifiedQuery = new StringBuilder();

		String[] tokens = inputQuery.split("\\s+");

		modifiedQuery.append(tokens[0]);

		for (int i = 1; i < tokens.length; i++) {
			String token = tokens[i];

			String modifiedToken = "(" + token + ")";

			modifiedQuery.append(" ");
			modifiedQuery.append(modifiedToken);
		}
		return modifiedQuery.toString();
	}


	private void setReadYn(SolrQuery sq, String adminId) {
		String query = "";
		query += String.format("+checked.readId:%s", adminId);
		sq.addFilterQuery(query);
	}

	@Override
	public void setAuthoritys(SolrQuery sq, String adminId) {
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
		//
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
				if (StringUtils.compare(first.getSvcNm(), second.getSvcNm()) > 0) {
					ret = 1;
				}
				if (StringUtils.compare(first.getSvcNm(), second.getSvcNm()) == 0) {
					if (StringUtils.compare(first.getSubject(), second.getSubject()) > 0) {
						ret = 1;
					} else if (StringUtils.compare(first.getSubject(), second.getSubject()) == 0) {
						if (StringUtils.compare(first.getSender(), second.getSender()) > 0) {
							ret = 1;
						} else if (StringUtils.compare(first.getSender(), second.getSender()) == 0) {
							ret = 0;
						} else if (StringUtils.compare(first.getSender(), second.getSender()) < 0) {
							ret = -1;
						}
					} else if (StringUtils.compare(first.getSubject(), second.getSubject()) < 0) {
						ret = -1;
					}
				}
				if (StringUtils.compare(first.getSvcNm(), second.getSvcNm()) < 0) {
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

	@Override
	public String[] getExistIndics(String msgId, String format) {
		String[] indics = new String[2];
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");
		LocalDate ld = YearMonth.parse(msgId.substring(0, 6), formatter).atDay(1);

		if (operation.indexOps(IndexCoordinates.of(format.concat(ld.format(formatter)))).exists()) indics[0] = format.concat(ld.format(formatter));
		if (operation.indexOps(IndexCoordinates.of(format.concat(ld.format(formatter)))).exists()) indics[1] = format.concat(ld.minusMonths(1).format(formatter));
		return indics;
	}


	public static Map<Date, List<parseJsonFile>> groupingByMlFeedbackTime(List<parseJsonFile> feedbackList) {
		return feedbackList.stream().collect(Collectors.groupingBy(parseJsonFile::getMlFeedbackTime));
	}

	private Map<String, List<parseJsonFile>> groupingBySecurityYn(List<parseJsonFile> ChangefeedbackList) {
		return ChangefeedbackList.stream().collect(Collectors.groupingBy(parseJsonFile::getSecurityYn));
	}

	@Override
	public List<SolrEdcVO> getCheckedList(List<SolrEdcVO> solrVo) {
		List<SolrEdcVO> result = new ArrayList<>();

		//조회 된 결과에서 중복 데이터 제거
		List<SolrEdcVO> emass = solrVo.stream().filter(distinctBykey(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());
		//조회 결과에서 중복되는 데이터만 추출
		List<SolrEdcVO> allOverlap = solrVo.stream().filter(distinctBykey2(SolrEdcVO::getSvcNm, SolrEdcVO::getSubject, SolrEdcVO::getSender)).collect(Collectors.toList());

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

		return result;
	}


	public void printCurrentIndexsNames(){
		try {
			RestHighLevelClient elsRestHighLevelClient = null;
			if(elsRestHighLevelClient == null) elsRestHighLevelClient  = elasticsearchConfig.elasticsearchClient();
			Request request = new Request("GET", "/_cat/indices?v");
			Response response = elsRestHighLevelClient.getLowLevelClient().performRequest(request);
			// 응답 본문을 문자열로 변환
			String responseBody = EntityUtils.toString(response.getEntity());
			log.info("{}",responseBody);
		}catch (IOException e){
			log.info("{}",e);
		}
	}

//		@Override
//		public void getCurIdx() {
//				org.springframework.data.elasticsearch.core.query.Query searchQuery = new NativeSearchQueryBuilder()
//								.withQuery(QueryBuilders.queryStringQuery("*:*"))
//								.withTrackTotalHits(true)
//								.withTimeout(Duration.ofSeconds(100)).build();
//				IndexOperations indexoperations = operation.indexOps(IndexCoordinates.of("test*"));
//				log.info("테스트 {}",operation.search(searchQuery, SolrEdcVO.class, indexoperations.getIndexCoordinates()).getTotalHits());
//		}

// 스크립트 쿼리 (백업용)
//		ScriptQueryBuilder scriptQueryBuilder = null;
//		if(!Common.isEmpty(sq.get("sizeFilter"))) {
//			 scriptQueryBuilder = QueryBuilders.scriptQuery(new Script(ScriptType.INLINE, "painless", sq.get("sizeFilter"), Collections.emptyMap(), Collections.emptyMap()));
//			complateQuery.filter(scriptQueryBuilder);
//		}

//		//highlight 설정
//		HighlightBuilder highlightBuilder = new HighlightBuilder().preTags("<highlight>").postTags("</highlight>");
//		highlightBuilder.field(s);


}
