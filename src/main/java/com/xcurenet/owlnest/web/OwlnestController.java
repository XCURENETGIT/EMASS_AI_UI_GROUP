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
//		String targetDate = Common.nvl(param.get("targetDate"));
		boolean subjectIsEmpty = Boolean.parseBoolean(Common.nvl(param.get("subjectIsEmpty")));
		boolean isUnknownDocument = Boolean.parseBoolean(Common.nvl(param.get("isUnknownDocument")));

		SolrEdcMessageVO solrVo = getSolrEdcMessage(msgId,subjectIsEmpty,isUnknownDocument, Common.getAdminId(request));
//			List<SolrEdcVO> emassList = solrVo.getEmass();
//		emassList.sort(new Comparator<SolrEdcVO>() {
//			@Override
//			public int compare(SolrEdcVO s1, SolrEdcVO s2) {
//				if (Double.parseDouble(s1.getConfidence()) < Double.parseDouble(s2.getConfidence())) {
//					return 1;
//				} else if (Double.parseDouble(s1.getConfidence()) > Double.parseDouble(s2.getConfidence())) {
//					return -1;
//				}
//				return 0;
//			}
//		});
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

	private SolrEdcMessageVO getSolrEdcMessage(String msgid,boolean subjectIsEmpty,boolean isUnknownDocument, String adminId) throws Exception {
		SolrQuery sq = new SolrQuery();
		String query = "";
		sq.setStart(0);
		sq.setRows(100);
		sq.setMoreLikeThis(true);

    	sq.addMoreLikeThisField("body");
		sq.addMoreLikeThisField("attach");
		sq.setSort("_score", SolrQuery.ORDER.desc);
		sq.setParam("id",msgid);
		if(!subjectIsEmpty) {
			SolrEdcVO solrEdcVO = solrEdcService.getSelectOne(msgid, isUnknownDocument);
			sq.addMoreLikeThisField("subject");
			String subject = (solrEdcVO != null) ? solrEdcVO.getSubject() : null;
			if (Common.isEmpty(subject))return null;
			/* 검색어 정리*/
			subject = owlnestService.getSearchQuery(subject);
			query = String.format("+subject:(%s) -msgid:(%s)",subject,msgid);
		} else {
			sq.addMoreLikeThisField("host");
			sq.addMoreLikeThisField("path");
		}
		sq.setQuery(query);
		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, adminId);

		return solrEdcMessageVO;
	}
}


