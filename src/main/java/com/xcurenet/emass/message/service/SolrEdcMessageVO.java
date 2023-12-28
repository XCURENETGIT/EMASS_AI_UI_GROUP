package com.xcurenet.emass.message.service;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.locale.Prop;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.log4j.Log4j2;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.common.util.SimpleOrderedMap;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.range.ParsedRange;
import org.elasticsearch.search.aggregations.bucket.range.Range;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedLongTerms;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedSum;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Log4j2
@ToString
public class SolrEdcMessageVO {

	private long numFound;
	private List<SolrEdcVO> emass = new ArrayList<>();
	private List<String> pivotHeader;
	private List<Map<String, Object>> pivotData;
	private List<String> facetHeader;
	private List<Map<String, Object>> facetData;
	private List<FacetVO> facet;

	@Getter
	@Setter
	private int facetQueryData;

	@Getter
	@Setter
	private SimpleOrderedMap<Object> facets;

	@Getter
	@Setter
	private String excuteQuery;

	@Getter
	@Setter
	private String searchTime;

	public SolrEdcMessageVO() throws SolrServerException, IOException {
	}

	public SolrEdcMessageVO(final SearchHits<SolrEdcVO> resp) throws SolrServerException, IOException {
		this(resp, null);
	}

	@SuppressWarnings({"unchecked", "rawtypes"})
	public SolrEdcMessageVO(final SearchHits<SolrEdcVO> resp, final String adminId) throws SolrServerException, IOException {
		this.numFound = resp.getTotalHits();
		resp.getSearchHits().stream().map(SearchHit::getContent).forEach(s -> {
			s.setReadYn(isRead(s.getChecked(), adminId) ? "Y" : "N");
			this.emass.add(s);
		});
		this.setFacet(resp);
		this.setPivot(resp);
//		this.setFacetQuery(resp);
//		if (resp.getAggregations() != null) {
//		if (resp.getAggregations() != null) {
//			this.setFacets((SimpleOrderedMap) resp.getAggregations());
//		}
	}

	private boolean isRead(final List<Map<String, Object>> checked, final String adminId) {
		if (checked == null) return false;
		for (Map<String, Object> item : checked) {
			if (Common.isEquals(item.get("readId"), adminId)) return true;
		}
		return false;
	}

	private void setFacetQuery(final SearchHits<SolrEdcVO> resp) {
//		Map<String, Integer> facetQuery = resp.getFacetQuery();
//
//		if(facetQuery == null || facetQuery.size() == 0) return;
//
//		Iterator<String> keys = facetQuery.keySet().iterator();
//		facetQueryData = facetQuery.get(keys.next());
	}

	private void setFacet(final SearchHits<SolrEdcVO> resp) {
		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		if(elasticSearchAggregations == null) return;

		//main aggregations key 출력
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());

		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key
		if (null == facetPivot || facetPivot.getBuckets().size() == 0 ) return;
		if( facetPivot.getBuckets().get(0).getAggregations().asList().size() >= 1) return; // sub aggregations 1개이상경우 return (통계 검색)
		String chkSvc = mainKey;

		List<String> list = new ArrayList<String>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> item = new HashMap<String, Object>();
		facet = new ArrayList<FacetVO>();
		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
		Aggregations subAggs = null;
		if(null != bucketList && bucketList.size() >= 1) subAggs = bucketList.get(0).getAggregations(); // sub Aggregations 여부

		if(null == subAggs || subAggs.asList().size() == 0) {
			for (Terms.Bucket bucket : bucketList) {
				String bucketKey = bucket.getKeyAsString();
				long docCount = bucket.getDocCount();
				item.put(bucketKey, docCount);
				list.add(bucketKey);
				facetParse(chkSvc, bucketKey, docCount);
			}
		} else {
			// subAggregations 존재 (통계)
			for(Terms.Bucket bucket : bucketList){
				Aggregations aggs = bucket.getAggregations();
				List<Aggregation> aggsList = aggs.asList();
				for(Aggregation subaggs :  aggsList) {
					if(subaggs instanceof ParsedStringTerms) {
						String headerKey = bucket.getKeyAsString();
						long docCount = bucket.getDocCount();
						ParsedStringTerms bucketArgments = (ParsedStringTerms) subaggs;
						for (Terms.Bucket arg : bucketArgments.getBuckets()) {
							String buckeyKey = arg.getKeyAsString();
							list.add(headerKey);
							facetParse(chkSvc, buckeyKey, docCount);
						}
					}
					else if(subaggs instanceof ParsedLongTerms){
						String headerKey = bucket.getKeyAsString();
						long docCount = bucket.getDocCount();
						ParsedLongTerms bucketArgments = (ParsedLongTerms) subaggs;
						for (Terms.Bucket arg : bucketArgments.getBuckets()) {
							String buckeyKey = arg.getKeyAsString();
							list.add(headerKey);
							facetParse(chkSvc, buckeyKey, docCount);
						}
					}else if(subaggs instanceof ParsedRange){
						ParsedRange bucketArgments = (ParsedRange) subaggs;
						String headerKey = bucket.getKeyAsString();
						long docCount = bucket.getDocCount();
						for (Range.Bucket arg : bucketArgments.getBuckets()) {
							String buckeyKey = arg.getKeyAsString();
							list.add(headerKey);
							facetParse(chkSvc, buckeyKey, docCount);
						}
					}else if(subaggs instanceof ParsedSum){
						ParsedSum bucketArgments = (ParsedSum) subaggs;
						String headerKey = bucket.getKeyAsString();
						long docCount = bucket.getDocCount();
						String buckeyKey = bucketArgments.getName();
						list.add(headerKey);
						facetParse(chkSvc, buckeyKey, docCount);
					}
				}
			}

		}

		item.put("total", resp.getTotalHits());
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

	public void facetParse(String chkSvc,String bucketKey,long docCount){
		FacetVO facetVo = new FacetVO();
		if (chkSvc.equals("svc12")) {
			facetVo.setName(Config.getServiceLv12Nm(bucketKey));
			facetVo.setName2(bucketKey);
		} else {
			facetVo.setName(bucketKey);
			facetVo.setUserId(Common.nvl(Config.getUserId(bucketKey)));
			facetVo.setName2(Common.nvl(Config.getUserName(bucketKey)));
			facetVo.setConm(Common.nvl(Config.getUserConm(bucketKey)));
			facetVo.setDeptnm(Common.nvl(Config.getUserDeptnm(bucketKey)));
			facetVo.setJikgubnm(Common.nvl(Config.getUserJikgubnm(bucketKey)));
			facetVo.setEmail(Common.nvl(Config.getUserEmail(bucketKey)));
		}
		facetVo.setCount(docCount);
		facet.add(facetVo);
	}



	private void setPivot(final SearchHits<SolrEdcVO> resp) {
		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		if(elasticSearchAggregations == null) return;


		//main aggregations key 출력
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());

		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key
		if (null == facetPivot ) return;
		Map<String, Object> keys = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		if(facetPivot.getBuckets().size() >= 1 ) {
			if (facetPivot.getBuckets().get(0).getAggregations().asList().size() == 0) return; // sub aggregations 0개인경우 return (메시지 검색)
			String svcChk = mainKey;
			List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
			Aggregations subAggs = null;
			if (null != bucketList && bucketList.size() >= 1)
				subAggs = bucketList.get(0).getAggregations(); // sub Aggregations 여부
			if (null == subAggs || subAggs.asList().size() == 0) {
				for (Terms.Bucket bucket : bucketList) {
					String bucketKey = bucket.getKeyAsString();
					long docCount = bucket.getDocCount();
					keys.put(Common.nvl(bucketKey), 0);
					result.add(pivotParse(svcChk, bucketKey, docCount));
				}
			} else {
				// subAggregations 존재 (통계)
				for (Terms.Bucket bucket : bucketList) {
					Map<String, Object> item = new HashMap<String, Object>();
					Aggregations aggs = bucket.getAggregations();
					List<Aggregation> aggsList = aggs.asList();
					for (Aggregation subaggs : aggsList) {
						if(subaggs instanceof ParsedStringTerms) {
							ParsedStringTerms bucketArgments = (ParsedStringTerms) subaggs;
							String buckeyKey = bucket.getKeyAsString();
							long docCount = bucket.getDocCount();
							for (Terms.Bucket arg : bucketArgments.getBuckets()) {
								item.put(Common.nvl(arg.getKeyAsString()), arg.getDocCount());
								keys.put(Common.nvl(arg.getKey()), 0);
								item.putAll(pivotParse(svcChk, buckeyKey, docCount));
							}
						}
						else if(subaggs instanceof ParsedLongTerms){
							ParsedLongTerms bucketArgments = (ParsedLongTerms) subaggs;
							String buckeyKey = bucket.getKeyAsString();
							long docCount = bucket.getDocCount();
							for (Terms.Bucket arg : bucketArgments.getBuckets()) {
								item.put(Common.nvl(arg.getKeyAsString()), arg.getDocCount());
								keys.put(Common.nvl(arg.getKey()), 0);
								item.putAll(pivotParse(svcChk, buckeyKey, docCount));
							}
						}
						else if(subaggs instanceof ParsedRange){
							ParsedRange bucketArgments = (ParsedRange) subaggs;
							String buckeyKey = bucket.getKeyAsString();
							long docCount = bucket.getDocCount();
							for (Range.Bucket arg : bucketArgments.getBuckets()) {
								item.put(Common.nvl(arg.getKeyAsString()), arg.getDocCount());
								keys.put(Common.nvl(arg.getKey()), 0);
								item.putAll(pivotParse(svcChk, buckeyKey, docCount));
							}
						}
						else if(subaggs instanceof ParsedSum){
							ParsedSum bucketArgments = (ParsedSum) subaggs;
							String buckeyKey = bucket.getKeyAsString();
							long docCount = bucket.getDocCount();
							item.put(Common.nvl(bucketArgments.getName()), bucketArgments.getValue());
							keys.put(Common.nvl(bucketArgments.getName()), 0);
							item.putAll(pivotParse(svcChk, buckeyKey, docCount));
						}



					}
					result.add(item);
				}

			}
		}
		List<String> list = new ArrayList<String>(keys.keySet());
		Collections.sort(list);
		this.pivotHeader = list;
		this.pivotData = result;

	}



	public Map<String, Object> pivotParse(String svcChk,String bucketKey,long docCount){
		Map<String, Object> item = new HashMap<String, Object>();
		if (svcChk.equals("svc12") || svcChk.equals("svc")) {
			item.put("svc", bucketKey);
			item.put("svcNm", svcDeepNm(bucketKey));
			item.put("svcLv12Nm", svcLv12GroupNm(bucketKey));
			item.put("svcLv1Nm", svcLv1Nm(bucketKey));
			item.put("svcLv2Nm", svcLv2Nm(bucketKey));
		}
		item.put("rowKey",  bucketKey);
		if (Common.isOrEquals( svcChk, "user_str", "sender_str", "userid", "userkey")) {
			item.put("rowName", Config.getUserName(Common.nvl(bucketKey)));
		}
		item.put("name", bucketKey);
		item.put("userId", Common.nvl(Config.getUserId(bucketKey)));
		item.put("name2", Common.nvl(Config.getUserName(bucketKey)));
		item.put("conm", Common.nvl(Config.getUserConm(bucketKey)));
		item.put("deptnm", Common.nvl(Config.getUserDeptnm(bucketKey)));
		item.put("jikgubnm", Common.nvl(Config.getUserJikgubnm(bucketKey)));
		item.put("email", Common.nvl(Config.getUserEmail(bucketKey)));
		item.put("total", docCount);
		return item;
	}



	public long getNumFound() {
		return numFound;
	}

	public void setNumFound(long numFound) {
		this.numFound = numFound;
	}

	public List<SolrEdcVO> getEmass() {
		return emass;
	}

	public void setEmass(List<SolrEdcVO> emass) {
		this.emass = emass;
	}

	public List<String> getPivotHeader() {
		return pivotHeader;
	}

	public void setPivotHeader(List<String> pivotHeader) {
		this.pivotHeader = pivotHeader;
	}

	public List<Map<String, Object>> getPivotData() {
		return pivotData;
	}

	public void setPivotData(List<Map<String, Object>> pivotData) {
		this.pivotData = pivotData;
	}

	public List<FacetVO> getFacet() {
		return facet;
	}

	public List<Map<String, Object>> getFacetData() {
		return facetData;
	}

	public void setFacetData(List<Map<String, Object>> facetData) {
		this.facetData = facetData;
	}

	public List<String> getFacetHeader() {
		return facetHeader;
	}

	public void setFacetHeader(List<String> facetHeader) {
		this.facetHeader = facetHeader;
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



//	private void pivotCalculator(SearchResponse searchResponse, ElasticSearchParam searchParam){
//		/* 통계 검색인 경우 pivot 계산 */
//		Aggregations aggregations = searchResponse.getAggregations();
//		if(null == aggregations || aggregations.getAsMap().size() == 0) return;
//
//		this.search_xAxis = Common.nvl(searchParam.getXAxis());
//		this.search_yAxis = Common.nvl(searchParam.getYAxis());
//		this.search_startDate = Common.nvl(searchParam.getStartDate());
//		this.search_endDate = Common.nvl(searchParam.getEndDate());
//		this.convertedXField = Config.getElsConvertField(search_xAxis);
//		this.convertedYField = Config.getElsConvertField(search_yAxis);
//		this.rowkey = Common.nvl(searchParam.getSearchParameters().get("rowKey"));
//
//		this.setPivot(aggregations);
//
//	}

//
//	private void dateCalculator(Terms results){
//		/* 시간 분류  */
//		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) results.getBuckets();
//		for (Terms.Bucket bucket : bucketList) {
//			Aggregations aggs = bucket.getAggregations();
//			List<Aggregation> aggsList = aggs.asList();
//			ParsedDateHistogram bucketArgments = (ParsedDateHistogram) aggsList.get(0); //subAggregations를 하나만 주고있어서 인덱스 0만 가져옴
//
//			/* data 관련 */
//			Map<String, Object> item = new HashMap();
//			for(Histogram.Bucket args : bucketArgments.getBuckets()){
//				String headerKey = convertTimeStr(args.getKeyAsString(),search_xAxis,true);
//				String headerStr = convertTimeStr(args.getKeyAsString(),search_xAxis,false);
//				item.put("rowKey", bucket.getKeyAsString());
//				item.put(headerStr, args.getDocCount());
//				headerKeys.put(headerStr,!Common.isEmpty(headerKey) ? Integer.parseInt(headerKey) : 0 );
//			}
//			item.put("total",bucket.getDocCount());
//			pivotResult.add(item);
//		}
//		List<Map.Entry<String,Integer>> keyList = new LinkedList<>(headerKeys.entrySet());
//		keyList.sort(Map.Entry.comparingByValue());
//		sortedHeaderList = keyList.stream().map( k -> k.getKey()).collect(Collectors.toList());
//
//	}
//
//	private void etcCalculator(Terms results){
//		/* 시간 분류 외 (회사,사업장,부서,직급,서비스) */
//		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) results.getBuckets();
//
//		for (Terms.Bucket bucket : bucketList) {
//			Aggregations aggs = bucket.getAggregations();
//			List<Aggregation> aggsList = aggs.asList();
//			ParsedStringTerms bucketArgments = (ParsedStringTerms) aggsList.get(0);
//			Map<String, Object> item = new HashMap();
//			for (Terms.Bucket arg : bucketArgments.getBuckets()) {
//				headerKeys.put(arg.getKeyAsString(), 0); // pivot header 추가
//				item.put("rowKey", bucket.getKeyAsString());
//				item.put(arg.getKeyAsString(), arg.getDocCount());
//			}
//			item.put("total",bucket.getDocCount());
//			pivotResult.add(item);
//
//		}
//		List<Map.Entry<String,Integer>> keyList = new LinkedList<>(headerKeys.entrySet());
//		sortedHeaderList = keyList.stream().map( k -> k.getKey()).collect(Collectors.toList());
//
//	}
//
//	public List reCalculator(){
//		List<Map<String, Object>> pivotDataList = new ArrayList<>();  // 최종 pivot 데이터
//		int idx = 0;
//		for (Map<String, Object> tempPivot : pivotResult) {
//			Map<String, Object> tempMap = new HashMap<>();
//			for (String header : sortedHeaderList) {
//				/* header 세팅*/
//				String headerKey = header;
//				if (!Common.isEmpty(tempPivot.get(header))) {
//					Long Value = Common.nvn(tempPivot.get(header));
//					tempMap.put(headerKey, Value);
//				} else {
//					tempMap.put(headerKey, 0L);
//				}
//			}
//			/* 중복 rowKey 체크  #############################################################*/
//			Map<String, Object> oldMap = null;
//			if ((oldMap = checkRowKey(pivotDataList, Common.nvl(tempPivot.get("rowKey")))) != null) {
//				int target = Common.nvz(oldMap.get("idx"));
//				tempMap.putAll(summaryMap(oldMap, tempMap));
//				/* total 계산 */
//				pivotDataList.get(target).putAll(tempMap);
//				continue;
//			}
//			/* 중복 아닐시  #############################################################*/
//			tempMap.put("rowKey", Common.nvl(tempPivot.get("rowKey")));  // rowKey
//			tempMap.put("rowName", Config.analysisFlag(convertedYField,Common.nvl(tempPivot.get("rowKey")))); // rowName
//			tempMap.put("total", Common.nvl(tempPivot.get("total")));
//			pivotDataList.add(tempMap);
//			idx++;
//		}
//
//		List resultList = pivotDataList.stream().sorted(Comparator.comparingInt(m -> Integer.parseInt(m.get("total").toString()))).collect(Collectors.toList());
//		Collections.reverse(resultList);
//		return resultList;
//	}



	public  String convertTimeStr(String str,String flag,boolean key){
		if(Common.isEmpty(str)) return str;
		if (ElasticSearchCommon.CTIME_HH.equals(flag))  return  (key) ? str.substring(8, 10) : Prop.msg(ElasticSearchCommon.TIME_FORMAT.concat(str.substring(8, 10)));
		else if(ElasticSearchCommon.CTIME_YYYYMM.equals(flag))  return  (key) ? str.substring(0, 6) : Common.formatMonthStat(str.substring(0, 6));
		else if(ElasticSearchCommon.CTIME_YYYYMMDD.equals(flag))  return (key) ? str.substring(0, 8) : Common.formatDate(str.substring(0, 8));
		else return str;
	}




}
