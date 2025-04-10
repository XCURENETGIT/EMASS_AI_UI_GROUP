package com.xcurenet.emass.keyword.web;


import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.keyword.service.KeywordService;
import com.xcurenet.emass.message.service.FacetVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;

@Controller
@AuditParentMenu(ParentMenu.DATA_STAT)
@AuditMenu(Menu.STAT_KEYWORDSERVICE)
public class KeywordServiceController {


	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;


	@Resource(name = "keywordService")
	private KeywordService keywordService;

	@Resource(name = "keywordHostController")
	private KeywordHostController keywordHostController;


	@RequestMapping(value = "/getKeywordService.xcn")
	@Description("핵심 기술 키워드 탐지 서비스 TOP 10")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getKeywordService(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String busiStr = Common.nvl(request.getParameter("busiStr"));
		String deptStr = Common.nvl(request.getParameter("deptStr"));
		String userStr = Common.nvl(request.getParameter("userStr"));

		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		if (Common.isEmpty(coreKeyword))  coreKeyword = String.join(",", keywordService.getCoreKeywordAll());



		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		if (!coreKeyword.isEmpty()){
			query.append(" +kwd:Y");
			query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
		}


		if (!busiStr.isEmpty()) appendQuery(busiStr.split(","), query, "busicd");
		if (!deptStr.isEmpty()) appendQuery(deptStr.split(","), query, "deptcd");
		if (!userStr.isEmpty()) appendQuery(userStr.split(","), query, "userid");



		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("svc1");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(0);

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		//전체 조회
		String facetHeader = String.join(",", solrEdcMessageVO.getFacetHeader());
		sq = new SolrQuery();
		query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +svc1:(" + getStrArrs(facetHeader.split(",")) + ")");

		if (!busiStr.isEmpty()) appendQuery(busiStr.split(","), query, "busicd");
		if (!deptStr.isEmpty()) appendQuery(deptStr.split(","), query, "deptcd");
		if (!userStr.isEmpty()) appendQuery(userStr.split(","), query, "userid");

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("svc1");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(0);
		SolrEdcMessageVO solrEdcTotalMessage = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		for (int i = 0; i < solrEdcMessageVO.getFacet().size(); i++) {
			for (int j = 0; j < solrEdcTotalMessage.getFacet().size(); j++) {
				FacetVO facet = solrEdcMessageVO.getFacet().get(i);
				if (Common.isEmpty(coreKeyword)) facet.setCount(0);
				FacetVO totalfacet = solrEdcTotalMessage.getFacet().get(j);
				if (Common.isEquals(facet.getName(), totalfacet.getName())) {
					facet.setName2(Long.toString(totalfacet.getCount()));
					facet.setCount2(Double.toString((double) facet.getCount() / totalfacet.getCount()));
					break;
				}
			}
		}

		int count = Integer.parseInt(solrEdcMessageVO.getFacetData().get(0).get("total").toString());
		int totalCount = Integer.parseInt(solrEdcTotalMessage.getFacetData().get(0).get("total").toString());
		solrEdcMessageVO.setNumFound(totalCount);

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, count);
	}

	@RequestMapping(value = "/getKeywordServiceDetail.xcn")
	@Description("서비스 상세 20")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getKeywordServiceDetail(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String svc = Common.nvl(request.getParameter("svc"));
		String busiStr = Common.nvl(request.getParameter("busiStr"));
		String deptStr = Common.nvl(request.getParameter("deptStr"));
		String userStr = Common.nvl(request.getParameter("userStr"));
		if (Common.isEmpty(coreKeyword))  coreKeyword = String.join(",", keywordService.getCoreKeywordAll());

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +svc1:(" + getStrArrsNotQts(svc.split(",")) + ")");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");

		if (!busiStr.isEmpty()) appendQuery(busiStr.split(","), query, "busicd");
		if (!deptStr.isEmpty()) appendQuery(deptStr.split(","), query, "deptcd");
		if (!userStr.isEmpty()) appendQuery(userStr.split(","), query, "userid");

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("svc12");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setFacetLimit(20);
		sq.setStart(0);
		sq.setRows(0);
		sq.setFields(""); // 집계검색 default

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}

	@RequestMapping(value = "/getServiceKeyword.xcn")
	@Description("키워드 TOP 20")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getServiceKeyword(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String svc12 = Common.nvl(request.getParameter("svc12"));
		String svc = Common.nvl(request.getParameter("svc"));
		String busiStr = Common.nvl(request.getParameter("busiStr"));
		String deptStr = Common.nvl(request.getParameter("deptStr"));
		String userStr = Common.nvl(request.getParameter("userStr"));
		if (Common.isEmpty(coreKeyword))  coreKeyword = String.join(",", keywordService.getCoreKeywordAll());

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
		query.append(" +svc1:(" + getStrArrsNotQts(svc.split(",")) + ")");
		query.append(" +svc12:(" + getStrArrsNotQts(svc12.split(",")) + ")");

		if (!busiStr.isEmpty()) appendQuery(busiStr.split(","), query, "busicd");
		if (!deptStr.isEmpty()) appendQuery(deptStr.split(","), query, "deptcd");
		if (!userStr.isEmpty()) appendQuery(userStr.split(","), query, "userid");

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("kwds");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setFacetLimit(20);
		sq.setStart(0);
		sq.setRows(0);
		sq.setFields(""); // 집계검색 default

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
		if (!Common.isEmpty(coreKeyword)) solrEdcMessageVO.setPivotHeader(Collections.singletonList(coreKeyword));
		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}

	@RequestMapping(value = "/getServiceKeywordDtail.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 의 키워드별 집계")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getServiceKeywordDtail(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("keyword"));
		String svc = Common.nvl(request.getParameter("svc"));
		String svc12 = Common.nvl(request.getParameter("svc12"));
		if (Common.isEmpty(coreKeyword))  coreKeyword = String.join(",", keywordService.getCoreKeywordAll());
		String busiStr = Common.nvl(request.getParameter("busiStr"));
		String deptStr = Common.nvl(request.getParameter("deptStr"));
		String userStr = Common.nvl(request.getParameter("userStr"));


		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +svc1:(" + getStrArrsNotQts(svc.split(",")) + ")");
		query.append(" +svc12:(" + getStrArrsNotQts(svc12.split(",")) + ")");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
		if (!busiStr.isEmpty()) appendQuery(busiStr.split(","), query, "busicd");
		if (!deptStr.isEmpty()) appendQuery(deptStr.split(","), query, "deptcd");
		if (!userStr.isEmpty()) appendQuery(userStr.split(","), query, "userid");
		sq.setQuery(query.toString());

		sq.setStart(0);
		sq.setRows(20);

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		keywordHostController.searchKeywordInfoForMessage(solrEdcMessageVO.getEmass(), Arrays.asList(coreKeyword.split(",")), session);

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}


	public String getStrArrs(String[] arrays) {
		StringBuilder resultSb = new StringBuilder();
		for (String str : arrays) {
			resultSb.append("(\"" + str + "\")");
		}
		return resultSb.toString();
	}

	public String getStrArrsNotQts(String[] arrays) {
		StringBuilder resultSb = new StringBuilder();
		for (String str : arrays) {
			resultSb.append("(" + str + ") ");
		}
		return resultSb.toString();
	}

	private void appendQuery(String[] values, StringBuilder query, String field) {
		if (values.length > 0) {
			query.append(" +" + field + ":((");
			for (int i = 0; i < values.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(values[i]);
			}
			query.append("))");
		}
	}
}
