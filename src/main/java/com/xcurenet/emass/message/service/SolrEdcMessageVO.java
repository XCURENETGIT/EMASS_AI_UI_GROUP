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
import org.elasticsearch.search.aggregations.bucket.filter.Filters;
import org.elasticsearch.search.aggregations.bucket.filter.ParsedFilter;
import org.elasticsearch.search.aggregations.bucket.filter.ParsedFilters;
import org.elasticsearch.search.aggregations.bucket.histogram.Histogram;
import org.elasticsearch.search.aggregations.bucket.range.ParsedRange;
import org.elasticsearch.search.aggregations.bucket.range.Range;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedLongTerms;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedSum;
import org.elasticsearch.search.aggregations.metrics.ParsedValueCount;
import org.elasticsearch.search.aggregations.metrics.ValueCount;
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
		float maxScore = resp.getMaxScore();
		for (SearchHit<SolrEdcVO> solrEdcVO : resp.getSearchHits()) {
			SolrEdcVO edcVO = solrEdcVO.getContent();
			edcVO.setReadYn(isRead(edcVO.getChecked(), adminId) ? "Y" : "N");
			edcVO.setConfidence((maxScore > 0) ? String.valueOf((solrEdcVO.getScore() / maxScore) * 100) : "0"); //유사도 계산

			//동적 필드 (패턴 pi..) 맵핑
			if (!Common.isEmpty(edcVO.getPi_amount())) {
				List<Map<String, Object>> piList = edcVO.getPi_amount();
				Map<String, Object> tempMap = new HashMap<>();
				for (Map<String, Object> pimap : piList) {
					for (Map.Entry<String, Object> item : pimap.entrySet()) {
						tempMap.put(item.getKey(), item.getValue());
					}
				}
				edcVO.setPiMap(tempMap);
			}
			this.emass.add(edcVO);
		}
	}

	private void aggregationsProc(final ElasticsearchAggregations elasticsearchAggregations){
		this.setFacet(elasticsearchAggregations.aggregations());
		this.setPivot(elasticsearchAggregations.aggregations());
		tempDataClear();
		this.setFacets(elasticsearchAggregations);

		if (Common.nvl(elasticsearchAggregations.aggregations().asMap().keySet().iterator().next()).indexOf(Common.ANALYSIS_GW_ATTACH_AGGS_SUFFIX) > -1) gwAttachedPivotParse(elasticsearchAggregations);
		else if (Common.nvl(elasticsearchAggregations.aggregations().asMap().keySet().iterator().next()).indexOf(Common.ANALYSIS_DASHBOARD_ATTACH_AGGS_SUFFIX) > -1) attachedDashboardPivotParse(elasticsearchAggregations);
		else if (Common.nvl(elasticsearchAggregations.aggregations().asMap().keySet().iterator().next()).indexOf(Common.ANALYSIS_DASHBOARD_WORK_AGGS_SUFFIX) > -1) getDashboardWorkPivotParse(elasticsearchAggregations);
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


	/**
	 * GroupWare pivot 첨부파일 전용 Parse
	 *
	 * @param elasticsearchAggregations
	 */
	private void gwAttachedPivotParse(ElasticsearchAggregations elasticsearchAggregations) {
		pivotResult = new ArrayList<Map<String, Object>>();
		headerList = new ArrayList();
		pivotKeys = new HashMap();

		Aggregations aggregations = elasticsearchAggregations.aggregations();
		for (Map.Entry<String, Aggregation> pivotAggs : aggregations.getAsMap().entrySet()) {
			Aggregation agg = pivotAggs.getValue();  // 집계 객체 (terms aggregation)
			if (agg instanceof Terms) {
				Terms termsAgg = (Terms) agg;
				Iterator<Terms.Bucket> iterator = (Iterator<Terms.Bucket>) termsAgg.getBuckets().iterator();
				while (iterator.hasNext()) {
					Terms.Bucket bucket = iterator.next();
					pivotItem = new HashMap();
					// 하위 집계 (Range Aggregation) 자동 처리
					Aggregations bucketAggregations = bucket.getAggregations();
					ValueCount countAgg = bucketAggregations.get("attachsize_count");
					Histogram histogramAgg = bucketAggregations.get("attachSizeSum_histogram");
					// Histogram.Bucket 순회
					Iterator<Histogram.Bucket> histIterator = (Iterator<Histogram.Bucket>) histogramAgg.getBuckets().iterator();
					while (histIterator.hasNext()) {
						Histogram.Bucket histBucket = histIterator.next();
						// 히스토그램의 구간 키값을 처리
						double doubleValue = Double.parseDouble(Common.nvl(histBucket.getKey()));
						String keyString = String.valueOf((int) doubleValue);
						pivotItem.put(Common.nvl(keyString), Common.nvz(histBucket.getDocCount(), 0));
						pivotItem = mergeMap(pivotItem, getRangeString(Common.nvl(keyString)), Common.nvz(histBucket.getDocCount(), 0));
						pivotKeys.put(getRangeString(Common.nvl(keyString)), 0);
						pivotItem.putAll(attachPivotParse(bucket.getKeyAsString(), Common.nvz(countAgg, 0)));

					}
					if (pivotItem.containsKey("rowKey")) {
						pivotResult.add(pivotItem);
					}
				}
			}
		}
		headerList = new ArrayList<String>(pivotKeys.keySet());
		Collections.sort(headerList);
		this.pivotHeader = headerList;
		headerList = new ArrayList<>();
		this.pivotData = pivotResult;
	}

	/**
	 * pivot Dashboard 첨부파일 전용 Parse
	 *
	 * @param elasticsearchAggregations
	 */
	private void attachedDashboardPivotParse(ElasticsearchAggregations elasticsearchAggregations) {
		headerList = new ArrayList();
		pivotKeys = new HashMap();

		Aggregations aggregations = elasticsearchAggregations.aggregations();
		for (Map.Entry<String, Aggregation> pivotAggs : aggregations.getAsMap().entrySet()) {
			Aggregation agg = pivotAggs.getValue();  // 집계 객체 (terms aggregation)
			if (agg instanceof Terms) {
				Terms termsAgg = (Terms) agg;
				Iterator<Terms.Bucket> iterator = (Iterator<Terms.Bucket>) termsAgg.getBuckets().iterator();
				while (iterator.hasNext()) {
					Terms.Bucket bucket = iterator.next();
					pivotItem = new HashMap();
					// 하위 집계 (Range Aggregation) 자동 처리
					Aggregations bucketAggregations = bucket.getAggregations();
					Iterator<Aggregation> aggIterator = bucketAggregations.iterator();
					while (aggIterator.hasNext()) {
						Aggregation subAgg = aggIterator.next();
						// Range 집계일 경우 처리
						if (subAgg instanceof Range) {
							Range rangeAgg = (Range) subAgg;
							// Range.Bucket 순회
							Iterator<Range.Bucket> rangeIterator = (Iterator<Range.Bucket>) rangeAgg.getBuckets().iterator();
							while (rangeIterator.hasNext()) {
								Range.Bucket rangeBucket = rangeIterator.next();
								String keyString = rangeBucket.getKeyAsString().replace("_@at@", "");
								pivotItem.put(Common.nvl(keyString), Common.nvz(rangeBucket.getDocCount(), 0));
								pivotKeys.put(Common.nvl(keyString), 0);
								pivotItem.putAll(attachPivotParse(bucket.getKeyAsString(), Common.nvz(bucket.getDocCount(), 0)));
							}
						}
						pivotResult.add(pivotItem);
					}
				}
			}
		}
		headerList = new ArrayList<String>(pivotKeys.keySet());
		Collections.sort(headerList);
		this.pivotHeader = headerList;
		headerList = new ArrayList<>();
		this.pivotData = pivotResult;
	}

	private void getDashboardWorkPivotParse(ElasticsearchAggregations elasticsearchAggregations) {
		headerList = new ArrayList<>();
		pivotKeys = new HashMap<>();

		Aggregations aggregations = elasticsearchAggregations.aggregations();
		for (Map.Entry<String, Aggregation> entry : aggregations.getAsMap().entrySet()) {
			pivotChkSvc = entry.getKey().replace(Common.ANALYSIS_DASHBOARD_WORK_AGGS_SUFFIX, "");
			Aggregation agg = entry.getValue();

			if (!(agg instanceof ParsedFilters)) continue;

			ParsedFilters parsedFilters = (ParsedFilters) agg;
			for (ParsedFilters.ParsedBucket filterBucket : (List<ParsedFilters.ParsedBucket>) parsedFilters.getBuckets()) {
				String filterKey = filterBucket.getKeyAsString();
				Aggregations subAggs = filterBucket.getAggregations();
				if (subAggs == null) continue;

				ParsedStringTerms svc12Terms = subAggs.get("by_svc12");
				if (svc12Terms == null) continue;

				for (Terms.Bucket svc12Bucket : svc12Terms.getBuckets()) {
					pivotItem = new HashMap<>();
					String svc12Key = svc12Bucket.getKeyAsString();
					long count = svc12Bucket.getDocCount();

					pivotItem.put(Common.nvl(svc12Key), count);
					pivotItem.put("filterKey", filterKey);
					pivotKeys.put(Common.nvl(svc12Key), 0);
					pivotItem.putAll(pivotParse(svc12Key, count));
					pivotResult.add(pivotItem);
				}
			}
		}

		headerList = new ArrayList<>(pivotKeys.keySet());
		Collections.sort(headerList);
		this.pivotHeader = headerList;
		headerList = new ArrayList<>();
		this.pivotData = pivotResult;
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

			} else if (aggregation instanceof ParsedValueCount) {
			ParsedValueCount valueCount = (ParsedValueCount) aggregation;
			long count = valueCount.getValue();
			String key = valueCount.getName();
			facetItem.put(key, count);
			facetlist.add(key);
			facetParse(key, count);
			} else if (aggregation instanceof ParsedFilters) {
				ParsedFilters parsedFilters = (ParsedFilters) aggregation;
				List<? extends Filters.Bucket> buckets = parsedFilters.getBuckets();
				facetTotal = buckets.size();
				for (Filters.Bucket bucket : buckets) {
					String bucketKey = bucket.getKeyAsString();
					long docCount = bucket.getDocCount();
					if (null != bucket.getAggregations() && bucket.getAggregations().asList().size() > 0) {
						facetAggregationsParser(bucketKey, bucket.getAggregations(), docCount);
					} else {
						facetItem.put(bucketKey, docCount);
						facetlist.add(bucketKey);
						facetParse(bucketKey, docCount);
					}
				}

			}
			else{
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

		if(headerList.size() == 0 && facetlist.size() > 0){
			headerList.addAll(facetlist);
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
			facetVo.setSabun(Common.nvl(Config.getUserSabun(bucketKey)));
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
				// 일반 통계
				pivotItem.put(Common.nvl(bucket.getKeyAsString()), bucket.getDocCount());
				pivotKeys.put(Common.nvl(bucket.getKey()), 0);
				pivotItem.putAll(pivotParse(key, docsCount));
				}
			}
			else if (aggregation instanceof ParsedSum) {
				ParsedSum bucketArgments = (ParsedSum) aggregation;
				pivotItem.put(Common.nvl(bucketArgments.getName()), bucketArgments.getValue());
				pivotKeys.put(Common.nvl(bucketArgments.getName()), 0);
				pivotItem.putAll(pivotParse( key, docsCount));
			}
			else if(aggregation instanceof ParsedFilter) {
				/*개인정보 유출분석 전용 */
				pivotItem.put(Common.nvl(aggregation.getName()), ((ParsedFilter) aggregation).getDocCount());
				pivotKeys.put(Common.nvl(aggregation.getName()), 0);
				pivotItem.putAll(pivotParse(key, docsCount));
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
			}else if (aggregation instanceof ParsedValueCount) {
				ParsedValueCount valueCount = (ParsedValueCount) aggregation;
				long count = valueCount.getValue(); // 집계된 개수를 가져옵니다

				Map<String, Object> pivotItem = new HashMap<>();

				pivotItem.put("name", valueCount.getName());
				pivotItem.put("count", count);

				// pivotResult에 추가
				pivotResult.add(pivotItem);

			} else if (aggregation instanceof ParsedFilters) {
				ParsedFilters parsedFilters = (ParsedFilters) aggregation;
				List<? extends Filters.Bucket> buckets = parsedFilters.getBuckets();
				for (Filters.Bucket bucket : buckets) {
					pivotItem = new HashMap();
					String bucketKey = bucket.getKeyAsString();
					long docCount = bucket.getDocCount();
					if (null != bucket.getAggregations() && bucket.getAggregations().asList().size() > 0) {
						pivotAggregationsParser(bucketKey, bucket.getAggregations(), docCount);
					} else {
						pivotItem.put(Common.nvl(bucketKey), docCount);
						pivotKeys.put(Common.nvl(bucketKey), 0);
						pivotItem.putAll(pivotParse(bucketKey, docCount));
						pivotResult.add(pivotItem);
					}
				}

			} else{
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

	public Map<String, Object> attachPivotParse(String bucketKey, long docCount) {
		Map<String, Object> item = new HashMap<String, Object>();
		item.put("rowKey", bucketKey);
		item.put("total", docCount);
		return item;
	}

	public String getRangeString(String bytes) {
		// 바이트 값을 받아서 int로 변환
		int byteValue = (int) Double.parseDouble(bytes);

		// 범위 정의 (바이트 단위)
		long[][] ranges = {
				{0, 10 * 1024 * 1024},             // 0MB ~ 10MB
				{11 * 1024 * 1024, 50 * 1024 * 1024},  // 11MB ~ 50MB
				{51 * 1024 * 1024, 100 * 1024 * 1024}, // 51MB ~ 100MB
				{101 * 1024 * 1024, 150 * 1024 * 1024}, // 101MB ~ 150MB
				{151 * 1024 * 1024, 200 * 1024 * 1024}, // 151MB ~ 200MB
				{201 * 1024 * 1024, Long.MAX_VALUE}  // 201MB 이상
		};

		// 범위 확인
		for (long[] range : ranges) {
			long minRange = range[0];
			long maxRange = range[1];

			if (byteValue >= minRange && byteValue <= maxRange) {
				// 범위 내에 있으면 MB로 변환 후 반환
				long minMB = minRange / (1024 * 1024);
				long maxMB = (maxRange == Long.MAX_VALUE) ? Long.MAX_VALUE : maxRange / (1024 * 1024);

				// 범위 키 생성
				if (maxMB == Long.MAX_VALUE) {
					return minMB + "MB~";
				} else {
					return minMB + "MB_" + maxMB + "MB";
				}
			}
		}
		// 범위에 맞는 값이 없으면 기본 값 반환
		return "Unknown range";
	}

	public static <K, V> Map<K, V> mergeMap(Map<K, V> map, K key, V value) {
		if (map == null) {
			map = new HashMap<>();
		}


		map.merge(key, value, (oldValue, newValue) -> {
			// 기존 값이 Integer 타입이면 덧셈을 수행
			if (oldValue instanceof Integer && newValue instanceof Integer) {
				return (V) Integer.valueOf((Integer) oldValue + (Integer) newValue);
			}

			return newValue;
		});

		return map;
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
		item.put("sabun", Common.nvl(Config.getUserSabun(bucketKey)));
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
