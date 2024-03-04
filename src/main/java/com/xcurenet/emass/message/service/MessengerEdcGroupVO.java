package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedCardinality;
import org.elasticsearch.search.aggregations.metrics.ParsedTopHits;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.io.IOException;
import java.util.*;

@ToString
@Slf4j
public class MessengerEdcGroupVO {

	private final static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private static long numFound;

	private long offset;

	private List<MessengerGroupVO> groups;

	private Map<String,List<MessengerGroupVO>> groupMaps;

	private Aggregations aggregations = null;
	private List<MessengerGroupSvcVO> fact;

	/* 카테고리 헤더 설정 */
	private Map<String,Integer> headerMap = new HashMap<>();

	private boolean detail = false;
	private String adminId = "";
	private boolean original = false;


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
		this.detail = detail;
		this.adminId = adminId;
		this.original = original;

		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		/* 집계쿼리 사용할때  */
		if (null != elasticSearchAggregations) {
			Aggregations mainAggregations = elasticSearchAggregations.aggregations();
			if (null == mainAggregations) return;

			ParsedCardinality cardinality = mainAggregations.get("bucket_total");
			if(!Common.isEmpty(cardinality)) this.numFound = cardinality.getValue();

			/* checked aggs 파싱 */
			if(mainAggregations.getAsMap().entrySet().stream().filter(k->Common.isEquals(k.getKey(),"checked_bucket_total")).count() > 0){
				this.aggregations = mainAggregations;
			}else aggregationsParser(mainAggregations); 	/* 일반 group 파싱 */


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

		this.detail = false;
		this.adminId = "";
		this.original = false;

	}

	public void aggregationsParser(Aggregations aggregations){

		for (Map.Entry<String, Aggregation> aggsKey : aggregations.getAsMap().entrySet()) {
			Aggregation aggregation = aggregations.get(aggsKey.getKey());

			/* StringTerms */
			if (aggregation instanceof ParsedStringTerms) {
				List<? extends Terms.Bucket> buckets = ((ParsedStringTerms) aggregation).getBuckets();
				Iterator iter = buckets.iterator();
				while (iter.hasNext()) {
					Terms.Bucket bucket = (Terms.Bucket) iter.next();
					if (null != bucket.getAggregations()) aggregationsParser(bucket.getAggregations());
				}
			}
			/* top hits */
			else if (aggregation instanceof ParsedTopHits) {
				ObjectMapper mapper = new ObjectMapper();
				ParsedTopHits topHits = (ParsedTopHits) aggregation;
				SearchHit[] hits = topHits.getHits().getHits();
				for (SearchHit hit : hits) {
					Map<String, Object> map = hit.getSourceAsMap();
					if (!map.isEmpty()) {
						map.put("msgid", hit.getId());
						SolrEdcVO solrEdcVO = mapper.convertValue(map, SolrEdcVO.class);
						if (detail) this.groups.add(reDefinedDetail(solrEdcVO, adminId, original));
						else {
							this.groups.add(reDefined(solrEdcVO, adminId, 0L));
							Collections.sort(this.groups);
						}
					}
				}
			}
		}
	}


	String currentMainKey = "";
	Long currentDocSize = 0L;

	public void  aggregationsCheckedParser(){
		for (Map.Entry<String, List<MessengerGroupVO>> maps : groupMaps.entrySet()) {
			aggregationsCheckedParser(this.getAggregations(),maps.getKey());
		}
		this.aggregations = null;
		currentMainKey = "";
		currentDocSize = 0L;
	}
	public void  aggregationsCheckedParser(Aggregations aggregations,String key){
		if(!Common.isEmpty(key)) {
			for (Map.Entry<String, Aggregation> aggsKey : aggregations.getAsMap().entrySet()) {
				if (Common.isEquals(aggsKey.getKey(), "userkey") && !Common.isEmpty(key)) currentMainKey = key;
				Aggregation aggregation = aggregations.get(aggsKey.getKey());

				/* StringTerms */
				if (aggregation instanceof ParsedStringTerms) {
					List<? extends Terms.Bucket> buckets = ((ParsedStringTerms) aggregation).getBuckets();
					Iterator iter = buckets.iterator();
					while (iter.hasNext()) {
						Terms.Bucket bucket = (Terms.Bucket) iter.next();
						if (Common.isEquals(aggsKey.getKey(), "userkey") && !Common.isEmpty(key))   currentDocSize = bucket.getDocCount();
						if (Common.isEquals(aggsKey.getKey(), "checked.readId")) {
//							log.info("서비스 : " + currentMainKey);
//							log.info("유저키 : " + key);
//							log.info("유저의 문서 수 : " +  currentDocSize );
//							log.info("읽은 이 : " + bucket.getKeyAsString());
//							log.info("읽은 수 : " + bucket.getDocCount());
							if(groupMaps.get(currentMainKey) == null ) break;
							else
							groupMaps.get(currentMainKey).stream().filter(m -> Common.isEquals(m.getUserkey(), key)).forEach(k -> k.setUnread_cnt(currentDocSize-bucket.getDocCount()));

						} else if (null != bucket.getAggregations()) {
							aggregationsCheckedParser(bucket.getAggregations(), bucket.getKeyAsString());
						}
					}
				}
			}
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
		solrGroupVO.setSvc12(edc.getSvc12());
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
		solrGroupVO.setSvc12(edc.getSvc12());
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

	public List<MessengerGroupSvcVO> setFact() {
		return fact;
	}

	public List<MessengerGroupSvcVO> getFact() {
		return fact;
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


	public void setFact(List<SolrEdcVO> groups) {
	}


	public Aggregations getAggregations() {
		return aggregations;
	}


	public Map<String,List<MessengerGroupVO>> getGroupMaps() {
		return groupMaps;
	}

	public void setGroupMaps(Map<String,List<MessengerGroupVO>> groupMaps) {
		this.groupMaps = groupMaps;
	}



	public Map<String,Integer> getHeaderMap(){
		return headerMap;
	}

	public void putHeaderMap(Map<String,Integer> map){
		 headerMap.putAll(map);
	}


}

