package com.xcurenet.emass.aiDashboard.service.impl;

import com.xcurenet.common.elasticsearch.ElasticsearchConfig;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.aiDashboard.model.*;
import com.xcurenet.emass.aiDashboard.service.AiDashboardService;
import lombok.extern.log4j.Log4j2;
import org.checkerframework.checker.units.qual.N;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.*;
import org.elasticsearch.script.Script;
import org.elasticsearch.script.ScriptType;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.BucketOrder;
import org.elasticsearch.search.aggregations.PipelineAggregatorBuilders;
import org.elasticsearch.search.aggregations.bucket.filter.FilterAggregationBuilder;
import org.elasticsearch.search.aggregations.bucket.filter.ParsedFilter;
import org.elasticsearch.search.aggregations.bucket.terms.*;
import org.elasticsearch.search.aggregations.pipeline.BucketScriptPipelineAggregationBuilder;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.FetchSourceContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("AiDashboardService")
@Log4j2
public class AiDashboardServiceImpl implements AiDashboardService {

    @Autowired
    private ElasticsearchConfig elasticsearchConfig;

    private RestHighLevelClient elsClient;
    private String piPatterns = "AN,BRN,CN,CPN,CRN,DN,DRM,FN,IMEI,MCN,MN,PN,SN,SSN"; // 개인정보 유출 패턴

    private String edcPrefixIndexName = "edc_w";

    /**
     * Ai 대시보드 전용 엘라스틱 쿼리
     */
    @Override
    public AiDashboardStatVO getAiDashboardStats() throws IOException {
        AiDashboardStatVO aiDashboardStatVO = new AiDashboardStatVO();
        if (Common.isEmpty(elsClient)) elsClient = elasticsearchConfig.elasticsearchClient();
        String todayStr = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE);
        String[] piFields = piPatterns.split(",");

        //금일 서비스 사용량 top 10
        SearchResponse todayAiTop10StatsResponse = getTodayTop10AiStats(elsClient,todayStr);
        List<AiSvcInfo> todayTop10AiStats = new ArrayList<>();
        setTodayTop10AiStats(todayTop10AiStats, todayAiTop10StatsResponse.getAggregations().get("ai_svc"));

        //일주일 서비스 사용량 top 10
        SearchResponse weeklyAiTop10StatsResponse = getWeeklyTop10AiStats(elsClient,todayStr);
        List<AiSvcInfo> weeklyAiTop10Stats = new ArrayList<>();
        setWeeklyTop10AiStats(weeklyAiTop10Stats, weeklyAiTop10StatsResponse.getAggregations().get("ai_svc"));


        aiDashboardStatVO.setTodayCount(getTodayAiTotalCount(elsClient,todayStr));  //전체 발신건수
        aiDashboardStatVO.setTodayAttachCount(getTodayAttachAiTotalCount(elsClient,todayStr));  //전체 (첨부파일 포함) 발신건수

        aiDashboardStatVO.setTodayPiCount(getTodayPiAmountExistsCount(elsClient,todayStr));  //전체 개인정보 유출 발신건수
        aiDashboardStatVO.setTodayPiAttachCount(getTodayAttachPiAmountExistsCount(elsClient,todayStr));  //전체 개인정보 유출 (첨부파일 포함) 발신건수

        aiDashboardStatVO.setTodayKwdCount(getTodayKwdAiTotalCount(elsClient,todayStr));  //전체 예약어 탐지 건수
        aiDashboardStatVO.setTodayKwdAttachCount(getTodayKwdAttachAiTotalCount(elsClient,todayStr)); //전체 예약어 (첨부파일 포함) 탐지 건수

        aiDashboardStatVO.setTodayTop10Info(todayTop10AiStats);     //금일 서비스 사용량 top 10
        aiDashboardStatVO.setWeeklyTop10Info(weeklyAiTop10Stats);   //일주일 서비스 사용량 top 10

        SearchResponse todayTop10UserStatsResponse = getTodayTop10UserStats(elsClient, todayStr);
        ParsedTerms userBuckets = todayTop10UserStatsResponse.getAggregations().get("by_userid_or_srcip");
        List<AiUser> aiUsers = new ArrayList<>();
        for (Terms.Bucket userBucket : userBuckets.getBuckets()) {
            AiUser aiUser = new AiUser();
            aiUser.setUserId(userBucket.getKeyAsString());
            List<AiSvcInfo> svcInfos = new ArrayList<>();
            ParsedTerms svcBuckets = userBucket.getAggregations().get("by_svc");
            for (Terms.Bucket svcBucket : svcBuckets.getBuckets()) {
                AiSvcInfo svcInfo = new AiSvcInfo();
                svcInfo.setSvc(svcBucket.getKeyAsString());
                svcInfo.setSvcName(null);
                svcInfo.setSvcCount(String.valueOf(svcBucket.getDocCount()));
                svcInfos.add(svcInfo);
            }
            aiUser.setSvcInfos(svcInfos);
            aiUsers.add(aiUser);
        }
        aiDashboardStatVO.setTodayAiUsers(aiUsers);

        //금일 AI 모델 사용 시간대 차트
        SearchResponse aiSvcTimeStats = getTodayAiSvcTimeStats(elsClient, todayStr);
        ParsedStringTerms by5min = aiSvcTimeStats.getAggregations().get("by_5min");
        Set<String> allSvcs = new java.util.LinkedHashSet<>();
        Map<String, Map<String, Long>> timeSvcCounts = new java.util.HashMap<>();

        for (Terms.Bucket timeBucket : by5min.getBuckets()) {
            String timeKey = timeBucket.getKeyAsString(); // 기대 형식: yyyyMMddHHmm
            ParsedStringTerms aiSvcAgg = timeBucket.getAggregations().get("ai_svc");

            Map<String, Long> svcMap = new java.util.HashMap<>();
            for (Terms.Bucket svcBucket : aiSvcAgg.getBuckets()) {
                String svc = svcBucket.getKeyAsString();
                long count = svcBucket.getDocCount();
                allSvcs.add(svc);
                svcMap.put(svc, count);
            }
            timeSvcCounts.put(timeKey, svcMap);
        }


        final java.time.format.DateTimeFormatter YMD   = java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd");
        final java.time.format.DateTimeFormatter YMDHM = java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmm");

        java.time.LocalDate day = java.time.LocalDate.parse(todayStr, YMD);
        java.time.LocalDateTime from = day.atStartOfDay();
        java.time.LocalDateTime to   = day.atTime(23, 55);

        java.util.List<String> allTimeKeys = new java.util.ArrayList<>(24 * 12);
        for (java.time.LocalDateTime t = from; !t.isAfter(to); t = t.plusMinutes(5)) {
            allTimeKeys.add(t.format(YMDHM)); // yyyyMMddHHmm
        }
        java.util.List<AiTimeStat> aiTimeStats =
                new java.util.ArrayList<>(allTimeKeys.size() * Math.max(1, allSvcs.size()));

        for (String timeKey : allTimeKeys) {
            String date   = timeKey.substring(0, 8);
            String hour   = timeKey.substring(8, 10);
            String minute = timeKey.substring(10, 12);

            Map<String, Long> svcMap = timeSvcCounts.getOrDefault(timeKey, java.util.Collections.emptyMap());

            if (allSvcs.isEmpty()) {
                AiTimeStat stat = new AiTimeStat();
                stat.setDate(date);
                stat.setHour(hour);
                stat.setMinute(minute);
                stat.setSvc("N/A");
                stat.setSvcName("N/A");
                stat.setSvcCount("0");
                aiTimeStats.add(stat);
            } else {
                for (String svc : allSvcs) {
                    long cnt = svcMap.getOrDefault(svc, 0L);
                    AiTimeStat stat = new AiTimeStat();
                    stat.setDate(date);
                    stat.setHour(hour);
                    stat.setMinute(minute);
                    stat.setSvc(svc);
                    stat.setSvcName(svc); // 필요 시 매핑 테이블로 정식 이름 세팅
                    stat.setSvcCount(String.valueOf(cnt));
                    aiTimeStats.add(stat);
                }
            }
        }
        aiDashboardStatVO.setAiTimeStats(aiTimeStats);



        SearchResponse todayTop10PiUserStatsResponse = getTodayTop10PiUserStats(elsClient, todayStr);
        ParsedTerms userPiBuckets = todayTop10PiUserStatsResponse.getAggregations().get("by_userid_or_srcip");
        List<AiUser> aiPiUsers = new ArrayList<>();
        for (Terms.Bucket piBucket : userPiBuckets.getBuckets()) {
            AiUser aiUser = new AiUser();
            aiUser.setUserId(piBucket.getKeyAsString());

            List<AiPiInfo> piInfos = new ArrayList<>();
            int piTotal = 0;
            for (String field : piFields) {
                ParsedFilter filter = piBucket.getAggregations().get("pi_" + field);
                long count = filter.getDocCount();
                if (count > 0) {
                    AiPiInfo info = new AiPiInfo();
                    info.setPi(field);
                    info.setPiCount(String.valueOf(count));
                    piInfos.add(info);
                    piTotal += count;
                }
            }
            aiUser.setPiInfos(piInfos);
            aiUser.setPiTotalCount(piTotal);
            aiPiUsers.add(aiUser);
        }
        aiPiUsers.sort((a, b) -> Integer.compare(b.getPiTotalCount(), a.getPiTotalCount()));
        List<AiUser> top10PiUsers = aiPiUsers.stream().limit(10).collect(Collectors.toList());
        aiDashboardStatVO.setTodayAiPiUsers(top10PiUsers);


        SearchResponse todayTop10KwdUserStatsResponse = getTodayTop10KwdUserStats(elsClient, todayStr);
        ParsedTerms userKwdBuckets = todayTop10KwdUserStatsResponse.getAggregations().get("by_userid_or_srcip");
        List<AiUser> aiKwdUsers = new ArrayList<>();
        for (Terms.Bucket userBucket : userKwdBuckets.getBuckets()) {
            AiUser aiUser = new AiUser();
            aiUser.setUserId(userBucket.getKeyAsString());
            List<AiKwdInfo> kwdInfos = new ArrayList<>();
            int totalKwdCount = 0;
            ParsedTerms kwdBuckets = userBucket.getAggregations().get("by_kwds");
            for (Terms.Bucket kwdBucket : kwdBuckets.getBuckets()) {
                String kwd = kwdBucket.getKeyAsString();
                long count = kwdBucket.getDocCount();
                AiKwdInfo info = new AiKwdInfo();
                info.setKwd(kwd); // keyword를 pi 필드에 세팅
                info.setKwdCount(String.valueOf(count));
                kwdInfos.add(info);
                totalKwdCount += count;
            }
            aiUser.setKwdInfos(kwdInfos);
            aiUser.setKwdTotalCount(totalKwdCount);
            aiKwdUsers.add(aiUser);
        }
        aiDashboardStatVO.setTodayAiKwdUsers(aiKwdUsers);
        return aiDashboardStatVO;
    }


    /**
     * 인사정보 및 코드 네임맵핑
     */
    @Override
    public AiDashboardStatVO redefined(AiDashboardStatVO aiDashboardStatVO) throws IOException {

        List<AiSvcInfo> todayTop10Infos = aiDashboardStatVO.getTodayTop10Info();
        for (AiSvcInfo svcInfo : todayTop10Infos) {
            svcInfo.setSvcName(Common.nvl(Config.getServiceLv2Nm(svcInfo.getSvc()), svcInfo.getSvc()));
        }

        List<AiSvcInfo> weeklyTop10Infos = aiDashboardStatVO.getWeeklyTop10Info();
        for (AiSvcInfo svcInfo : weeklyTop10Infos) {
            svcInfo.setSvcName(Common.nvl(Config.getServiceLv2Nm(svcInfo.getSvc()), svcInfo.getSvc()));
        }

        List<AiTimeStat> aiTimeStats = aiDashboardStatVO.getAiTimeStats();
        for (AiTimeStat aiTimeStat : aiTimeStats) {
            aiTimeStat.setSvcName(Common.nvl(Config.getServiceLv2Nm(aiTimeStat.getSvc()), aiTimeStat.getSvc()));
        }


        List<AiUser> todayAiUsers = aiDashboardStatVO.getTodayAiUsers();
        for (AiUser aiUser : todayAiUsers) {
            aiUser.setUserNm(Config.getUserName(Common.nvl(aiUser.getUserId(), aiUser.getUserId())));
            aiUser.setDeptNm(Config.getUserDeptnm(Common.nvl(aiUser.getUserId(), aiUser.getUserId())));
            aiUser.setJikgubNm(Config.getUserJikgubnm(Common.nvl(aiUser.getUserId(), aiUser.getUserId())));
            List<AiSvcInfo> svcInfos = aiUser.getSvcInfos();
            for (AiSvcInfo aiSvcInfo : svcInfos) {
                aiSvcInfo.setSvcName(Common.nvl(Config.getServiceLv2Nm(aiSvcInfo.getSvc()), aiSvcInfo.getSvc()));
            }
        }

        List<AiUser> aiPiUsers = aiDashboardStatVO.getTodayAiPiUsers();
        for (AiUser aiPiUser : aiPiUsers) {
            aiPiUser.setUserNm(Config.getUserName(Common.nvl(aiPiUser.getUserId(), aiPiUser.getUserId())));
            aiPiUser.setDeptNm(Config.getUserDeptnm(Common.nvl(aiPiUser.getUserId(), aiPiUser.getUserId())));
            aiPiUser.setJikgubNm(Config.getUserJikgubnm(Common.nvl(aiPiUser.getUserId(), aiPiUser.getUserId())));
            List<AiPiInfo> aiPiInfos = aiPiUser.getPiInfos();
            for (AiPiInfo aiPiInfo : aiPiInfos) {
                aiPiInfo.setPiName(Common.nvl(Config.getPiName(aiPiInfo.getPi()), aiPiInfo.getPi()));
            }
        }

        List<AiUser> aiKwdUsers = aiDashboardStatVO.getTodayAiKwdUsers();
        for (AiUser aiKwdUser : aiKwdUsers) {
            aiKwdUser.setUserNm(Config.getUserName(Common.nvl(aiKwdUser.getUserId(), aiKwdUser.getUserId())));
            aiKwdUser.setDeptNm(Config.getUserDeptnm(Common.nvl(aiKwdUser.getUserId(), aiKwdUser.getUserId())));
            aiKwdUser.setJikgubNm(Config.getUserJikgubnm(Common.nvl(aiKwdUser.getUserId(), aiKwdUser.getUserId())));
        }

        aiDashboardStatVO.setTodayTop10Info(todayTop10Infos);
        aiDashboardStatVO.setWeeklyTop10Info(weeklyTop10Infos);
        aiDashboardStatVO.setAiTimeStats(aiTimeStats);
        aiDashboardStatVO.setTodayAiUsers(todayAiUsers);
        aiDashboardStatVO.setTodayAiPiUsers(aiPiUsers);
        aiDashboardStatVO.setTodayAiKwdUsers(aiKwdUsers);
        return aiDashboardStatVO;
    }





    public void setTodayTop10AiStats(List<AiSvcInfo> todayTop10AiStats, ParsedTerms buckets){
        if(null == buckets.getBuckets()) return;
        for (Terms.Bucket bucket : buckets.getBuckets()) {
            String svc = bucket.getKeyAsString();
            long count = bucket.getDocCount();
            AiSvcInfo info = new AiSvcInfo();
            info.setSvc(svc);
            info.setSvcName(svc); // svcName이 따로 없으면 key를 그대로 사용
            info.setSvcCount(String.valueOf(count));
            todayTop10AiStats.add(info);
        }
    }

    public void setWeeklyTop10AiStats(List<AiSvcInfo> weeklyAiTop10Stats, ParsedTerms buckets){
        if(null == buckets.getBuckets()) return;
        for (Terms.Bucket bucket : buckets.getBuckets()) {
            String svc = bucket.getKeyAsString();
            long count = bucket.getDocCount();
            AiSvcInfo info = new AiSvcInfo();
            info.setSvc(svc);
            info.setSvcName(svc); // svcName이 따로 없으면 key를 그대로 사용
            info.setSvcCount(String.valueOf(count));
            weeklyAiTop10Stats.add(info);
        }
    }

    //금일 AI 서비스 총 count
    public long getTodayAiTotalCount(RestHighLevelClient client,String todayStr){
        try {
            QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +svc:I* AND +ctime_yyyymmdd:" + todayStr);
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                    .query(queryString)
                    .trackTotalHits(true)
                    .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                    .size(0);
            SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
            searchRequest.source(sourceBuilder);
            SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
            return response.getHits().getTotalHits().value;
        }catch (Exception e){
            log.error("getTodayAiTotalCount error : ", e.getMessage());
            return 0;
        }
    }

    //금일 AI 서비스 (첨부파일 포함)  총 count
    public long getTodayAttachAiTotalCount(RestHighLevelClient client,String todayStr){
        try {
            QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +(attachexistcnt:[1 TO *] AND svc:I*) AND +ctime_yyyymmdd:" + todayStr);
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                    .query(queryString)
                    .trackTotalHits(true)
                    .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                    .size(0);
            SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
            searchRequest.source(sourceBuilder);
            SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
            return response.getHits().getTotalHits().value;
        }catch (Exception e){
            log.error("getTodayAiTotalCount error : ", e.getMessage());
            return 0;
        }
    }

    //금일 AI 서비스 개인정보 유출  총 count
    public long getTodayPiAmountExistsCount(RestHighLevelClient client,String todayStr) throws IOException {
        QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +svc:I* AND +ctime_yyyymmdd:" + todayStr);
        String[] fields = piPatterns.split(",");
        BoolQueryBuilder shouldQuery = QueryBuilders.boolQuery();
        for (String field : fields) {
            shouldQuery.should(QueryBuilders.existsQuery("pi_amount.pi_" + field));
        }
        shouldQuery.minimumShouldMatch(1);
        BoolQueryBuilder finalQuery = QueryBuilders.boolQuery()
                .must(queryString)
                .must(shouldQuery);
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(finalQuery)
                .size(1)
                .trackTotalHits(true)
                .fetchSource(new String[]{"pi_amount"}, null);
        SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        searchRequest.source(sourceBuilder);
        SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
        return response.getHits().getTotalHits().value;
    }


    //금일 AI 서비스 개인정보 유출(첨부파일 포함)  총 count
    public long getTodayAttachPiAmountExistsCount(RestHighLevelClient client,String todayStr) throws IOException {
        QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +(pi_amount.type:A +svc:I*) AND +ctime_yyyymmdd:" + todayStr);
        String[] fields = piPatterns.split(",");
        BoolQueryBuilder shouldQuery = QueryBuilders.boolQuery();
        for (String field : fields) {
            shouldQuery.should(QueryBuilders.existsQuery("pi_amount.pi_" + field));
        }
        shouldQuery.minimumShouldMatch(1);
        BoolQueryBuilder finalQuery = QueryBuilders.boolQuery()
                .must(queryString)
                .must(shouldQuery);
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(finalQuery)
                .size(1)
                .trackTotalHits(true)
                .fetchSource(new String[]{"pi_amount"}, null);
        SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        searchRequest.source(sourceBuilder);
        SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
        return response.getHits().getTotalHits().value;
    }

    //금일 AI 서비스 예약어 탐지 총 count
    public long getTodayKwdAiTotalCount(RestHighLevelClient client,String todayStr){
        try {
            QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +kwd:Y AND +svc:I* AND +ctime_yyyymmdd:" + todayStr);
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                    .query(queryString)
                    .trackTotalHits(true)
                    .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                    .size(0);
            SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
            searchRequest.source(sourceBuilder);
            SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
            return response.getHits().getTotalHits().value;
        }catch (Exception e){
            log.error("getTodayAiTotalCount error : ", e.getMessage());
            return 0;
        }
    }

    //금일 AI 서비스 예약어 탐지 (첨부파일 포함)  총 count
    public long getTodayKwdAttachAiTotalCount(RestHighLevelClient client,String todayStr){
        try {
            QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +kwd:Y AND +kwds_attach:* AND  +svc:I* AND +ctime_yyyymmdd:" + todayStr);
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                    .query(queryString)
                    .trackTotalHits(true)
                    .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                    .size(0);
            SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
            searchRequest.source(sourceBuilder);
            SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
            return response.getHits().getTotalHits().value;
        }catch (Exception e){
            log.error("getTodayAiTotalCount error : ", e.getMessage());
            return 0;
        }
    }


    /**
     * 금일 AI 서비스 사용량
     */
    public SearchResponse getTodayTop10AiStats(RestHighLevelClient client,String todayStr) throws IOException {
        TermsAggregationBuilder svcAgg = AggregationBuilders
                .terms("ai_svc")
                .field("svc")
                .includeExclude(new IncludeExclude("I.*", null))
                .size(10)
                .order(BucketOrder.count(false));
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
                .must(QueryBuilders.rangeQuery("ctime_yyyymmdd").gte(todayStr).lte(todayStr))
                .must(QueryBuilders.queryStringQuery("+direction_svc:O"));

        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(boolQuery)
                .size(0)
                .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                .aggregation(svcAgg);

        SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        searchRequest.source(sourceBuilder);

        return client.search(searchRequest, RequestOptions.DEFAULT);
    }

    /**
     * 주간 AI 서비스 사용량
     */
    public SearchResponse getWeeklyTop10AiStats(RestHighLevelClient client,String todayStr) throws IOException {
        DateTimeFormatter formatter = DateTimeFormatter.BASIC_ISO_DATE;
        LocalDate today = LocalDate.parse(todayStr, formatter);
        String weekAgoStr = today.minusDays(6).format(formatter);

        TermsAggregationBuilder svcAgg = AggregationBuilders
                .terms("ai_svc")
                .field("svc")
                .includeExclude(new IncludeExclude("I.*", null))
                .size(10)
                .order(BucketOrder.count(false));
        String queryString = "+direction_svc:O AND +ctime_yyyymmdd:[" + weekAgoStr + " TO " + todayStr + "] AND +svc:I*";
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(QueryBuilders.queryStringQuery(queryString))
                .size(0)
                .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                .aggregation(svcAgg);
        SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        searchRequest.source(sourceBuilder);
        return client.search(searchRequest, RequestOptions.DEFAULT);
    }

    /**
     *  금일 AI 서비스 사용 시간대별 차트
     */
    public SearchResponse getTodayAiSvcTimeStats(RestHighLevelClient client, String todayStr) throws IOException {
        Script script = new Script(
                ScriptType.INLINE,
                "painless",
                "String ts = doc['ctime'].value;" +
                        "String datePart = ts.substring(0, 10);" +
                        "int minute = Integer.parseInt(ts.substring(10, 12));" +
                        "int bucketMin = (minute / 5) * 5;" +
                        "String minStr = bucketMin < 10 ? '0' + bucketMin : '' + bucketMin;" +
                        "return datePart + minStr;",
                Collections.emptyMap()
        );

        TermsAggregationBuilder svcAgg = AggregationBuilders
                .terms("ai_svc")
                .field("svc")
                .includeExclude(new IncludeExclude("I.*", null))
                .size(10)
                .order(BucketOrder.count(false));

        TermsAggregationBuilder timeAgg = AggregationBuilders
                .terms("by_5min")
                .script(script)
                .size(10000)
                .order(BucketOrder.key(true))
                .subAggregation(svcAgg);
        QueryBuilder query = QueryBuilders.queryStringQuery("+direction_svc:O AND +svc:I* AND +ctime_yyyymmdd:" + todayStr);
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(query)
                .size(0)
                .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                .aggregation(timeAgg);
        SearchRequest searchRequest = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        searchRequest.source(sourceBuilder);
        return client.search(searchRequest, RequestOptions.DEFAULT);
    }


    /**
     * 금일 TOP 10 AI 서비스 사용 유저
     */
    public SearchResponse getTodayTop10UserStats(RestHighLevelClient client,String todayStr) throws IOException {
        QueryStringQueryBuilder queryString = QueryBuilders.queryStringQuery("+direction_svc:O AND +svc:I* AND +ctime_yyyymmdd:" + todayStr);
        Script userScript = new Script(
                ScriptType.INLINE,
                "painless",
                "if (doc.containsKey('userid') && !doc['userid'].empty) {" +
                        "return doc['userid'].value;" +
                        "} else if (doc.containsKey('srcip') && !doc['srcip'].empty) {" +
                        "return doc['srcip'].value;" +
                        "} else { return 'unknown'; }",
                Collections.emptyMap()
        );
        TermsAggregationBuilder bySvcAgg = AggregationBuilders
                .terms("by_svc")
                .field("svc")
                .size(10);
        TermsAggregationBuilder userAgg = AggregationBuilders
                .terms("by_userid_or_srcip")
                .script(userScript)
                .size(10)
                .order(BucketOrder.count(false))
                .subAggregation(bySvcAgg);
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(queryString)
                .size(0)
                .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                .aggregation(userAgg);
        SearchRequest request = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        request.source(sourceBuilder);
        return client.search(request, RequestOptions.DEFAULT);
    }


    /**
     * 금일 TOP 10 AI 서비스 (예약어 포함 발신)사용 유저
     */
    public SearchResponse getTodayTop10KwdUserStats(RestHighLevelClient client,String todayStr) throws IOException {
        BoolQueryBuilder query = QueryBuilders.boolQuery()
                .must(QueryBuilders.queryStringQuery("+direction_svc:O AND +svc:I* AND +ctime_yyyymmdd:" + todayStr))
                .must(QueryBuilders.existsQuery("kwds")); // kwds 필드가 있어야 함

        Script userScript = new Script(
                ScriptType.INLINE,
                "painless",
                "if (doc.containsKey('userid') && !doc['userid'].empty) {" +
                        "return doc['userid'].value;" +
                        "} else if (doc.containsKey('srcip') && !doc['srcip'].empty) {" +
                        "return doc['srcip'].value;" +
                        "} else { return 'unknown'; }",
                Collections.emptyMap()
        );

        TermsAggregationBuilder byKwdsAgg = AggregationBuilders
                .terms("by_kwds")
                .field("kwds")
                .size(10);

        TermsAggregationBuilder userAgg = AggregationBuilders
                .terms("by_userid_or_srcip")
                .script(userScript)
                .size(10)
                .order(BucketOrder.count(false))
                .subAggregation(byKwdsAgg);
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(query)
                .size(0)
                .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                .aggregation(userAgg);

        SearchRequest request = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        request.source(sourceBuilder);
        return client.search(request, RequestOptions.DEFAULT);
    }

    /**
     * 금일 TOP 10 AI 서비스 (개인정보 포함 발신)사용 유저
     */
    public SearchResponse getTodayTop10PiUserStats(RestHighLevelClient client,String todayStr) throws IOException {
        String[] fields = piPatterns.split(",");
        BoolQueryBuilder piExistsQuery = QueryBuilders.boolQuery();
        for (String field : fields) {
            piExistsQuery.should(QueryBuilders.existsQuery("pi_amount.pi_" + field));
        }
        piExistsQuery.minimumShouldMatch(1);  // PI 중 하나 이상 존재해야 통과
        QueryStringQueryBuilder baseQuery = QueryBuilders.queryStringQuery("+direction_svc:O AND +svc:I* AND +ctime_yyyymmdd:" + todayStr);
        BoolQueryBuilder finalQuery = QueryBuilders.boolQuery()
                .must(baseQuery)
                .must(piExistsQuery);
        Script userScript = new Script(
                ScriptType.INLINE,
                "painless",
                "if (doc.containsKey('userid') && !doc['userid'].empty) {" +
                        "return doc['userid'].value;" +
                        "} else if (doc.containsKey('srcip') && !doc['srcip'].empty) {" +
                        "return doc['srcip'].value;" +
                        "} else { return 'unknown'; }",
                Collections.emptyMap()
        );
        TermsAggregationBuilder userAgg = AggregationBuilders
                .terms("by_userid_or_srcip")
                .script(userScript)
                .size(100)
                .order(BucketOrder.count(false)); // Elasticsearch 정렬은 doc_count 기준

        for (String field : fields) {
            String aggName = "pi_" + field;
            ExistsQueryBuilder existsQuery = QueryBuilders.existsQuery("pi_amount." + aggName);
            FilterAggregationBuilder filterAgg = AggregationBuilders.filter(aggName, existsQuery);
            userAgg.subAggregation(filterAgg);
        }

        Map<String, String> bucketsPathMap = new HashMap<>();
        for (String field : fields) {
            String aggName = "pi_" + field;
            bucketsPathMap.put(aggName, aggName + "._count");  // filter의 doc_count 참조
        }

        StringBuilder scriptBuilder = new StringBuilder();
        for (int i = 0; i < fields.length; i++) {
            String var = "pi_" + fields[i];
            if (i > 0) scriptBuilder.append(" + ");
            scriptBuilder.append("(params." + var + " != null ? params." + var + " : 0)");
        }

        Script script = new Script(ScriptType.INLINE, "painless", scriptBuilder.toString(), Collections.emptyMap());
        BucketScriptPipelineAggregationBuilder piTotalCount =
                PipelineAggregatorBuilders.bucketScript("pi_count", bucketsPathMap, script);
        userAgg.subAggregation(piTotalCount);
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(finalQuery)
                .size(0)
                .fetchSource(FetchSourceContext.DO_NOT_FETCH_SOURCE)
                .aggregation(userAgg);

        SearchRequest request = new SearchRequest(getLastAndThisMonthIndices(edcPrefixIndexName));
        request.source(sourceBuilder);

        return client.search(request, RequestOptions.DEFAULT);
    }


    public static String[] getLastAndThisMonthIndices(String indexPrefix) {
        DateTimeFormatter ymFormatter = DateTimeFormatter.ofPattern("yyyyMM");
        LocalDate today = LocalDate.now();
        String thisMonth = today.format(ymFormatter);
        String lastMonth = today.minusMonths(1).format(ymFormatter);
        return new String[] {
                indexPrefix + "_" + lastMonth,
                indexPrefix + "_" + thisMonth
        };
    }

}