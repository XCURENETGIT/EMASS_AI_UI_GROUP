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
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
		String targetDate = Common.nvl(param.get("targetDate"));


		SolrQuery sq = new SolrQuery();
		sq.setStart(Common.nvz(param.get("offset"), 0));
		sq.setRows(Common.nvz(param.get("limit"), 1));
		sq.setQuery(String.format("+_id:%s",msgId));
		SearchHits<SolrEdcVO> document = solrEdcService.getList(sq);
		SolrEdcVO solrEdcVO = null;
		if(document.getSearchHits().size() > 0) solrEdcVO = document.getSearchHits().get(0).getContent();
		SolrEdcMessageVO solrVo = null;
		if(!("").equals(Common.nvl(solrEdcVO.getSubject())) && !("").equals(Common.nvl(solrEdcVO.getBody_snippet()))) {

			/*  선택문서의 subject , body_snippet 추출*/
			String subject = Common.nvl(solrEdcVO.getSubject());
			subject = String.format("*\"%s\"*", subject);

			String body_snippet = Common.nvl(solrEdcVO.getBody_snippet());
			if (body_snippet.length() > 30) body_snippet = body_snippet.substring(0, 20);
			body_snippet = String.format("*\"%s\"*", body_snippet);


			String query = String.format("+( +(subject:%s) +(body_snippet:%s) ) -msgid:%s", subject, body_snippet, msgId);
			solrVo = getSolrEdcMessage(query, Common.getAdminId(request));
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
		}else { solrVo = new SolrEdcMessageVO();}
		return new XcnResponseVO(XcnRspCode.OK, solrVo, solrVo.getNumFound());
	}

	private SolrEdcMessageVO getSolrEdcMessage(String query, String adminId) throws Exception {
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setStart(0);
		sq.setRows(100);

		sq.setSort("_score", SolrQuery.ORDER.desc);
		sq.setParam("track_scores",true);
//		sq.setFacet(true);
//		sq.addFacetField("svc1");
//		sq.setFacetMinCount(1);

		return solrEdcService.getEmassMessage(sq, adminId);
	}
}


