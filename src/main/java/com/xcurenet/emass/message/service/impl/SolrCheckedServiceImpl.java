package com.xcurenet.emass.message.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.KafkaProducerService;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.emass.message.service.*;
import lombok.extern.log4j.Log4j2;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.mapping.IndexCoordinates;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Log4j2
@Service("solrCheckedService")
public class SolrCheckedServiceImpl implements SolrCheckedService {

	@Autowired
	private MongoUtil mongo;

	@Autowired
	@Qualifier("elasticsearchTemplate")
	private ElasticsearchOperations operation;

	public static final DateTimeFormatter DATETIMEMILLISSYMBOL = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource
	private KafkaProducerService kafkaProducerService; // kafka

	@Override
	public void setRead(final String msgId, final String adminId) {
		if (Common.isEmpty(msgId) || Common.isEmpty(adminId)) return;

		Query query = new Query(Criteria.where("_id").is(msgId));
		SolrCheckedVO vo = mongo.selectOne(query, SolrCheckedVO.class);


		boolean mongoExist = false;


		if (vo != null) {
			List<SolrCheckedVO.SolrCheckedAttr> checkedList = vo.getChecked();
			if (checkedList != null) {
				String isAlreadyId = "";
				for (SolrCheckedVO.SolrCheckedAttr checked : checkedList) { //이미 등록된 운용자
					if (checked.getReadId().equals(adminId)) {
						isAlreadyId = adminId;
						mongoExist = true;
					}
				}
				/* 엘라스틱 인덱스도 같이 조회 */
				if (!Common.isEmpty(isAlreadyId)) {
					SolrEdcVO solrEdcVO = operation.get(msgId, SolrEdcVO.class, IndexCoordinates.of(String.format("%s_%s", "edc", msgId.substring(0, 6))));
					if (!Common.isEmpty(solrEdcVO)) {
						List<Map<String, Object>> checked = solrEdcVO.getChecked();
						for (Map<String, Object> map : checked) {
							if (Common.isEquals(adminId, map.get("readId"))) return;
						}
					}
				}

			} else vo.setChecked(new ArrayList<>());
		} else {
			vo = new SolrCheckedVO();
			vo.setMsgId(msgId);
			vo.setChecked(new ArrayList<>());
		}
		if (!mongoExist) {
			List<SolrCheckedVO.SolrCheckedAttr> checkedList = vo.getChecked();
			SolrCheckedVO.SolrCheckedAttr attr = new SolrCheckedVO.SolrCheckedAttr();
			attr.setReadId(adminId);
			attr.setReadTime(LocalDateTime.parse(new DateTime().toString(), DATETIMEMILLISSYMBOL).toDateTime(DateTimeZone.UTC));
			checkedList.add(attr);
			vo.setChecked(checkedList);
			log.info("checked : {}", vo);
			mongo.save(vo);
		}

		String checkedTopic = "ems_ui_checked_index";
		kafkaProducerService.send(checkedTopic, "_id", msgId);

	}


	@Override
	public SolrEdcMessageVO getCheckedStatList(SolrQuery sq) throws SolrServerException, IOException {
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
}
