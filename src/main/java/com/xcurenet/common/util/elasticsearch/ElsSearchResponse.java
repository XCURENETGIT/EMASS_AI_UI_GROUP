package com.xcurenet.common.util.elasticsearch;

import lombok.Data;
import org.elasticsearch.action.search.SearchResponse;

@Data
public class ElsSearchResponse {

    private SearchResponse searchResponse;
    private long totalCnt;
    private ElasticSearchQueryBuilder elsQueryBuilder;

    public ElsSearchResponse(SearchResponse searchResponse, long totalCnt, ElasticSearchQueryBuilder elsQueryBuilder){
        this.searchResponse = searchResponse;
        this.totalCnt = totalCnt;
        this.elsQueryBuilder = elsQueryBuilder;
    }

}
