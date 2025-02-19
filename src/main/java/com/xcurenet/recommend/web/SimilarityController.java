package com.xcurenet.recommend.web;

import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.recommend.service.SimilarityService;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class SimilarityController {

	@Resource(name = "similarityService")
	SimilarityService similarityService;

	@RequestMapping(value = "/getSimilarity.xcn")
	@Description("유사도 분석 조회")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getSimilarity(final HttpServletRequest request) throws Exception {
		int percent = Common.nvz(request.getParameter("percent"));
		SolrEdcMessageVO solrEdcMessageVO = similarityService.getSimilarity(request);

		List<SolrEdcVO> resultList = new ArrayList<>();
		for (SolrEdcVO solrEdcVO : solrEdcMessageVO.getEmass()) {
			if (Double.parseDouble(solrEdcVO.getConfidence()) >= percent) {
				resultList.add(solrEdcVO);
			}
		}
		solrEdcMessageVO.setEmass(resultList);
		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO);
	}
}
