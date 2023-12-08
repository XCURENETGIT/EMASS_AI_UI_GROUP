package com.xcurenet.emass.message.service;

import com.xcurenet.common.util.Common;
import lombok.Data;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.ParsedStringTerms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
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

	//사용자 수
	private long numFoundUser;

	private List<SolrEdcVO> groups;

	public MessengerGroupUserVO(final SearchHits<SolrEdcVO> resp) throws SolrServerException, IOException {
		this.groups = new ArrayList<>();

		long queryResultCnt = resp.getTotalHits();

		//참여자 출력시 usr_id가 아닌 sender에 적재해야하지만 usr_id 영역으로 사용함
		//main aggregations key 출력
		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());
		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key
		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
		Aggregations subAggs = null;
		if (null != bucketList && bucketList.size() >= 1)
			subAggs = bucketList.get(0).getAggregations(); // sub Aggregations 여부

		if(facetPivot != null) {
			for (Terms.Bucket bucket : bucketList) {
				Aggregations aggs = bucket.getAggregations();
				List<Aggregation> aggsList = aggs.asList();
				for (Aggregation subaggs : aggsList) {
					String field = bucket.getKeyAsString();
					String usr_id = Common.nvl(field);
					SolrEdcVO vo = new SolrEdcVO();
					vo.setUsr_id(usr_id);
					List<Map<String, Integer>> srcIpList = new ArrayList<Map<String, Integer>>();
					ParsedStringTerms bucketArgments = (ParsedStringTerms) subaggs;
					for (Terms.Bucket arg : bucketArgments.getBuckets()) {
						String subField = arg.getKeyAsString();
						String ip = Common.nvl(subField);
						int cnt = Common.nvz((arg.getDocCount()));
						Map<String, Integer> ipList = new HashMap<String, Integer>();
						ipList.put(ip, cnt);
						srcIpList.add(ipList);
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

		//usr_id 기준으로 인사매핑
		if (resp.getAggregations() != null) {

			//tophits

//			for(GroupCommand gc : gGroupCommands) {
//				String name = gc.getName();
//				List<Group> userGroups = gc.getValues();
//				for (Group group : userGroups) {
//					SolrDocumentList solrDocs = group.getResult();
//					if (solrDocs.size() > 0) {
//						SolrEdcVO edc = new DocumentObjectBinder().getBean(SolrEdcVO.class, solrDocs.get(0));
//						for (int i=0; i<groups.size(); i++) {
//							SolrEdcVO vo = groups.get(i);
//							if(Common.isOrEquals(name, "srcip", "usr_id") && Common.isEquals(edc.getUsr_id(), vo.getUsr_id())) {
//								vo.setUser(edc.getUser());
//								vo.setConm(edc.getConm());
//								vo.setBusinm(edc.getBusinm());
//								vo.setName(edc.getName());
//								vo.setJikgubnm(edc.getJikgubnm());
//								vo.setSender(edc.getSender());
//								vo.setSname(edc.getSname());
//								this.groups.set(i, vo);
//							}
//							else if(Common.isEquals(name, "sender_str") && Common.isEquals(edc.getSender(), vo.getUsr_id())) {
//								vo.setSender(edc.getSender());
//								vo.setSname(edc.getSname());
//								this.groups.set(i, vo);
//							}
//						}
//					}
//				}
//			}
		}
	}
}
