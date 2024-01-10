package com.xcurenet.emass.searchHistory.web;

import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.searchHistory.vo.SearchHistoryGroupVO;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class SearchHistoryController {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;


	private SolrQuery createQuery(JSONObject param) {
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String userName = Common.nvl(param.get("userName"));

		SolrQuery sq = new SolrQuery();
		StringBuilder sb = new StringBuilder();
		if (Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt)) sb.append(String.format(" +ctimeYYYYMMDD : [ %s TO %s ] ", startDt, endDt));
		if (Common.isNotEmpty(userName)) sb.append(String.format(" +user.name : \"%s\" ", userName));

		sq.setQuery(sb.toString());
		return sq;
	}

	@RequestMapping(value = "/getSearchHistoryList.xcn")
	@Description("검색어 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchHistoryList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String busi = Common.nvl(request.getParameter("busiStr"));
		String dept = Common.nvl(request.getParameter("deptStr"));
		String name = Common.nvl(request.getParameter("userStr"));

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		String query = String.format("+ctimeYYYYMMDD : [ %s TO %s ] ", startDt, endDt);
		SolrQuery sq = new SolrQuery();

		if (!name.isEmpty()) {
			solrCreateQuery.setName(name);
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}
		if (!busi.isEmpty()) {
			solrCreateQuery.setBusicd(busi);
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}
		if (!dept.isEmpty()) {
			solrCreateQuery.setDeptcd(dept);
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}


		sq.setQuery(query);

		System.out.println(sq.getQuery());


		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "keyword_str");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "keyword_str");

		/* 그룹 디테일검색 동적 들어와야 할 offset,size 값*/
		sq.setParam("facet.offset", String.valueOf(Common.nvz(param.get("offset"), 0)));
		sq.setParam("facet.group", String.valueOf(Common.nvz(param.get("limit"), 100)));
		sq.setParam("facet.list", true);
		sq.setParam("facet.mincount", "1");

		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 0));

		sq.setSort("ctime", SolrQuery.ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id", "userid");

		SearchHistoryGroupVO vo = solrEdcService.getSearchHistoryList(sq);
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}


	@RequestMapping(value = "/getSearchKeywordTrend.xcn")
	@Description("검색어 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchKeywordTrend(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String keyword = Common.nvl(param.get("keyword"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		sq.setQuery(String.format("+ctimeYYYYMMDD : [ %s TO %s ] +keyword_str:\"%s\"", startDt, endDt, keyword));
		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "ctimeYYYYMMDDHH");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "ctimeYYYYMMDDHH");

		sq.setParam("facet.offset", String.valueOf(Common.nvz(param.get("offset"), 0)));
		sq.setParam("facet.group", String.valueOf(Common.nvz(param.get("limit"), 100000)));
		sq.setParam("facet.list", true);
		sq.setParam("facet.mincount", "1");

		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 0));

		sq.setSort("ctime", SolrQuery.ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id", "userid");

		SearchHistoryGroupVO vo = solrEdcService.getSearchHistoryList(sq);
		List<Map<String, Object>> data = new ArrayList<>();
		Map<String, Object> obj = new HashMap<>();
		obj.put("type", "column");
		obj.put("name", keyword);
		obj.put("pointInterval", (60 * 60 * 1000));
		obj.put("pointStart", Common.getTime(startDt));

		obj.put("data", Common.make24HourResult(vo.getBuckets(), startDt, endDt));
		data.add(obj);

		return new XcnResponseVO(XcnRspCode.OK, data);
	}

	@RequestMapping(value = "/getSearchHistoryDetailList.xcn")
	@Description("검색어 내역 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchHistoryDetailList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String keyword = Common.nvl(param.get("keyword"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		sq.setQuery(String.format("+ctimeYYYYMMDD : [ %s TO %s ] +keyword_str:\"%s\"", startDt, endDt, keyword));
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 100));
		sq.setSort("ctime", SolrQuery.ORDER.desc);

		SearchHistoryGroupVO vo = solrEdcService.getSearchHistoryList(sq);
		return new XcnResponseVO(XcnRspCode.OK, vo.getHits());
	}

}
