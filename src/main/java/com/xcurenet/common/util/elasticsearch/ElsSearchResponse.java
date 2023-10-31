package com.xcurenet.common.util.elasticsearch;

import lombok.Data;
import org.elasticsearch.action.search.SearchResponse;

@Data
public class ElsSearchResponse {

    private SearchResponse searchResponse;
    private long totalCnt;
    private QueryParamReady queryParamReady;

    public ElsSearchResponse(SearchResponse searchResponse, long totalCnt, QueryParamReady queryParamReady){
        this.searchResponse = searchResponse;
        this.totalCnt = totalCnt;
        this.queryParamReady = queryParamReady;
    }

}
