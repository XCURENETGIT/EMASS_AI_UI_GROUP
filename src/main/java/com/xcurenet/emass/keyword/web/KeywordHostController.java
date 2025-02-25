package com.xcurenet.emass.keyword.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.keyword.service.KeywordService;
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
@AuditParentMenu(ParentMenu.DATA_STAT)
@AuditMenu(Menu.STAT_KEYWORDHOST)
public class KeywordHostController{

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource(name = "emsMessageService")
	private EmsMessageService emsMessageService;


	@Resource(name = "keywordService")
	private KeywordService keywordService;

	public String expectSvcTypes = " -svc:(MIM- MP3- MSM- ZNP- ZPC- ZRL- ZSH- ZTN- ZXT-) " ;

	@RequestMapping(value = "/getKeywordHost.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getKeywordHost(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String unclsfiedOnly = Common.nvl(request.getParameter("unclsfiedOnly"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));

		String adminId = Common.getAdminId(request);

		if (Common.isEmpty(coreKeyword)) return getKeywordHostEmpty(unclsfiedOnly,serviceCd,startDate, endDate, adminId,request);
		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");

		query.append(schSvcType(unclsfiedOnly,serviceCd));


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
		query.append(" +host_str:(" +getStrArrs(facetHeader.split(",")) +")");
		query.append(schSvcType(unclsfiedOnly,serviceCd));

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("host_str");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setFacetLimit(10);


		sq.setStart(0);
		sq.setRows(0);
		SolrEdcMessageVO solrEdcTotalMessage = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));


		for (int i = 0; i < solrEdcMessageVO.getFacet().size(); i++) {
			for (int j = 0; j < solrEdcTotalMessage.getFacet().size(); j++) {
				FacetVO facet = solrEdcMessageVO.getFacet().get(i);
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
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 keyword 지정 안한 초기화면")
	private XcnResponseVO getKeywordHostEmpty(String unclsfiedOnly,String serviceCd,String startDate, String endDate, String adminId, HttpServletRequest request) throws SolrServerException, IOException {
		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(schSvcType(unclsfiedOnly,serviceCd));

		sq.setQuery(query.toString());
		sq.setFacet(true);
		sq.addFacetField("host_str");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setFacetLimit(10);


		sq.setStart(0);
		sq.setRows(0);

		SolrEdcMessageVO solrEdcTotalMessage = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		String coreKeyword = String.join(",", keywordService.getCoreKeywordAll());
		String facetHeader = String.join(",", solrEdcTotalMessage.getFacetHeader());

		int count = 0;
		if (Common.isEmpty(coreKeyword)){
			for (FacetVO totalFacet : solrEdcTotalMessage.getFacet()) {
				totalFacet.setName2(String.valueOf(totalFacet.getCount()));
				totalFacet.setCount(0);
			}
			count = Integer.parseInt(solrEdcTotalMessage.getFacetData().get(0).get("total").toString());
			solrEdcTotalMessage.setNumFound(0);
		}else {
			sq = new SolrQuery();
			query = new StringBuilder();
			query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
			query.append(" +kwd:Y");
			query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
			query.append(schSvcType(unclsfiedOnly, serviceCd));
			query.append(" +host_str:(\"" + facetHeader.replaceAll(",", "\" \"") + "\")");

			query.append(schSvcType(unclsfiedOnly,serviceCd));

			sq.setQuery(query.toString());
			sq.setFacet(true);
			sq.addFacetField("host_str");
			sq.setFacetMinCount(1);
			sq.setFacetSort("count");
			sq.setFacetLimit(10);


			sq.setStart(0);
			sq.setRows(0);
			SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

			for (FacetVO totalFacet : solrEdcTotalMessage.getFacet()) {
				totalFacet.setName2(String.valueOf(totalFacet.getCount()));
				long count2 = totalFacet.getCount();
				totalFacet.setCount(0);
				for (FacetVO facet : solrEdcMessageVO.getFacet()) {
					if (Common.isEquals(facet.getName(), totalFacet.getName())) {
						totalFacet.setCount2(Double.toString((double) facet.getCount() / count2));
						totalFacet.setCount(facet.getCount());
						break;
					}
				}
			}


			count = Integer.parseInt(solrEdcTotalMessage.getFacetData().get(0).get("total").toString());
			int totalCount = Integer.parseInt(solrEdcMessageVO.getFacetData().get(0).get("total").toString());

			solrEdcTotalMessage.setNumFound(totalCount);
		}
		return new XcnResponseVO(XcnRspCode.OK, solrEdcTotalMessage, count);
	}




	@RequestMapping(value = "/getKeywordHostRatio.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10, HOST 사용비율을 조회하기 위한 그룹쿼리")
	@ResponseBody
	public XcnResponseVO getKeywordHostRatio(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String unclsfiedOnly = Common.nvl(request.getParameter("unclsfiedOnly"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));

		StringBuilder query = new StringBuilder();
		SolrQuery sq = new SolrQuery();
		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(schSvcType(unclsfiedOnly,serviceCd));

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
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getKeywordUrl(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String unclsfiedOnly = Common.nvl(request.getParameter("unclsfiedOnly"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));

		if (Common.isEmpty(coreKeyword)) coreKeyword = String.join(",", keywordService.getCoreKeywordAll());

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
		query.append(schSvcType(unclsfiedOnly,serviceCd));

		sq.setQuery(query + String.format(" +host_str:(%s)", getStrArrs(hosts.split(","))));

		sq.setFacet(true);
		sq.addFacetField("path_str");
		sq.setFacetMinCount(1);
		sq.setFacetLimit(20);
		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(0);

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));

		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}

	@RequestMapping(value = "/getKeywordDetail.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 의 키워드별 집계")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getKeywordDetail(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String paths = Common.nvl(request.getParameter("paths"));
		String unclsfiedOnly = Common.nvl(request.getParameter("unclsfiedOnly"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));

		if (Common.isEmpty(coreKeyword)) coreKeyword = String.join(",", keywordService.getCoreKeywordAll());

		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
		query.append(schSvcType(unclsfiedOnly,serviceCd));
		sq.setQuery(query + String.format(" +host_str:(%s)", getStrArrs(hosts.split(",")) + String.format(" +path_str:(%s)", getStrArrs(paths.split("@XCNJOIN@")))));

		sq.setFacet(true);
		sq.addFacetField("kwds");
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setStart(0);
		sq.setRows(0);

		SolrEdcMessageVO solrEdcMessageVO = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
		if (!Common.isEmpty(coreKeyword)) solrEdcMessageVO.setPivotHeader(Collections.singletonList(coreKeyword));
		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO, solrEdcMessageVO.getNumFound());
	}

	@RequestMapping(value = "/getKeywordDetailData.xcn")
	@Description("핵심 기술 키워드 탐지 HOST TOP 10 의 키워드별 집계")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getKeywordDetailData(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));
		String hosts = Common.nvl(request.getParameter("hosts"));
		String paths = Common.nvl(request.getParameter("paths"));
		String unclsfiedOnly = Common.nvl(request.getParameter("unclsfiedOnly"));
		String serviceCd = Common.nvl(request.getParameter("serviceCd"));


		if (Common.isEmpty(coreKeyword)) coreKeyword = String.join(",", keywordService.getCoreKeywordAll());
		SolrQuery sq = new SolrQuery();
		StringBuilder query = new StringBuilder();

		query.append("+ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		query.append(" +kwd:Y");
		query.append(" +kwds:(" + getStrArrsNotQts(coreKeyword.split(",")) + ")");
		query.append(schSvcType(unclsfiedOnly,serviceCd));


		sq.setQuery(query.toString());
		sq.setFacetLimit(20);

		sq.setStart(0);
		sq.setRows(20);
		sq.setQuery(query + String.format(" +host_str:(%s)", getStrArrs(hosts.split(",")) + String.format(" +path_str:(%s)", getStrArrs(paths.split("@XCNJOIN@")))));

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


		TimeUtil.start();
		//본문
		EmsBodyVO emsBody = emsMessageService.getEmassBody(edcVO.getMsgid(), Common.getFirstAdminYn(session), Common.getAdminType(session));
		if(Common.isNotEmpty(emsBody)) {
			List<String> contexts = EmsMessageController.getDetectContextList( keywords, "UTF-8", emsBody);
			if(!Common.isEmpty(contexts) && contexts.size() > 0){
				types.add(Prop.propFormat("condition.body"));
				result.addAll(contexts);
			}
		}

		log.info("content {}", TimeUtil.print());

//		TimeUtil.start();
		//첨부파일 내용
		List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(edcVO.getMsgid(), null);
		if(Common.isNotEmpty(attachs) && attachs.size() > 0) {
			List<String> texts = attachParser(attachs,edcVO.getMsgid(), 0, Common.DETECT_CONTEXT_SIZE);
			if(Common.isNotEmpty(texts) && texts.size() > 0){
				types.add(Prop.propFormat("condition.attach"));
				for(String text : texts){
					if (text == null) continue;
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

	public String getStrArrsNotQts(String[] arrays){
		StringBuilder resultSb = new StringBuilder();
		for(String str : arrays){
			resultSb.append(  "("+ str + ") " );
		}
		return resultSb.toString();
	}

	public String schSvcType(final String unclsfiedOnly,final String serviceCd){
		if(Common.isEquals(unclsfiedOnly,"Y"))  return " +svc:(X* U*)";  		//미분류
		else {
			return 	andSvcQuery(serviceCd) +" "+ expectSvcTypes;
		}
	}
	public String andSvcQuery(String serviceCd){
		String[] svcCdArray =  serviceCd.split(",");
		String svcQuery = padString(svcCdArray);
		return String.format(" +svc:(%s)",svcQuery);
	}

	public static String padString(String[] inputArray) {
		// 문자열의 최대 길이
		int maxLength = 4;

		// 입력 배열이 null일 경우 빈 문자열로 처리
		if (Common.isEmpty(inputArray) || inputArray.length < 2) {
			return "*";
		}

		// 패딩이 적용된 문자열을 저장할 StringBuilder
		StringBuilder resultBuilder = new StringBuilder();

		// 각 문자열 요소에 대해 패딩 처리
		for (String input : inputArray) {
			// 입력이 null일 경우 빈 문자열로 처리
			if (input == null) {
				input = "";
			}

			// 현재 문자열의 길이
			int currentLength = input.length();
			// 빈 자리수 계산
			int paddingLength = maxLength - currentLength;

			// 문자열이 최대 길이보다 긴 경우 처리
			if (currentLength > maxLength) {
				resultBuilder.append("(").append(input, 0, maxLength);
			} else {
				// 결과 문자열 생성
				resultBuilder.append("(").append(input);
				for (int i = 0; i < paddingLength; i++) {
					resultBuilder.append('*');
				}
			}

			// 각 문자열을 공백으로 구분
			resultBuilder.append(") ");
		}

		// 마지막 공백 제거
		if (resultBuilder.length() > 0) {
			resultBuilder.setLength(resultBuilder.length() - 1);
		}

		return resultBuilder.toString();
	}

}
