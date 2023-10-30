package com.xcurenet.common.util.elasticsearch;


import lombok.Builder;
import lombok.Getter;
import org.elasticsearch.search.sort.SortBuilder;

import java.util.List;
import java.util.Map;

@Builder
@Getter
public class ElasticSearchQueryBuilder {

    private String[] indices; // 대상 인덱스
    private String[] searchFields; // 검색 대상 필드
    private String   searchAggregations; // 화면에서 받아온 colkey로 집계 검색할 Str
    private String   query; // 쿼리

    private String yAxis; // 페이지별  주요 검색 열
    private String xAxis; // 통계 영역 열 시간,사업장,부서...


    /* 검색 범위 */
    private int  from;
    private int to;
    
    /* 정렬 속성*/
    private List<SortBuilder<?>> sorts;
    
    private String[] includeFields; // 대상 필드
    private String[] excludeFields; // 제외 필드

    private Map<String,String> searchParam;

}

