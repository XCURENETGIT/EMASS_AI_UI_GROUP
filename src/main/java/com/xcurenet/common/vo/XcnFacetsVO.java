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
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedSum;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;

import java.io.IOException;
import java.util.ArrayList;
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
				jArray.add(parsedSum(subaggs, bucket.getKeyAsString(), bucket.getDocCount()));
			}
		}
	}

	public JSONObject parsedSum(Aggregation aggs,String headerKey,long docCount){
		ParsedSum bucketArgments = (ParsedSum) aggs;
		JSONObject json = new JSONObject();
		json.put("val",headerKey);
		json.put("count",(int) docCount);
		json.put("key",bucketArgments.getName());
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