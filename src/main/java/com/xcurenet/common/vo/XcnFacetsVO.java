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
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class XcnFacetsVO {
	private JSONArray jArray = new JSONArray();
	private List<String> column = new ArrayList<>();

	private int facetSize = 0;
	private int facetIdx = 0;



	public XcnFacetsVO(SolrEdcMessageVO edc) {
		this(edc, 0);
	}

	public XcnFacetsVO(SolrEdcMessageVO edc, int columnCount) {
		this(edc, "result", columnCount);
	}

	@SuppressWarnings("unchecked")
	public XcnFacetsVO(SolrEdcMessageVO edc, String name, int columnCount) {
		facetSize = edc.getFacets().aggregations().asList().size();

		ElasticsearchAggregations facets = edc.getFacets();
		if(facets != null) {
			Aggregations mainAggregations = facets.aggregations();
			Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
			String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());

			Terms facetPivot = facets.aggregations().get(mainKey);
			if(facetPivot != null) {
				List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
				for (Terms.Bucket bucket  : bucketList) {
					jArray.add(bucketsSetting(bucket));
				}
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



//	public void parsedLongTerms(Aggregation aggs,String headerKey,long docCount){
//		ParsedLongTerms bucketArgments = (ParsedLongTerms) aggs;
//		for (Terms.Bucket arg : bucketArgments.getBuckets()) {
//			String buckeyKey = arg.getKeyAsString();
//			headerList.add(headerKey);
//			facetParse(buckeyKey, docCount);
//		}
//	}
//
//	public void parsedRange(Aggregation aggs,String headerKey,long docCount){
//		ParsedRange bucketArgments = (ParsedRange) aggs;
//		for (Range.Bucket arg : bucketArgments.getBuckets()) {
//			String buckeyKey = arg.getKeyAsString();
//			headerList.add(headerKey);
//			facetParse(buckeyKey, docCount);
//		}
//	}
//
//	public void parsedSum(Aggregation aggs,String headerKey,long docCount){
//		ParsedSum bucketArgments = (ParsedSum) aggs;
//		String buckeyKey = bucketArgments.getName();
//		headerList.add(headerKey);
//		facetParse( buckeyKey, docCount);
//	}


	@SuppressWarnings({"rawtypes", "unchecked"})
	private JSONObject bucketsSetting(Terms.Bucket bucket) {
		if(null == bucket.getAggregations()) return null;
		JSONObject json = new JSONObject();

		Aggregations aggs = bucket.getAggregations();
		List<Aggregation> aggsList = aggs.asList();

		JSONArray jsonArray = new JSONArray();

		if(this.facetSize == this.facetIdx) {

		}else {
			for (Aggregation subaggs : aggsList) {
				jsonArray.add(parseFacetAggs(subaggs, bucket.getKeyAsString(), bucket.getDocCount()));
				facetIdx = facetIdx + 1;
			}
			json.put(bucket.getKey(), jsonArray);
		}

		return json;
	}


	public JSONObject parseFacetAggs(Aggregation aggs,String headerKey,long docCount){
		if (aggs instanceof ParsedStringTerms) return parsedStringTerms(aggs,headerKey,docCount);
		else return null;
	}


	public JSONObject parsedStringTerms(Aggregation aggs,String headerKey,long docCount){
		JSONObject json = new JSONObject();
		ParsedStringTerms bucketArgments = (ParsedStringTerms) aggs;
		for (Terms.Bucket arg : bucketArgments.getBuckets()) {
			String buckeyKey = arg.getKeyAsString();
			json.put(buckeyKey, docCount);
		}
		return json;
	}


}