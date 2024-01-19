package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import lombok.ToString;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedCardinality;
import org.elasticsearch.search.aggregations.metrics.TopHits;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ToString
public class MessengerEdcGroupVO {

	private final static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private static long numFound;

	private long offset;

	private List<MessengerGroupVO> groups;

	public MessengerEdcGroupVO(final List<MessengerGroupVO> groups) {
		this.groups = groups;
	}

	public MessengerEdcGroupVO(final SearchHits<SolrEdcVO> resp) throws SolrServerException, IOException {
		this(resp, null, false);
	}

	public MessengerEdcGroupVO(final SearchHits<SolrEdcVO> resp, final String adminId) throws SolrServerException, IOException {
		this(resp, null, false);
	}

	public MessengerEdcGroupVO(final SearchHits<SolrEdcVO> resp, final String adminId, final boolean detail) throws SolrServerException, IOException {
		this(resp, null, false, false);
	}

	public MessengerEdcGroupVO(SearchHits<SolrEdcVO> resp, final String adminId, final boolean detail, final boolean original) throws SolrServerException, IOException {
		this.groups = new ArrayList<>();
		ObjectMapper mapper = new ObjectMapper(); //임시

		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		/* 집계쿼리 사용할때  */
		if (null != elasticSearchAggregations) {
			Aggregations mainAggregations = elasticSearchAggregations.aggregations();
			if (null == mainAggregations) return;

			Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
			Map<String, Aggregations> groupAggsMap = new HashMap<>();  // 추출할 그룹 aggs

			long total = 0;
			//메인 Aggs의 sub Aggs 추출
			for (Map.Entry<String, Aggregation> map : mainAggsMap.entrySet()) {
				Aggregation agg = map.getValue();
				String currentKey = map.getKey();

				if ("bucket_total".equals(currentKey)) {
					continue;
				}

				ParsedCardinality cardinality = mainAggregations.get("bucket_total");
				if (!Common.isEmpty(cardinality)) {
					/* 그룹 파싱만 */
					total = cardinality.getValue();
					if (agg instanceof Terms) {
						Terms terms = (Terms) agg;
						for (Terms.Bucket bucket : terms.getBuckets()) {
							groupAggsMap.put(bucket.getKeyAsString(), bucket.getAggregations());
						}
					}
					break;
				} else if (agg instanceof Terms) {
					/* 대화방 파싱 */
					Terms terms = (Terms) agg;
					for (Terms.Bucket bucket : terms.getBuckets()) {
						total = total + bucket.getDocCount();
						groupAggsMap.put(bucket.getKeyAsString(), bucket.getAggregations());
					}
				}
			}


			// sub Aggs에서 document 추출
			List<TopHits> topHitsList = new ArrayList<>();
			for (Map.Entry<String, Aggregations> groupAgg : groupAggsMap.entrySet()) {
				Aggregations groupAggs = groupAggsMap.get(groupAgg.getKey());
				Map<String, Aggregation> groupAggMap = groupAggs.getAsMap();
				for (Map.Entry<String, Aggregation> gMap : groupAggMap.entrySet()) {
					Aggregation gAgg = gMap.getValue();
					topHitsList.add(groupAggs.get(gAgg.getName()));
				}
			}

			for (TopHits topHits : topHitsList) {
				org.elasticsearch.search.SearchHit[] hits = topHits.getHits().getHits();
				for (SearchHit hit : hits) {
					Map<String, Object> map = hit.getSourceAsMap();
					if (!map.isEmpty()) {
						map.put("msgid", hit.getId());
						SolrEdcVO solrEdcVO = mapper.convertValue(map, SolrEdcVO.class);
						if (detail) this.groups.add(reDefinedDetail(solrEdcVO, adminId, original));
						else this.groups.add(reDefined(solrEdcVO, adminId, 0L));
					}
				}
			}
			this.numFound = total;
		} else { //집계쿼리 사용하지 않을때
			if (detail) {
				resp.getSearchHits().stream().map(org.springframework.data.elasticsearch.core.SearchHit::getContent).forEach(s -> {
					this.groups.add(reDefinedDetail(s, adminId, original));
				});
			} else {
				resp.getSearchHits().stream().map(org.springframework.data.elasticsearch.core.SearchHit::getContent).forEach(s -> {
					this.groups.add(reDefined(s, adminId, 0));
				});
			}
			this.numFound = resp.getTotalHits();
		}
	}

	/**
	 * 아이콘 메신저 그룹방 상세보기
	 *
	 * @param edc
	 * @return
	 */
	public static MessengerGroupVO reDefinedDetail(SolrEdcVO edc, String adminId, boolean original) {
		MessengerGroupVO solrGroupVO = new MessengerGroupVO();
		solrGroupVO.setMsgid(edc.getMsgid());
		solrGroupVO.setSvc(edc.getSvc());
		solrGroupVO.setReadYn(isRead(edc.getChecked(), adminId) ? "Y" : "N");
		solrGroupVO.setReadYn(edc.getReadYn());
		solrGroupVO.setSvc3(edc.getSvc3());
		solrGroupVO.setCtime(reCtime(edc.getCtime()));
		solrGroupVO.setAttached(edc.getAttached());
		if (edc.getAttachname() != null && edc.getAttachname().size() > 0) {
			solrGroupVO.setAttachname(Common.join(edc.getAttachname(), "|"));
			solrGroupVO.setAttachhash(Common.join(edc.getAttachhash(), "|"));
			solrGroupVO.setAttachtype(Common.join(edc.getAttachtype(), "|"));
			solrGroupVO.setAttachsize(Common.join_long(edc.getAttachsize(), "|"));
		}
		solrGroupVO.setMessage(getMessageDetail(edc, 0, original));
		solrGroupVO.setTitle(getSender(edc));
		solrGroupVO.setDeptNm(edc.getDeptnm());
		solrGroupVO.setBody_snippet(edc.getBody_snippet());
		solrGroupVO.setBusiNm(edc.getBusinm());
		solrGroupVO.setJikgubNm(edc.getJikgubnm());
		solrGroupVO.setSrcip(edc.getSrcip());
		solrGroupVO.setName(edc.getName());
		solrGroupVO.setReadYn("Y");
		solrGroupVO.setXrootmtr(edc.getXrootmtr());
		solrGroupVO.setUser(edc.getUser());
		solrGroupVO.setUserkey(edc.getUserkey());
		solrGroupVO.setSender(edc.getSender());
		solrGroupVO.setUsr_id(edc.getUsr_id());
		solrGroupVO.setUserid(edc.getUserid());
		solrGroupVO.setInside(edc.getInside());
		solrGroupVO.setDirection_svc(edc.getDirection_svc());
		solrGroupVO.setBody_snippet(edc.getBody_snippet());
		return solrGroupVO;
	}

	public static MessengerGroupVO reDefined(SolrEdcVO edc, String adminId, long msg_cnt) {
		MessengerGroupVO solrGroupVO = new MessengerGroupVO();
		solrGroupVO.setMsgid(edc.getMsgid());
		solrGroupVO.setSvc(edc.getSvc());
		solrGroupVO.setSvc3(edc.getSvc3());
		solrGroupVO.setReadYn(isRead(edc.getChecked(), adminId) ? "Y" : "N");
		solrGroupVO.setCtime(reCtime(edc.getCtime()));
		solrGroupVO.setAttached(edc.getAttached());
		solrGroupVO.setBody_snippet(edc.getBody_snippet());
		solrGroupVO.setAttachname(Common.join(edc.getAttachname(), ","));
		solrGroupVO.setAttachtype(Common.join(edc.getAttachtype(), ","));
		solrGroupVO.setAttachsize(Common.join_long(edc.getAttachsize(), ","));
		solrGroupVO.setXrootmtr(edc.getXrootmtr());
		if (edc.getRecvs() != null) solrGroupVO.setUser_cnt(edc.getRecvs().size() + 1);
		else solrGroupVO.setUser_cnt(1);
		solrGroupVO.setMessage(getMessage(edc));
		solrGroupVO.setTitle(getTitle(edc));
		solrGroupVO.setBusiNm(edc.getBusinm());
		solrGroupVO.setDeptNm(edc.getDeptnm());
		solrGroupVO.setJikgubNm(edc.getJikgubnm());
		solrGroupVO.setSrcip(edc.getSrcip());
		solrGroupVO.setName(edc.getName());
		solrGroupVO.setUser(edc.getUser());
		solrGroupVO.setUserkey(edc.getUserkey());
		solrGroupVO.setSender(edc.getSender());
		solrGroupVO.setUsr_id(edc.getUsr_id());
		solrGroupVO.setDirection_svc(edc.getDirection_svc());
		solrGroupVO.setInside(edc.getInside());
		solrGroupVO.setUserid(edc.getUserid());
		return solrGroupVO;
	}

	private static String getTitle(SolrEdcVO edc) {
		return edc.getXrootmtr();

	}

	private static String getMessage(SolrEdcVO edc) {
		String msg = getMessageDetail(edc, 200, false).replaceAll("\\r", "").replaceAll("\\n", "");
		return getSender(edc) + " : " + msg;
	}

	private static String getMessageDetail(SolrEdcVO edc, int cutLength, boolean original) {
		String result = Common.EMPTY;
		if (Common.isOrEquals(edc.getSvc3(), "C", "M")) {
			String body = Common.nvl(edc.getBody_snippet());
			if (cutLength > 0 && body.length() > cutLength) body = body.substring(0, cutLength);
			result = body;
		} else if (Common.isEquals(edc.getSvc3(), "F")) {
			result = Common.join(edc.getAttachname(), "\n");
			//if (Common.isNotEmpty(edc.getBody_snippet())) result += "\n" + edc.getBody_snippet();
		} else if (Common.isEquals(edc.getSvc3(), "J")) result = "[" + Prop.propFormat("common.messenger.join") + "]";
		else if (Common.isEquals(edc.getSvc3(), "L")) result = "[" + Prop.propFormat("common.messenger.leave") + "]";
		return original ? result : textParser(result);
	}

	private static String getSender(SolrEdcVO edc) {
		//if (Common.isNotEmpty(edc.getName())) return edc.getName();
		if (Common.isNotEmpty(edc.getSname())) return edc.getSname();
		else if (Common.isNotEmpty(edc.getSender())) return edc.getSender();
		return edc.getSrcip();
	}

	private static String reCtime(String ctime) {
		if (Common.isEmpty(ctime)) return Common.EMPTY;
		return DateTime.parse(ctime, yyyyMMddHHmmss).toString(yyyyMMddHHmmss2);
	}

	public long getNumFound() {
		return numFound;
	}

	public void setNumFound(long numFound) {
		this.numFound = numFound;
	}

	public List<MessengerGroupVO> getGroups() {
		return groups;
	}

	public void setGroups(List<MessengerGroupVO> groups) {
		this.groups = groups;
	}

	public static String textParser(String text) {
		text = Common.escapeTag(text);
		//style='word-wrap: break-word;white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-break:break-all;font-size:11px;padding:0;margin:0;border:0;background-color: transparent;'
		return "<pre class='ignoreHtmlPre'><code>" + text + "</code></pre>";
	}

	private int getMessengerGroupCnt(QueryResponse resp) {
		if (Common.isNotEmpty(resp.getFacetField("xrootmtr"))) {
			return resp.getFacetField("xrootmtr").getValueCount();
		}
		return 0;
	}

	private static boolean isRead(final List<Map<String, Object>> checked, final String adminId) {
		if (checked == null) return false;
		for (Map<String, Object> item : checked) {
			if (Common.isEquals(item.get("readId"), adminId)) return true;
		}
		return false;
	}

}

