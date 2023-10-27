package com.xcurenet.emass.message.newService.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.elasticsearch.*;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.newService.EmsReDefined;
import com.xcurenet.emass.message.newService.EmsSearchService;
import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.service.MessengerGroupUserVO;
import com.xcurenet.emass.message.service.impl.parseJsonFile;
import com.xcurenet.emass.message.vo.emass.Emass;
import com.xcurenet.emass.message.vo.emass.EmassResponse;
import com.xcurenet.emass.message.vo.message.EdcMessage;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import lombok.extern.slf4j.Slf4j;
import org.apache.lucene.search.TotalHits;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.core.CountRequest;
import org.elasticsearch.client.core.CountResponse;
import org.elasticsearch.core.TimeValue;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.QueryStringQueryBuilder;
import org.elasticsearch.index.query.RangeQueryBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.histogram.DateHistogramInterval;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.sort.SortBuilder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;


@Slf4j
@Service("emsSearchService")
public class EmsSearchServiceImpl implements EmsSearchService {

    @Resource
    private AdminUserGroupService adminUserGroupService;


    @Resource
    private ConfigAdminService configAdminService;


    /* client */
    private final RestHighLevelClient client = new ElasticSearchConnection().getElasticSearchClient();

    @Override
    public ElsSearchResponse getList(Map<String,String> searchParam) throws IOException {
        String bodysnippet = "N"; // ?
        ElsSearchResponse elsSearchResponse = null;

        ElasticSearchQueryBuilder elsQueryBuilder = setQueryBuilder(searchParam);

        try {
            // 총 카운트 계산
     //       CountResponse countResponse = getTotalCount(elsQueryBuilder);
            TimeUtil.start(); // 검색 시간 측정
            SearchSourceBuilder searchSourceBuilder = initSearchSource(elsQueryBuilder);// Init SearchSourceBuilder
            SearchRequest searchRequest = new SearchRequest(elsQueryBuilder.getIndices()).source(searchSourceBuilder);
            SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
            TotalHits totalHits = searchResponse.getHits().getTotalHits();
            log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", totalHits.value, TimeUtil.print());

            elsSearchResponse = new ElsSearchResponse(searchResponse, totalHits.value,elsQueryBuilder);

        }catch (ElasticsearchException e){
            e.printStackTrace();
        }

        return elsSearchResponse;

    }

    @Override
    public EdcMessage getEmassMessage(Map<String,String> searchParam, String adminId) throws IOException {
        return getEmassMessage(searchParam, adminId, null, null);
    }


    @Override
    public EdcMessage getEmassMessage(Map<String,String> searchParam, String adminId, String readYn, String consentNo) throws IOException {

        if (Common.isNotEmpty(readYn) && Common.isNotEmpty(adminId)) {
            if (Common.isEquals(readYn, "Y")) {
             //   sq.addFilterQuery(String.format(JOIN_READ, adminId));
            } else {
            //   sq.addFilterQuery(String.format(JOIN_UNREAD, adminId));
            }
        }

        /* 추후 수정예정 =============================================*/

        /* admin snippet */
        List<ConfigAdminVO> conf = configAdminService.getConfAdminOption(adminId);
        String bodysnippetVal = "N";
        for (int i = 0; i < conf.size(); i++) {
            if (conf.get(i).getConfId().equals("body.snippet.sum.use")) {
                bodysnippetVal = conf.get(i).getVal();
                break;
            }
        }
        searchParam.put("bodysnippet", bodysnippetVal);
        setAuthoritys(searchParam, adminId);

        /* 추후 수정예정 =============================================*/

        /* 검색 */
        ElsSearchResponse elsSearchResponse = getList(searchParam);
        EdcMessage edcMessage = new EdcMessage(elsSearchResponse,adminId);

        /* 읽음 확인 관련*/
//        if (readYn != null && readYn.equals("")) {
//            edcMessage.setEmass(checkedService.findReadList((List<Emass>) edcMessage.getEmass(), adminId));
//        }
        
        /* response용 Data 재 빌드 */
        List<EmassResponse> emassResponse = new EmsReDefined((List<Emass>) edcMessage.getEmass(), readYn, consentNo, adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId)).reDefined(adminId, conf);
        edcMessage.setEmass(emassResponse);

        String serverTime = getServerTime();
        edcMessage.setSearchTime(serverTime);
        edcMessage.setExcuteQuery(elsSearchResponse.getElsQueryBuilder().getQuery());

        return edcMessage;
    }

    @Override
    public MessengerEdcGroupVO getMessengerGroupList(Map<String, String> searchParam, String adminId) throws IOException {
        return null;
    }

    @Override
    public MessengerEdcGroupVO getMessengerGroupList(Map<String, String> searchParam, String adminId, boolean detail) throws IOException {
        return null;
    }

    @Override
    public MessengerEdcGroupVO getMessengerGroupList(Map<String, String> searchParam, String adminId, boolean detail, boolean original) throws IOException {
        return null;
    }

    @Override
    public MessengerGroupUserVO getMessengerGroupUserList(Map<String, String> searchParam, String adminId) throws IOException {
        return null;
    }

    @Override
    public void setFeedback(String msgId, String ml_confd_feedback) throws IOException {

    }


    @Override
    public boolean setSecretInfo(String sourceKey, String securityYn, String doublSecurityPctStr, Map<String, List<parseJsonFile>> sortList) throws IOException {
        return false;
    }

    @Override
    public boolean updateSolrFeedbackData(List<parseJsonFile> feedbackList) {
        return false;
    }



    private <T> Predicate<T> distinctBykey(Function<? super T, ?>... keyExtractors) {
        final Map<List<?>, Boolean> seen = new ConcurrentHashMap<>();
        return t -> {
            final List<?> keys = Arrays.stream(keyExtractors).map(ke -> ke.apply(t)).collect(Collectors.toList());
            return seen.putIfAbsent(keys, true) == null;
        };
    }


    private void setAuthoritys(Map<String,String> searchParam, String adminId) {
//        if (Common.isNotEmpty(adminId)) {
//            String adminType = "S";
//            if (!Common.isOrEquals(adminId, "*")) {
//                adminType = adminServiceImpl.getAdmin(adminId).getAdminType();
//            }
//
//            String ceoReadYn = Config.getString("ceo.readyn");
//
//            if (Common.isEquals(adminType, "C")) {
//                sq.addFilterQuery("+ceo:Y");
//            } else if (!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y"))) {
//                sq.addFilterQuery("-ceo:Y");
//            }
//            sq.addFilterQuery("-svc:QEKH");
//            JSONObject param = new JSONObject();
//            param.put("adminId", adminId);
//            param.put("queryType", Config.getString("query.type", "A"));
//            List<AuthorityVO> authoritys = authorityService.getAdminAuthority(param);
//            for (AuthorityVO authority : authoritys) {
//                if (authority.getCnt() > 0) {
//                    sq.addFilterQuery(authority.getQuery());
//                }
//            }
//            if (log.isInfoEnabled()) {
//                StringBuilder sb = new StringBuilder();
//                if (sq.getFilterQueries() != null) {
//                    for (int i = 0; i < sq.getFilterQueries().length; i++) {
//                        sb.append(sq.getFilterQueries()[i]).append(" ");
//                    }
//                }
//            }
//        }
    }


    private String getServerTime() {
        try {
            return Common.getDateTimeFormat();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public CountResponse getTotalCount(ElasticSearchQueryBuilder elsQueryBuilder) throws IOException {
        CountResponse countResponse = null;
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
        sourceBuilder.query(QueryBuilders.queryStringQuery(elsQueryBuilder.getQuery()));

        CountRequest countRequest = new CountRequest();
        countRequest.indices(elsQueryBuilder.getIndices());
        countRequest.source(sourceBuilder);

        countResponse = client.count(countRequest,RequestOptions.DEFAULT);

        return countResponse;
    }

    /***
     * setQueryBuilder
     * @param elasticSearchQueryBuilder
     * @param searchParam
     */
    public ElasticSearchQueryBuilder setQueryBuilder(Map<String,String> searchParam) {

        ElasticSearchQuery elasticSearchQuery = new ElasticSearchQuery();

        /* sort 관련 */
        elasticSearchQuery.setSort("");
        List<SortBuilder<?>> sortBuilderList = elasticSearchQuery.getSortInfo();
        log.debug("[SORT] {}", sortBuilderList.stream().collect(Collectors.toList()));

        /* 검색 갯수 설정  */
        int offset = 0;
        int limit = 0;

        offset = Integer.parseInt(Common.nvl(searchParam.get("offset")));
        limit = Integer.parseInt(Common.nvl(searchParam.get("limit")));

        /* rowKey 존재할시 검색조건 추가 */
        if(!Common.isEmpty(searchParam.get("rowKey"))) elasticSearchQuery.setSearchQuery(Common.nvl(searchParam.get("rowKey")));

        /* 아무런 rowKey & colkey  조건이 없을시 */
        if(Common.isEmpty(searchParam.get("rowKey")) && Common.isEmpty(searchParam.get("colKey"))){
            limit = 0;
        }

        /* set Query */
        elasticSearchQuery.setQuery();

        /* 사용자 입력 검색어 없을시 전체 검색어를 넣어줌 */
        if(Common.isEmpty(elasticSearchQuery.getQuery())){
            elasticSearchQuery.setQuery(ElasticSearchCommon.ALL_SEARCH);
        }

        // Custom Query Builder (엘라스틱 서치 쿼리에 쓰기전 빌드)
        ElasticSearchQueryBuilder elsQueryBuilder = ElasticSearchQueryBuilder.builder()
                .indices(new String[]{ElasticSearchCommon.INDEX})
                .from(offset)
                .to(limit)
                .sorts(sortBuilderList)
                .searchFields(new String[]{"mail.sender.mail.keyword"})
                .query(elasticSearchQuery.getQuery())
                .includeFields(ElasticSearchCommon.SEARCH_FIELD)
                .searchAggregations(Common.nvl(searchParam.get("colKey")))
                .yAxis(Common.nvl(searchParam.get("yAxis").concat(ElasticSearchCommon.FIELD_SUFFIX)))
                .xAxis(Common.nvl(searchParam.get("xAxis")))
                .excludeFields(null)
                .searchParam(searchParam)
                .build();

        log.debug("[Fields] {}", ElasticSearchCommon.SEARCH_FIELD);
        log.debug("[SORT] : {}", elsQueryBuilder.getSorts());
        log.debug("[QUERY] {}", elsQueryBuilder.getQuery());


        return elsQueryBuilder;

    }


    /***
     *
     * @param elsQueryBuilder
     * @return
     */
    public SearchSourceBuilder initSearchSource(ElasticSearchQueryBuilder elsQueryBuilder){
        String colSearchType = "";
        SearchSourceBuilder searchSourceBuilder = null;

        String startDate = "";
        String endDate = "";

        String xAxis =  Common.nvl(elsQueryBuilder.getXAxis());
        String yAxis =  Common.nvl(elsQueryBuilder.getYAxis());

        /* 기간 범위 */
        startDate = Common.nvl(elsQueryBuilder.getSearchParam().get("startDate"));
        endDate = Common.nvl(elsQueryBuilder.getSearchParam().get("endDate"));


//        DateRangeAggregationBuilder dateRange = null;

        /* 집계화면에서의 디테일 검색인지 체크 */
//        if(!Common.isEmpty(elsQueryBuilder.getSearchParam().get("searched_xAxis"))) {
//            colSearchType =  elsQueryBuilder.getSearchParam().get("searched_xAxis");
//            if(!Common.isEmpty(ElasticSearchCommon.XFIELD.get(colSearchType))){
//                 dateRange = AggregationBuilders.dateRange(ElasticSearchCommon.CTIME).field(ElasticSearchCommon.CTIME).format("yyyyMMddHHmmss");
//                int hour = Common.nvz(elsQueryBuilder.getSearchAggregations().substring(0,2));
//
//                LocalDateTime from = ElasticSearchCommon.stringToDate(startDate);
//                LocalDateTime to = ElasticSearchCommon.stringToDate(endDate);
//                int diffDay = to.compareTo(from);
//
//                for(int d=0; d<=diffDay; d++){
//                   String fromStr =  ElasticSearchCommon.dateToString(from.withHour(hour));
//                   String toStr =  ElasticSearchCommon.dateToString(from.withHour(hour+1).minusSeconds(1));
//                   dateRange.addRange(fromStr,toStr);
//                   from = from.plusDays(1);
//                }
//                yAxis = "detail";
//            }
//        }

        RangeQueryBuilder rangeQuery = new RangeQueryBuilder(ElasticSearchCommon.CTIME).gte(startDate).lte(endDate);
        QueryStringQueryBuilder secondQuery = QueryBuilders.queryStringQuery(elsQueryBuilder.getQuery());


        /* 검색 대상 필드 존재시 추가 */
        String[] searchFields =  elsQueryBuilder.getSearchFields();
        if(searchFields != null && searchFields.length >= 1){
            for(String field : searchFields){
                secondQuery.field(field);
            }
        }

        /* 쿼리 merge */
        BoolQueryBuilder complateQuery = new BoolQueryBuilder()
              .filter(rangeQuery)
              .must(secondQuery);


        /* 빌드 */
        searchSourceBuilder = new SearchSourceBuilder()
                .from(elsQueryBuilder.getFrom())
                .size(elsQueryBuilder.getTo())
                .query(complateQuery)
                .fetchSource(elsQueryBuilder.getIncludeFields(), elsQueryBuilder.getExcludeFields())
                .sort(elsQueryBuilder.getSorts())
                .aggregation(initAggregation(yAxis,xAxis))
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

        switch (xAxis){
            case "ctime_hh" :  // 시간별  (1시간)
                aggregationBuilder = AggregationBuilders.dateHistogram(xfield).field(xfield).calendarInterval(DateHistogramInterval.hours(1));
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "ctime_yyyymmdd" :  // 일별 (1일)
                aggregationBuilder = AggregationBuilders.dateHistogram(xfield).field(xfield).calendarInterval(DateHistogramInterval.days(1));
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "ctime_yyyymm" : // 월별 (한달)
                aggregationBuilder = AggregationBuilders.dateHistogram(xfield).field(xfield).calendarInterval(DateHistogramInterval.MONTH);
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "businm" : // 사업장
                aggregationBuilder = AggregationBuilders.terms(xfield).field(xfield);
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "conm" :// 회사
                aggregationBuilder = AggregationBuilders.terms(xfield).field(xfield);
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "deptnm" : // 부서
                aggregationBuilder = AggregationBuilders.terms(xfield).field(xfield);
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "direction_svc" : // 수/발신
                aggregationBuilder = AggregationBuilders.terms(xfield).field(xfield);
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
            case "jikgubnm" : // 직급
                aggregationBuilder = AggregationBuilders.terms(xfield).field(xfield);
                aggregationBuilder.subAggregation(AggregationBuilders.terms(yAxis).field(yAxis));
                break;
        }
        return aggregationBuilder;
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
//                    .query(QueryBuilders.queryStringQuery(elsQueryBuilder.getQuery()))
//                    .fetchSource(elsQueryBuilder.getIncludeFields(), elsQueryBuilder.getExcludeFields())
//                    .sort(elsQueryBuilder.getSorts())
//                    .timeout(new TimeValue(60, TimeUnit.SECONDS));
//
//            if (searchAfter != null) searchSourceBuilder.searchAfter(searchAfter);
//
//            SearchRequest searchRequest = new SearchRequest(elsQueryBuilder.getIndices()).source(searchSourceBuilder);
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



}
