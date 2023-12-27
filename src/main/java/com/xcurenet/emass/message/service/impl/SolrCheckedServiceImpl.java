package com.xcurenet.emass.message.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.KafkaProducerService;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.emass.message.service.SolrCheckedService;
import com.xcurenet.emass.message.service.SolrCheckedVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcVO;
import lombok.extern.log4j.Log4j2;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
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

	public static final DateTimeFormatter DATETIMEMILLISSYMBOL = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

	@Resource
	private KafkaProducerService kafkaProducerService; // kafka

	@Override
	public void setRead(final String msgId, final String adminId) {
		if (Common.isEmpty(msgId) || Common.isEmpty(adminId)) return;

		Query query = new Query(Criteria.where("_id").is(msgId));
		SolrCheckedVO vo = mongo.selectOne(query, SolrCheckedVO.class);
		if (vo != null) {
			List<SolrCheckedVO.SolrCheckedAttr> checkedList = vo.getChecked();
			if (checkedList != null) {
				for (SolrCheckedVO.SolrCheckedAttr checked : checkedList) { //이미 등록된 운용자
					if (checked.getReadId().equals(adminId)) return;
				}
			} else vo.setChecked(new ArrayList<>());
		} else {
			vo = new SolrCheckedVO();
			vo.setMsgId(msgId);
			vo.setChecked(new ArrayList<>());
		}
		List<SolrCheckedVO.SolrCheckedAttr> checkedList = vo.getChecked();
		SolrCheckedVO.SolrCheckedAttr attr = new SolrCheckedVO.SolrCheckedAttr();
		attr.setReadId(adminId);
		attr.setReadDate(LocalDateTime.parse(new DateTime().toString(), DATETIMEMILLISSYMBOL).toDateTime(DateTimeZone.UTC));
		checkedList.add(attr);
		vo.setChecked(checkedList);
		mongo.save(vo);

		String checkedTopic = "ems_ui_checked_index";
		kafkaProducerService.send(checkedTopic, "_id", msgId);
	}


	@Override
	public SolrEdcMessageVO getCheckedStatList(SolrQuery sq) throws SolrServerException, IOException {
//		QueryResponse resp = getList(sq);
//		return new SolrEdcMessageVO(resp);

		return null;
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
