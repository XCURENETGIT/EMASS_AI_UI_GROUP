package com.xcurenet.emass.message.newService.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.KafkaProducerService;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.elasticsearch.ElasticSearchConnection;
import com.xcurenet.common.util.elasticsearch.ElasticSearchQueryUtils;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.newService.EmsReDefined;
import com.xcurenet.emass.message.newService.EmsSearchService;
import com.xcurenet.emass.message.newService.MessengerEdcGroupUserVO;
import com.xcurenet.emass.message.service.EmsMessageService;
import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.service.impl.parseJsonFile;
import com.xcurenet.emass.message.vo.emass.EmassIntegrated;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import com.xcurenet.emass.message.vo.emass.els.EmassChecked;
import com.xcurenet.emass.message.vo.emass.els.EmassResponse;
import com.xcurenet.emass.message.vo.emass.mongo.fields.CheckedVo_Mgo;
import com.xcurenet.interestUser.service.AdminUserGroupService;
import lombok.extern.slf4j.Slf4j;
import org.apache.lucene.search.TotalHits;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.*;
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
	private KafkaProducerService kafkaProducerService;

	@Resource
	private ConfigAdminService configAdminService;

	@Resource
	EmsMessageService messageService; // mongoDb

	@Value("${kafka.checked.index}")
	private String kafkaCheckedIdx;

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
	public boolean readDoc(String msgId, CheckedVo_Mgo checkedVoMgo)  {
		boolean isProc = messageService.readDoc(msgId,checkedVoMgo); // 운용자 읽음 처리
		if(isProc) { // 읽음 처리 작업 완료시
			kafkaProducerService.send(kafkaCheckedIdx,"_id",msgId);
			//log.info("[UPDATE_RESULT] 읽음 처리 완료 {}",getServerTime());
		}
		return isProc;
	}



	@Override
	public EmassIntegrated getEmassMessage(Map<String,Object> searchParam, String adminId) throws IOException {
		return getEmassMessage(searchParam, adminId, null, null);
	}


	@Override
	public EmassIntegrated getEmassMessage(Map<String,Object> searchParam, String adminId, String readYn, String consentNo) throws IOException {
		EmassIntegrated emassIntegrated = null;

		/* 바디 스니펫 사용 설정 불러오기 */
		List<ConfigAdminVO> conf = configAdminService.getConfAdminOption(adminId);
		String bodysnippetVal = "N";
		for (int i = 0; i < conf.size(); i++) {
			if (conf.get(i).getConfId().equals("body.snippet.sum.use")) {
				bodysnippetVal = conf.get(i).getVal();
				break;
			}
		}
		searchParam.put(ElasticSearchCommon.BODY_SNIPPET, bodysnippetVal);

		try {
			//쿼리 준비 시작
			SearchSourceBuilder searchSourceBuilder = elsSearchQueryUtils.initSearchSource(searchParam,adminId);

			if(null == searchSourceBuilder) throw new NullPointerException();

			/* 검색 진행 */
			SearchRequest searchRequest = new SearchRequest(elsSearchQueryUtils.getElasticSearchParam().getIndices()).source(searchSourceBuilder);
			SearchResponse searchResponse = getList(searchRequest); // getList 수행
			emassIntegrated = new EmassIntegrated(searchResponse,elsSearchQueryUtils.getElasticSearchParam(), adminId);


			/* front response 용 Data로 재 빌드해야함  */
			List<EmassResponse> emassResponse = new EmsReDefined((List<Emass>) emassIntegrated.getEmass(), readYn, consentNo, adminUserGroupService.getAdminUserGroupSimpleAdminList(adminId)).reDefined(adminId, conf);
			emassIntegrated.setEmass(emassResponse);

			/* 기타 정보 입력*/
			String serverTime = getAsiaServerTime();
			emassIntegrated.setSearchTime(serverTime);
			emassIntegrated.setExcuteQuery(elsSearchQueryUtils.getQuery());

		}catch (Exception e){
			e.printStackTrace();
		}

		return emassIntegrated;
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
		EmassIntegrated emassIntegrated = null;
		boolean flag = false;

		SearchSourceBuilder searchSourceBuilder = elsSearchQueryUtils.initSearchSource(searchParam,adminId);

		if(null == searchSourceBuilder) throw new NullPointerException();

		SearchRequest searchRequest = new SearchRequest(elsSearchQueryUtils.getElasticSearchParam().getIndices()).source(searchSourceBuilder);
		SearchResponse searchResponse = getList(searchRequest);


		if (Common.nvl(searchParam.get(ElasticSearchCommon.SEARCH_TYPE)) == ElasticSearchCommon.SEARCH_TYPE_MESSENGER_GROUP){
			emassIntegrated = new EmassIntegrated(searchResponse,elsSearchQueryUtils.getElasticSearchParam(), adminId);
			emassIntegrated.setTopHitsAggsDocData(searchResponse);
			flag = true;
		}


		return new MessengerEdcGroupVO(flag,searchResponse,adminId,false,false);
	}

	@Override
	public MessengerEdcGroupUserVO getMessengerGroupUserList(Map<String, Object> searchParam, String adminId, boolean detail, boolean original) throws IOException {
		SearchSourceBuilder searchSourceBuilder = elsSearchQueryUtils.initUserSearchSource(searchParam,adminId);

		if(null == searchSourceBuilder) throw new NullPointerException();

		SearchRequest searchRequest = new SearchRequest(elsSearchQueryUtils.getElasticSearchParam().getIndices()).source(searchSourceBuilder);
		SearchResponse searchResponse = getList(searchRequest);

		return new MessengerEdcGroupUserVO(searchResponse);
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


	/* LocalTime */
	private String getServerTime() {
		try {
			return Common.getDateTimeFormat();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}


	/* 아시아  서버 시간 */
	private String getAsiaServerTime() {
		try {
			return Common.getAsiaServerTime();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}


	@Override
	public List<EmassChecked> getCheckedList(Map<String, Object> searchParam) throws IOException {
		return null;
	}

	@Override
	public List<Emass> findReadList(List<Emass> emass, String adminId) throws IOException {
		return null;
	}

	@Override
	public void setRead(String msgId, String userId) {
		if (Common.isEmpty(msgId) || Common.isEmpty(userId) ) return;
		CheckedVo_Mgo checkedVoMgo = new CheckedVo_Mgo();
		checkedVoMgo.setReadId(userId);
		String datetime = ("GMT+09:00".equals(TimeZone.getDefault().getID())) ? getAsiaServerTime() : getServerTime();
		checkedVoMgo.setReadDate(ElasticSearchCommon.stringToDate(datetime));
		readDoc(msgId,checkedVoMgo);

	}

	@Override
	public boolean setMessengerRead(List<Emass> data, String adminId) {
		String msgId = null;
		for (Emass edc : data){
			msgId = edc.getMsgid();
			setRead(msgId, adminId);
		}
		return false;
	}

	@Override
	public EmassIntegrated getCheckedStatList(Map<String, Object> searchParam) throws IOException {
		return null;
	}




}
