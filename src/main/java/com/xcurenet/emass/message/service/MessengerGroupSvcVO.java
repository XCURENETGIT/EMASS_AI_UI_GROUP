package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.message.service.vo.EmsSvcVo;
import lombok.Data;
import org.apache.commons.math3.linear.ArrayRealVector;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedCardinality;
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
public class MessengerGroupSvcVO {

	private ObjectMapper mapper = new ObjectMapper(); //임시
	private long numFoundsvc;
	private ArrayList<EmsSvcVo> groups;

	public MessengerGroupSvcVO(final SearchHits<SolrEdcVO> resp) throws SolrServerException, IOException {
		this.groups = new ArrayList<>();

		long queryResultCnt = 0L; // aggregations 총 합계

		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();

		Map<String, Aggregations> groupAggsMap = new HashMap<>();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());
		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey); // aggregations main Key
		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();


		for (Map.Entry<String, Aggregation> map : mainAggsMap.entrySet()) {
			Aggregation agg = map.getValue();

					Terms terms = (Terms) agg;
					for (Terms.Bucket bucket : terms.getBuckets()) {
						/*groupAggsMap.put(bucket.getKeyAsString(), bucket.getAggregations().get(0).getBuckets().get(0).getAggregations());*/
						groupAggsMap.put(bucket.getKeyAsString(), bucket.getAggregations());
					}
				break;
		}

		if (null != bucketList && bucketList.size() >= 1) {
			queryResultCnt = bucketList.get(0).getDocCount();
		}

		if (queryResultCnt > 0) {
			for (Terms.Bucket bucket : bucketList) {
				String facetSvc = bucket.getKeyAsString();
				long facetCnt = mainAggsMap.size();

				EmsSvcVo emsSvcVo = new EmsSvcVo(); // EmsSvcVo 인스턴스 생성
				emsSvcVo.setFacetSvc(facetSvc);
				emsSvcVo.setFacetCnt(facetCnt);

				groups.add(emsSvcVo); // ArrayList에 추가
			}
		}
		this.numFoundsvc = groups.size();
	}
}

