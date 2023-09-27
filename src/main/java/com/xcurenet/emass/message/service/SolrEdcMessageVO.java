package com.xcurenet.emass.message.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.FacetField.Count;
import org.apache.solr.client.solrj.response.PivotField;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.util.NamedList;
import org.apache.solr.common.util.SimpleOrderedMap;
import org.springframework.util.SystemPropertyUtils;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
public class SolrEdcMessageVO {

	private long numFound;
	private List<SolrEdcVO> emass;
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

	public SolrEdcMessageVO(final QueryResponse resp) throws SolrServerException, IOException {
		this(resp, null);
	}

	@SuppressWarnings({"unchecked", "rawtypes"})
	public SolrEdcMessageVO(final QueryResponse resp, final String adminId) throws SolrServerException, IOException {
		this.numFound = resp.getResults().getNumFound();
		this.emass = resp.getBeans(SolrEdcVO.class);
		this.setPivot(resp);
		this.setFacet(resp);
		this.setFacetQuery(resp);
		if (resp.getResponse().get("facets") != null) {
			this.setFacets((SimpleOrderedMap) resp.getResponse().get("facets"));
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
		List<Count> values = field.getValues();
		if (values == null) return;
		facet = new ArrayList<FacetVO>();
		for (Count count : values) {
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

	private void setPivot(final QueryResponse resp) {
		NamedList<List<PivotField>> facetPivot = resp.getFacetPivot();
		
		if (facetPivot == null) return;
		if (facetPivot.size() == 0) return;

		Map<String, Object> keys = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		List<PivotField> yFields = facetPivot.getVal(0);
		for (PivotField yPivotField : yFields) {
			Map<String, Object> item = new HashMap<String, Object>();
			String svcChk = yPivotField.getField().toString();
			
			if (svcChk.equals("svc12") || svcChk.equals("svc")) {
				item.put("svc", yPivotField.getValue().toString());
				item.put("svcNm", svcDeepNm(yPivotField.getValue().toString()));
				item.put("svcLv12Nm", svcLv12GroupNm(yPivotField.getValue().toString()));
				item.put("svcLv1Nm", svcLv1Nm(yPivotField.getValue().toString()));
				item.put("svcLv2Nm", svcLv2Nm(yPivotField.getValue().toString()));
			}

			item.put("rowKey", yPivotField.getValue());
			if (Common.isOrEquals(yPivotField.getField(), "user_str", "sender_str", "userid")) {
				item.put("rowName", Config.getUserName(Common.nvl(yPivotField.getValue())));
			}
			item.put("total", yPivotField.getCount());
			List<PivotField> xFields = yPivotField.getPivot();
			if (xFields != null) {
				for (PivotField xPivotField : xFields) {
					item.put(Common.nvl(xPivotField.getValue()), xPivotField.getCount());
					keys.put(Common.nvl(xPivotField.getValue()), 0);
					/*
					 * String chksvc = xPivotField.getField().toString();
					 * if(chksvc.equals("svc")) {
					 * keys.put(svcNm(xPivotField.getValue().toString()), 0); }
					 * else { keys.put(Common.nvl(xPivotField.getValue()), 0); }
					 */
				}
			}
			result.add(item);
		}
		
		List<String> list = new ArrayList<String>(keys.keySet());
		Collections.sort(list);
		this.pivotHeader = list;
		this.pivotData = result;
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
	
}
