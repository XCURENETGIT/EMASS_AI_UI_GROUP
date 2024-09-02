package com.xcurenet.owlnest.web;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.emass.searchLog.service.SearchLogService;
import com.xcurenet.owlnest.service.OwlnestService;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
public class OwlnestController {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource(name = "searchLogService")
	private SearchLogService searchLogService;

	@Resource(name = "owlnestService")
	private OwlnestService owlnestService;

	@RequestMapping(value = "/getRecommendData.xcn")
	@Description("owlnest recommend 데이터")
	@ResponseBody
	public XcnResponseVO getRecommendData(final HttpServletRequest request, final HttpServletResponse response, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);

		String msgId = Common.nvl(param.get("msgId"));
		boolean subjectIsEmpty = Boolean.parseBoolean(Common.nvl(param.get("subjectIsEmpty")));
		boolean isUnknownDocument = Boolean.parseBoolean(Common.nvl(param.get("isUnknownDocument")));
		String tabId = Common.nvl(param.get("tabId"));

		SolrEdcMessageVO solrVo = getSolrEdcMessage(msgId,subjectIsEmpty,isUnknownDocument,tabId, Common.getAdminId(request));

		long total = 0;
		if(!Common.isEmpty(solrVo)) {
			total = solrVo.getNumFound();
		}else{
			solrVo = new SolrEdcMessageVO();
			List<SolrEdcVO> emass = new ArrayList<>();
			solrVo.setEmass(emass);
		}
		return new XcnResponseVO(XcnRspCode.OK, solrVo,total);
	}

	private SolrEdcMessageVO getSolrEdcMessage(String msgid,boolean subjectIsEmpty,boolean isUnknownDocument,String tabId, String adminId) throws Exception {
		SolrQuery sq = new SolrQuery();
		sq.setStart(0);
		sq.setRows(100);
		sq.setMoreLikeThis(true);

		boolean all = false;
		boolean body = false;
		boolean attach = false;
		boolean subject = false;

		if(Common.isEmpty(tabId) || Common.isEquals(tabId,"allRecommendTab")) all = true;
		else if(Common.isEquals(tabId,"bodyRecommendTab")) body = true;
		else if(Common.isEquals(tabId,"attachRecommendTab")) attach = true;
		else if(Common.isEquals(tabId,"subjectRecommendTab")) subject = true;

		if(body || all)  sq.addMoreLikeThisField("body");
		if(attach || all) sq.addMoreLikeThisField("attach");
		if(subject || all){
			if(!subjectIsEmpty) {
				sq.addMoreLikeThisField("subject");
			} else {
				sq.addMoreLikeThisField("host");
				sq.addMoreLikeThisField("path");
			}
		}

		LocalDate endDt = LocalDate.parse(msgid.substring(0,8),  DateTimeFormatter.ofPattern("yyyyMMdd"));
		LocalDate startDt = endDt.minusMonths(1);

		String startData = startDt.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		String endData = endDt.format( DateTimeFormatter.ofPattern("yyyyMMdd"));
		String query = String.format("+ctime:[%s000000 TO %s235959] ", startData, endData);
		sq.setQuery(query);


		sq.setSort("_score", SolrQuery.ORDER.desc);
		sq.setParam("indics", isUnknownDocument ? "edc_u_*" : "edc_w_*");
		sq.setParam("id",msgid);
		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, adminId);

		return solrEdcMessageVO;
	}
}


