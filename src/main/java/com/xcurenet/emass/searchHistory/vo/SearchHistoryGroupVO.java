package com.xcurenet.emass.searchHistory.vo;

import lombok.Data;
import lombok.Getter;
import lombok.ToString;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedCardinality;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHits;

import java.util.ArrayList;
import java.util.List;


@Getter
@ToString
public class SearchHistoryGroupVO {

	private long numFound;

	private final List<SearchHistoryVO> hits = new ArrayList<>();

	private final List<Bucket> buckets = new ArrayList<>();

	public SearchHistoryGroupVO(final SearchHits<SearchHistoryVO> resp) {
		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		if (elasticSearchAggregations != null) {
			elasticSearchAggregations.aggregations().forEach(aggregation -> {
				if (aggregation instanceof ParsedCardinality) {
					ParsedCardinality cardinality = (ParsedCardinality) aggregation;
					this.numFound = cardinality.getValue();
				} else if (aggregation instanceof Terms) {
					Terms terms = (Terms) aggregation;
					terms.getBuckets().forEach(bucket -> {
						Bucket bucket1 = new Bucket();
						bucket1.setKey(bucket.getKeyAsString());
						bucket1.setCount(bucket.getDocCount());
						buckets.add(bucket1);
					});
				}
			});
		}
	}

	@Data
	public static class Bucket {
		private String key;
		private long count;
	}
}
