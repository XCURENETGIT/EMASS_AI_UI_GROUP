package com.xcurenet.common.vo;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.google.gson.Gson;


import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import lombok.Data;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.solr.common.util.SimpleOrderedMap;

public class XcnFacetsVO {
	private JSONArray jArray = new JSONArray();
	private List<String> column = new ArrayList<>();

	public XcnFacetsVO(SolrEdcMessageVO edc) {
		this(edc, 0);
	}

	public XcnFacetsVO(SolrEdcMessageVO edc, int columnCount) {
		this(edc, "result", columnCount);
	}

	@SuppressWarnings("unchecked")
	public XcnFacetsVO(SolrEdcMessageVO edc, String name, int columnCount) {
		setColumn(columnCount);

		SimpleOrderedMap<Object> facets = edc.getFacets();
		if(facets != null) {
			SimpleOrderedMap<Object> map = (SimpleOrderedMap<Object>)facets.get(name);
			if(map != null) {
				List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List<SimpleOrderedMap<Object>>)map.get("buckets");
				for (SimpleOrderedMap<Object> simpleOrderedMap : simpleOrderedMapList) {
					jArray.add(bucketsSetting(simpleOrderedMap));
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


	@SuppressWarnings({"rawtypes", "unchecked"})
	private JSONObject bucketsSetting(SimpleOrderedMap<Object> simpleOrderedMap) {
		JSONObject json = new JSONObject();
		for(Map.Entry e : simpleOrderedMap) {
			Object value = e.getValue();
			if(this.column.contains(e.getKey())) {
				json.put("buckets", bucketsSetting((SimpleOrderedMap<Object>)e.getValue()).get("buckets"));
			} else if(value instanceof List) {
				List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List)value;
				JSONArray jsonArray = new JSONArray();
				for (SimpleOrderedMap<Object> simpleOrderedMap2 : simpleOrderedMapList) {
					jsonArray.add(bucketsSetting(simpleOrderedMap2));
				}
				json.put(e.getKey(), jsonArray);
			} else {
				if(value instanceof String || value instanceof Long || value instanceof Integer) {
					json.put(e.getKey(), value);
				} else {
					json.put(e.getKey(), Math.round((Double)value));
				}
			}
		}
		return json;
	}
}