package com.xcurenet.emass.message.vo.emass;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.elasticsearch.ElasticSearchParam;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.emass.message.service.FacetVO;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.MultiBucketsAggregation;
import org.elasticsearch.search.aggregations.bucket.histogram.ParsedDateHistogram;
import org.elasticsearch.search.aggregations.bucket.nested.Nested;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.TopHits;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
@Slf4j
@Data
public class EmassIntegrated {

    private long numFound;
    private List<?> emass;
    private List<String> pivotHeader;
    private List<Map<String, Object>> pivotData;
    private List<Emass> aggregationsData;

    /* ---- 아직 엘라스틱 서치용으로 분석&개발 안됨 ---*/
    private List<String> facetHeader;
    private List<Map<String, Object>> facetData;
    private List<FacetVO> facet;
    private int facetQueryData;
    /* ------------------------------------------*/

    private String excuteQuery;
    private String searchTime;

    /*----- 통계용 필드 -----*/
    /* 총 카운트 */
    private long total;
    private String search_xAxis;
    private String search_yAxis;
    private String search_startDate;
    private String search_endDate;


    public EmassIntegrated() throws IOException {}

    public EmassIntegrated(final SearchResponse searchResponse,final ElasticSearchParam searchParam) throws IOException {
        this(searchResponse,searchParam, null);
    }

    public EmassIntegrated(final SearchResponse searchResponse, final ElasticSearchParam searchParam, final String adminId) throws  IOException {
        if(searchResponse == null) return;
        if(searchParam == null) return;

        /* response 파싱 */
        List<Emass> result = new ArrayList<>();
        SearchHit[] hits = searchResponse.getHits().getHits();
        ObjectMapper mapper = new ObjectMapper();
        for (SearchHit hit : hits) {
            Map<String, Object> map = hit.getSourceAsMap();
            if (map.size() > 0) {
                map.put(ElasticSearchCommon.MSGID,hit.getId());
                result.add(mapper.convertValue(map, Emass.class));
            }
        }
       this.emass = result;
       this.total = searchResponse.getHits().getHits().length;

       /* 통계 검색인 경우 pivot 계산 */
        String[] statisticSearchType = new String[]{ElasticSearchCommon.SEARCH_TYPE_STATISTIC,ElasticSearchCommon.SEARCH_TYPE_ANALYSIS};
        boolean isStatisticType =  Arrays.stream(statisticSearchType).anyMatch( s -> s.equals(Common.nvl(searchParam.getSearchType())));
        if(isStatisticType) {
            this.search_xAxis =  Common.nvl(searchParam.getXAxis());
            this.search_yAxis = Common.nvl(searchParam.getYAxis());
            this.search_startDate = Common.nvl(searchParam.getStartDate());
            this.search_endDate = Common.nvl(searchParam.getEndDate());
            this.setPivot(searchResponse);
        }
    }


    private void setPivot(final SearchResponse searchResponse) {
             if(searchResponse == null) return;

            List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

            //aggregations
            Aggregations aggregations = searchResponse.getAggregations();
            if(aggregations.getAsMap().size() == 0 ) return;

            /* Pivot field 정의 #############################################################*/
            String xField = Common.nvl(search_xAxis);
            String xTypeFlag = (!Common.isEmpty(ElasticSearchCommon.XFIELD.get(xField))) ? ElasticSearchCommon.XFIELD.get(xField) : xField;
            String yField = Common.nvl(search_yAxis);


            /* Date 분류일 경우 #############################################################*/
            if (ElasticSearchCommon.CTIME.equals(xTypeFlag)) {
                Map<String, Integer> keys = new HashMap(); // 피벗 헤더 관련
                    ParsedDateHistogram results = aggregations.get(ElasticSearchCommon.CTIME);
                    for (MultiBucketsAggregation.Bucket bucket : results.getBuckets()) {
                        if (Common.isEmpty(bucket.getAggregations().get(yField))) continue;
                         Terms argments = bucket.getAggregations().get(yField);
                         String headerStr = "";
                         int headerValue = 0;

                        /* #######  시간분류일경우 Header 재 계산 ####### */
                        String timeStr = bucket.getKeyAsString();
                        /* Date 단위*/
                        switch (xField) {
                            case ElasticSearchCommon.CTIME_HH :         //  시간
                                headerStr =   Prop.msg(ElasticSearchCommon.TIME_FORMAT.concat(timeStr.substring(8, 10)));
                                headerValue = Integer.parseInt(timeStr.substring(8, 10));
                                break;
                            case ElasticSearchCommon.CTIME_YYYYMM :     // 월
                                headerStr = Common.formatMonthStat(timeStr.substring(0,6));
                                headerValue = Integer.parseInt(timeStr.substring(0,6));
                                break;
                            case ElasticSearchCommon.CTIME_YYYYMMDD:    // 일
                                headerStr = Common.formatDate(timeStr.substring(0,8));
                                headerValue = Integer.parseInt(timeStr.substring(0,8));
                                break;
                            default:
                                headerStr = timeStr;
                        }

                        /* ########################################### */
                         keys.put(headerStr,headerValue);    // pivot header 추가  ( xAxis 정보 일,월,시간...)
                        for (Terms.Bucket arg : argments.getBuckets()) {
                            Map<String, Object> item = new HashMap();
    //                    if(Common.isOrEquals("", "user_str", "sender_str", "userid")){
    //                        item.put("rowName", Config.getUserName(Common.nvl(arg.getKey())));
    //                    }
                            item.put("svc", arg.getKey().toString());
                            item.put("svcNm", svcDeepNm(arg.getKey().toString()));
                            item.put("svcLv12Nm", svcLv12GroupNm(arg.getKey().toString()));
                            item.put("svcLv1Nm", svcLv1Nm(arg.getKey().toString()));
                            item.put("svcLv2Nm", svcLv2Nm(arg.getKey().toString()));

                            item.put("rowKey", arg.getKey());
                            item.put(headerStr, arg.getDocCount());
                            /* PIVOT XAxis */
                            result.add(item);
                        }
                }
                List<Map.Entry<String,Integer>> keyList = new LinkedList<>(keys.entrySet());
                keyList.sort(Map.Entry.comparingByValue());
                List<String> headerList = keyList.stream().map( k -> k.getKey()).collect(Collectors.toList());
                this.pivotHeader = headerList;
            }
            else if(ElasticSearchCommon.USER_ID.equals(xTypeFlag) && ElasticSearchCommon.PI_ID.equals(yField)  ){
               // pi_code 패턴 관련
                Map<String, Object> keys = new HashMap();
                Terms results = aggregations.get("stat");

                for (Terms.Bucket bucket : results.getBuckets()) {
                    if (Common.isEmpty(bucket.getAggregations().get("nested_pi"))) continue;
                    Nested nestedPi = bucket.getAggregations().get("nested_pi");
                    Terms argments = nestedPi.getAggregations().get("stat2");

                    String rowName = Common.nvl(bucket.getKey()); // main aggregations Key는 유저 아이디
                    for (Terms.Bucket arg : argments.getBuckets()) {
                        Map<String, Object> item = new HashMap();
                        keys.put(ElasticSearchCommon.PI_PREFIX.concat(Common.nvl(arg.getKey())), 0); // pivot header 추가
                        item.put("rowName",rowName);
                        item.put("rowKey",Common.nvl(bucket.getKey()));

                        if(!arg.getKey().equals("EC")){
                            item.put(ElasticSearchCommon.PI_PREFIX.concat(Common.nvl(arg.getKey())), arg.getDocCount());
                        }
                        /* PIVOT XAxis */
                        result.add(item);
                    }
                }
                List<String> keyList = new ArrayList(keys.keySet());
                Collections.sort(keyList);
                this.pivotHeader = keyList;
            }


            else { /* 시간 분류 외 (사업장,부서 등등) #############################################################*/
                Map<String, Object> keys = new HashMap(); // 피벗 헤더 관련
                Terms results = aggregations.get(xTypeFlag);
                for (Terms.Bucket bucket : results.getBuckets()) {
                    if (Common.isEmpty(bucket.getAggregations().get(yField))) continue;
                    Terms argments = bucket.getAggregations().get(yField);
                    keys.put(Common.nvl(bucket.getKey()), 0); // pivot header 추가
                    for (Terms.Bucket arg : argments.getBuckets()) {
                        Map<String, Object> item = new HashMap();
//                        if(Common.isOrEquals(bucket, "user_str", "sender_str", "userid")){
//                            item.put("rowName", Config.getUserName(Common.nvl(arg.getKey())));
//                        }
                        item.put("rowKey", arg.getKey());
                        item.put(Common.nvl(bucket.getKey()), arg.getDocCount());
                        /* PIVOT XAxis */
                        result.add(item);
                    }
                }
                List<String> keyList = new ArrayList(keys.keySet());
                Collections.sort(keyList);
                this.pivotHeader = keyList;
            }


            /* pivotData 재 계산 #############################################################*/
            List<Map<String, Object>> pivotDataList = new ArrayList<>();  // 최종 pivot 데이터
            int idx = 0;
            for (Map<String, Object> tempPivotList : result) {
                int rowTotal = 0;
                Map<String, Object> tempMap = new HashMap<>();
                for (String header : this.pivotHeader) {
                    /* header 세팅*/
                    if (!Common.isEmpty(tempPivotList.get(header))) {
                        Long Value = Common.nvn(tempPivotList.get(header));
                        tempMap.put(header, Value);
                    } else {
                        tempMap.put(header, 0L);
                    }
                }
                /* 중복 rowKey 체크  #############################################################*/
                Map<String, Object> oldMap = null;
                if ((oldMap = checkRowKey(pivotDataList, Common.nvl(tempPivotList.get("rowKey")))) != null) {
                    int target = Common.nvz(oldMap.get("idx"));
                    tempMap.putAll(summaryMap(oldMap, tempMap));
                    rowTotal = tempMap.values().stream().collect(Collectors.summingInt(v1 -> Common.nvz(v1)));  // 합계 토탈
                    tempMap.put("total", rowTotal);
                    /* total 계산 */
                    pivotDataList.get(target).putAll(tempMap);
                    continue;
                }
                /* 중복 아닐시  #############################################################*/

                if(yField.equals("service.svc")) {
                    tempMap.put("svc", Common.nvl(tempPivotList.get("svc")));
                    tempMap.put("svcNm", Common.nvl(tempPivotList.get("svcNm")));
                    tempMap.put("svcLv12Nm", Common.nvl(tempPivotList.get("svcLv12Nm")));
                    tempMap.put("svcLv1Nm", Common.nvl(tempPivotList.get("svcLv1Nm")));
                    tempMap.put("svcLv2Nm", Common.nvl(tempPivotList.get("svcLv2Nm")));
                }
                tempMap.put("rowKey", Common.nvl(tempPivotList.get("rowKey")));
                tempMap.put("rowName", Common.nvl(tempPivotList.get("rowName")));
                tempMap.put("xAxisType", Common.nvl(tempPivotList.get("xAxisType")));
                rowTotal = tempMap.values().stream().collect(Collectors.summingInt(v1 -> Common.nvz(v1))); // 합계 토탈
                tempMap.put("total", rowTotal);
                pivotDataList.add(tempMap);
                idx++;
            }

            this.pivotData = pivotDataList;
        /*  ###################################################################################*/


    }


    /***
     *   // sub aggrations TopHitsAggregationBuilder 사용시 이 메서드 사용
     * @param searchResponse
     */
    public void setTopHitsAggsDocData(SearchResponse searchResponse){
        if(searchResponse == null) return;
        Aggregations aggregations = searchResponse.getAggregations();
        if(aggregations.getAsMap().size() == 0 ) return;

        List<Emass> result = new ArrayList();
        Map<String, Aggregation> aggregationsMap =  aggregations.getAsMap(); // 메인 aggs
        Map<String,Aggregations> groupAggsMap = new HashMap<>();  // 추출할 그룹 aggs
        //메인 Aggs의 sub Aggs 추출
        for(Map.Entry<String, Aggregation> map : aggregationsMap.entrySet()) {
                Aggregation agg =  map.getValue();
                Terms terms = aggregations.get(agg.getName());
                for(Terms.Bucket bucket : terms.getBuckets()){
                    groupAggsMap.put(bucket.getKeyAsString(),bucket.getAggregations());
                }
        }

        // sub Aggs에서 document 추출
        List<TopHits> topHitsList = new ArrayList<>();
        for(Map.Entry<String, Aggregations> groupAgg : groupAggsMap.entrySet()) {
            Aggregations groupAggs = groupAggsMap.get(groupAgg.getKey());
            Map<String, Aggregation> groupAggMap = groupAggs.getAsMap();
            for (Map.Entry<String, Aggregation> gMap  : groupAggMap.entrySet()) {
                Aggregation gAgg =  gMap.getValue();
                topHitsList.add(groupAggs.get(gAgg.getName()));
            }
        }

        // emass 데이터로 추출
        ObjectMapper mapper = new ObjectMapper();
        for(TopHits topHit : topHitsList){
            SearchHit[] hits  = topHit.getHits().getHits();
            for (SearchHit hit : hits) {
                Map<String, Object> map = hit.getSourceAsMap();
                if (map.size() > 0) {
                    map.put("_id",hit.getId());
                    result.add(mapper.convertValue(map, Emass.class));
                }
            }
        }
        this.emass = result;
    }


    public Map<String,Object> checkRowKey(List<Map<String,Object>> list,String rowKey){
        Map<String,Object> result = null;
        int idx = 0;
        for(Map<String,Object> map : list){
            if(rowKey.equals(Common.nvl(map.get("rowKey")))) {
                result = new HashMap<>();
                result.putAll(map);
                result.put("idx",idx);
                break;
            };
            idx++;
        }
        return result;
    }

    /***
     *  동일 키의 Value 합산
     * @param oldMap
     * @param newMap
     * @return
     */
    public Map<String,Object> summaryMap(Map<String,Object> oldMap,Map<String,Object> newMap){
        Map<String,Object> result = new HashMap<>();
        oldMap.forEach((k,v) -> {
            if(!Common.isEmpty(newMap.get(k))){
                Long oldValue = (Long) v;
                Long newValue = Common.nvn(newMap.get(k));
                Long sumValue = oldValue + newValue;
                result.put(k,sumValue);
            }
         });
        return result;
    }


    private String svcNm(String svc) {
        if (Common.isEmpty(svc)) return null;
        return Config.getServiceNm(svc);
    }

    private String svcDeepNm(String svc) {
        if (Common.isEmpty(svc)) return null;
        return Config.getServiceDeepNm(svc);
    }

    private String svcLv1Nm(String svc) {
        if (Common.isEmpty(svc)) return null;
        return Config.getServiceLv1Nm(svc);
    }

    private String svcLv2Nm(String svc) {
        if (Common.isEmpty(svc)) return null;
        return Config.getServiceLv2Nm(svc);
    }

//	private String svcLv12Nm(String svc) {
//		if (Common.isEmpty(svc)) return null;
//		return Config.getServiceLv12Nm(svc);
//	}

    private String svcLv12GroupNm(String svc) {
        if (Common.isEmpty(svc)) return null;
        return Config.getServiceLv12GroupNm(svc);
    }


    /* 총 카운트 */

    private void setTotalCount(final Long total) throws  IOException {
        this.total = total;
    }



}
