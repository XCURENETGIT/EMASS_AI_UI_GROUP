package com.xcurenet.emass.keyword.web;

import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.emass.message.web.EmsMessageController;
import lombok.extern.log4j.Log4j2;
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
import java.io.UnsupportedEncodingException;
import java.util.*;
import java.util.stream.Collectors;

@Log4j2
@Controller
@AuditParentMenu(ParentMenu.DATA_ANALYSIS)
public class KeywordHostController{

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource(name = "emsMessageService")
	private EmsMessageService emsMessageService;

	@RequestMapping(value = "/getKeywordHost.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10")
	@ResponseBody
	public XcnResponseVO getKeywordHost(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + coreKeyword.replaceAll(",", " ") + ")");
		query.append(" +svc:(X* U*)");

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("host_str");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setFacetLimit(10);

		sq.setStart(0);
		sq.setRows(0);

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		String facetHeader = String.join(",",solrEdcMessageVO.getFacetHeader());
		sq = new SolrQuery();
		query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +host_str:(\"" + facetHeader.replaceAll(",", "\" \"") + "\")");
		query.append(" +kwd:Y");
		query.append(" +svc:(X* U*)");

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("host_str");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setFacetLimit(10);


		sq.setStart(0);
		sq.setRows(0);
		SolrEdcMessageVO solrEdcTotalMessage = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));


		for (int i = 0; i<solrEdcMessageVO.getFacet().size(); i++){
			for (int j = 0; j< solrEdcTotalMessage.getFacet().size(); j++){
				FacetVO facet = solrEdcMessageVO.getFacet().get(i);
				FacetVO totalfacet = solrEdcTotalMessage.getFacet().get(j);
				if (Common.isEquals(facet.getName(), totalfacet.getName())){
					facet.setName2(Long.toString(totalfacet.getCount()));
					break;
				}
			}
		}

		int count = Integer.parseInt(solrEdcMessageVO.getFacetData().get(0).get("total").toString());
		int totalCount = Integer.parseInt(solrEdcTotalMessage.getFacetData().get(0).get("total").toString());
		solrEdcMessageVO.setNumFound(totalCount);

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, count);
	}

	@RequestMapping(value = "/getKeywordHostRatio.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10, HOST 사용비율을 조회하기 위한 그룹쿼리")
	@ResponseBody
	public XcnResponseVO getKeywordHostRatio(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));

		StringBuilder query = new StringBuilder();
		SolrQuery sq = new SolrQuery();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +svc:(X* U*)");

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("host_str");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setFacetLimit(10);

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
		int count = Integer.parseInt(solrEdcMessageVO.getFacetData().get(0).get("total").toString());

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, count);
	}


	@RequestMapping(value = "/getKeywordUrl.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 의 URL 별 집계")
	@ResponseBody
	public XcnResponseVO getKeywordUrl(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + coreKeyword.replaceAll(",", " ") + ")");
		query.append(" +svc:(X* U*)");

		//	log.info("url aggs query {}",query);
		sq.setQuery(query.toString());


		sq.setFacet(true);
		sq.addFacetField("path_str");
		sq.setFacetMinCount(1);
		sq.setFacetLimit(20);
		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(0);

		sq.addFilterQuery(String.format(" +host_str:(%s)",getStrArrs(hosts.split(","))));

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}

	@RequestMapping(value = "/getKeywordDetail.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 의 키워드별 집계")
	@ResponseBody
	public XcnResponseVO getKeywordDetail(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String paths = Common.nvl(request.getParameter("paths"));

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + coreKeyword.replaceAll(",", " ") + ")");
		query.append(" +svc:(X* U*)");

		//log.info("keyword aggs query {}",query);

		sq.setQuery(query.toString());


		sq.setFacet(true);
		sq.addFacetField("kwds");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(0);

		sq.addFilterQuery(String.format(" +host_str:(%s)",getStrArrs(hosts.split(","))));
		sq.addFilterQuery(String.format(" +path_str:(%s)",getStrArrs(paths.split("@XCNJOIN@"))));

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}

	@RequestMapping(value = "/getKeywordDetailData.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 의 키워드별 집계")
	@ResponseBody
	public XcnResponseVO getKeywordDetailData(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String paths = Common.nvl(request.getParameter("paths"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + coreKeyword.replaceAll(",", " ") + ")");
//		query.append(" +path_str:*");
		query.append(" +svc:(X* U*)");

		sq.setQuery(query.toString());
//
//		sq.setFacet(true);
//		sq.addFacetField("kwds");
//		sq.setFacetMinCount(1);
//		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(20);

		sq.addFilterQuery(String.format(" +host_str:(%s)",getStrArrs(hosts.split(","))));
		sq.addFilterQuery(String.format(" +path_str:(%s)",getStrArrs(paths.split("@XCNJOIN@"))));

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
		searchKeywordInfoForMessage(solrEdcMessageVO.getEmass(), Arrays.asList(coreKeyword.split(",")), session);

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}
	/*=============================================================== 키워드 검출 메서드 ==================================================================================*/

	/**
	 * Message에서 키워드 검출
	 * @param messageList
	 * @param session
	 * @return
	 */
	public List<SolrEdcVO> searchKeywordInfoForMessage(List<SolrEdcVO> messageList, List<String> keywords, HttpSession session) {
		List<SolrEdcVO> resultList = messageList;
		try {
			for (int j = 0; j < messageList.size(); j++) {
				searchKeywordInfoForMessage(messageList.get(j), keywords, session);
			}
		}catch (IOException e){
			log.info("{}",e);
		}
		return resultList;
	}

	public void searchKeywordInfoForMessage(SolrEdcVO edcVO, List<String> keywords, HttpSession session) throws UnsupportedEncodingException {
		List<String> result = new ArrayList<>();
		Set<String> types = new TreeSet<>();
		if (Common.isNotEmpty(keywords) && keywords.size() > 0) keywords = keywords.stream().map(m -> m.toLowerCase()).collect(Collectors.toList());
		else return;

//		TimeUtil.start();
		//제목
		if (Common.isNotEmpty(edcVO.getSubject())) {
			List<String> contexts = extractContext(edcVO.getSubject(), keywords, Common.DETECT_CONTEXT_RANGE);
			if(Common.isNotEmpty(contexts) && contexts.size() > 0){
				types.add(Prop.propFormat("condition.subject"));
				result.addAll(contexts);
			}
		}
//		log.info("제목 {}",TimeUtil.print());

//		TimeUtil.start();
		//첨부파일명
		List<String> attachnames = edcVO.getAttachname();
		if (Common.isNotEmpty(attachnames) && attachnames.size() > 0) {
			boolean found = false;
			for (String attachName : attachnames) {
				List<String> contexts = extractContext(attachName, keywords, Common.DETECT_CONTEXT_RANGE);
				if(Common.isNotEmpty(contexts) && contexts.size() > 0 ){
					found = true;
				}
				result.addAll(contexts);
			}
			if(found) types.add(Prop.propFormat("condition.attach_name"));
		}

//		log.info("attachnames {}",TimeUtil.print());


//		TimeUtil.start();
		//본문
		EmsBodyVO emsBody = emsMessageService.getEmassBody(edcVO.getMsgid(), Common.getFirstAdminYn(session), Common.getAdminType(session));
		if(Common.isNotEmpty(emsBody)) {
			List<String> contexts = EmsMessageController.getDetectContextList( keywords, "UTF-8", emsBody);
			if(!Common.isEmpty(contexts) && contexts.size() > 0){
				types.add(Prop.propFormat("condition.body"));
				result.addAll(contexts);
			}
		}

//		log.info("content {}",TimeUtil.print());

//		TimeUtil.start();
		//첨부파일 내용
		List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(edcVO.getMsgid(), null);
		if(Common.isNotEmpty(attachs) && attachs.size() > 0) {
			List<String> texts = attachParser(attachs,edcVO.getMsgid(), 0, Common.DETECT_CONTEXT_SIZE);
			if(Common.isNotEmpty(texts) && texts.size() > 0){
				types.add(Prop.propFormat("condition.attach"));
				for(String text : texts){
					result.addAll(extractContext(text.replaceAll("\\n+", ""), keywords, Common.DETECT_CONTEXT_RANGE));
				}
			}
		}
//		log.info("첨부파일 {}",TimeUtil.print());


		edcVO.setDetectionKeywordText(result.stream().collect(Collectors.joining(",")));
		edcVO.setDetectionKeywordType(types.stream().collect(Collectors.joining(",")));
	}


	/***
	 * textParser
	 * @param attachs
	 * @return
	 */
	public List<String> attachParser(List<EmsAttachVO> attachs,String msgId, int offset, int limit) {
		List<String> result = new ArrayList<>();
		for (EmsAttachVO attach : attachs) {
			result.add(emsMessageService.getEmassAttachText(msgId, attach.getAttachId(), "N", offset, limit));
		}
		return result;
	}

	/***
	 * 텍스트 검출 (Host Url 페이지에서 사용)
	 * @param text
	 * @param keywords
	 * @param contextLength
	 * @return
	 */
	public List<String> extractContext(String text, List<String> keywords, int contextLength) {
		List<String> results = new ArrayList<>();
		List<KeywordHostController.Range> ranges = new ArrayList<>();

		if (Common.isEmpty(text)) return results;
		if (Common.isEmpty(keywords)) return results;

		String originalText = text;
		String compareText = originalText.toLowerCase();

		for (String keyword : keywords) {
			int index = 0;
			while ((index = compareText.indexOf(keyword, index)) != -1) {
				int start = Math.max(0, index - contextLength);
				int end = Math.min(text.length(), index + keyword.length() + contextLength);
				boolean added = false;
				for (KeywordHostController.Range r : ranges) {
					if (r.isOverlapping(start, end)) {
						r.expand(start, end);
						added = true;
						break;
					}
				}
				if (!added) {
					ranges.add(new KeywordHostController.Range(start, end));
				}
				index += keyword.length(); // Move past the current keyword
			}
		}

		// Collect results based on merged ranges
		for (KeywordHostController.Range r : ranges) {
			results.add(text.substring(r.start, r.end));
		}

		return results;

	}


	/***
	 * Range 관리용 중첩 클래스
	 */
	public class Range {
		int start;
		int end;

		Range(int start, int end) {
			this.start = start;
			this.end = end;
		}

		// Check if the given range overlaps with this range
		boolean isOverlapping(int newStart, int newEnd) {
			return newStart <= end && newEnd >= start;
		}

		// Expand this range to include the new range
		void expand(int newStart, int newEnd) {
			this.start = Math.min(this.start, newStart);
			this.end = Math.max(this.end, newEnd);
		}
	}

	public String getStrArrs(String[] arrays){
		StringBuilder resultSb = new StringBuilder();
		for(String str : arrays){
			resultSb.append(  "(\"" + str + "\")" );
		}
		return resultSb.toString();
	}

}
