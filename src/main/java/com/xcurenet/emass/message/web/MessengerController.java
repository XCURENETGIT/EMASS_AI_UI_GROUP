package com.xcurenet.emass.message.web;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.excel.XLSXWriter;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.elasticsearch.ElasticSearchCommon;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.newService.EmsSearchService;
import com.xcurenet.emass.message.service.EmsAttachVO;
import com.xcurenet.emass.message.service.EmsMessageService;
import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.vo.emass.EmassIntegrated;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import com.xcurenet.emass.message.vo.emass.els.EmassMessenger;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.catalina.connector.ClientAbortException;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.io.IOUtils;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.util.*;

@Scope("prototype")
@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.MESSAGE_SERVICE)
public class MessengerController {

	private static final String MESSENGER = " +svc1:(Q T) ";
	private static final String MESSENGER2 = " +svc1:(I T) ";
	private static final String EMPTY_LINE = "\n";
	private final static DateTimeFormatter yyyyMMddHHmmss2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	private final static DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyy-MM-dd");
	private final static DateTimeFormatter HHmmss = DateTimeFormat.forPattern("HH:mm:ss");


	@Resource(name = "emsSearchService")
	private EmsSearchService emsSearchService;


	@Autowired
	private EmsMessageService emsMessageService;


//	private boolean setMessengerRead(List<SolrEdcVO> emass, String adminId) {
//		if (Common.isEmpty(emass)) return false;
//		return solrCheckedService.setMessengerRead(emass, adminId);
//	}

	@RequestMapping(value = "/setMessengerRead.xcn")
	@Description("메신저 읽음 여부 처리")
	@ResponseBody
	public XcnResponseVO setMessengerRead(final HttpServletRequest request, final HttpSession session) throws Exception {
//		String data = Common.nvl(request.getParameter("body"));
//		JSONArray datas = Common.toJSONArray(data);
//		log.info("datas: "+datas);
//		List<SolrEdcVO> emass = new ArrayList<>();
//		for (int i = 0; i < datas.size(); i++) {
//			SolrEdcVO edc = new SolrEdcVO();
//			log.info("msgid: "+datas.getJSONObject(i).getString("msgid"));
//			edc.setMsgid(datas.getJSONObject(i).getString("msgid"));
//			edc.setCtime(datas.getJSONObject(i).getString("ctime").replaceAll("-", "").replaceAll(" ", "").replaceAll(":", ""));
//			log.info("ctime: "+datas.getJSONObject(i).getString("ctime").replaceAll("-", "").replaceAll(" ", "").replaceAll(":", ""));
//			edc.setCtime_hh(datas.getJSONObject(i).getString("ctime").substring(11, 13));
//			edc.setCtime_yyyy(datas.getJSONObject(i).getString("ctime").substring(0, 4));
//			edc.setCtime_yyyymm(datas.getJSONObject(i).getString("ctime").substring(0, 7).replaceAll("-", ""));
//			edc.setCtime_yyyymmdd(datas.getJSONObject(i).getString("ctime").substring(0, 10).replaceAll("-", ""));
//			emass.add(edc);
//		}
		return new XcnResponseVO(XcnRspCode.OK);
	}


	@RequestMapping(value = "/getMessengerGroupList.xcn")
	@Description("메신저 대화방 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getMessengerGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSENGER_GROUP);

		}
		/*
		**** setCount 작성
		 */
		MessengerEdcGroupVO edcMessage = emsSearchService.getMessengerGroupList(searchParam, Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, edcMessage, edcMessage.getTotal());
	}

	@RequestMapping(value = "/getMessengerMessageList.xcn")
	@Description("메신저 대화내용 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getMessengerMessageList(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSENGER);
		}
		MessengerEdcGroupVO edcMessage = emsSearchService.getMessengerGroupList(searchParam, Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, edcMessage, edcMessage.getTotal());

	}


	@RequestMapping(value = "/getMessengerGroupDetailSearch.xcn")
	@Description("메신저 대화방 상세 검색 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getMessengerGroupDetailSearch(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSENGER_DETAIL);
		}

		MessengerEdcGroupVO messengerEdcGroupVO = emsSearchService.getMessengerGroupList(searchParam,Common.getAdminId(session));
		List<Emass> list = (List<Emass>) messengerEdcGroupVO.getEmass();
		List<String> result = new ArrayList<>();
		if (list != null){
			for (Emass vo : list){
				result.add(vo.getMsgid());
			}
		}

		return new XcnResponseVO(XcnRspCode.OK, result, messengerEdcGroupVO.getTotal());
	}



	@RequestMapping(value = "/getMessengerMessage.xcn")
	@Description("메신저 대화방 대화 내용 조회")
	@ResponseBody
	public XcnResponseVO getMessengerMessage(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSENGER_TOTAL);
		}

		MessengerEdcGroupVO result = emsSearchService.getMessengerGroupList(searchParam, Common.getAdminId(request), true);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}

//	public List<EmassMessenger> setCount(List<EmassMessenger> groups, String adminId) throws IOException {
//		List<String> xrootmtrs = new ArrayList<>();
//		for (EmassMessenger group : groups) {
//			xrootmtrs.add("\"" + group.getXrootmtr() + "\"");
//		}
//		if (xrootmtrs.size() == 0) return groups;
//
//		Map<String, Long> allCount = getAllCount(xrootmtrs);
//		Map<String, Long> unReadCount = getUnReadCount(xrootmtrs, adminId);
//
//		for (EmassMessenger group : groups) {
//			group.setMsg_cnt(Common.nvn(allCount.get(group.getXrootmtr())));
//			group.setUnread_cnt(Common.nvn(unReadCount.get(group.getXrootmtr())));
//		}
//		return groups;

/*
	private Map<String, Long> getAllCount(List<String> xrootmtrs) throws IOException, SolrServerException {
		SolrQuery sq = new SolrQuery();
		sq.setQuery(String.format("+xrootmtr:( %s ) %s", Common.join(xrootmtrs, " "), MESSENGER));
		sq.setRows(0);
		sq.addFacetField("xrootmtr");
		sq.setFacetLimit(-1);
		sq.setFacetMinCount(1);
		sq.setFacetSort("index");
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, null);

		Map<String, Long> cnt = new HashMap<>();
		List<FacetVO> facet = edc.getFacet();
		if (facet != null) {
			for (FacetVO vo : facet) {
				cnt.put(vo.getName(), vo.getCount());
			}
		}
		return cnt;
	}*/
/*
	private Map<String, Long> getUnReadCount(List<String> xrootmtrs, String adminId) throws IOException, SolrServerException {
		SolrQuery sq = new SolrQuery();
		sq.setQuery(String.format(" +xrootmtr:( %s ) %s ", Common.join(xrootmtrs, " "), MESSENGER));
		sq.setQuery(sq.getQuery() + String.format(SolrEdcServiceImpl.JOIN_UNREAD, adminId));

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "xrootmtr");
		sq.setStart(0);
		sq.setRows(Common.MAX_VALUE);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr");

		Map<String, Long> cnt = new HashMap<>();
		MessengerEdcGroupVO solrEdcGroupVO = solrEdcService.getMessengerGroupList(sq, adminId);
		List<EmassMessenger> groups = solrEdcGroupVO.getGroups();
		for (EmassMessenger group : groups) {
			cnt.put(group.getXrootmtr(), group.getMsg_cnt());
		}
		return cnt;
	}*/

	@RequestMapping(value = "/getMessengerGenertiveList.xcn")
	@Description("생성형 AI 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getMessengerGenertiveList(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_COLLECTION);
		}
		MessengerEdcGroupVO edcMessage = emsSearchService.getMessengerGroupList(searchParam, Common.getAdminId(request));
//		Gson gson = new Gson();
//		Map<String,Object> resultParam = Common.getParamMap(request);
//		Map<String,String> searchParam = new HashMap<>();
//		if(!Common.isEmpty(resultParam.get("searchParam"))){
//			Type type = new TypeToken<Map<String,String>>(){}.getType();
//			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
//		}

		return new XcnResponseVO(XcnRspCode.OK, edcMessage, edcMessage.getNumFound());

	}

	@RequestMapping(value = "/getMessengerNoteList.xcn")
	@Description("노트 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getMessengerNoteList(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSAGE);
		}
		MessengerEdcGroupVO edcMessage = emsSearchService.getMessengerGroupList(searchParam, Common.getAdminId(request));
//		Gson gson = new Gson();
//		Map<String,Object> resultParam = Common.getParamMap(request);
//		Map<String,String> searchParam = new HashMap<>();
//		if(!Common.isEmpty(resultParam.get("searchParam"))){
//			Type type = new TypeToken<Map<String,String>>(){}.getType();
//			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
//		}

		return new XcnResponseVO(XcnRspCode.OK, edcMessage, edcMessage.getNumFound());

	}


	@RequestMapping(value = "/getFiletransferList.xcn")
	@Description("파일전송 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getFiletransferList(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if(!Common.isEmpty(resultParam.get("searchData"))){
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchData"),type);
			searchParam.put("elsSearchType", ElasticSearchCommon.SEARCH_TYPE_MESSAGE);
		}
		/*############################################################################*/

		EmassIntegrated edcMessage = emsSearchService.getEmassMessage(searchParam,Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, edcMessage, edcMessage.getTotal());

	}

	@RequestMapping(value = "/getMessengerMessageTotal.xcn")
	@Description("메신저 대화방 대화 내용 전체 건수 조회")
	@ResponseBody
	public XcnResponseVO getMessengerMessageTotal(final HttpServletRequest request, final HttpSession session) throws Exception {
		MessengerEdcGroupVO result = getMessengerMsgTotal(request);
		return new XcnResponseVO(XcnRspCode.OK, result.getNumFound());
	}

//
//	@RequestMapping(value = "/getMessengerMessageNext.xcn")
//	@Description("메신저 대화방 다음 대화 내용 조회")
//	@ResponseBody
//	public XcnResponseVO getMessengerMessageNext(final HttpServletRequest request, final HttpSession session) throws Exception {
//		JSONObject param = Common.getParam(request);
//		String msgId = Common.nvl(param.get("msgId"));
//
//		SolrQuery nextQuery = getMessengerMsgNext(request, msgId, false);
//		MessengerEdcGroupVO result = solrEdcService.getMessengerGroupList(nextQuery, Common.getAdminId(request), true, false);
//
//		return new XcnResponseVO(XcnRspCode.OK, result);
//	}

	@RequestMapping(value = "/getMessengerMessagePrev.xcn")
	@Description("메신저 대화방 이전 대화 내용 조회")
	@ResponseBody
	public XcnResponseVO getMessengerMessagePrev(final HttpServletRequest request, final HttpSession session) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchParam"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchParam"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSENGER_TOTAL);
			log.info("Controller Prev Message: "+searchParam);
		}
		//return new XcnResponseVO(XcnRspCode.OK, result);
		return new XcnResponseVO(XcnRspCode.OK, 0);
	}

	public MessengerEdcGroupVO getMessengerMsgTotal(final HttpServletRequest request) throws Exception {
		return getMessengerMsgTotal(request, false);
	}

	public MessengerEdcGroupVO getMessengerMsgTotal(final HttpServletRequest request, boolean original) throws Exception {
		Gson gson = new Gson();
		Map<String,Object> resultParam = Common.getParamMap(request);
		Map<String,Object> searchParam = new HashMap<>();
		if (!Common.isEmpty(resultParam.get("searchData"))) {
			Type type = new TypeToken<Map<String,Object>>(){}.getType();
			searchParam = gson.fromJson((String) resultParam.get("searchData"),type);
			searchParam.put(ElasticSearchCommon.SEARCH_TYPE, ElasticSearchCommon.SEARCH_TYPE_MESSENGER_TOTAL);

		}
		MessengerEdcGroupVO result = emsSearchService.getMessengerGroupList(searchParam, Common.getAdminId(request), true, original);
		return result;
	}

//	public SolrQuery getMessengerMsgNext(final HttpServletRequest request, final String msgId, final boolean lastMsgYn) throws Exception {
//		JSONObject param = Common.getParam(request);
//		String xRootMtr = Common.nvl(param.get("xRootMtr"));
//		String srcip = Common.nvl(param.get("srcip"));
//		String usr_id = Common.nvl(param.get("usr_id"));
//		String startDt = Common.nvl(param.get("startDt"));
//		String endDt = Common.nvl(param.get("endDt"));
//		String searchStr = Common.nvl(param.get("searchStr"));
//		int limit = Common.nvz(param.get("limit"), 100000);
//
//		SolrQuery sq = new SolrQuery();
//		String query = String.format("+ctime:[%s TO %s] +xrootmtr:\"%s\"", startDt, endDt, xRootMtr);
//
//		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);
//
//		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
//		else query += String.format(" -usr_id:*");
//
//		//이미 출력된 동시간대 데이터 제외
//		if(Common.isNotEmpty(msgId)) {
//			if(lastMsgYn) {
//				query += String.format(" +msgid:[%s TO *]", msgId);
//			} else {
//				query += String.format(" +msgid:{%s TO *]", msgId);
//			}
//		}
//
//		if(Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);
//
//		sq.setQuery(query + MESSENGER);
//		sq.setStart(Common.nvz(param.get("offset"), 0));
//		sq.setRows(limit);
//		sq.addSort("ctime", ORDER.asc);
//		sq.addSort("msgid", ORDER.asc);
//		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachhash", "attachname", "attachsize", "xrootmtr", "deptnm", "jikgubnm", "usr_id", "user");
//
//		return sq;
//	}
//
//	public SolrQuery getMessengerMsgPrev(final HttpServletRequest request, final String msgId) throws Exception {
//		JSONObject param = Common.getParam(request);
//		String xRootMtr = Common.nvl(param.get("xRootMtr"));
//		String srcip = Common.nvl(param.get("srcip"));
//		String usr_id = Common.nvl(param.get("usr_id"));
//		String startDt = Common.nvl(param.get("startDt"));
//		String endDt = Common.nvl(param.get("endDt"));
//		String searchStr = Common.nvl(param.get("searchStr"));
//		int limit = Common.nvz(param.get("limit"), 100000);
//
//		SolrQuery sq = new SolrQuery();
//		String query = String.format("+ctime:[%s TO %s] +xrootmtr:\"%s\"", startDt, endDt, xRootMtr);
//
//		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);
//
//		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
//		else query += String.format(" -usr_id:*");
//
//		//이미 출력된 동시간대 데이터 제외
//		if(Common.isNotEmpty(msgId)) {
//			query += String.format(" +msgid:[* TO %s}", msgId);
//		}
//
//		if(Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);
//
//		sq.setQuery(query + MESSENGER);
//		sq.setStart(Common.nvz(param.get("offset"), 0));
//		sq.setRows(limit);
//		sq.addSort("ctime", ORDER.desc);
//		sq.addSort("msgid", ORDER.desc);
//		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachhash", "attachname", "attachsize", "xrootmtr", "deptnm", "jikgubnm", "usr_id", "user");
//
//		return sq;
//	}

	private boolean setMessengerRead( String adminId) {
		return false;
	}

	@RequestMapping(value = "/updateEmassMessengerAdminXrootMtr.xcn")
	@Description("메신저 대화방 운용자 최종 위치 저장")
	@ResponseBody
	public XcnResponseVO updateEmassMessengerAdminXrootMtr(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		String msgId = Common.nvl(param.get("msgId"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		emsMessageService.updateEmassMessengerAdminXrootMtr(xRootMtr, msgId, Common.getAdminId(request), srcip, usr_id);
		return new XcnResponseVO(XcnRspCode.OK);
	}

//	@RequestMapping(value = "/getMessengerGroupDetailCtimes.xcn")
//	@Description("메신저 대화방 상세 유효한 날짜 조회")
//	@ResponseBody
//	public XcnResponseVO getMessengerGroupDetailCtimes(final HttpServletRequest request, final HttpSession session) throws Exception {
//
//		JSONObject param = Common.getParam(request);
//		String xRootMtr = Common.nvl(param.get("xRootMtr"));
//		String srcip = Common.nvl(param.get("srcip"));
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(String.format("+xrootmtr:\"%s\" +srcip:\"%s\"", xRootMtr, srcip) + MESSENGER);
//		sq.setRows(0);
//		sq.addFacetField("ctime_yyyymmdd");
//		sq.setFacetLimit(-1);
//		sq.setFacetMinCount(1);
//		sq.setFacetSort("index");
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
//
//		List<String> result = new ArrayList<>();
//		List<FacetVO> facet = edc.getFacet();
//		if (facet != null) {
//			for (FacetVO vo : facet) {
//				result.add(vo.getName());
//			}
//		}
//		return new XcnResponseVO(XcnRspCode.OK, result, result.size());
//	}



//	@RequestMapping(value = "/getMessengerGroupAttachCnt.xcn")
//	@Description("메신저 대화방 첨부 전송 건수 조회")
//	@ResponseBody
//	public XcnResponseVO getMessengerGroupAttachCnt(final HttpServletRequest request, final HttpSession session) throws Exception {
//
//		JSONObject param = Common.getParam(request);
//		String xRootMtr = Common.nvl(param.get("xRootMtr"));
//		String srcip = Common.nvl(param.get("srcip"));
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(String.format("+xrootmtr:\"%s\" +srcip:\"%s\" +attached:Y", xRootMtr, srcip) + MESSENGER);
//		sq.setStart(Common.nvz(param.get("offset"), 0));
//		sq.setRows(Common.nvz(param.get("limit"), 0));
//		MessengerEdcGroupVO solrEdcGroupVO = solrEdcService.getMessengerGroupList(sq, Common.getAdminId(request), true);
//		return new XcnResponseVO(XcnRspCode.OK, solrEdcGroupVO.getNumFound(), solrEdcGroupVO.getNumFound());
//	}

/*
	@RequestMapping(value = "/getMessengerGroupAttachList.xcn")
	@Description("메신저 대화방 첨부 전송 리스트 조회")
	@ResponseBody
	public XcnResponseVO getMessengerGroupAttachList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String searchStr = Common.nvl(param.get("searchStr"));

		SolrQuery sq = new SolrQuery();
		String query = "";
		if(Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt)) query += String.format("+ctime:[%s TO %s] ", startDt, endDt);
		query += String.format("+xrootmtr:\"%s\" +attached:Y", xRootMtr);
		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
		else query += " -usr_id:*";
		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);
		if(Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);

		sq.setQuery(query + MESSENGER);
		sq.setStart(0);
		sq.setRows(30000);
		sq.setSort("ctime", ORDER.asc);
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
*/

/*	@RequestMapping(value = "/getMessengerGroupUserCnt.xcn")
	@Description("메신저 대화방 참여자 건수 조회")
	@ResponseBody
	public XcnResponseVO getMessengerGroupUserCnt(final HttpServletRequest request, final HttpSession session) throws Exception {
		MessengerGroupUserVO solrEdcGroupVO = getMessengerGroupUserList(request, 0);
		return new XcnResponseVO(XcnRspCode.OK, solrEdcGroupVO.getNumFoundUser(), solrEdcGroupVO.getNumFoundUser());
	}*/


	@RequestMapping(value = "/getMessengerGroupUserList.xcn")
	@Description("메신저 대화방 참여자 리스트 조회")
	@ResponseBody
	public XcnResponseVO getMessengerGroupUserList(final HttpServletRequest request, final HttpSession session) throws Exception {
//		MessengerGroupUserVO EdcGroupVO = getMessengerGroupUserList(request, 10000);
		return new XcnResponseVO(XcnRspCode.OK, null, 0);
	}





/*	public MessengerGroupUserVO getMessengerGroupUserList(final HttpServletRequest request, final int rows) throws IOException, SolrServerException {
		JSONObject param = Common.getParam(request);
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		String groupField = Common.nvl(param.get("groupField"), "usr_id");
		String srcip = Common.nvl(param.get("srcip"));
		String usr_id = Common.nvl(param.get("usr_id"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String searchStr = Common.nvl(param.get("searchStr"));

		SolrQuery sq = new SolrQuery();

		String query = "";
		if(Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt)) query += String.format("+ctime:[%s TO %s] ", startDt, endDt);

		query += String.format("+xrootmtr:\"%s\" ", xRootMtr) + MESSENGER;

		if(Common.isNotEmpty(srcip)) query += String.format(" +srcip:\"%s\"", srcip);
		if(Common.isNotEmpty(usr_id)) query += String.format(" +usr_id:\"%s\"", usr_id);
		if(Common.isNotEmpty(searchStr)) query += String.format(" +body:(*%s*) ", searchStr);

		sq.setQuery(query);
		sq.setSort("ctime", ORDER.desc);
		sq.setStart(0);
		sq.setRows(rows);
		sq.setFields("usr_id", "srcip", "name", "conm", "businm", "deptnm", "jikgubnm", "suborgnm", "sname", "sender", "srcip", "sname", "user");
		sq.setParam("group", true);
		sq.setParam("group.field", groupField);
		sq.setParam("facet", true);
		sq.setFacetLimit(rows);
		sq.setParam("facet.pivot", "{!stats=usr_id}"+groupField+",srcip");
		if(Common.isEquals(groupField, "usr_id")) sq.setParam("facet.query", "-usr_id:*");
		sq.setParam("facet.field", "srcip");
		sq.setFacetMinCount(1);
		//group=true&group.field=usr_id&facet=true&facet.pivot={!stats=usr_id}usr_id,srcip&facet.query=-usr_id:*&facet.field=srcip

		MessengerGroupUserVO solrEdcGroupVO = solrEdcService.getMessengerGroupUserList(sq, Common.getAdminId(request));
		return solrEdcGroupVO;
	}*/

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
		List<EmassMessenger> list = groups.getGroups();
		if (list != null) {
			for (EmassMessenger item : list) {
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
//
//	public String getFileName(String xRootMtr, MessengerGroupUserVO users, Locale locale) {
//		String fileName = Common.EMPTY;
////		List<String> groupUsers = new ArrayList<>();
////		if (users != null) {
////			for (SolrEdcVO user : users.getGroups()) {
////				String name = Common.nvl(user.getSname());
////				String usr_id = Common.nvl(user.getUsr_id());
////				String srcip = Common.nvl(user.getSrcip());
////
////				if(Common.isEmpty(name)) {
////					if(Common.isNotEmpty(usr_id)) name = usr_id;
////					else if(Common.isNotEmpty(srcip)) name = srcip;
////					else name = Common.nvl(user.getUser());
////				}else {
////					if(Common.isNotEmpty(usr_id)) name += " ("+usr_id+")";
////					if(Common.isNotEmpty(srcip)) name += " ("+srcip+")";
////				}
////
////
////				if (groupUsers.size() <= 2) groupUsers.add(name);
////				else break;
////			}
////			fileName = Common.join(groupUsers, ",") + String.format(" (Total %s" + Prop.propFormat("eikon.msg.person", locale) + ")", users.getGroups().size());
////			fileName = fileName.replaceAll("[\\\\/:*?\"<>|]", "");
////		}
////		if (Common.isEmpty(fileName)) fileName = xRootMtr;
//		return fileName;


	@RequestMapping(value = "/getMessengerGroupAllExport.xcn")
	@Description("메신저 대화내용 내보내기")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getMessengerGroupAllExport(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

//		JSONObject param = Common.getParam(request);
//		String xRootMtr = Common.nvl(param.get("xRootMtr"));
//
//		response.setCharacterEncoding(Common.UTF8);
//		response.setHeader("Cache-control", "no-store");
//		response.setHeader("Pragma", "no-cache");
//		response.setDateHeader("Expires", 0);
//		response.setContentType("application/octet-stream");
//		response.setHeader("Content-Transfer-Encoding", "binary");
//		response.setHeader("Connection", "close");
//
//		ServletOutputStream out = null;
//		ArchiveOutputStream os = null;
//		try {
//			response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.zip\"");
//
//			out = response.getOutputStream();
//			os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
//			MessengerEdcGroupVO groups = getMessengerMsgTotal(request, true);
//			MessengerGroupUserVO users = getMessengerGroupUserList(request, 30000);
//			inputAttach(os, groups);
//			inputZipExcel(os, groups, users, xRootMtr, Common.getLocale(request.getSession()));
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			IOUtils.closeQuietly(os);
//			IOUtils.closeQuietly(out);
//			response.flushBuffer();
//		}
	}


//	public String getGroupBody(List<EmassMessenger> data, String rootmtr, Locale locale) throws Exception {
//		StringBuffer _sb = new StringBuffer();
//		_sb.append("<table class=\"g_request\"><colgroup><col width=\"120\"><col width=\"*\"><col width=\"70\"></colgroup><tbody>").append(EMPTY_LINE);
//		String tempDay = "";
//		for (EmassMessenger item : data) {
//			String day = DateTime.parse(item.getCtime(), yyyyMMddHHmmss2).toString(yyyyMMdd);
//			String time = DateTime.parse(item.getCtime(), yyyyMMddHHmmss2).toString(HHmmss);
//			if (Common.isNotEquals(day, tempDay)) {
//				_sb.append(String.format("<tr><th class=\"date_title\" colspan=\"3\">%s</th></tr>", day)).append(EMPTY_LINE);
//				tempDay = day;
//			}
//			_sb.append(String.format("<tr><th>%s</th><td>%s</td><td>%s</td></tr>", item.getTitle(), item.getMessage().replaceAll("\n", "<br>"), time)).append(EMPTY_LINE);
//		}
//		_sb.append("</tbody></table>");
//		return _sb.toString();
//	}
//
//	private void inputZipExcel(ArchiveOutputStream os, MessengerEdcGroupVO groups, MessengerGroupUserVO users, String xRootMtr, Locale locale) throws IOException, Exception {
//
////		ByteArrayOutputStream xOut = new ByteArrayOutputStream();
////		ByteArrayInputStream bIn = null;
////		try {
////			String name = getFileName(xRootMtr, users, locale);
////			os.putArchiveEntry(new ZipArchiveEntry(name + ".xlsx"));
////
////			xlsxExport(xRootMtr, groups, xOut, true, locale);
////
////			bIn = new ByteArrayInputStream(xOut.toByteArray());
////			IOUtils.copy(bIn, os);
////			os.closeArchiveEntry();
////		} catch (Exception e) {
////			e.printStackTrace();
////		} finally {
////			IOUtils.closeQuietly(bIn);
////			IOUtils.closeQuietly(xOut);
////		}
//	}


	private void inputAttach(ArchiveOutputStream os, MessengerEdcGroupVO groups) throws Exception {
		List<EmassMessenger> list = groups.getGroups();
		if (list != null) {
			EmsAttachDownload attachDown = new EmsAttachDownload();
			for (EmassMessenger item : list) {
				List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(item.getMsgid(), null);
				for (EmsAttachVO attach : attachs) {
					InputStream in = null;
					try {
						String path = attach.getAttachPath();
						String harPath = attach.getAttachHarPath();
						log.info("path:{}, harPath:{}", path, harPath);
						in = attachDown.getAttach(path, harPath);
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

	@RequestMapping(value = "/getMessengerGroupTextExport.xcn")
	@Description("메신저 대화내용 내보내기")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getMessengerGroupTextExport(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

//		JSONObject param = Common.getParam(request);
//		String xRootMtr = Common.nvl(param.get("xRootMtr"));
//		String print = Common.nvl(param.get("print"));
//		String type = Common.nvl(param.get("type"), "html").toLowerCase();
//		if (!Common.isOrEquals(type, "html", "txt", "xlsx")) type = "html";
//
//		response.setCharacterEncoding(Common.UTF8);
//		response.setHeader("Cache-control", "no-store");
//		response.setHeader("Pragma", "no-cache");
//		response.setDateHeader("Expires", 0);
//		response.setHeader("Content-Disposition", "inline");
//		if (Common.isEmpty(xRootMtr)) {
//			response.setContentType("application/octet-stream");
//			response.setHeader("Content-Transfer-Encoding", "binary");
//			response.setHeader("Content-Disposition", "attachment; filename=notfound.txt\"");
//			return;
//		}
//
//		Locale locale = Common.getLocale(request.getSession());
//
//		ServletOutputStream out = null;
//		try {
//			out = response.getOutputStream();
//
//			MessengerEdcGroupVO groups = getMessengerMsgTotal(request, true);
//			MessengerGroupUserVO users = getMessengerGroupUserList(request, 30000);
//
//			if (Common.isEquals(type, "xlsx")) {
//				response.setContentType("application/octet-stream");
//				response.setHeader("Content-Transfer-Encoding", "binary");
//				response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(getFileName(xRootMtr, users, Common.getLocale(request.getSession())).getBytes("KSC5601"), "ISO8859_1") + "." + type + "\"");
//				xlsxExport(xRootMtr, groups, out, false, Common.getLocale(request.getSession()));
//			} else {
//				if (Common.isNotEquals(print, "Y")) {
//					response.setContentType("application/octet-stream");
//					response.setHeader("Content-Transfer-Encoding", "binary");
//				}
//				StringBuffer _sb = new StringBuffer();
//				if (Common.isEquals(type, "html")) {
//					_sb.append("<html><body><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><pre>");
//				}
//				_sb.append("<" + Prop.propFormat("condition.xrootmtr", locale) + ">").append(Common.EMPTY_LINE);
//				_sb.append(xRootMtr).append(Common.EMPTY_LINE).append(Common.EMPTY_LINE);
//				_sb.append("<" + Prop.propFormat("condition.participation", locale) + ">").append(Common.EMPTY_LINE);
//
//				if (users != null) {
//					for (SolrEdcVO user : users.getGroups()) {
//						String name = Common.nvl(Common.isEmpty(user.getSname()) ? user.getSender() : user.getSname(), Common.nvl(user.getSrcip())) ;
//						_sb.append(String.format("[%s] ["+Prop.propFormat("common.org.co", locale)+":%s, "+Prop.propFormat("common.org.busi", locale)+":%s, "+Prop.propFormat("common.org.dept", locale)+":%s, "+Prop.propFormat("common.org.jikgub", locale)+":%s]", name, Common.nvl(user.getConm()), Common.nvl(user.getBusinm()), Common.nvl(user.getDeptnm()), Common.nvl(user.getJikgubnm()))).append(Common.EMPTY_LINE);
//						if(Common.isNotEmpty(user.getSname())) _sb.append(String.format("%s(%s)", name, Common.nvl(user.getSender())) + Common.EMPTY_LINE);
//						else _sb.append(String.format("%s", name) + Common.EMPTY_LINE);
//					}
//				}
//
//				_sb.append(Common.EMPTY_LINE);
//				_sb.append("<" + Prop.propFormat("eikon.msg.chatContents", locale) + ">").append(Common.EMPTY_LINE);
//				List<EmassMessenger> list = groups.getGroups();
//				if (list != null) {
//					for (EmassMessenger item : list) {
//						_sb.append(String.format("[%s] [%s] %s", item.getTitle(), item.getCtime(), item.getMessage())).append(Common.EMPTY_LINE);
//					}
//				}
//				if (Common.isEquals(type, "html")) {
//					_sb.append("</pre></body></html>");
//				}
//				if (Common.isNotEquals(print, "Y")) {
//					response.setContentLength(_sb.toString().getBytes().length);
//					response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(getFileName(xRootMtr, users, Common.getLocale(request.getSession())).getBytes("KSC5601"), "ISO8859_1") + "." + type + "\"");
//				}
//				out.write(_sb.toString().getBytes());
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			IOUtils.closeQuietly(out);
//		}
	}

	@RequestMapping(value = "/getMessengerList.xcn")
	@Description("메신저 대화방 상세 목록 조회")
	@ResponseBody
	public XcnResponseVO getMessengerList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getMessengerList());
	}


	@RequestMapping(value = "/getGenerativeList.xcn")
	@Description(" 생성형 ai 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getGenerativeList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getGenerativeList());
	}

	@RequestMapping(value = "/getFileList.xcn")
	@Description("파일전송 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getFileList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getFileList());
	}

	private EmassIntegrated setAlltotal(EmassIntegrated edcMessage) {
		List<Map<String, Object>> resultData = edcMessage.getPivotData();
		Map<String, Object> totalItem = new HashMap<>();
		long allTotal = 0;

		for(Map<String, Object> datas : resultData) {
			allTotal = allTotal + Common.nvz(datas.get("total"));
			for(String header : edcMessage.getPivotHeader()) {
				totalItem.put(Common.nvl(header), Common.nvz(totalItem.get(header)) + Common.nvz(datas.get(header)));
			}
		}

		totalItem.put("total", allTotal);
		totalItem.put("NUM", Prop.propFormat("bodyview.total"));
		resultData.add(totalItem);
		edcMessage.setPivotData(resultData);
		return edcMessage;
	}


	@RequestMapping(value = "/getNoteList.xcn")
	@Description("노트 서비스 목록 조회")
	@ResponseBody
	public XcnResponseVO getNoteList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getNoteList());
	}

}
