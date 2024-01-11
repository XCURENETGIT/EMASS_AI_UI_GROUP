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


	private SolrQuery createQuery(JSONObject param) throws Exception {
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String busi = Common.nvl(param.get("busiStr"));
		String dept = Common.nvl(param.get("deptStr"));
		String userStr = Common.nvl(param.get("userStr"));
		String keyword = Common.nvl(param.get("keyword"));

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		if (Common.isNotEmpty(startDt) && Common.isNotEmpty(endDt)) solrCreateQuery.addDateQuery("", startDt + "000000", endDt + "235959");
		if (Common.isNotEmpty(busi)) solrCreateQuery.setSearchHistoryBusicd(busi);
		if (Common.isNotEmpty(dept)) solrCreateQuery.setSearchHistoryDeptcd(dept);
		if (Common.isNotEmpty(userStr)) solrCreateQuery.setSearchHistoryUserStr(userStr);
		if (Common.isNotEmpty(keyword)) solrCreateQuery.setSearchHistoryKeywordStr(keyword);
		return solrCreateQuery.setQuery();
	}

	@RequestMapping(value = "/getSearchHistoryList.xcn")
	@Description("검색어 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchHistoryList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);

		SolrQuery sq = createQuery(param);
		sq.setQuery(sq.getQuery());
		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "keyword_str");
		sq.setParam("facet", true);
		sq.setParam("facet.field", "keyword_str");

		sq.setParam("facet.offset", String.valueOf(Common.nvz(param.get("offset"), 0)));
		sq.setParam("facet.group", String.valueOf(Common.nvz(param.get("limit"), 100)));
		sq.setParam("facet.list", true);
		sq.setParam("facet.mincount", "1");
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 0));
		sq.setSort("ctime", SolrQuery.ORDER.desc);

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

		SolrQuery sq = createQuery(param);
		sq.setQuery(sq.getQuery());
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

		SolrQuery sq = createQuery(param);
		sq.setQuery(sq.getQuery());
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 100));
		sq.setSort("ctime", SolrQuery.ORDER.desc);

		SearchHistoryGroupVO vo = solrEdcService.getSearchHistoryList(sq);
		return new XcnResponseVO(XcnRspCode.OK, vo.getHits());
	}

}
