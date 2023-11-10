package com.xcurenet.common.util.elasticsearch;


import lombok.Data;
import org.elasticsearch.search.sort.SortBuilder;

import java.util.List;
import java.util.Map;


@Data
/* 쿼리 파라미터 */
public class ElasticSearchParam {

    private String searchType;

    private String[] indices; // 대상 인덱스
    private String[] searchFields; // 검색 대상 필드

    /* 검색 범위 */
    private int from;
    private int to;

    /* 조회할 Date정보 */
    private String startDate;
    private String endDate;


    /* 조회할 Date정보 */
    private String serviceType;


    /* 정렬 속성*/
    private List<SortBuilder<?>> sorts;

    private String[] includeFields; // 대상 필드
    private String[] excludeFields; // 제외 필드


    /* 통계 관련 */
    private String searchAggregations; // 화면에서 받아온 colkey로 집계 검색할 Str
    private String yAxis; // 페이지별  주요 검색 열
    private String xAxis; // 통계 영역 열 시간,사업장,부서...

    private String colId; // 디테일 검색시 클릭했던 column id
    private String searched_xAxis; // 바로 이전 검색했었던 xAxis값

    /* 메신저 관련 */
    private String xRootmtr;
    private String groupField;


    /* 분석 관련 */
    private String user_str;
    private String pi_SN;
    private String pi_PN;
    private String pi_DN;
    private String pi_FN;
    private String pi_CN;



    private Map<String,Object> searchParameters; // 유저가 검색에 입력,사용한 값 (객체형태)
}

