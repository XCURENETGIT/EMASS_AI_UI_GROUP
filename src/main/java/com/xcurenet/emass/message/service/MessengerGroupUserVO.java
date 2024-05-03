package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.util.Common;
import lombok.Data;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedTopHits;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Data
public class MessengerGroupUserVO {
	ObjectMapper mapper = new ObjectMapper(); //임시
	//사용자 수
	private long numFoundUser;

	private List<SolrEdcVO> groups;

	public MessengerGroupUserVO(final SearchHits<SolrEdcVO> resp) throws SolrServerException, IOException {
		this.groups = new ArrayList<>();

		long queryResultCnt = 0L; // aggregations 총 합계

		//참여자 출력시 usr_id가 아닌 sender에 적재해야하지만 usr_id 영역으로 사용함
		//main aggregations key 출력
		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());
		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key
		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();

		if (null != bucketList && bucketList.size() >= 1) {
			queryResultCnt = bucketList.get(0).getDocCount();
		}

		if(facetPivot != null) {
			for (Terms.Bucket bucket : bucketList) {
				Aggregations aggs = bucket.getAggregations();
				List<Aggregation> aggsList = aggs.asList();
				List<Map<String, Integer>> srcIpList = new ArrayList<Map<String, Integer>>();
				for (Aggregation subaggs : aggsList) {
					Map<String, Integer> ipMap = new HashMap<String, Integer>();
					String field = bucket.getKeyAsString();
					String usr_id = Common.nvl(field);
					SolrEdcVO vo = new SolrEdcVO();
					vo.setUsr_id(usr_id);

					ParsedTopHits bucketArgments = (ParsedTopHits) subaggs;
					int cnt = Common.nvz((bucketArgments.getHits().getTotalHits().value));
					ipMap.put(usr_id, cnt);

					srcIpList.add(ipMap);

					/* usr_id 기준으로 인사매핑*/
					org.elasticsearch.search.SearchHit[] hits  = bucketArgments.getHits().getHits();
					Map<String, Object> hitsMap = hits[0].getSourceAsMap();
					if (hitsMap.size() > 0) {
						vo.setUser(Common.nvl(hitsMap.get("user")));
						vo.setUserkey(Common.nvl(hitsMap.get("userkey")));
						vo.setConm(Common.nvl(hitsMap.get("conm")));
						vo.setBusinm(Common.nvl(hitsMap.get("businm")));
						vo.setName(Common.nvl(hitsMap.get("name")));
						vo.setJikgubnm(Common.nvl(hitsMap.get("jikgubnm")));
						vo.setSender(Common.nvl(hitsMap.get("sender")));
						vo.setSname(Common.nvl(hitsMap.get("sname")));
						vo.setUserid(Common.nvl(hitsMap.get("userid")));
						vo.setBody_snippet(Common.nvl(hitsMap.get("body_snippet")));
					}
					vo.setSrcIpList(srcIpList);
					groups.add(vo);
				}
			}
		}

		//usr_id가 없는 경우에 ip로 보여주기 위한 작업
		if(queryResultCnt > 0) {
				SolrEdcVO onlyIp = null;
				for(Terms.Bucket bucket : bucketList){
					boolean addFlag = false;
					String facetIp = bucket.getKeyAsString();
					long facetCnt = bucket.getDocCount();

					int size = groups.size();
					for(int i=0; i<size; i++) {
						SolrEdcVO edc = groups.get(i);
						List<Map<String, Integer>> ipList = edc.getSrcIpList();
						if(ipList == null) {
							if(Common.isEquals(facetIp, edc.getSrcip()) ) {
								addFlag = true;
								continue;
							}
						}
						else {
							for(Map<String, Integer> map : ipList) {
								int cnt = Common.nvz(map.get(facetIp));
								if(facetCnt == cnt) {
									addFlag = true;
									break;
								}
							}
						}
					}
					if(!addFlag) {
						onlyIp = new SolrEdcVO();
						onlyIp.setSrcip(facetIp);
						groups.add(onlyIp);
					}
				}
		}


		this.numFoundUser = groups.size();

	}
}
