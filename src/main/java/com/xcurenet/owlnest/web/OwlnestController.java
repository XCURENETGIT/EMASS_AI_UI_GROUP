//package com.xcurenet.owlnest.web;
//
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
//import java.util.List;
//import java.util.Map;
//
//import javax.annotation.Resource;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import org.apache.xmlrpc.parser.LongParser;
//import org.springframework.context.annotation.Description;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import com.xcurenet.common.util.Common;
//import com.xcurenet.common.util.locale.Prop;
//import com.xcurenet.common.vo.XcnResponseVO;
//import com.xcurenet.common.vo.XcnRspCode;
//import com.xcurenet.emass.message.service.SolrEdcMessageVO;
//import com.xcurenet.emass.message.service.SolrEdcService;
//import com.xcurenet.emass.message.service.SolrEdcVO;
//import com.xcurenet.emass.searchLog.service.SearchLogService;
//import com.xcurenet.owlnest.service.OwlnestResultVO;
//import com.xcurenet.owlnest.service.OwlnestService;
//import com.xcurenet.owlnest.service.ParaphraserMessageVO;
//
//import lombok.extern.slf4j.Slf4j;
//import net.sf.json.JSONObject;
//
//@Slf4j
//@Controller
//public class OwlnestController {
//
//
//	@Resource(name = "searchLogService")
//	private SearchLogService searchLogService;
//
//	@Resource(name = "owlnestService")
//	private OwlnestService owlnestService;
//
//	@RequestMapping(value = "/getRecommendData.xcn")
//	@Description("owlnest recommend 데이터")
//	@ResponseBody
//	public XcnResponseVO getRecommendData(final HttpServletRequest request, final HttpServletResponse response, final HttpSession session) throws Exception {
//		JSONObject param = Common.getParam(request);
//		OwlnestResultVO result = owlnestService.getParaphraserData(Common.nvl(param.get("msgId")), Common.nvl(param.get("targetDate")));
//		if(result == null) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("common.msg.nodata", request));
//
//		Map<String, ParaphraserMessageVO> paraphraserMessageVOData = result.getParaphraserMessageVOData();
//
//		if(result.getMsgIds().size() == 0) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("common.msg.nodata", request));
//
//		SolrEdcMessageVO solrVo = getSolrEdcMessage(String.format("+msgid:(%s)", String.join(" ", result.getMsgIds())), Common.getAdminId(request));
//		List<SolrEdcVO> emassList = solrVo.getEmass();
//		for(SolrEdcVO emass : emassList) {
//			ParaphraserMessageVO vo = paraphraserMessageVOData.get(emass.getMsgid());
//			emass.setTitle(vo.getTitle());
//			emass.setContent(vo.getContent());
//			emass.setConfidence(vo.getConfidence());
//		}
//
//		Collections.sort(emassList, new Comparator<SolrEdcVO>() {
//            @Override
//            public int compare(SolrEdcVO s1, SolrEdcVO s2) {
//                if (Double.parseDouble(s1.getConfidence()) < Double.parseDouble(s2.getConfidence())) {
//                    return 1;
//                } else if (Double.parseDouble(s1.getConfidence()) > Double.parseDouble(s2.getConfidence())) {
//                    return -1;
//                }
//                return 0;
//            }
//        });
//
//		return new XcnResponseVO(XcnRspCode.OK, solrVo, solrVo.getNumFound());
//	}
//
//	private SolrEdcMessageVO getSolrEdcMessage(String query, String adminId) throws Exception {
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(query);
//		sq.setStart(0);
//		sq.setRows(Common.MAX_VALUE);
//		sq.setFacet(true);
//		sq.addFacetField("svc1");
//		sq.setFacetMinCount(1);
//
//		return solrEdcService.getEmassMessage(sq, adminId);
//		//return new SolrEdcMessageVO(solrEdcService.getList(sq), adminId); //redefined 하지 않은 데이터
//	}
// }
//
//
