package com.xcurenet.common.util;

import com.xcurenet.audit.service.AuditVO;
import lombok.extern.log4j.Log4j2;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cloud.configuration.CompatibilityVerifierProperties;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.aggregation.LookupOperation;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.Map;

@Log4j2
@Component
public class MongoUtil {

	private static final String EMS_MESSAGE_COLLECTION = "EMS_MESSAGE";

	@Autowired
	@Qualifier("mongoTemplate")
	private MongoTemplate mongoTemplate;


	@Autowired
	private CompatibilityVerifierProperties compatibilityVerifierProperties;

	private String getCollectionName(final String msgId, final String collectionName) {
		return String.format("%s_%s", collectionName, msgId.substring(0, 6));
	}

	/**
	 * INFO_* 테이블의 seq 값
	 *
	 * @param tableCon 테이블
	 * @param vo       INFO VO
	 * @return 최대값
	 */
	public <T> T maxValue(String tableCon, Class<T> vo) {
		Query query = new Query();
		query.with(Sort.by(Sort.Direction.DESC, "VERSION"));
		query.limit(1);
		return selectOne(query, vo, tableCon);
	}


	//단건조회
	public <T> T selectOne(Query query, Class<T> vo) {
		return mongoTemplate.findOne(query, vo);
	}


	//단건조회
	public <T> T selectOne(Query query, Class<T> vo, String collectionName) {
		return mongoTemplate.findOne(query, vo, collectionName);
	}

	public <T> T selectId(String msgId, Class<T> vo) {
		return selectId(msgId, vo, EMS_MESSAGE_COLLECTION);
	}

	//특정 id값 조회
	public <T> T selectId(String msgId, Class<T> vo, String collectionName) {
		Query query = new Query(Criteria.where("_id").is(msgId));
		return mongoTemplate.findOne(query, vo, getCollectionName(msgId, collectionName));
	}


	/**
	 * 주어진 MongoDB Query의 Count 값을 반환
	 *
	 * @param query MongoDB Query
	 * @param vo    Collection Name VO
	 * @return count
	 */
	public Long count(Query query, Class<AuditVO> vo) {
		return mongoTemplate.count(query, vo);
	}

	//다건조회
	public <T> List<T> selectList(Query query, Class<T> vo) {
		return mongoTemplate.find(query, vo);
	}

	//다건조회
	public <T> List<T> selectList(Query query, Class<T> vo, String collectionName) {
		return mongoTemplate.find(query, vo, collectionName);
	}

	public <T> T insert(T object, String collectionName) {
		return mongoTemplate.insert(object, collectionName);
	}

	//단건등록
	public <T> T insert(T object) {
		return mongoTemplate.insert(object);
	}

	//다건등록
	public <T> Collection<T> insertAll(Collection<T> object) {
		return mongoTemplate.insertAll(object);
	}

	//조인조회
	public <T> List<T> joinSelect(LookupOperation lo, String joinColcn, Class<T> vo) {
		Aggregation aggregation = Aggregation.newAggregation(lo);
		AggregationResults<T> results = mongoTemplate.aggregate(aggregation, joinColcn, vo);
		return results.getMappedResults();
	}


	/**
	 * @param col        - 조건 컬럼
	 * @param where      - 조건
	 * @param updateCol  - 수정 할 컬럼
	 * @param val        - 수정할 값
	 * @param collection - 수정할 컬렉션 명
	 * @param multiYn    - 다건 수정 여부 (Y: 다건수정, N: 단건 수정)
	 */
	public void update(String[] col, String[] where, String[] updateCol, String[] val, String collection, String multiYn) {
		Query query = new Query();
		Update update = new Update();
		for (int i = 0; i < col.length; i++) {
			query.addCriteria(Criteria.where(col[i]).is(where[i]));
		}

		for (int i = 0; i < updateCol.length; i++) {
			update.set(updateCol[i], val[i]);
		}

		if (Common.isEquals("Y", multiYn)) {
			mongoTemplate.updateMulti(query, update, collection);
		} else {
			mongoTemplate.updateFirst(query, update, collection);
		}
	}

	public void upsertEmsMessage(final String msgId, Query query, Update update) {
		mongoTemplate.upsert(query, update, getCollectionName(msgId,EMS_MESSAGE_COLLECTION ));
	}

	public void updateVersion(String collectionName, String table, long version) {
		Query query = new Query();
		Update update = new Update();
		query.addCriteria(Criteria.where("TABLENAME").is(table));
		update.set("VERSION", version);
		mongoTemplate.updateMulti(query, update, collectionName);
	}

	public void updateDate(String tableName, LocalDateTime localDateTime) {
		Query query = new Query();
		Update update = new Update();
		query.addCriteria(Criteria.where("TABLENAME").is(tableName));
		update.set("DATE", localDateTime);
		mongoTemplate.updateMulti(query, update, "INFO_VERSION");
	}

	public <T> T save(T vo) {
		return mongoTemplate.save(vo);
	}

	public List<AuditVO> selectAuditList(Map<String, Object> map) {
		Query query = new Query();
		//검색 단어가 있을 경우 작업행위/ 정보 검색
		if (map.get("searchStr") != null && map.get("searchStr") != "") {
			query.addCriteria(Criteria.where("information").regex(".*" + map.get("searchStr") + ".*"));
		}
		//sort 정렬 -> 최신순이 위로 오게
		query.with(Sort.by(Sort.Direction.DESC, "date"));
		return mongoTemplate.find(query, AuditVO.class);
	}




}
