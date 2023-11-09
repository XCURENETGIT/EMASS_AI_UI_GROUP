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
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.util.SimpleOrderedMap;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.MultiBucketsAggregation;
import org.elasticsearch.search.aggregations.bucket.histogram.ParsedDateHistogram;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Data
public class EmassIntegrated {

    private long numFound;
    private List<?> emass;
    private List<String> pivotHeader;
    private List<Map<String, Object>> pivotData;

    /* ---- 아직 엘라스틱 서치용으로 분석&개발 안됨 ---*/
    private List<String> facetHeader;
    private List<Map<String, Object>> facetData;
    private List<FacetVO> facet;
    private int facetQueryData;
    private SimpleOrderedMap<Object> facets;
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
    public EmassIntegrated(final Map<String,Object> responseMap) throws IOException {
        this(responseMap, null);
    }

    public EmassIntegrated(final Map<String,Object> responseMap, final String adminId) throws  IOException {
        if(responseMap == null) return;

        /* response 파싱 */
        List<Emass> result = new ArrayList<>();
        if(responseMap.get("searchResponse") == null) return;
        SearchResponse searchResponse = (SearchResponse) responseMap.get("searchResponse");
        searchResponse.getHits();

        SearchHit[] hits = searchResponse.getHits().getHits();
        ObjectMapper mapper = new ObjectMapper();
        for (SearchHit hit : hits) {
            Map<String, Object> map = hit.getSourceAsMap();
            if (map.size() > 0) {
                map.put("_id",hit.getId());
                result.add(mapper.convertValue(map, Emass.class));
            }
        }
       this.emass = result;
       this.total = searchResponse.getHits().getHits().length;

        if(responseMap.get("elsSearchParam") == null) return;
        ElasticSearchParam elsSearchParam = (ElasticSearchParam) responseMap.get("elsSearchParam");
       /* 통계 검색인 경우 pivot 계산 */
        String[] statisticSearchType = new String[]{ElasticSearchCommon.SEARCH_TYPE_STATISTIC,ElasticSearchCommon.SEARCH_TYPE_ANALYSIS};
        boolean isStatisticType =  Arrays.stream(statisticSearchType).anyMatch( s -> s.equals(elsSearchParam.getSearchType()));
        if(isStatisticType) {
            this.search_xAxis = elsSearchParam.getXAxis();
            this.search_yAxis = elsSearchParam.getYAxis();
            this.search_startDate = elsSearchParam.getStartDate();
            this.search_endDate = elsSearchParam.getEndDate();
            this.setPivot(searchResponse);
        }
    }


    private void setFacetQuery(final QueryResponse resp) {
        Map<String, Integer> facetQuery = resp.getFacetQuery();

        if(facetQuery == null || facetQuery.size() == 0) return;

        Iterator<String> keys = facetQuery.keySet().iterator();
        facetQueryData = facetQuery.get(keys.next());
    }

    private void setFacet(final QueryResponse resp) {
        List<FacetField> fields = resp.getFacetFields();
        if (fields == null) return;
        if (fields.size() == 0) return;
        FacetField field = fields.get(0);
        String chkSvc = field.getName();

        List<String> list = new ArrayList<String>();
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        Map<String, Object> item = new HashMap<String, Object>();
        List<FacetField.Count> values = field.getValues();
        if (values == null) return;
        facet = new ArrayList<FacetVO>();
        for (FacetField.Count count : values) {
            item.put(count.getName(), count.getCount());
            /*
             * Map<String, Object> item = new HashMap<String, Object>();
             * item.put("rowKey", count.getName()); item.put("count",
             * count.getCount());
             */
            list.add(count.getName());
            FacetVO facetVo = new FacetVO();
            if (chkSvc.equals("svc12")) {
                facetVo.setName(Config.getServiceLv12Nm(count.getName()));
                facetVo.setName2(count.getName());
            }

            else {
                facetVo.setName(count.getName());
                facetVo.setUserId(Common.nvl(Config.getUserId(count.getName())));
                facetVo.setName2(Common.nvl(Config.getUserName(count.getName())));
                facetVo.setConm(Common.nvl(Config.getUserConm(count.getName())));
                facetVo.setDeptnm(Common.nvl(Config.getUserDeptnm(count.getName())));
                facetVo.setJikgubnm(Common.nvl(Config.getUserJikgubnm(count.getName())));
                facetVo.setEmail(Common.nvl(Config.getUserEmail(count.getName())));
            }
            facetVo.setCount(count.getCount());
            facet.add(facetVo);
            // result.add(item);
        }
        item.put("total", resp.getResults().getNumFound());
        result.add(item);

        Collections.sort(list);
        Collections.sort(result, new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> first, Map<String, Object> second) {
                return ((String) first.get("rowKey")).compareTo((String) second.get("rowKey"));
            }
        });
        this.facetHeader = list;
        this.facetData = result;
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
            else if(ElasticSearchCommon.USER_ID.equals(xTypeFlag) && ElasticSearchCommon.PI.equals(yField)  ){
               // pi_code 패턴 관련
                Map<String, Object> keys = new HashMap();
                Terms results = aggregations.get(xTypeFlag);
                for (Terms.Bucket bucket : results.getBuckets()) {
                    if (Common.isEmpty(bucket.getAggregations().get(yField))) continue;
                         String rowName = Common.nvl(bucket.getKey()); // main aggregations Key는 유저 아이디
                         Terms argments = bucket.getAggregations().get(yField);
                    for (Terms.Bucket arg : argments.getBuckets()) {
                        Map<String, Object> item = new HashMap();
                        keys.put(ElasticSearchCommon.PI_PREFIX.concat(Common.nvl(arg.getKey())), 0); // pivot header 추가
                        item.put("rowName",rowName);
                        item.put("rowKey",Common.nvl(bucket.getKey()));
                        item.put(ElasticSearchCommon.PI_PREFIX.concat(Common.nvl(arg.getKey())), arg.getDocCount());
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
