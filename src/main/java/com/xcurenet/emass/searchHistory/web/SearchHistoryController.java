package com.xcurenet.emass.searchHistory.web;

import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.searchHistory.vo.SearchHistoryGroupVO;
import com.xcurenet.emass.searchHistory.vo.SearchHistoryVO;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.springframework.context.annotation.Description;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.beans.Visibility;

@Controller
public class SearchHistoryController {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@RequestMapping(value = "/getSearchHistoryList.xcn")
	@Description("검색어 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchHistoryList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		sq.setQuery("*:*");

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
}
