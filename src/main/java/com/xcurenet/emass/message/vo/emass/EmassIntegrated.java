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
import org.elasticsearch.search.aggregations.bucket.histogram.Histogram;
import org.elasticsearch.search.aggregations.bucket.histogram.ParsedDateHistogram;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
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
    private String convertedXField;
    private String convertedYField;
    private String search_startDate;
    private String search_endDate;

    private String rowkey;
    private Map<String,String> pivotHeader = new HashMap<>();
    private List<Map<String, Object>> pivotData;
    private  Map<String, Integer> headerKeys = new HashMap<>();
    private  List<String> sortedHeaderList = new ArrayList();
    List<Map<String, Object>> pivotResult = new ArrayList();


    public EmassIntegrated() throws IOException {}

    public EmassIntegrated(final SearchResponse searchResponse,final ElasticSearchParam searchParam) throws IOException {
        this(searchResponse,searchParam, null);
    }

    public EmassIntegrated(final SearchResponse searchResponse, final ElasticSearchParam searchParam, final String adminId) throws  IOException {
        if(null == searchResponse || null == searchParam) return;

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

        pivotCalculator(searchResponse,searchParam);
          //  this.setPivot(searchResponse);
        responseCheck();
    }

    private void responseCheck() {
        this.convertedXField = "";
        this.convertedYField = "";

    }


    private void setPivot(Aggregations aggregations) {
        Terms results = aggregations.get(search_yAxis);
        if(null == results) return;
        if(ElasticSearchCommon.CTIME.equals(convertedXField)) dateCalculator(results); //Yaxis 조건 시간 계산일시
        else etcCalculator(results);  // 그 외

        List dataList = reCalculator(); // 재 계산

        /* 헤더 관련 */
        if(sortedHeaderList.size() != 0) {
            for (String header : sortedHeaderList) {
                pivotHeader.put(header,Config.analysisFlag(convertedXField,header));
            }
        }else {
            this.pivotHeader = null;
        }
        this.pivotData = dataList;
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

    private void pivotCalculator(SearchResponse searchResponse,ElasticSearchParam searchParam){
        /* 통계 검색인 경우 pivot 계산 */
        Aggregations aggregations = searchResponse.getAggregations();
        if(null == aggregations || aggregations.getAsMap().size() == 0) return;

        this.search_xAxis = Common.nvl(searchParam.getXAxis());
        this.search_yAxis = Common.nvl(searchParam.getYAxis());
        this.search_startDate = Common.nvl(searchParam.getStartDate());
        this.search_endDate = Common.nvl(searchParam.getEndDate());
        this.convertedXField = Config.getElsConvertField(search_xAxis);
        this.convertedYField = Config.getElsConvertField(search_yAxis);
        this.rowkey = Common.nvl(searchParam.getSearchParameters().get("rowKey"));

        this.setPivot(aggregations);

    }


    private void dateCalculator(Terms results){
        /* 시간 분류  */
        List<Terms.Bucket> bucketList = (List<Terms.Bucket>) results.getBuckets();
        for (Terms.Bucket bucket : bucketList) {
            Aggregations aggs = bucket.getAggregations();
            List<Aggregation> aggsList = aggs.asList();
            ParsedDateHistogram bucketArgments = (ParsedDateHistogram) aggsList.get(0); //subAggregations를 하나만 주고있어서 인덱스 0만 가져옴

            /* data 관련 */
            Map<String, Object> item = new HashMap();
            for(Histogram.Bucket args : bucketArgments.getBuckets()){
                String headerKey = convertTimeStr(args.getKeyAsString(),search_xAxis,true);
                String headerStr = convertTimeStr(args.getKeyAsString(),search_xAxis,false);
                item.put("rowKey", bucket.getKeyAsString());
                item.put(headerStr, args.getDocCount());
                headerKeys.put(headerStr,!Common.isEmpty(headerKey) ? Integer.parseInt(headerKey) : 0 );
            }
            item.put("total",bucket.getDocCount());
            pivotResult.add(item);
        }
        List<Map.Entry<String,Integer>> keyList = new LinkedList<>(headerKeys.entrySet());
        keyList.sort(Map.Entry.comparingByValue());
        sortedHeaderList = keyList.stream().map( k -> k.getKey()).collect(Collectors.toList());

    }

    private void etcCalculator(Terms results){
        /* 시간 분류 외 (회사,사업장,부서,직급,서비스) */
        List<Terms.Bucket> bucketList = (List<Terms.Bucket>) results.getBuckets();

        for (Terms.Bucket bucket : bucketList) {
            Aggregations aggs = bucket.getAggregations();
            List<Aggregation> aggsList = aggs.asList();
            ParsedStringTerms bucketArgments = (ParsedStringTerms) aggsList.get(0);
            Map<String, Object> item = new HashMap();
            for (Terms.Bucket arg : bucketArgments.getBuckets()) {
                headerKeys.put(arg.getKeyAsString(), 0); // pivot header 추가
                item.put("rowKey", bucket.getKeyAsString());
                item.put(arg.getKeyAsString(), arg.getDocCount());
            }
            item.put("total",bucket.getDocCount());
            pivotResult.add(item);

        }
        List<Map.Entry<String,Integer>> keyList = new LinkedList<>(headerKeys.entrySet());
        sortedHeaderList = keyList.stream().map( k -> k.getKey()).collect(Collectors.toList());

    }

    public List reCalculator(){
        List<Map<String, Object>> pivotDataList = new ArrayList<>();  // 최종 pivot 데이터
        int idx = 0;
        for (Map<String, Object> tempPivot : pivotResult) {
            Map<String, Object> tempMap = new HashMap<>();
            for (String header : sortedHeaderList) {
                /* header 세팅*/
                String headerKey = header;
                if (!Common.isEmpty(tempPivot.get(header))) {
                    Long Value = Common.nvn(tempPivot.get(header));
                    tempMap.put(headerKey, Value);
                } else {
                    tempMap.put(headerKey, 0L);
                }
            }
            /* 중복 rowKey 체크  #############################################################*/
            Map<String, Object> oldMap = null;
            if ((oldMap = checkRowKey(pivotDataList, Common.nvl(tempPivot.get("rowKey")))) != null) {
                int target = Common.nvz(oldMap.get("idx"));
                tempMap.putAll(summaryMap(oldMap, tempMap));
                /* total 계산 */
                pivotDataList.get(target).putAll(tempMap);
                continue;
            }
            /* 중복 아닐시  #############################################################*/
            tempMap.put("rowKey", Common.nvl(tempPivot.get("rowKey")));  // rowKey
            tempMap.put("rowName", Config.analysisFlag(convertedYField,Common.nvl(tempPivot.get("rowKey")))); // rowName
            tempMap.put("total", Common.nvl(tempPivot.get("total")));
            pivotDataList.add(tempMap);
            idx++;
        }

        List resultList = pivotDataList.stream().sorted(Comparator.comparingInt(m -> Integer.parseInt(m.get("total").toString()))).collect(Collectors.toList());
        Collections.reverse(resultList);
        return resultList;
    }



    public  String convertTimeStr(String str,String flag,boolean key){
        if(Common.isEmpty(str)) return str;
        if (ElasticSearchCommon.CTIME_HH.equals(flag))  return  (key) ? str.substring(8, 10) : Prop.msg(ElasticSearchCommon.TIME_FORMAT.concat(str.substring(8, 10)));
        else if(ElasticSearchCommon.CTIME_YYYYMM.equals(flag))  return  (key) ? str.substring(0, 6) : Common.formatMonthStat(str.substring(0, 6));
        else if(ElasticSearchCommon.CTIME_YYYYMMDD.equals(flag))  return (key) ? str.substring(0, 8) : Common.formatDate(str.substring(0, 8));
        else return str;
    }




}
