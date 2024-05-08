package com.xcurenet.emass.message.service.impl;

import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.admin.service.impl.AdminServiceImpl;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.KafkaProducerService;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.emass.message.service.*;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.search.aggregations.AbstractAggregationBuilder;
import org.elasticsearch.search.aggregations.bucket.terms.TermsAggregationBuilder;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Log4j2
@Service("solrCheckedService")
public class SolrCheckedServiceImpl implements SolrCheckedService {

	@Autowired
	private MongoUtil mongo;
//
	@Autowired
	@Qualifier("elasticsearchTemplate")
	private ElasticsearchOperations operation;

	public static final DateTimeFormatter DATETIMEMILLISSYMBOL = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource
	private KafkaProducerService kafkaProducerService; // kafka

	@Resource(name = "authorityService")
	private AuthorityService authorityService;

	@Resource
	private ConfigAdminService configAdminService;

	@Autowired
	private AdminServiceImpl adminServiceImpl;
	private AbstractAggregationBuilder<TermsAggregationBuilder> termsAggregation;

	@Override
	public void setRead(final String msgId, final String adminId) {
		if (Common.isEmpty(msgId) || Common.isEmpty(adminId)) return;

		Query query = new Query(Criteria.where("_id").is(msgId));
		SolrCheckedVO vo = mongo.selectOne(query, SolrCheckedVO.class);

		boolean isEmpty = true;
		boolean update = false;
		String isAlreadyId = "";
		if (vo != null) {
			List<SolrCheckedVO.SolrCheckedAttr> checkedList = vo.getChecked();
			if (checkedList != null) {
				for (SolrCheckedVO.SolrCheckedAttr checked : checkedList) { //이미 등록된 운용자
					if (checked.getReadId().equals(adminId)) {
						isAlreadyId = adminId;
						update = true;
						break;
					}
				}
				/* 엘라스틱 인덱스도 같이 조회 */
//				if (!Common.isEmpty(isAlreadyId)) {
//					org.springframework.data.elasticsearch.core.query.Query searchQuery = new NativeSearchQueryBuilder()
//							.withQuery(QueryBuilders.termQuery("msgid",msgId))
//							.withTimeout(Duration.ofSeconds(60))
//							.build();
//					SearchHit<SolrEdcVO> searchHits = operation.searchOne(searchQuery, SolrEdcVO.class, IndexCoordinates.of(String.format("%s_w_%s", "edc", msgId.substring(0, 6))));
//					//SolrEdcVO solrEdcVO = operation.searchOne(searchQuery, SolrEdcVO.class, IndexCoordinates.of(String.format("%s_w_%s", "edc", msgId.substring(0, 6)))).getContent();
//					if (!Common.isEmpty(searchHits) && searchHits != null) {
//						SolrEdcVO solrEdcVO = searchHits.getContent();
//						List<Map<String, Object>> checked = solrEdcVO.getChecked();
//						for (Map<String, Object> map : checked) {
//							if (Common.isEquals(adminId, map.get("readId"))) {
//							isEmpty = false;
//							break;
//							}
//						}
//					}
//				}
			} else vo.setChecked(new ArrayList<>());
		} else {
			vo = new SolrCheckedVO();
			vo.setMsgId(msgId);
			vo.setChecked(new ArrayList<>());
		}

		if (isEmpty) {
			List<SolrCheckedVO.SolrCheckedAttr> checkedList = vo.getChecked();
			SolrCheckedVO.SolrCheckedAttr attr = new SolrCheckedVO.SolrCheckedAttr();
			attr.setReadId(adminId);
			attr.setReadTime(LocalDateTime.parse(new DateTime().toString(), DATETIMEMILLISSYMBOL).toDateTime(DateTimeZone.UTC));
			checkedList.add(attr);
			vo.setChecked(checkedList);
			log.info("checked : {}", vo);
			if (update){
				mongo.updateReadTimeIfExists("EMS_CHECKED",adminId, String.valueOf(LocalDateTime.parse(new DateTime().toString(), DATETIMEMILLISSYMBOL).toDateTime(DateTimeZone.UTC)));
			}else mongo.save(vo);
			String checkedTopic = "ems_ui_checked_index";
			kafkaProducerService.send(checkedTopic, "_id", msgId);
		}

	}


	@Override
	public SolrEdcMessageVO getCheckedStatList(SolrQuery sq) throws SolrServerException, IOException {
		SearchHits<SolrEdcVO> resp = solrEdcService.getList(sq);
		return new SolrEdcMessageVO(resp);
	}

	public SolrEdcMessageVO getCheckedStatList(final SolrQuery sq, final String adminId) throws SolrServerException, IOException {
		setAuthoritys(sq, adminId);
		SearchHits<SolrEdcVO> resp = solrEdcService.getList(sq);
		return new SolrEdcMessageVO(resp);
	}

	@Override
	public boolean setMessengerRead(List<SolrEdcVO> data, String adminId) {
		try {
			List<SolrCheckedVO> checkedList = new ArrayList<>();
			for (SolrEdcVO edc : data) {
				setRead(edc.getMsgid(), adminId);
			}
		} catch (Exception e) {
			log.error("", e);
			return false;
		}
		return true;
	}

	private void setAuthoritys(SolrQuery sq, String adminId) {
		if (Common.isNotEmpty(adminId)) {
			String adminType = "S";
			if (!Common.isOrEquals(adminId, "*")) {
				adminType = adminServiceImpl.getAdmin(adminId).getAdminType();
			}

			String ceoReadYn = Config.getString("ceo.readyn");

//			if (Common.isEquals(adminType, "C")) {
//				sq.addFilterQuery("+ceo:Y");
//			} else if (!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y"))) {
//				sq.addFilterQuery("-ceo:Y");
//			}

			sq.addFilterQuery("-svc:QEKH");
			JSONObject param = new JSONObject();
			param.put("adminId", adminId);
			param.put("queryType", Config.getString("query.type", "A"));
			List<AuthorityVO> authoritys = authorityService.getAdminAuthority(param);
			for (AuthorityVO authority : authoritys) {
				if (authority.getCnt() > 0) {
					sq.addFilterQuery(authority.getQuery());
				}
			}
			if (log.isInfoEnabled()) {
				StringBuilder sb = new StringBuilder();
				if (sq.getFilterQueries() != null) {
					for (int i = 0; i < sq.getFilterQueries().length; i++) {
						sb.append(sq.getFilterQueries()[i]).append(" ");
					}
				}
			}
		}
	}
}
