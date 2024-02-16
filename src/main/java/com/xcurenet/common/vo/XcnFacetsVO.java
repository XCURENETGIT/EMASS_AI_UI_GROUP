package com.xcurenet.common.vo;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.google.gson.Gson;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import lombok.Data;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedLongTerms;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedStats;
import org.elasticsearch.search.aggregations.metrics.ParsedSum;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class XcnFacetsVO {

	private JSONArray jArray = new JSONArray();
	private List<String> column = new ArrayList<>();



	public XcnFacetsVO(SolrEdcMessageVO edc) {
		this(edc, 0);
	}


	@SuppressWarnings("unchecked")
	public XcnFacetsVO(SolrEdcMessageVO edc,int columnCount) {
		setColumn(columnCount);

		String mainKey = getMainKey(edc.getFacets());
		ElasticsearchAggregations facets = edc.getFacets();
		if(facets != null) {

			Terms facetPivot = facets.aggregations().get(mainKey);
			if(facetPivot != null) {
				List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
				bucketList.stream().forEach(m -> bucketsSetting(m));
			}
		}
	}

	@SuppressWarnings("unchecked")
	protected <T> List<T> getList(T buckets) throws JsonParseException, JsonMappingException, IOException {
		Gson gson = new Gson();
		List<T> list = new ArrayList<T>();
		for (int i = 0; i < jArray.size(); i++) {
			list.add((T) gson.fromJson(jArray.getString(i), buckets.getClass()));
		}
		return list;
	}


	protected static @Data class Buckets {
		private String val;
		private String key;
		private int count;
	}

	private void setColumn(int columnCount) {
		int asciiForLowerA = 97;
		for (int i = 1; i < columnCount; i++, asciiForLowerA++) {
			column.add(String.valueOf((char)asciiForLowerA));
		}
	}


	@SuppressWarnings({"rawtypes", "unchecked"})
	private void bucketsSetting(Terms.Bucket bucket) {
		if(bucket.getAggregations() != null) {
			Aggregations aggs = bucket.getAggregations();
			List<Aggregation> aggsList = aggs.asList();
			for (Aggregation subaggs : aggsList) {
				jArray.add(parseFacetAggs(subaggs, bucket.getKeyAsString(), bucket.getDocCount()));
			}
		}
	}



	public JSONObject parseFacetAggs(Aggregation aggs,String headerKey,long docCount){
		JSONObject json = new JSONObject();
		if (aggs instanceof ParsedStringTerms) return   parsedStringTerms(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedStats) return parsedStats(aggs,headerKey);
		else if (aggs instanceof ParsedSum)  return parsedSum(aggs,headerKey,docCount);
		else if (aggs instanceof ParsedLongTerms) return  parsedLongTerms(aggs, headerKey, docCount);
		else return json;
	}

	List<Long> totalMax = new ArrayList<>();
	List<Long> totalSum = new ArrayList<>();
	List<Long> totalMin = new ArrayList<>();

	public JSONObject parseFacetAggs(Terms.Bucket bucket,String headerKey){
		Aggregations aggregations =	bucket.getAggregations();
		for(Aggregation aggs : aggregations) {
			if (aggs instanceof ParsedStats) return parsedStats(aggs,headerKey);
		}
		return null;
	}

	public JSONObject parsedLongTerms(Aggregation aggs,String headerKey,long docCount){
		/* 자유분석 */
		ParsedLongTerms bucketArgments = (ParsedLongTerms) aggs;
		if(bucketArgments.getBuckets().size() < 1) return null;
		JSONArray jsonArray = new JSONArray();
		JSONObject json = new JSONObject();
		if(!bucketArgments.getBuckets().get(0).getKeyAsString().equals(headerKey)) {


			totalMax = new ArrayList<>();
			totalSum = new ArrayList<>();
			totalMin = new ArrayList<>();
			for (Terms.Bucket arg : bucketArgments.getBuckets()) {
				jsonArray.add(parseFacetAggs(arg, arg.getKeyAsString()));
			}
			json.put("val", headerKey);
			json.put("count", docCount);

			long tSum = totalSum.stream().mapToLong(m -> m).sum();
			json.put("sum", totalSum.stream().mapToLong(m -> m).sum());
			json.put("avg", (tSum / totalSum.size()));
			json.put("max", Collections.max(totalMax));
			json.put("min", Collections.max(totalMin));
			json.put("buckets", jsonArray);
		}else{
			return parseFacetAggs(bucketArgments.getBuckets().get(0), bucketArgments.getBuckets().get(0).getKeyAsString());
		}

		return json;
	}

	public JSONObject parsedStringTerms(Aggregation aggs,String headerKey,long docCount){
		/* 자유분석 */
		ParsedStringTerms bucketArgments = (ParsedStringTerms) aggs;
		if(bucketArgments.getBuckets().size() < 1) return null;
		JSONArray jsonArray = new JSONArray();
		JSONObject json = new JSONObject();
		if(!bucketArgments.getBuckets().get(0).getKeyAsString().equals(headerKey)) {


			totalMax = new ArrayList<>();
			totalSum = new ArrayList<>();
			totalMin = new ArrayList<>();
			for (Terms.Bucket arg : bucketArgments.getBuckets()) {
				jsonArray.add(parseFacetAggs(arg, arg.getKeyAsString()));
			}
			json.put("val", headerKey);
			json.put("count", docCount);

			long tSum = totalSum.stream().mapToLong(m -> m).sum();
			json.put("sum", totalSum.stream().mapToLong(m -> m).sum());
			json.put("avg", (tSum / totalSum.size()));
			json.put("max", Collections.max(totalMax));
			json.put("min", Collections.max(totalMin));
			json.put("buckets", jsonArray);
		}else{
			return parseFacetAggs(bucketArgments.getBuckets().get(0), bucketArgments.getBuckets().get(0).getKeyAsString());
		}

		return json;
	}

	public JSONObject parsedStats(Aggregation aggs,String headerKey){
		ParsedStats bucketArgments = (ParsedStats) aggs;
		JSONObject json = new JSONObject();
		json.put("val",headerKey);
		json.put("count",bucketArgments.getCount());

		totalMax.add((long) bucketArgments.getMax());
		totalSum.add((long) bucketArgments.getSum());
		totalMin.add((long) bucketArgments.getMin());

		json.put("sum",(long)bucketArgments.getSum());
		json.put("avg",(long) bucketArgments.getAvg());
		json.put("max",(long)bucketArgments.getMax());
		json.put("min",(long)bucketArgments.getMin());
		return json;
	}


	public JSONObject parsedSum(Aggregation aggs,String headerKey,long docCount){
		ParsedSum bucketArgments = (ParsedSum) aggs;
		JSONObject json = new JSONObject();
		json.put("val",headerKey);
		json.put("count",(int) docCount);
		json.put("key",null);
		json.put("size",((long) bucketArgments.getValue()));
		return json;
	}

	public String getMainKey(ElasticsearchAggregations elasticsearchAggregations){
		if(elasticsearchAggregations == null) return "";
		Aggregations mainAggregations = elasticsearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());
		return mainKey;
	}

}
