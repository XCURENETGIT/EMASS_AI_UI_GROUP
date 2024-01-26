package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.locale.Prop;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.log4j.Log4j2;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.range.ParsedRange;
import org.elasticsearch.search.aggregations.bucket.range.Range;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedLongTerms;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedTerms;
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

	@Getter
	private float maxScore;

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
	@JsonIgnore
	private ElasticsearchAggregations facets;

	@Getter
	@Setter
	private String excuteQuery;

	@Getter
	@Setter
	private String searchTime;


	@JsonIgnore private String facetChkSvc;
	@JsonIgnore private String pivotChkSvc;

	@JsonIgnore private List<String> headerList = new ArrayList<>();
	@JsonIgnore Map<String, Object> pivotItem = new HashMap<>();
	@JsonIgnore Map<String, Object> pivotKeys = new HashMap<>();


	public SolrEdcMessageVO() throws SolrServerException, IOException {
	}

	public SolrEdcMessageVO(final SearchHits<SolrEdcVO> resp) throws SolrServerException, IOException {
		this(resp, null);
	}

	@SuppressWarnings({"unchecked", "rawtypes"})
	public SolrEdcMessageVO(final SearchHits<SolrEdcVO> resp, final String adminId) throws SolrServerException, IOException {
		this.numFound = resp.getTotalHits();
		this.maxScore = resp.getMaxScore();
		for (SearchHit<SolrEdcVO> solrEdcVO : resp.getSearchHits()) {
			SolrEdcVO edcVO = solrEdcVO.getContent();
			edcVO.setReadYn(isRead(solrEdcVO.getContent().getChecked(), adminId) ? "Y" : "N");
			edcVO.setConfidence( (maxScore > 0) ? String.valueOf((solrEdcVO.getScore() / maxScore ) * 100) : "0"); //유사도 계산
			this.emass.add(edcVO);
		}

		this.setFacet(resp);
		this.setPivot(resp);

		tempDataClear();
//
//		this.setFacetQuery(resp);
		if (resp.getAggregations() != null) {
			this.setFacets((ElasticsearchAggregations) resp.getAggregations());
		}

	}

	private void tempDataClear(){
		this.facetChkSvc = null;
		this.pivotChkSvc = null;
		this.headerList =  new ArrayList<>();
		this.pivotItem =  new HashMap<>();
		this.pivotKeys =  new HashMap<>();
	}

	private boolean isRead(final List<Map<String, Object>> checked, final String adminId) {
		if (checked == null) return false;
		for (Map<String, Object> item : checked) {
			if (Common.isEquals(item.get("readId"), adminId)) return true;
		}
		return false;
	}

	private Object getScore(final List<Map<String, Object>> items, final String adminId) {
		for (Map<String, Object> item : items) {
			if (!Common.isEmpty(item.get("_score"))) return item.get("_score");
		}
		return null;
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
		if (elasticSearchAggregations == null) return;

		headerList = new ArrayList();

		//main aggregations key 출력
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());
		facetChkSvc = mainKey;

		long total = 0;
		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key

		if (null == facetPivot) return;
			 // sub aggregations 1개이상경우 return (통계 검색)
			List<String> list = new ArrayList<String>();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			Map<String, Object> item = new HashMap<String, Object>();
			total = facetPivot.getBuckets().size();

			facet = new ArrayList<FacetVO>();
			List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
			Aggregations subAggs = null;
			if (null != bucketList && bucketList.size() >= 1)
				subAggs = bucketList.get(0).getAggregations(); // sub Aggregations 존재 여부

			if (null == subAggs || subAggs.asList().size() == 0) {
				for (Terms.Bucket bucket : bucketList) {
					String bucketKey = bucket.getKeyAsString();
					long docCount = bucket.getDocCount();
					item.put(bucketKey, docCount);
					list.add(bucketKey);
					facetParse(bucketKey, docCount);
				}
			} else {
				// subAggregations 존재 (통계)
				for (Terms.Bucket bucket : bucketList) {
					Aggregations aggs = bucket.getAggregations();
					List<Aggregation> aggsList = aggs.asList();
					for (Aggregation subaggs : aggsList) {
						parseFacetAggs(subaggs,bucket.getKeyAsString(),bucket.getDocCount());
					}
				  }
			   }

		item.put("total",total);
		result.add(item);

		Collections.sort(headerList);
		Collections.sort(result, new Comparator<Map<String, Object>>() {
			@Override
			public int compare(Map<String, Object> first, Map<String, Object> second) {
				return ((String) first.get("rowKey")).compareTo((String) second.get("rowKey"));
			}
		});
		this.facetHeader = headerList;
		this.facetData = result;
	}

	public void facetParse(String bucketKey,long docCount){
		FacetVO facetVo = new FacetVO();
		if (facetChkSvc.equals("svc12")) {
			facetVo.setName(Config.getServiceLv12Nm(bucketKey));
			facetVo.setName2(bucketKey);
		}else{
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

		headerList = new ArrayList();

		//main aggregations key 출력
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());
		pivotChkSvc = mainKey;
		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key
		if (null == facetPivot ) return;
	 	 pivotKeys = new HashMap();

		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		if(facetPivot.getBuckets().size() >= 1 ) {
			if (facetPivot.getBuckets().get(0).getAggregations().asList().size() == 0) return; // sub aggregations 0개인경우 return (메시지 검색)

			List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
			Aggregations subAggs = null;
			if (null != bucketList && bucketList.size() >= 1)
				subAggs = bucketList.get(0).getAggregations(); // sub Aggregations 여부
			if (null == subAggs || subAggs.asList().size() == 0) {
				for (Terms.Bucket bucket : bucketList) {
					String bucketKey = bucket.getKeyAsString();
					long docCount = bucket.getDocCount();
					pivotKeys.put(Common.nvl(bucketKey), 0);
					result.add(pivotParse( bucketKey, docCount));
				}
			} else {
				// subAggregations 존재 (통계)
				for (Terms.Bucket bucket : bucketList) {
					pivotItem = new HashMap();
					Aggregations aggs = bucket.getAggregations();
					List<Aggregation> aggsList = aggs.asList();
					for (Aggregation subaggs : aggsList) {
						parsePivotAggs(subaggs,bucket.getKeyAsString(),bucket.getDocCount());
					}
					result.add(pivotItem);
				}

			}
		}
		headerList = new ArrayList<String>(pivotKeys.keySet());

		Collections.sort(headerList);
		this.pivotHeader = headerList;
		this.pivotData = result;

	}



	public Map<String, Object> pivotParse(String bucketKey,long docCount){
		Map<String, Object> item = new HashMap<String, Object>();
		if (pivotChkSvc.equals("svc12") || pivotChkSvc.equals("svc")) {
			item.put("svc", bucketKey);
			item.put("svcNm", svcDeepNm(bucketKey));
			item.put("svcLv12Nm", svcLv12GroupNm(bucketKey));
			item.put("svcLv1Nm", svcLv1Nm(bucketKey));
			item.put("svcLv2Nm", svcLv2Nm(bucketKey));
		}
		item.put("rowKey",  bucketKey);
		if (Common.isOrEquals( pivotChkSvc, "user_str", "sender_str", "userid", "userkey")) {
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


	/* facet aggregations 계산 전용 start */

	public void parseFacetAggs(Aggregation aggs,String headerKey,long docCount){
		if (aggs instanceof ParsedStringTerms) parsedStringTerms(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedLongTerms) parsedLongTerms(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedRange) parsedRange(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedSum) parsedSum(aggs,headerKey,docCount);
	}

	public void parsedStringTerms(Aggregation aggs,String headerKey,long docCount){
		ParsedStringTerms bucketArgments = (ParsedStringTerms) aggs;
		for (Terms.Bucket arg : bucketArgments.getBuckets()) {
			String buckeyKey = arg.getKeyAsString();
			headerList.add(headerKey);
			facetParse(buckeyKey, docCount);
		}
	}


	public void parsedLongTerms(Aggregation aggs,String headerKey,long docCount){
		ParsedLongTerms bucketArgments = (ParsedLongTerms) aggs;
		for (Terms.Bucket arg : bucketArgments.getBuckets()) {
			String buckeyKey = arg.getKeyAsString();
			headerList.add(headerKey);
			facetParse(buckeyKey, docCount);
		}
	}

	public void parsedRange(Aggregation aggs,String headerKey,long docCount){
		ParsedRange bucketArgments = (ParsedRange) aggs;
		for (Range.Bucket arg : bucketArgments.getBuckets()) {
			String buckeyKey = arg.getKeyAsString();
			headerList.add(headerKey);
			facetParse(buckeyKey, docCount);
		}
	}

	public void parsedSum(Aggregation aggs,String headerKey,long docCount){
		ParsedSum bucketArgments = (ParsedSum) aggs;
		String buckeyKey = bucketArgments.getName();
		headerList.add(headerKey);
		facetParse( buckeyKey, docCount);
	}

	/* facet aggregations 계산 전용 END */



	/* pivot aggregations 계산 전용 start */

	public void parsePivotAggs(Aggregation aggs,String headerKey,long docCount){
		if (aggs instanceof ParsedStringTerms) parsedStringTermsPivot(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedLongTerms) parsedLongTermsPivot(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedRange) parsedRangePivot(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedSum) parsedSumPivot(aggs,headerKey,docCount);
	}

	public void parsedStringTermsPivot(Aggregation aggs,String buckeyKey,long docCount){
		ParsedStringTerms bucketArgments = (ParsedStringTerms) aggs;
		for (Terms.Bucket arg : bucketArgments.getBuckets()) {
			pivotItem.put(Common.nvl(arg.getKeyAsString()), arg.getDocCount());
			pivotKeys.put(Common.nvl(arg.getKey()), 0);
			pivotItem.putAll(pivotParse( buckeyKey, docCount));
		}
	}


	public void parsedLongTermsPivot(Aggregation aggs,String buckeyKey,long docCount){
		ParsedLongTerms bucketArgments = (ParsedLongTerms) aggs;
		for (Terms.Bucket arg : bucketArgments.getBuckets()) {
			pivotItem.put(Common.nvl(arg.getKeyAsString()), arg.getDocCount());
			pivotKeys.put(Common.nvl(arg.getKey()), 0);
			pivotItem.putAll(pivotParse( buckeyKey, docCount));
		}
	}

	public void parsedRangePivot(Aggregation aggs,String buckeyKey,long docCount){
		ParsedRange bucketArgments = (ParsedRange) aggs;
		for (Range.Bucket arg : bucketArgments.getBuckets()) {
			pivotItem.put(Common.nvl(arg.getKeyAsString()), arg.getDocCount());
			pivotKeys.put(Common.nvl(arg.getKey()), 0);
			pivotItem.putAll(pivotParse( buckeyKey, docCount));
		}
	}

	public void parsedSumPivot(Aggregation aggs,String buckeyKey,long docCount){
		ParsedSum bucketArgments = (ParsedSum) aggs;
		pivotItem.put(Common.nvl(bucketArgments.getName()), bucketArgments.getValue());
		pivotKeys.put(Common.nvl(bucketArgments.getName()), 0);
		pivotItem.putAll(pivotParse( buckeyKey, docCount));
	}

	/* pivot aggregations 계산 전용 END */






	public  String convertTimeStr(String str,String flag,boolean key){
		if(Common.isEmpty(str)) return str;
		if (ElasticSearchCommon.CTIME_HH.equals(flag))  return  (key) ? str.substring(8, 10) : Prop.msg(ElasticSearchCommon.TIME_FORMAT.concat(str.substring(8, 10)));
		else if(ElasticSearchCommon.CTIME_YYYYMM.equals(flag))  return  (key) ? str.substring(0, 6) : Common.formatMonthStat(str.substring(0, 6));
		else if(ElasticSearchCommon.CTIME_YYYYMMDD.equals(flag))  return (key) ? str.substring(0, 8) : Common.formatDate(str.substring(0, 8));
		else return str;
	}


}
