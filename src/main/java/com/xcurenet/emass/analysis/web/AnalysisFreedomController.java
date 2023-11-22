//package com.xcurenet.emass.analysis.web;
//
//import java.util.Locale;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Description;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import com.xcurenet.annotations.AuditMenu;
//import com.xcurenet.annotations.AuditOperation;
//import com.xcurenet.annotations.AuditParentMenu;
//import com.xcurenet.audit.service.Menu;
//import com.xcurenet.audit.service.Operation;
//import com.xcurenet.audit.service.ParentMenu;
//import com.xcurenet.common.util.Common;
//import com.xcurenet.common.vo.XcnResponseVO;
//import com.xcurenet.common.vo.XcnRspCode;
//import com.xcurenet.emass.analysis.service.AnalysisFreedomListVO;
//import com.xcurenet.emass.analysis.service.AnalysisRelationService;
//import com.xcurenet.emass.analysis.service.FreedomSearchVO;
//import com.xcurenet.emass.message.service.SolrEdcMessageVO;
//
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//@Controller
//@RequestMapping("/analysis")
//@Description("데이터 관계 분석")
//@AuditParentMenu(ParentMenu.DATA_ANALYSIS)
//@AuditMenu(Menu.ANALYSIS_CUSTOM)
//public class AnalysisFreedomController {
//
//	@Autowired public AnalysisRelationService analysisRelationService;
//
//	@RequestMapping("/dataFreedom.do")
//	@Description("분석 - 원하는 통계데이터를 다양한 형식으로 분석할 수 있는 화면")
//	public String dataFreedom(Locale locale, Model model) {
//		return "analysis/dataFreedom";
//	}
//
//	@RequestMapping("/freedomView.xcn")
//	@AuditOperation(Operation.SEARCH)
//	@Description("분석 - 데이터 자유 분석 - 조회")
//	@ResponseBody
//	public XcnResponseVO freedomView(HttpServletRequest request, HttpSession session) throws Exception {
//
//		FreedomSearchVO freedomSearchVO = new FreedomSearchVO();
//		freedomSearchVO.setAdminId(Common.getAdminId(session));
//		freedomSearchVO = setFreedomSearchVO(request, freedomSearchVO);
//
//		String errMsg = "";
//		XcnRspCode code = XcnRspCode.OK;
//
//		AnalysisFreedomListVO vo = analysisRelationService.freedomView(freedomSearchVO);
//
//		XcnResponseVO xcnVo = new XcnResponseVO(code, vo.getBuckets());
//		xcnVo.setMessage(errMsg);
//		return xcnVo;
//	}
//
//	@RequestMapping("/selectFreedomMessageList.xcn")
//	@AuditOperation(Operation.SEARCH)
//	@Description("분석 - 데이터 자유 분석 - 메시지목록 조회")
//	@ResponseBody
//	public XcnResponseVO selectFreedomMessageList(FreedomSearchVO freedomSearchVO, HttpServletRequest request, HttpSession session) throws Exception {
//		freedomSearchVO.setAdminId(Common.getAdminId(session));
//		SolrEdcMessageVO solrEdcMessageVO = analysisRelationService.selectFreedomMessageList(setFreedomSearchVO(request, freedomSearchVO));
//		return new XcnResponseVO(XcnRspCode.OK, solrEdcMessageVO.getEmass(), solrEdcMessageVO.getNumFound());
//	}
//
//	private FreedomSearchVO setFreedomSearchVO(HttpServletRequest request, FreedomSearchVO freedomSearchVO) {
//
//		String tabIdx = request.getParameter("tabIdx");
//		String[] tmpAndOr = request.getParameterValues("andOr"+tabIdx);
//		int size = tmpAndOr == null ? 0 : tmpAndOr.length;
//		String[] andOr = new String[size+1];
//		andOr[0] = "";
//		for (int i = 1, j = 0; i < andOr.length; i++, j++) {
//			andOr[i] = tmpAndOr[j];
//		}
//
//		freedomSearchVO.setAndOr(andOr);
//		freedomSearchVO.setBeforePparen(request.getParameterValues("beforePparen"+tabIdx));
//		freedomSearchVO.setTermsColumn(request.getParameterValues("termsColumn"+tabIdx));
//		freedomSearchVO.setCompare(request.getParameterValues("compare"+tabIdx));
//		freedomSearchVO.setContext(request.getParameterValues("context"+tabIdx));
//		freedomSearchVO.setSizeNum(request.getParameterValues("sizeNum"+tabIdx));
//		freedomSearchVO.setStartDate(request.getParameterValues("startDate"+tabIdx));
//		freedomSearchVO.setEndDate(request.getParameterValues("endDate"+tabIdx));
//		freedomSearchVO.setServiceCd(request.getParameterValues("serviceCd"+tabIdx));
//		freedomSearchVO.setAfterPparen(request.getParameterValues("afterPparen"+tabIdx));
//		freedomSearchVO.setColumn(request.getParameterValues("columnData"+tabIdx));
//		freedomSearchVO.setGroupBy(request.getParameterValues("groupBy"+tabIdx));
//		freedomSearchVO.setGroupData(request.getParameterValues("groupData"+tabIdx));
//		//System.out.println(freedomSearchVO);
//		return freedomSearchVO;
//	}
//}
//
