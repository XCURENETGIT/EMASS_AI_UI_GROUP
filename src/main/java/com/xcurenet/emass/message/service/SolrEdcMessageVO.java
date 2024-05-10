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
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedSum;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.io.IOException;
import java.util.*;

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
		dataProc(resp,adminId); // 조회한 데이터 처리
		if(resp.getAggregations() != null) aggregationsProc( (ElasticsearchAggregations) resp.getAggregations());	// 집계 처리

	}




	private void dataProc(final SearchHits<SolrEdcVO> resp, final String adminId){
		for (SearchHit<SolrEdcVO> solrEdcVO : resp.getSearchHits()) {
			SolrEdcVO edcVO = solrEdcVO.getContent();
			edcVO.setReadYn(isRead(solrEdcVO.getContent().getChecked(), adminId) ? "Y" : "N");
			edcVO.setConfidence( (maxScore > 0) ? String.valueOf((solrEdcVO.getScore() / maxScore ) * 100) : "0"); //유사도 계산
			if(!Common.isEmpty(edcVO.getPi_amount())) {
				List<Map<String, Integer>> piList = edcVO.getPi_amount();
				Map<String, Integer> tempMap = new HashMap<>();
				for (Map<String, Integer> pimap : piList) {
					for(Map.Entry<String,Integer> item : pimap.entrySet()) {
						tempMap.put(item.getKey(),item.getValue());
					}
				}
				edcVO.setPiMap(tempMap);
			}
			//실시간 정규식 검색 전용 엘라스틱서치 highlight
//			Map<String,String> highLight = new HashMap<>();
//			Map<String, List<String>> highlightFields = solrEdcVO.getHighlightFields();
//			for(Map.Entry hlsItem :  highlightFields.entrySet()) {
//				List<String> itemList = (List<String>) hlsItem.getValue();
//				highLight.put((String) hlsItem.getKey(),itemList.stream().collect(Collectors.joining(",")));
//			}
//			edcVO.setRegexpHighlight(highLight);
//
			this.emass.add(edcVO);
		}
	}

	private void aggregationsProc(final ElasticsearchAggregations elasticsearchAggregations){
		this.setFacet(elasticsearchAggregations.aggregations());
		this.setPivot(elasticsearchAggregations.aggregations());
		tempDataClear();
		this.setFacets(elasticsearchAggregations);
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




	public void facetAggregationsParser(final String key,final Aggregations aggregations,final long docsCount){
		for (Map.Entry<String, Aggregation> aggsKey : aggregations.getAsMap().entrySet()) {
			Aggregation aggregation = aggregations.get(aggsKey.getKey());
			/* StringTerms */
			if (aggregation instanceof ParsedStringTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedStringTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					headerList.add(key);
					facetParse(bucket.getKeyAsString(), bucket.getDocCount());

				}
			}
			else if (aggregation instanceof ParsedLongTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedLongTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					headerList.add(key);
					facetParse(bucket.getKeyAsString(), bucket.getDocCount());
				}
			}
			else if (aggregation instanceof ParsedRange) {
				List<? extends Range.Bucket> buckets = ((ParsedRange) aggregation).getBuckets();
				Iterator<? extends Range.Bucket> iter = buckets.iterator();
				while (iter.hasNext()) {
					Range.Bucket bucket = iter.next();
					headerList.add(key);
					facetParse(bucket.getKeyAsString(), bucket.getDocCount());
				}
			} else if (aggregation instanceof ParsedSum) {
				ParsedSum sumAggs =  (ParsedSum) aggregation;
				headerList.add(key);
				facetParse( sumAggs.getName(),docsCount);

			}

		}
	}

	private void setFacet(final Aggregations aggregations){
		long facetTotal = 0;
		List<String> facetlist = new ArrayList<String>();
		List<Map<String, Object>> facetResult = new ArrayList<Map<String, Object>>();
		Map<String, Object> facetItem = new HashMap<String, Object>();
		headerList = new ArrayList();
		facet = new ArrayList<>();



		for (Map.Entry<String, Aggregation> aggsKey : aggregations.getAsMap().entrySet()) {
			facetChkSvc = aggsKey.getKey();
			Aggregation aggregation = aggregations.get(aggsKey.getKey());

			if (aggregation instanceof ParsedStringTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedStringTerms) aggregation).getBuckets();
				facetTotal = buckets.size();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					if (null != bucket.getAggregations() && bucket.getAggregations().asList().size() > 0 ) {
						facetAggregationsParser(bucket.getKeyAsString(),bucket.getAggregations(),bucket.getDocCount());
					}else{
						long docCount = bucket.getDocCount();
						String bucketKey = bucket.getKeyAsString();
						facetItem.put(bucketKey, docCount);
						facetlist.add(bucketKey);
						facetParse(bucketKey, docCount);
					}

				}

			}else{
				List<? extends Terms.Bucket> buckets = ((ParsedLongTerms) aggregation).getBuckets();
				facetTotal = buckets.size();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					if (null != bucket.getAggregations() && bucket.getAggregations().asList().size() > 0 ) {
						facetAggregationsParser(bucket.getKeyAsString(),bucket.getAggregations(),bucket.getDocCount());
					}else{
						long docCount = bucket.getDocCount();
						String bucketKey = bucket.getKeyAsString();
						facetItem.put(bucketKey, docCount);
						facetlist.add(bucketKey);
						facetParse(bucketKey, docCount);
					}

				}

			}
		}
		facetItem.put("total",facetTotal);
		facetResult.add(facetItem);

		Collections.sort(headerList);
		Collections.sort(facetResult, new Comparator<Map<String, Object>>() {
			@Override
			public int compare(Map<String, Object> first, Map<String, Object> second) {
				return ((String) first.get("rowKey")).compareTo((String) second.get("rowKey"));
			}
		});
		this.facetHeader = headerList;
		headerList = new ArrayList<>();
		this.facetData = facetResult;
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



	List<Map<String, Object>> pivotResult = new ArrayList<Map<String, Object>>();
	public void pivotAggregationsParser(final String key,final Aggregations aggregations,final long docsCount){
		for (Map.Entry<String, Aggregation> aggsKey : aggregations.getAsMap().entrySet()) {
			Aggregation aggregation = aggregations.get(aggsKey.getKey());
			/* StringTerms */
			if (aggregation instanceof ParsedStringTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedStringTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					pivotItem.put(Common.nvl(bucket.getKeyAsString()), bucket.getDocCount());
					pivotKeys.put(Common.nvl(bucket.getKey()), 0);
					pivotItem.putAll(pivotParse( key, docsCount));
//
//					log.info("pivotItem {} ",Common.nvl(bucket.getKeyAsString()), bucket.getDocCount());
//					log.info("pivotKey {} ",Common.nvl(bucket.getKey()), 0);
				}
			}
			else if (aggregation instanceof ParsedLongTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedLongTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					pivotItem.put(Common.nvl(bucket.getKeyAsString()), bucket.getDocCount());
					pivotKeys.put(Common.nvl(bucket.getKey()), 0);
					pivotItem.putAll(pivotParse(key, docsCount));
				}
			}
			else if (aggregation instanceof ParsedRange) {
				List<? extends Range.Bucket> buckets = ((ParsedRange) aggregation).getBuckets();
				Iterator<? extends Range.Bucket> iter = buckets.iterator();
				while (iter.hasNext()) {
					Range.Bucket bucket = iter.next();
					if (null != bucket.getAggregations()) {
					   Aggregations childBucket = bucket.getAggregations();
						   Aggregation childAggs = childBucket.get(aggsKey.getKey());
						   ParsedSum sumNucket = (ParsedSum) childAggs;
						if(sumNucket != null) {
							//개인정보 유출관계 분석 전용
						   pivotItem.put(Common.nvl(aggsKey.getKey()), sumNucket.getValue());
						   pivotKeys.put(Common.nvl(aggsKey.getKey()), 0);
						   pivotItem.putAll(pivotParse(key, (long) sumNucket.getValue()));
					   }else{
							// 일반 통계
						   pivotItem.put(Common.nvl(bucket.getKeyAsString()), bucket.getDocCount());
						   pivotKeys.put(Common.nvl(bucket.getKey()), 0);
						   pivotItem.putAll(pivotParse(key, docsCount));
					   }
					}else{
						// 일반 통계
						pivotItem.put(Common.nvl(bucket.getKeyAsString()), bucket.getDocCount());
						pivotKeys.put(Common.nvl(bucket.getKey()), 0);
						pivotItem.putAll(pivotParse(key, docsCount));
					}
				}
			} else if (aggregation instanceof ParsedSum) {
				ParsedSum bucketArgments = (ParsedSum) aggregation;
				pivotItem.put(Common.nvl(bucketArgments.getName()), bucketArgments.getValue());
				pivotKeys.put(Common.nvl(bucketArgments.getName()), 0);
				pivotItem.putAll(pivotParse( key, docsCount));
			}
		}
		pivotResult.add(pivotItem);
	}


	private void setPivot(final Aggregations aggregations) {

		headerList = new ArrayList();
		pivotKeys = new HashMap();

		for (Map.Entry<String, Aggregation> aggsKey : aggregations.getAsMap().entrySet()) {
			pivotChkSvc = aggsKey.getKey();
			Aggregation aggregation = aggregations.get(aggsKey.getKey());

			if (aggregation instanceof ParsedStringTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedStringTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					pivotItem = new HashMap();
					if (null != bucket.getAggregations() && bucket.getAggregations().asList().size() > 0 ) {
						pivotAggregationsParser(bucket.getKeyAsString(),bucket.getAggregations(), bucket.getDocCount());
					}else {
						String bucketKey = bucket.getKeyAsString();
						long docCount = bucket.getDocCount();
						pivotItem.put(Common.nvl(bucketKey), docCount);
						pivotKeys.put(Common.nvl(bucketKey), 0);
						pivotItem.putAll(pivotParse(bucketKey, docCount));
						pivotResult.add(pivotItem);
					}
				}
			}else{
				List<? extends Terms.Bucket> buckets = ((ParsedLongTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					pivotItem = new HashMap();
					if (null != bucket.getAggregations() && bucket.getAggregations().asList().size() > 0 ) {
						pivotAggregationsParser(bucket.getKeyAsString(),bucket.getAggregations(), bucket.getDocCount());
					}else {
						String bucketKey = bucket.getKeyAsString();
						long docCount = bucket.getDocCount();
						pivotItem.put(Common.nvl(bucketKey), docCount);
						pivotKeys.put(Common.nvl(bucketKey), 0);
						pivotItem.putAll(pivotParse(bucketKey, docCount));
						pivotResult.add(pivotItem);
					}

				}

			}

			headerList = new ArrayList<String>(pivotKeys.keySet());
			Collections.sort(headerList);
			this.pivotHeader = headerList;
			headerList = new ArrayList<>();
			this.pivotData = pivotResult;
		}
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



	public  String convertTimeStr(String str,String flag,boolean key){
		if(Common.isEmpty(str)) return str;
		if (ElasticSearchCommon.CTIME_HH.equals(flag))  return  (key) ? str.substring(8, 10) : Prop.msg(ElasticSearchCommon.TIME_FORMAT.concat(str.substring(8, 10)));
		else if(ElasticSearchCommon.CTIME_YYYYMM.equals(flag))  return  (key) ? str.substring(0, 6) : Common.formatMonthStat(str.substring(0, 6));
		else if(ElasticSearchCommon.CTIME_YYYYMMDD.equals(flag))  return (key) ? str.substring(0, 8) : Common.formatDate(str.substring(0, 8));
		else return str;
	}




}
