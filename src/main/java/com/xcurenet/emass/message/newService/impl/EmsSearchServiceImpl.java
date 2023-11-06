package com.xcurenet.emass.message.newService.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.elasticsearch.*;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.newService.EmsReDefined;
import com.xcurenet.emass.message.newService.EmsSearchService;
import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.service.MessengerGroupUserVO;
import com.xcurenet.emass.message.service.impl.parseJsonFile;
import com.xcurenet.emass.message.vo.emass.Emass;
import com.xcurenet.emass.message.vo.emass.EmassResponse;
import com.xcurenet.emass.message.vo.message.EdcMessage;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import lombok.extern.slf4j.Slf4j;
import org.apache.lucene.search.TotalHits;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;


@Slf4j
@Service("emsSearchService")
public class EmsSearchServiceImpl implements EmsSearchService {

    @Resource
    private AdminUserGroupService adminUserGroupService;

    @Resource
    private ElasticSearchQueryUtils elsSearchQueryUtils;

    @Resource
    private ConfigAdminService configAdminService;


    /* client */
    private final RestHighLevelClient client = new ElasticSearchConnection().getElasticSearchClient();

    @Override
    public SearchResponse getList(SearchRequest searchRequest) throws IOException {
        SearchResponse searchResponse = null;
        try {
            TimeUtil.start(); // 검색 시간 측정
             searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
             TotalHits totalHits = searchResponse.getHits().getTotalHits();
            log.info("[QUERY_RESULT] TOTAL_COUNT : {}, QUERY_TIME : {}", totalHits.value, TimeUtil.print());
        }catch (ElasticsearchException e){
            e.printStackTrace();
        }
        return searchResponse;
    }


    @Override
    public EdcMessage getEmassMessage(Map<String,Object> searchParam, String adminId) throws IOException {
        return getEmassMessage(searchParam, adminId, null, null);
    }


    @Override
    public EdcMessage getEmassMessage(Map<String,Object> searchParam, String adminId, String readYn, String consentNo) throws IOException {
        EdcMessage edcMessage = null;

        if (Common.isNotEmpty(readYn) && Common.isNotEmpty(adminId)) {
            if (Common.isEquals(readYn, "Y")) {
             //   sq.addFilterQuery(String.format(JOIN_READ, adminId));
            } else {
            //   sq.addFilterQuery(String.format(JOIN_UNREAD, adminId));
            }
        }

        /*추후 작업예정 =============================================*/
        /* admin snippet */
        List<ConfigAdminVO> conf = configAdminService.getConfAdminOption(adminId);
        String bodysnippetVal = "N";
        for (int i = 0; i < conf.size(); i++) {
            if (conf.get(i).getConfId().equals("body.snippet.sum.use")) {
                bodysnippetVal = conf.get(i).getVal();
                break;
            }
        }
        searchParam.put("bodysnippet", bodysnippetVal);
        setAuthoritys(searchParam, adminId);

        /* 검색 로직 ############################################################################################################################################################################# */
        SearchSourceBuilder searchSourceBuilder = null;
        try {
            /* 검색 타입 조건 */
            switch (Common.nvl(searchParam.get(ElasticSearchCommon.SEARCH_TYPE))) {
                case ElasticSearchCommon.SEARCH_TYPE_MESSAGE:  // 메시지 검색시
                    searchSourceBuilder = elsSearchQueryUtils.initMessageSearchSource(searchParam); // 검색 소스 준비
                    break;
                case ElasticSearchCommon.SEARCH_TYPE_STATISTIC: // 통계 검색시
                    searchSourceBuilder = elsSearchQueryUtils.initStatisticSearchSource(searchParam); // 검색 소스 준비
                    break;
            }
            /* 검색 진행 */
            SearchRequest searchRequest = new SearchRequest(elsSearchQueryUtils.getElasticSearchParam().getIndices()).source(searchSourceBuilder);
            SearchResponse searchResponse = getList(searchRequest); // getList 수행
            Map<String,Object> responseMap = new HashMap<>();
            responseMap.put("searchResponse",searchResponse);
            responseMap.put("elsSearchParam",elsSearchQueryUtils.getElasticSearchParam());
            edcMessage = new EdcMessage(responseMap, adminId);

            /* 읽음 확인 관련 추후 작업 예정*/
 /*           if (readYn != null && readYn.equals("")) {
                   edcMessage.setEmass(checkedService.findReadList((List<Emass>) edcMessage.getEmass(), adminId));
            }*/

            /* response 용 Data로 재 빌드해야함  */
            List<EmassResponse> emassResponse = new EmsReDefined((List<Emass>) edcMessage.getEmass(), readYn, consentNo, adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId)).reDefined(adminId, conf);
            edcMessage.setEmass(emassResponse);

            String serverTime = getServerTime();
            edcMessage.setSearchTime(serverTime);
            edcMessage.setExcuteQuery(elsSearchQueryUtils.getQuery());

        }catch (Exception e){
            e.printStackTrace();
        }

        /* ######################################################################################################################################################################################## */

        return edcMessage;
    }

    @Override
    public MessengerEdcGroupVO getMessengerGroupList(Map<String, Object> searchParam, String adminId) throws IOException {
        return getMessengerGroupList(searchParam, adminId, false);
    }

    @Override
    public MessengerEdcGroupVO getMessengerGroupList(Map<String, Object> searchParam, String adminId, boolean detail) throws IOException {
        return getMessengerGroupList(searchParam, adminId, detail,false);
    }

    @Override
    public MessengerEdcGroupVO getMessengerGroupList(Map<String, Object> searchParam, String adminId, boolean detail, boolean original) throws IOException {
        setAuthoritys(searchParam,adminId);
        SearchSourceBuilder searchSourceBuilder = null;
        searchSourceBuilder = elsSearchQueryUtils.initCollectionSearchSource(searchParam);
        SearchRequest searchRequest = new SearchRequest(elsSearchQueryUtils.getElasticSearchParam().getIndices()).source(searchSourceBuilder);
        SearchResponse searchResponse = getList(searchRequest);
        return new MessengerEdcGroupVO(searchResponse);

    }

    @Override
    public MessengerGroupUserVO getMessengerGroupUserList(Map<String, Object> searchParam, String adminId) throws IOException {
        return null;
    }

    @Override
    public void setFeedback(String msgId, String ml_confd_feedback) throws IOException {

    }


    @Override
    public boolean setSecretInfo(String sourceKey, String securityYn, String doublSecurityPctStr, Map<String, List<parseJsonFile>> sortList) throws IOException {
        return false;
    }

    @Override
    public boolean updateSolrFeedbackData(List<parseJsonFile> feedbackList) {
        return false;
    }



    private <T> Predicate<T> distinctBykey(Function<? super T, ?>... keyExtractors) {
        final Map<List<?>, Boolean> seen = new ConcurrentHashMap<>();
        return t -> {
            final List<?> keys = Arrays.stream(keyExtractors).map(ke -> ke.apply(t)).collect(Collectors.toList());
            return seen.putIfAbsent(keys, true) == null;
        };
    }


    private void setAuthoritys(Map<String,Object> searchParam, String adminId) {
//        if (Common.isNotEmpty(adminId)) {
//            String adminType = "S";
//            if (!Common.isOrEquals(adminId, "*")) {
//                adminType = adminServiceImpl.getAdmin(adminId).getAdminType();
//            }
//
//            String ceoReadYn = Config.getString("ceo.readyn");
//
//            if (Common.isEquals(adminType, "C")) {
//                sq.addFilterQuery("+ceo:Y");
//            } else if (!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y"))) {
//                sq.addFilterQuery("-ceo:Y");
//            }
//            sq.addFilterQuery("-svc:QEKH");
//            JSONObject param = new JSONObject();
//            param.put("adminId", adminId);
//            param.put("queryType", Config.getString("query.type", "A"));
//            List<AuthorityVO> authoritys = authorityService.getAdminAuthority(param);
//            for (AuthorityVO authority : authoritys) {
//                if (authority.getCnt() > 0) {
//                    sq.addFilterQuery(authority.getQuery());
//                }
//            }
//            if (log.isInfoEnabled()) {
//                StringBuilder sb = new StringBuilder();
//                if (sq.getFilterQueries() != null) {
//                    for (int i = 0; i < sq.getFilterQueries().length; i++) {
//                        sb.append(sq.getFilterQueries()[i]).append(" ");
//                    }
//                }
//            }
//        }
    }


    private String getServerTime() {
        try {
            return Common.getDateTimeFormat();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }








}
