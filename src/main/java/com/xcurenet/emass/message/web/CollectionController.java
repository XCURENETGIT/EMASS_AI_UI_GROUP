package com.xcurenet.emass.message.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.excel.XLSXWriter;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.emass.message.service.impl.SolrEdcServiceImpl;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.catalina.connector.ClientAbortException;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.io.IOUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.context.annotation.Scope;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Scope("prototype")
@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.MESSAGE_SERVICE)
public class CollectionController {

	@Autowired
	private MongoUtil mongo;

	private static final String MESSENGER2 = " +svc1: I ";
	private static final String MESSENGER3 = " +svc1: N ";
	private static final String MESSENGER4 = " +svc1: F ";

	private static final String EMPTY_LINE = "\n";
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	private final static DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd");
	private final static DateTimeFormatter HHmmss = DateTimeFormat.forPattern("HH:mm:ss");

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Autowired
	private SolrCheckedService solrCheckedService;

	@Autowired
	private EmsMessageService emsMessageService;

	@Autowired
	public MinioFileAdapter minioFileAdapter;



	@RequestMapping(value = "/getNoteList.xcn")
	@Description("노트 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getNoteList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getNoteList());
	}

	@RequestMapping(value = "/getGenerativeList.xcn")
	@Description(" 생성형 ai 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getGenerativeList());
	}

	@RequestMapping(value = "/getFileServiceList.xcn")
	@Description(" 파일전송 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getFileServiceList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getFileServiceList());
	}


	@RequestMapping(value = "/getFileMessageList.xcn")
	@Description("파일전송 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getFileMessageList(final HttpServletRequest request, final HttpSession session) throws Exception {

		JSONObject param = Common.getParam(request);
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		String name = Common.nvl(request.getParameter("userStr"));

		StringBuilder query = new StringBuilder();

		if (Common.isEquals(param.get("readYn"), "N")) {
			query.append(" -checked.readId:").append(Common.getAdminId(session));
		}
		if (!name.isEmpty()) {
			String[] nameArray = name.split(",");
			query.append(" +userid:((");

			for (int i = 0; i < nameArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(nameArray[i]);
			}

			query.append("))");
		}

		sq.setQuery(sq.getQuery()+query+ MESSENGER4 + " +userkey:* +attached:Y");
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 100));
		sq.setSort("ctime", ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "deptnm","businm", "jikgubnm", "usr_id");

		MessengerEdcGroupVO solrEdcGroupVO = solrEdcService.getMessengerGroupList(sq, Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, solrEdcGroupVO, solrEdcGroupVO.getNumFound());
	}



	@RequestMapping(value = "/getCollectionMessageSvc.xcn")
	@Description("메세지 서비스타입 조회")
	@ResponseBody
	public XcnResponseVO getCollectionMessageSvc(final HttpServletRequest request, final HttpSession session) throws Exception {
		MessengerGroupSvcVO  solrEdcGroupVO = getCollectionMessageSvc(request, 10000,session);
		return new XcnResponseVO(XcnRspCode.OK, solrEdcGroupVO,solrEdcGroupVO.getNumFoundsvc() );
	}

	public MessengerGroupSvcVO getCollectionMessageSvc(final HttpServletRequest request, final int rows,final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		String name = Common.nvl(request.getParameter("userStr"));
		String type = Common.nvl(request.getParameter("type"));

		StringBuilder query = new StringBuilder();

		if (Common.isEquals(param.get("readYn"), "N")) {
			query.append(" -checked.readId:").append(Common.getAdminId(session));
		}
		if (!name.isEmpty()) {
			String[] nameArray = name.split(",");
			query.append(" +userid:((");

			for (int i = 0; i < nameArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(nameArray[i]);
			}

			query.append("))");
		}


		sq.setQuery(sq.getQuery()+query);
		sq.setStart(0);
		sq.setRows(rows);
		sq.setFields("svc12", "srcip", "name", "conm", "businm", "deptnm", "jikgubnm", "suborgnm", "sname", "sender", "srcip", "sname", "user");
		sq.setParam("group", true);
		sq.setParam("group.field", "svc12,userkey");
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("facet", true);
		sq.setParam("facet.field", "userkey");
		MessengerGroupSvcVO result = solrEdcService.getCollectionMessageSvc(sq, Common.getAdminId(request));
		return result;
	}



	@AuditOperation(Operation.SEARCH)
	@RequestMapping(value = "/getCollectionGroupList.xcn")
	@Description("서비스 그룹 조회")
	@ResponseBody
	public XcnResponseVO getCollectionGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String name = Common.nvl(request.getParameter("userStr"));
	//	String type = Common.nvl(request.getParameter("type"));
		JSONObject param = Common.getParam(request);

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		StringBuilder query = new StringBuilder();

		if (Common.isEquals(param.get("readYn"), "N")) {
			query.append(" -checked.readId:").append(Common.getAdminId(session));
		}
		if (!name.isEmpty()) {
			String[] nameArray = name.split(",");
			query.append(" +userid:((");

			for (int i = 0; i < nameArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(nameArray[i]);
			}

			query.append("))");
		}

		sq.setQuery(sq.getQuery()+query);

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "svc12");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "userkey");



		/* 그룹 디테일검색 동적 들어와야 할 offset,size 값*/
		sq.setParam("facet.offset", String.valueOf(Common.nvz(param.get("offset"), 0)));
		sq.setParam("facet.group", String.valueOf(Common.nvz(param.get("limit"), 100)));
		sq.setParam("facet.detail", false);
		sq.setParam("facet.list", true);
		sq.setParam("facet.mincount", "1");
		sq.setParam("facet.sort", "DESC");

		/* 일반 문서 검색은 하지않으므로 0 (그룹검색만 하므로 ) */
		sq.setStart(Common.nvz(request.getParameter("offset"), 0));
		sq.setRows(Common.nvz(request.getParameter("limit"), 100000));

		sq.setSort("ctime", ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc12","svc3","userkey", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id", "userkey");

		MessengerEdcGroupVO solrEdcGroupVO = solrEdcService.getMessengerGroupList(sq, Common.getAdminId(request));

		/* 그룹 짓기 */
		Map<String,List<MessengerGroupVO>> groupMap =  new HashMap<>();
		List<MessengerGroupVO> groupList = solrEdcGroupVO.getGroups();
		for(MessengerGroupVO messengerGroupVO : groupList){
			List<MessengerGroupVO> tempList = new ArrayList<>();
			if(groupMap.containsKey(messengerGroupVO.getSvc12())){
				tempList = groupMap.get(messengerGroupVO.getSvc12());
				tempList.add(messengerGroupVO);
			}else{
				tempList.add(messengerGroupVO);
			}
			groupMap.put(messengerGroupVO.getSvc12(),tempList);
		}

		/* Header 구하기 */
		Map<String,Integer> tempHeaderMap = new HashMap<>();
		for(Map.Entry<String, List<MessengerGroupVO>> gmap  : groupMap.entrySet()){
			tempHeaderMap.put(gmap.getKey(),groupMap.get(gmap.getKey()).size()); // header Insert
		}

		/* 총 계산 (안읽음처리)*/
		MessengerEdcGroupVO messengerEdcGroupVO = getCheckedList(request,session);
		messengerEdcGroupVO.setGroupMaps(groupMap);
		messengerEdcGroupVO.aggregationsCheckedParser();
		messengerEdcGroupVO.putHeaderMap(tempHeaderMap);


		long NumFound= solrEdcGroupVO.getNumFound();

		return new XcnResponseVO(XcnRspCode.OK, messengerEdcGroupVO, NumFound);
	}

	public MessengerEdcGroupVO getCheckedList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String name = Common.nvl(request.getParameter("userStr"));

		JSONObject param = Common.getParam(request);

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));

		StringBuilder query = new StringBuilder();

		if (Common.isEquals(param.get("readYn"), "N")) {
			query.append(" -checked.readId:").append(Common.getAdminId(session));
		}
		if (!name.isEmpty()) {
			String[] nameArray = name.split(",");
			query.append(" +userid:((");

			for (int i = 0; i < nameArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(nameArray[i]);
			}

			query.append("))");
		}


		sq.setQuery(sq.getQuery()+query);

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "svc12");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "userkey");


		/* 그룹 디테일검색 동적 들어와야 할 offset,size 값*/
		sq.setParam("facet.offset", String.valueOf(Common.nvz(param.get("offset"), 0)));
		sq.setParam("facet.group", String.valueOf(Common.nvz(param.get("limit"), 100)));
		sq.setParam("facet.detail", false);
		sq.setParam("facet.list", true);
		sq.setParam("facet.mincount", "1");
		sq.setParam("facet.sort", "DESC");

		/* 일반 문서 검색은 하지않으므로 0 (그룹검색만 하므로 ) */
		sq.setStart(Common.nvz(request.getParameter("offset"), 0));
		sq.setRows(Common.nvz(request.getParameter("limit"), 100000));

		sq.setSort("ctime", ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc12","svc3","userkey", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id", "userkey");


		String currentQuery = sq.getQuery();
		sq.setParam("checked.readId", "checked.readId");
		int ctimeIdx = currentQuery.indexOf("]") + 1;
		currentQuery = currentQuery.substring(ctimeIdx);
		sq.setQuery(currentQuery);
		return solrEdcService.getMessengerGroupList(sq, Common.getAdminId(request));
	}



	public List<MessengerGroupVO> setCount_temp(List<MessengerGroupVO> groups, String adminId, JSONObject param) throws IOException, SolrServerException {
		List<String> userids = new ArrayList<>();
		List<String> svc12s = new ArrayList<>();
		for (MessengerGroupVO group : groups) {
			userids.add("\"" + group.getUserid() + "\"");
			svc12s.add("\"" + group.getSvc12() + "\"");
		}
		if (userids.size() == 0) return groups;

		//* 임시 주석*//*
		Map<String, Long> unReadCount = getUnReadCount_temp(userids, svc12s, adminId,param);

		for (MessengerGroupVO group : groups) {
			group.setUnread_cnt(Common.nvn(unReadCount.get(group.getUserid())));
		}
		return groups;
	}

	private Map<String, Long> getUnReadCount_temp(List<String> userids,List<String> svc12s, String adminId, JSONObject param) throws IOException, SolrServerException {

		SolrQuery sq = new SolrQuery();
		String query="";

		if (!userids.isEmpty()) {
			query +=" +userkey:((";

			for (int i = 0; i < userids.size(); i++) {
				if (i > 0) {
					query+=") (";
				}
				query+=userids.get(i);
			}

			query+="))";
		}

		if (!svc12s.isEmpty()) {
			query +=" +svc12:((";

			for (int i = 0; i < svc12s.size(); i++) {
				if (i > 0) {
					query+=") (";
				}
				query+=svc12s.get(i);
			}

			query+="))";
		}

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "svc12");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "userkey");

		query += String.format("+ctime:[%s TO %s] ",
				Common.nvl(param.get("startTotalDate"), "defaultStartDate"),
				Common.nvl(param.get("endTotalDate"), "defaultEndDate")
		);

		sq.setQuery(query);
		sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, adminId));

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("facet.detail", true);
		sq.setParam("facet.list", false);
		sq.setParam("group.field", "userkey");
		sq.setStart(0);
		sq.setRows(Common.MAX_VALUE);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr");

		Map<String, Long> cnt = new HashMap<>();
		MessengerEdcGroupVO solrEdcGroupVO = solrEdcService.getMessengerGroupList(sq, adminId);
		List<MessengerGroupVO> groups = solrEdcGroupVO.getGroups();

		for (MessengerGroupVO group : groups) {
			Query query2 = new Query(Criteria.where("_id").is(group.getMsgid()));
			SolrCheckedVO vo = mongo.selectOne(query2, SolrCheckedVO.class);
			if (vo==null) {
				int cnt2 = 0;
				if (cnt.containsKey(group.getUserid())) {
					// 이미 해당 키가 존재하는 경우, 중복 방지를 위해 값을 더하지 않고 새로운 값을 설정
					cnt2 = cnt.get(group.getUserid()).intValue() + 1;
				} else {
					// 해당 키가 존재하지 않는 경우, 값을 설정
					cnt2 = 1;
				}
				cnt.put(group.getUserid(), (long) cnt2);
			}
		}
		return cnt;

	}


	/**
	 * 괄호 생성
	 *
	 * @param argment
	 * @return
	 */
	private String makeParentheses(String argment) {
		StringBuilder tempSb = new StringBuilder();
		tempSb.append(ElasticSearchCommon.OPEN_PARENTHESES);
		tempSb.append(argment);
		tempSb.append(ElasticSearchCommon.CLOSE_PARENTHESES);
		return tempSb.toString();
	}

	@RequestMapping(value = "/getGenerativeMessage.xcn")
	@Description("생성형ai/노트 대화내용 목록 조회")
	/*	@AuditOperation(Operation.SEARCH)*/
	@ResponseBody
	public XcnResponseVO getGenerativeMessage(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String msgId = Common.nvl(param.get("msgId"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String type = Common.nvl(param.get("type"));


		int startRange = 0;
		int endRange = 0;

		SolrQuery sq = new SolrQuery();
		if (Common.isEmpty(msgId)) {

			EmsMessengerAdminXrootMtrVO emaxm = emsMessageService.getEmassGenerativeAdminXrootMtr(userkey, Common.getAdminId(request), srcip, usr_id,type);

			if (Common.isNotEmpty(emaxm)) {
				msgId = Common.nvl(emaxm.getMsgId());
				startRange = Common.diffOfDate(startDt.substring(0, 8), msgId.substring(0, 8));
				endRange = Common.diffOfDate(endDt.substring(0, 8), msgId.substring(0, 8));
			}

		}

		if (Common.isEmpty(msgId) || (startRange < 0) || (endRange > 0)) {
			sq = getCollectionMessageTotalQuery(request);
		} else {
			sq = getMessengerGtNext(request, msgId, true);
		}


		MessengerEdcGroupVO result = solrEdcService.getMessengerGroupList(sq, Common.getAdminId(request), true, false);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/getCollectionMessageTotal.xcn")
	@Description("서비스 대화방 대화 내용 전체 건수 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeMessageTotal(final HttpServletRequest request, final HttpSession session) throws Exception {
		MessengerEdcGroupVO result = getCollectionMessageTotal(request);
		return new XcnResponseVO(XcnRspCode.OK, result.getNumFound());
	}


	@RequestMapping(value = "/getGenerativeMessageNext.xcn")
	@Description("생성형 대화방 다음 대화 내용 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeMessagenext(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));

		SolrQuery sq = getMessengerGtNext(request, msgId, false);
		MessengerEdcGroupVO result = solrEdcService.getMessengerGroupList(sq, Common.getAdminId(request), true, false);


		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/getGenerativeMessagePrev.xcn")
	@Description("생성형 대화방 이전 대화 내용 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeMessagePrev(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));

		SolrQuery prevQuery = getMessengerGtPrev(request, msgId);
		MessengerEdcGroupVO result = solrEdcService.getMessengerGroupList(prevQuery, Common.getAdminId(request), true, false);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}


	public SolrQuery getMessengerGtNext(final HttpServletRequest request, final String msgId, final boolean lastMsgYn) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String searchStr = Common.nvl(param.get("searchStr"));
		String type = Common.nvl(param.get("type"));
		int limit = Common.nvz(param.get("limit"), 10000);

		SolrQuery sq = new SolrQuery();
		String query = String.format("+ctime:[%s TO %s] +userkey:\"%s\"", startDt, endDt, userkey);

		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);

		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
		else query += String.format(" -usr_id:*");

		//이미 출력된 동시간대 데이터 제외
		if(Common.isNotEmpty(msgId)) {
			if(lastMsgYn) {
				query += String.format(" +msgid:[%s TO *]", msgId);
			} else {
				query += String.format(" +msgid:{%s TO *]", msgId);
			}
		}

		if(type.equals("N")||type.equals("G")){
			if (type.equals("N")){
				query +=String.format(" +svc1:N");
			}else{
				query +=String.format(" +svc1:I");
			}
		}
		else{
			String[] svcArray = type.split(",");
			query +=String.format(" +svc12:((");

			for (int i = 0; i < svcArray.length; i++) {
				if (i > 0) {
					query+=String.format(") (");
				}
				query+=String.format(svcArray[i]);
			}

			query+=String.format("))");
		}


		if(Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);

		sq.setQuery(query);
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(limit);
		sq.addSort("ctime", ORDER.asc);
		sq.addSort("msgid", ORDER.asc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachhash", "attachname", "attachsize", "xrootmtr", "deptnm", "jikgubnm", "usr_id", "user");

		return sq;
	}

	public SolrQuery getMessengerGtPrev(final HttpServletRequest request, final String msgId) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String searchStr = Common.nvl(param.get("searchStr"));
		String type = Common.nvl(param.get("type"));
		int limit = Common.nvz(param.get("limit"), 10000);

		SolrQuery sq = new SolrQuery();
		String query = String.format("+ctime:[%s TO %s] +userkey:\"%s\"", startDt, endDt, userkey);

		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);

		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
		else query += String.format(" -usr_id:*");
		if(type.equals("N")||type.equals("G")){
			if (type.equals("N")){
				query +=String.format(" +svc1:N");
			}else{
				query +=String.format(" +svc1:I");
			}
		}
		else{
			String[] svcArray = type.split(",");
			query +=String.format(" +svc12:((");

			for (int i = 0; i < svcArray.length; i++) {
				if (i > 0) {
					query+=String.format(") (");
				}
				query+=String.format(svcArray[i]);
			}

			query+=String.format("))");
		}

		//이미 출력된 동시간대 데이터 제외
		if(Common.isNotEmpty(msgId)) {
			query += String.format(" +msgid:[* TO %s}", msgId);
		}

		if(Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);

		sq.setQuery(query);
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(limit);
		sq.addSort("ctime", ORDER.desc);
		sq.addSort("msgid", ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachhash", "attachname", "attachsize", "xrootmtr", "deptnm", "jikgubnm", "usr_id", "user");

		return sq;
	}

	public MessengerEdcGroupVO getCollectionMessageTotal(final HttpServletRequest request) throws Exception {
		return getCollectionMessageTotal(request, false);
	}

	public MessengerEdcGroupVO getCollectionMessageTotal(final HttpServletRequest request, boolean original) throws Exception {
		SolrQuery totalQuery = getCollectionMessageTotalQuery(request);
		MessengerEdcGroupVO result = solrEdcService.getMessengerGroupList(totalQuery, Common.getAdminId(request), true, original);
		return result;
	}


	public SolrQuery getCollectionMessageTotalQuery(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String type = Common.nvl(param.get("type"));
		int limit = Common.nvz(param.get("limit"), 10000);

		SolrQuery sq = new SolrQuery();
		String query = String.format("+ctime:[%s TO %s] +userkey:\"%s\"", startDt, endDt, userkey);

		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);

		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
		else query += String.format(" -usr_id:*");

		if(type.equals("N")||type.equals("G")){
			if (type.equals("N")){
				query +=String.format(" +svc1:N");
			}else{
				query +=String.format(" +svc1:I");
			}
		}
		else{
				String[] svcArray = type.split(",");
				query +=String.format(" +svc12:((");

				for (int i = 0; i < svcArray.length; i++) {
					if (i > 0) {
						query+=String.format(") (");
					}
					query+=String.format(svcArray[i]);
				}

				query+=String.format("))");
		}


		sq.setQuery(query);
		sq.setRows(limit);
		sq.addSort("ctime", ORDER.asc);
		sq.addSort("msgid", ORDER.asc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachhash", "attachname", "attachsize", "xrootmtr", "deptnm", "jikgubnm", "usr_id", "user");

		return sq;

	}


	private boolean setMessengerRead(List<SolrEdcVO> emass, String adminId) {
		if (Common.isEmpty(emass)) return false;
		return solrCheckedService.setMessengerRead(emass, adminId);
	}

	@RequestMapping(value = "/updateEmassGenerativeAdminUserid.xcn")
	@Description("생성형ai/노트 대화방 운용자 최종 위치 저장")
	@ResponseBody
	public XcnResponseVO updateEmassGenerativeAdminUserid(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String msgId = Common.nvl(param.get("msgId"));
		String srcip = Common.nvl(param.get("srcip"));
		String type = Common.nvl(param.get("type"));


		emsMessageService.updateEmassGenerativeAdminUserid(userkey, msgId, Common.getAdminId(request), srcip,type);
		return new XcnResponseVO(XcnRspCode.OK);
	}


	@RequestMapping(value = "/getGenerativeGroupDetailSearch.xcn")
	@Description("생성형ai/노트 대화방 상세 검색 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeGroupDetailSearch(final HttpServletRequest request, final HttpSession session) throws Exception {

		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String type = Common.nvl(param.get("type"));

		String addQuery = String.format(" +userkey:\"%s\"", userkey);
		if(Common.isNotEmpty(srcip)) addQuery += String.format(" +srcip:\"%s\"", srcip);

		if(type.equals("N")||type.equals("G")){
			if (type.equals("N")){
				addQuery +=String.format(" +svc1:N");
			}else{
				addQuery +=String.format(" +svc1:I");
			}
		}
			else{
				String[] svcArray = type.split(",");
				addQuery +=String.format(" +svc12:((");

				for (int i = 0; i < svcArray.length; i++) {
					if (i > 0) {
						addQuery+=String.format(") (");
					}
					addQuery+=String.format(svcArray[i]);
				}

				addQuery+=String.format("))");
			}

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		sq.setQuery(sq.getQuery() + addQuery);
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(1);
		sq.setSort("ctime", ORDER.asc);
		sq.setSort("msgid", ORDER.asc);
		sq.setFields("msgid");

		SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(session));
		List<SolrEdcVO> list = solrVo.getEmass();
		List<String> result = new ArrayList<>();
		if (list != null) {
			for (SolrEdcVO vo : list) {
				result.add(vo.getMsgid());
			}
		}
		return new XcnResponseVO(XcnRspCode.OK, result, solrVo.getNumFound());
	}


	@RequestMapping(value = "/getCollectionGroupAttachList.xcn")
	@Description("생성형ai/노트 대화방 첨부 전송 리스트 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeGroupAttachList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String searchStr = Common.nvl(param.get("searchStr"));
		String type = Common.nvl(param.get("type"));

		SolrQuery sq = new SolrQuery();
		String query = "";
		if (Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt))
			query += String.format("+ctime:[%s TO %s] ", startDt, endDt);
		query += String.format("+userkey:\"%s\" +attached:Y", userkey);

		if(type.equals("N")||type.equals("G")){
			if (type.equals("N")){
				query +=String.format(" +svc1:N");
			}else{
				query +=String.format(" +svc1:I");
			}
		}
		else{
			String[] svcArray = type.split(",");
			query +=String.format(" +svc12:((");

			for (int i = 0; i < svcArray.length; i++) {
				if (i > 0) {
					query+=String.format(") (");
				}
				query+=String.format(svcArray[i]);
			}

			query+=String.format("))");
		}
		if (Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);
		if (Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);

		sq.setQuery(query);

		sq.setStart(0);
		sq.setRows(10000);

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "userkey");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "userkey");
		SolrEdcMessageVO edcVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		List<Map<String, String>> result = new ArrayList<>();
		List<SolrEdcVO> emass = edcVO.getEmass();
		if (emass != null) {
			for (SolrEdcVO edc : emass) {
				List<String> attachs = edc.getAttachname();
				List<String> attachHashs = edc.getAttachhash();
				List<Long> attachSizes = edc.getAttachsize();
				List<String> attachtypes = edc.getAttachtype();
				if (attachs == null) break;
				for (int i = 0; i < attachs.size(); i++) {
					String attach = attachs.get(i);
					Map<String, String> obj = new HashMap<>();
					obj.put("msgid", edc.getMsgid());
					obj.put("ctime", edc.getCtime());
					obj.put("srcip", edc.getSrcip());
					obj.put("user", edc.getUser());
					obj.put("name", edc.getName());
					obj.put("sender", edc.getSender());
					obj.put("sname", edc.getSname());
					obj.put("conm", edc.getConm());
					obj.put("businm", edc.getBusinm());
					obj.put("xrootmtr", edc.getXrootmtr());
					obj.put("deptnm", edc.getDeptnm());
					obj.put("jikgubnm", edc.getJikgubnm());
					obj.put("attachname", attach);
					if (attachHashs == null) obj.put("attachhash", Common.EMPTY);
					else obj.put("attachhash", Common.nvl(attachHashs.get(i)));
					obj.put("attachsize", Common.nvl(attachSizes.get(i)));
					obj.put("attachtype", Common.nvl(attachtypes.get(i)));
					result.add(obj);
				}
			}
		}
		return new XcnResponseVO(XcnRspCode.OK, result, result.size());
	}

	@RequestMapping(value = "/getGenerativeGroupUserCnt.xcn")
	@Description("서비스 대화방 참여자 건수 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeGroupUserCnt(final HttpServletRequest request, final HttpSession session) throws Exception {
		MessengerGroupUserVO solrEdcGroupVO = getGenerativeGroupUserList(request, 0);
		return new XcnResponseVO(XcnRspCode.OK, solrEdcGroupVO.getNumFoundUser(), solrEdcGroupVO.getNumFoundUser());
	}

	public MessengerGroupUserVO getGenerativeGroupUserList(final HttpServletRequest request, final int rows) throws IOException, SolrServerException {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String groupField = Common.nvl(param.get("groupField"), "usr_id");
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String searchStr = Common.nvl(param.get("searchStr"));

		SolrQuery sq = new SolrQuery();

		String query = "";
		if (Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt))
			query += String.format("+ctime:[%s TO %s] ", startDt, endDt);

		query += String.format("+userkey:\"%s\" ", userkey) + (Common.nvl(param.get("type")).equals("N") ? MESSENGER3 : (Common.nvl(param.get("type")).equals("G") ? MESSENGER2 : (Common.nvl(param.get("type")).equals("F") ? MESSENGER4 : "")));


		if (Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);
		if (Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
		if (Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);

		sq.setQuery(query);
		sq.setSort("ctime", ORDER.desc);
		sq.setStart(0);
		sq.setRows(rows);
		sq.setFields("usr_id", "srcip", "name", "conm", "businm", "deptnm", "jikgubnm", "suborgnm", "sname", "sender", "srcip", "sname", "user");
		sq.setParam("group", true);
		sq.setParam("group.field", groupField);
		sq.setParam("facet", true);
		sq.setFacetLimit(rows);
		//	sq.setParam("facet.pivot", groupField+"srcip");  // "{!stats=usr_id}"+groupField=",srcip"  내용
		if (Common.isEquals(groupField, "usr_id")) sq.setParam("facet.query", "-usr_id:*");
		sq.setParam("facet.field", "srcip");
		sq.setFacetMinCount(1);
		//group=true&group.field=usr_id&facet=true&facet.pivot={!stats=usr_id}usr_id,srcip&facet.query=-usr_id:*&facet.field=srcip

		MessengerGroupUserVO solrEdcGroupVO = solrEdcService.getGenerativeGroupUserList(sq, Common.getAdminId(request));
		return solrEdcGroupVO;
	}


	private JSONObject getXlsxHeader(String key, String title, String width, String align, String type) {
		JSONObject headerObj = new JSONObject();
		headerObj.put("key", key);
		headerObj.put("title", title);
		headerObj.put("width", width);
		headerObj.put("align", align);
		if (type != null) headerObj.put("type", type);
		return headerObj;
	}

	private JSONObject getXlsxHeader(String key, String title, String width, String align) {
		return getXlsxHeader(key, title, width, align, null);
	}

	private void xlsxExport(String xRootMtr, MessengerEdcGroupVO groups, OutputStream out, boolean link, Locale locale) throws Exception {
		JSONArray header = new JSONArray();
		header.add(getXlsxHeader("sender", Prop.propFormat("eikon.msg.sender", locale), "130", "center"));
		header.add(getXlsxHeader("ctime", Prop.propFormat("eikon.msg.send.time"), "130", "center"));
		header.add(getXlsxHeader("content", Prop.propFormat("eikon.msg.chatContents", locale), "750", "left", "LINK"));

		JSONArray data = new JSONArray();
		List<MessengerGroupVO> list = groups.getGroups();
		if (list != null) {
			for (MessengerGroupVO item : list) {
				JSONObject dataObj = new JSONObject();
				dataObj.put("sender", item.getTitle());
				dataObj.put("ctime", item.getCtime());
				dataObj.put("content", item.getMessage());
				if (link && Common.isEquals(item.getAttached(), "Y")) {
					dataObj.put("content_LINK", Common.makeFilepath("attachs", item.getMsgid()));
				}
				data.add(dataObj);
			}
		}
		XLSXWriter xlsx = new XLSXWriter(Prop.propFormat("eikon.msg.export.chat", locale) + " : " + xRootMtr, header, data, out);
		xlsx.execute();
	}

	public String getFileName(String xRootMtr, MessengerGroupUserVO users, Locale locale) {
		String fileName = Common.EMPTY;
		List<String> groupUsers = new ArrayList<>();
		if (users != null) {
			for (SolrEdcVO user : users.getGroups()) {
				String name = Common.nvl(user.getSname());
				String usr_id = Common.nvl(user.getUsr_id());
				String srcip = Common.nvl(user.getSrcip());

				if (Common.isEmpty(name)) {
					if (Common.isNotEmpty(usr_id)) name = usr_id;
					else if (Common.isNotEmpty(srcip)) name = srcip;
					else name = Common.nvl(user.getUser());
				} else {
					if (Common.isNotEmpty(usr_id)) name += " (" + usr_id + ")";
					if (Common.isNotEmpty(srcip)) name += " (" + srcip + ")";
				}


				if (groupUsers.size() <= 2) groupUsers.add(name);
				else break;
			}
			fileName = Common.join(groupUsers, ",") + String.format(" (Total %s" + Prop.propFormat("eikon.msg.person", locale) + ")", users.getGroups().size());
			fileName = fileName.replaceAll("[\\\\/:*?\"<>|]", "");
		}
		if (Common.isEmpty(fileName)) fileName = xRootMtr;
		return fileName;
	}


	@RequestMapping(value = "/getCollectionGroupAllExport.xcn")
	@Description("서비스 대화내용 압축 내보내기")
	@ResponseBody
	public void getCollectionGroupAllExport(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");

		ServletOutputStream out = null;
		ArchiveOutputStream os = null;
		try {
			response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.zip\"");

			out = response.getOutputStream();
			os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
			MessengerEdcGroupVO groups = getCollectionMessageTotal(request, true);
			inputAttach(os, groups);
			inputCollectionZipExcel(os, groups, userkey, Common.getLocale(request.getSession()));

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(os);
			IOUtils.closeQuietly(out);
			response.flushBuffer();
		}
	}

	public String getGroupBody(List<MessengerGroupVO> data, String rootmtr, Locale locale) throws Exception {
		StringBuffer _sb = new StringBuffer();
		_sb.append("<table class=\"g_request\"><colgroup><col width=\"120\"><col width=\"*\"><col width=\"70\"></colgroup><tbody>").append(EMPTY_LINE);
		String tempDay = "";
		for (MessengerGroupVO item : data) {
			String day = DateTime.parse(item.getCtime(), yyyyMMddHHmmss2).toString(yyyyMMdd);
			String time = DateTime.parse(item.getCtime(), yyyyMMddHHmmss2).toString(HHmmss);
			if (Common.isNotEquals(day, tempDay)) {
				_sb.append(String.format("<tr><th class=\"date_title\" colspan=\"3\">%s</th></tr>", day)).append(EMPTY_LINE);
				tempDay = day;
			}
			_sb.append(String.format("<tr><th>%s</th><td>%s</td><td>%s</td></tr>", item.getTitle(), item.getMessage().replaceAll("\n", "<br>"), time)).append(EMPTY_LINE);
		}
		_sb.append("</tbody></table>");
		return _sb.toString();
	}


	private void inputCollectionZipExcel(ArchiveOutputStream os, MessengerEdcGroupVO groups, String userkey, Locale locale) throws IOException, Exception {

		ByteArrayOutputStream xOut = new ByteArrayOutputStream();
		ByteArrayInputStream bIn = null;
		try {
			String name = userkey;
			os.putArchiveEntry(new ZipArchiveEntry(name + ".xlsx"));
			xlsxCollectionExport(userkey, groups, xOut, true, locale);

			bIn = new ByteArrayInputStream(xOut.toByteArray());
			IOUtils.copy(bIn, os);
			os.closeArchiveEntry();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(bIn);
			IOUtils.closeQuietly(xOut);
		}
	}


	private void inputAttach(ArchiveOutputStream os, MessengerEdcGroupVO groups) throws Exception {
		List<MessengerGroupVO> list = groups.getGroups();
		if (list != null) {
			EmsAttachDownload attachDown = new EmsAttachDownload();
			for (MessengerGroupVO item : list) {

				List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(item.getMsgid(), null);
				for (EmsAttachVO attach : attachs) {
					InputStream in = null;
					try {
						String path = attach.getAttachPath();
						String harPath = attach.getAttachHarPath();
						log.info("path:{}, harPath:{}", path, harPath);
						in = minioFileAdapter.findFile(attach.getAttachPath());
						if (in == null) continue;
						os.putArchiveEntry(new ZipArchiveEntry(Common.makeFilepath("attachs", item.getMsgid(), attach.getAttachName())));
						IOUtils.copy(in, os);
						os.closeArchiveEntry();
					} catch (ClientAbortException e) {
						throw new Exception(e);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						IOUtils.closeQuietly(in);
					}
				}
			}
		}
	}

	@RequestMapping(value = "/getCollectionrGroupTextExport.xcn")
	@Description("서비스 대화내용 내보내기")
	@ResponseBody
	public void getCollectionrGroupTextExport(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		JSONObject param = Common.getParam(request);
		String userkey = Common.nvl(param.get("userkey"));
		String print = Common.nvl(param.get("print"));
		String usr_id = "";
		String type = Common.nvl(param.get("export_type"), "html").toLowerCase();
		if (!Common.isOrEquals(type, "html", "txt", "xlsx")) type = "html";

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Disposition", "inline");
		if (Common.isEmpty(userkey)) {
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Content-Disposition", "attachment; filename=notfound.txt\"");
			return;
		}

		Locale locale = Common.getLocale(request.getSession());

		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			MessengerEdcGroupVO groups = getCollectionMessageTotal(request, true);

			if (Common.isEquals(type, "xlsx")) {
				response.setContentType("application/octet-stream");
				response.setHeader("Content-Transfer-Encoding", "binary");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + userkey + "." + type + "\"");
				xlsxCollectionExport(userkey, groups, out, false, Common.getLocale(request.getSession()));
			} else {
				if (Common.isNotEquals(print, "Y")) {
					response.setContentType("application/octet-stream");
					response.setHeader("Content-Transfer-Encoding", "binary");
				}
				StringBuffer _sb = new StringBuffer();
				if (Common.isEquals(type, "html")) {
					_sb.append("<html><body><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><pre>");
				}
				_sb.append("<" + Prop.propFormat("condition.xrootmtr", locale) + ">").append(Common.EMPTY_LINE);
				_sb.append(userkey).append(Common.EMPTY_LINE).append(Common.EMPTY_LINE);
				_sb.append("<" + Prop.propFormat("condition.participation", locale) + ">").append(Common.EMPTY_LINE);

				_sb.append(Common.EMPTY_LINE);
				_sb.append("<" + Prop.propFormat("eikon.msg.chatContents", locale) + ">").append(Common.EMPTY_LINE);
				List<MessengerGroupVO> list = groups.getGroups();
				if (list != null) {
					for (MessengerGroupVO item : list) {
						_sb.append(String.format("[%s] [%s] %s", item.getTitle(), item.getCtime(), item.getBody_snippet())).append(Common.EMPTY_LINE);
					}
				}
				if (Common.isEquals(type, "html")) {
					_sb.append("</pre></body></html>");
				}
				if (Common.isNotEquals(print, "Y")) {
					response.setContentLength(_sb.toString().getBytes().length);
					response.setHeader("Content-Disposition", "attachment; filename=\"" + userkey + "." + type + "\"");
				}
				out.write(_sb.toString().getBytes());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
		}
	}

	private void xlsxCollectionExport(String userkey, MessengerEdcGroupVO groups, OutputStream out, boolean link, Locale locale) throws Exception {
		JSONArray header = new JSONArray();
		header.add(getXlsxHeader("sender", Prop.propFormat("eikon.msg.sender", locale), "130", "center"));
		header.add(getXlsxHeader("content", Prop.propFormat("eikon.msg.chatContents", locale), "750", "left", "LINK"));

		JSONArray data = new JSONArray();
		List<MessengerGroupVO> list = groups.getGroups();
		if (list != null) {
			for (MessengerGroupVO item : list) {
				JSONObject dataObj = new JSONObject();
				dataObj.put("sender", item.getTitle());
				dataObj.put("ctime", item.getCtime());
				dataObj.put("content", item.getBody_snippet());
				if (link && Common.isEquals(item.getAttached(), "Y")) {
					dataObj.put("content_LINK", Common.makeFilepath("attachs", item.getMsgid()));
				}
				data.add(dataObj);
			}
		}
		XLSXWriter xlsx = new XLSXWriter(Prop.propFormat("eikon.msg.export.chat", locale) + " : " + userkey, header, data, out);
		xlsx.execute();
	}
}
