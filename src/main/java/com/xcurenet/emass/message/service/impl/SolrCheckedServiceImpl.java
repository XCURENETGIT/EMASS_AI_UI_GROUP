package com.xcurenet.emass.message.service.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrRequest.METHOD;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrInputDocument;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import com.xcurenet.common.solr.SolrConnection;
import com.xcurenet.common.util.Common;
import com.xcurenet.emass.message.service.SolrCheckedConstant;
import com.xcurenet.emass.message.service.SolrCheckedService;
import com.xcurenet.emass.message.service.SolrCheckedVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcVO;

@Service("solrCheckedService")
public class SolrCheckedServiceImpl implements SolrCheckedService {

	@Resource(name = "checkedSolrClient")
	private SolrConnection checkedSolrClient;

	private static final  DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private static final  DateTimeFormatter HH = DateTimeFormat.forPattern("HH");
	private static final  DateTimeFormatter yyyy = DateTimeFormat.forPattern("yyyy");
	private static final  DateTimeFormatter yyyyMM = DateTimeFormat.forPattern("yyyyMM");
	private static final  DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");
	private static final  int BULK_CNT = 100;

	private static final int COMMIT_WITH_IN_MS = 3000;

	public QueryResponse getList(SolrQuery sq) throws SolrServerException, IOException {
		return checkedSolrClient.getSolrServer().query(sq, METHOD.POST);
	}
	@Override
	public List<SolrCheckedVO> getCheckedList(SolrQuery sq) throws SolrServerException, IOException {
		QueryResponse resp = getList(sq);
		return resp.getBeans(SolrCheckedVO.class);
	}

	@Override
	public List<SolrEdcVO> findReadList(final List<SolrEdcVO> emass, final String adminId) throws SolrServerException, IOException {
		if (emass == null) return emass;
		if (Common.isEmpty(adminId)) return emass;

		SolrQuery sq = new SolrQuery();
		sq.setStart(0);
		sq.setRows(Integer.MAX_VALUE);
		sq.setFields("msgid");

		String prefix = " +msgid:(";
		List<String> reads = new ArrayList<>();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < emass.size(); i++) {
			SolrEdcVO msg = emass.get(i);
			sb.append(msg.getMsgid()).append(" ");

			if (i % BULK_CNT == 0 && i > 0 || emass.size() == (i + 1)) {
				sq.setQuery("+id:" + adminId + prefix + sb.toString() + ")");
				List<SolrCheckedVO> checkeds = getCheckedList(sq);
				for (int j = 0; j < checkeds.size(); j++) {
					reads.add(checkeds.get(j).msgid);
				}
				checkeds.clear();
				sb = new StringBuilder();
			}
		}

		for (int i = 0; i < emass.size(); i++) {
			SolrEdcVO msg = emass.get(i);
			if (reads.contains(msg.getMsgid())) msg.setReadYn("Y");
			else msg.setReadYn("N");
			emass.set(i, msg);
		}
		return emass;
	}

	@Override
	public void setRead(SolrCheckedVO checked) {
		if (Common.isEmpty(checked.msgid) || Common.isEmpty(checked.id)) return;
		if (Common.isEmpty(checked.key)) {
			checked.key = checked.msgid + "@" + checked.id;
		}

		SolrInputDocument doc = null;
		try {

			SolrQuery sq = new SolrQuery();
			sq.setRows(1);
			sq.setFields("msgid");
			sq.setQuery("key:" + checked.key);
			if (CollectionUtils.isNotEmpty(getCheckedList(sq))) return;

			DateTime dt = new DateTime();
			doc = new SolrInputDocument();
			doc.addField(SolrCheckedConstant.KEY, checked.getKey());
			doc.addField(SolrCheckedConstant.ID, checked.getId());
			doc.addField(SolrCheckedConstant.MSGID, checked.getMsgid());
			doc.addField(SolrCheckedConstant.DATE, yyyyMMddHHmmss.print(dt));
			doc.addField(SolrCheckedConstant.DATE_HH, HH.print(dt));
			doc.addField(SolrCheckedConstant.DATE_YYYY, yyyy.print(dt));
			doc.addField(SolrCheckedConstant.DATE_YYYYMM, yyyyMM.print(dt));
			doc.addField(SolrCheckedConstant.DATE_YYYYMMDD, yyyyMMdd.print(dt));

			doc.addField(SolrCheckedConstant.CTIME, checked.getCtime());
			doc.addField(SolrCheckedConstant.CTIME_HH, checked.getCtime_hh());
			doc.addField(SolrCheckedConstant.CTIME_YYYY, checked.getCtime_yyyy());
			doc.addField(SolrCheckedConstant.CTIME_YYYYMM, checked.getCtime_yyyymm());
			doc.addField(SolrCheckedConstant.CTIME_YYYYMMDD, checked.getCtime_yyyymmdd());
			doc.addField(SolrCheckedConstant.BUSICD, checked.getBusicd());
			doc.addField(SolrCheckedConstant.IP_BUSICD, checked.getIp_busicd());
			doc.addField(SolrCheckedConstant.SVC, checked.getSvc());
			checkedSolrClient.getSolrServer().add(doc, COMMIT_WITH_IN_MS);
		} catch (final IOException | SolrServerException e) {
			e.printStackTrace();
		} finally {
			if(doc != null)doc.clear();
		}
	}


	@Override
	public SolrEdcMessageVO getCheckedStatList(SolrQuery sq) throws SolrServerException, IOException {
		QueryResponse resp = getList(sq);
		/*
		 * List<FacetVO> facet = new ArrayList<FacetVO>();; List<FacetField>
		 * fields = resp.getFacetFields(); FacetField field = fields.get(1);
		 * System.out.println("field="+field.toString()); List<Count> values =
		 * field.getValues(); for (Count count : values) { FacetVO facetVo = new
		 * FacetVO(); facetVo.setName(count.getName());
		 * facetVo.setCount(count.getCount()); facet.add(facetVo); } return
		 * facet;
		 */
		return new SolrEdcMessageVO(resp);
	}

	private void setRead(List<SolrCheckedVO> checkeds) throws SolrServerException, IOException {
		List<SolrInputDocument> docs = new ArrayList<>();
		for (SolrCheckedVO checked : checkeds) {
			if (Common.isEmpty(checked.msgid) || Common.isEmpty(checked.id)) continue;
			if (Common.isEmpty(checked.key)) {
				checked.key = checked.msgid + "@" + checked.id;
			}

			SolrInputDocument doc = null;
			SolrQuery sq = new SolrQuery();
			sq.setRows(1);
			sq.setFields("msgid");
			sq.setQuery("key:" + checked.key);
			if (CollectionUtils.isNotEmpty(getCheckedList(sq))) continue;

			DateTime dt = new DateTime();
			doc = new SolrInputDocument();
			doc.addField(SolrCheckedConstant.KEY, checked.getKey());
			doc.addField(SolrCheckedConstant.ID, checked.getId());
			doc.addField(SolrCheckedConstant.MSGID, checked.getMsgid());
			doc.addField(SolrCheckedConstant.DATE, yyyyMMddHHmmss.print(dt));
			doc.addField(SolrCheckedConstant.DATE_HH, HH.print(dt));
			doc.addField(SolrCheckedConstant.DATE_YYYY, yyyy.print(dt));
			doc.addField(SolrCheckedConstant.DATE_YYYYMM, yyyyMM.print(dt));
			doc.addField(SolrCheckedConstant.DATE_YYYYMMDD, yyyyMMdd.print(dt));

			doc.addField(SolrCheckedConstant.CTIME, checked.getCtime());
			doc.addField(SolrCheckedConstant.CTIME_HH, checked.getCtime_hh());
			doc.addField(SolrCheckedConstant.CTIME_YYYY, checked.getCtime_yyyy());
			doc.addField(SolrCheckedConstant.CTIME_YYYYMM, checked.getCtime_yyyymm());
			doc.addField(SolrCheckedConstant.CTIME_YYYYMMDD, checked.getCtime_yyyymmdd());
			doc.addField(SolrCheckedConstant.BUSICD, checked.getBusicd());
			doc.addField(SolrCheckedConstant.IP_BUSICD, checked.getIp_busicd());
			doc.addField(SolrCheckedConstant.SVC, checked.getSvc());
			docs.add(doc);
		}

		try {
			if(CollectionUtils.isNotEmpty(docs)) {
				checkedSolrClient.getSolrServer().add(docs, COMMIT_WITH_IN_MS);
			}
		} catch (final IOException | SolrServerException e) {
			e.printStackTrace();
		}
	}

	@Override
	public boolean setMessengerRead(List<SolrEdcVO> data, String adminId) {
		try {
			List<SolrCheckedVO> checkeds = new ArrayList<>();
			for (SolrEdcVO edc : data) {
				SolrCheckedVO checked = new SolrCheckedVO();
				checked.setId(adminId);
				checked.setMsgid(edc.getMsgid());
				checked.setCtime(edc.getCtime());
				checked.setCtime_hh(edc.getCtime_hh());
				checked.setCtime_yyyy(edc.getCtime_yyyy());
				checked.setCtime_yyyymm(edc.getCtime_yyyymm());
				checked.setCtime_yyyymmdd(edc.getCtime_yyyymmdd());

				checkeds.add(checked);
			}
			setRead(checkeds);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public static void main(String[] args) throws SolrServerException, IOException {

		ApplicationContext context = new ClassPathXmlApplicationContext("com/spring/context-*.xml");
		try {
			SolrConnection sc = (SolrConnection) context.getBean("emassSolrClient");

			SolrInputDocument doc = new SolrInputDocument();
			doc.addField("msgid", "20180727155956.A22XT5KYCD4A7M34OR2QGN6R5Z6XIF4I");

			HashMap<String, Object> value = new HashMap<String, Object>();
			value.put("set", 3);
			doc.addField("ml_confd_class", value);

			sc.getSolrServer().add(doc);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			((ConfigurableApplicationContext) context).close();
			System.exit(1);
		}


//
//		SolrCheckedVO checked = new SolrCheckedVO();
//		checked.msgid = "20160601160526.HGRXXGTXIR7JM6XLQLANAJBQMTNPEULP";
//		checked.id = "sysadmin";
//		checked.ctime = "20160601160526";
//		checked.svc = "MP3-";
//
//		if (Common.isEmpty(checked.key)) {
//			checked.key = checked.msgid + "@" + checked.id;
//		}
//
//		SolrInputDocument doc = null;
//		try {
//
//			SolrQuery sq = new SolrQuery();
//			sq.setRows(1);
//			sq.setFields("msgid");
//			sq.setQuery("key:" + checked.key);
//
//			doc = new SolrInputDocument();
//			doc.addField("key", checked.key);
//			doc.addField("msg", checked.msgid);
//			doc.addField("id", checked.id);
//			doc.addField("ctime", checked.ctime);
//			doc.addField("date", yyyyMMddHHmmss.print(new DateTime()));
//
//			if (Common.isNotEmpty(checked.busicd)) doc.addField("busicd", checked.busicd);
//			if (Common.isNotEmpty(checked.svc)) doc.addField("svc", checked.svc);
//
//			sc.getSolrServer().add(doc);
//			sc.getSolrServer().commit();
//			/*UpdateRequest req = new UpdateRequest();
//			req.setAction(UpdateRequest.ACTION.COMMIT, false, false);
//			req.add(doc);
//			UpdateResponse rsp = req.process(sc.getSolrServer());*/
//		} catch (IOException | SolrServerException e) {
//			e.printStackTrace();
//		} finally {
//			doc.clear();
//		}


	}

}
