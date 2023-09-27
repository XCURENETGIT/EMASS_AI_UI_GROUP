package com.xcurenet.emass.dashboard.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.dashboard.service.DashBoardPreDefineService;
import com.xcurenet.emass.dashboard.service.InterestUserMailVO;
import com.xcurenet.emass.dashboard.service.InterestUserServiceVO;
import com.xcurenet.emass.dashboard.service.KeywordDetectionVO;
import com.xcurenet.emass.dashboard.service.PatternPrivacyVO;
import com.xcurenet.emass.dashboard.service.RiskBehaviorVO;
import com.xcurenet.emass.dashboard.service.ServiceDataLoggingVO;
import com.xcurenet.emass.dashboard.service.TodayDataStatusVO;

@Controller
public class DashBoardPreDefineController {

	@Resource(name = "dashBoardPreDefineService")
	private DashBoardPreDefineService dashBoardPreDefineService;

	@RequestMapping(value = "/getTodayDataStatus.xcn")
	@Description("Dashboard - 금일 데이터 수집 현황")
	@ResponseBody
	public XcnResponseVO getTodayDataStatus(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		TodayDataStatusVO vo = new TodayDataStatusVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		TodayDataStatusVO todayDataStatusVO = dashBoardPreDefineService.getTodayDataStatus(vo);
		if (todayDataStatusVO != null) {
			vo.setTotal(todayDataStatusVO.getTotal());
			vo.setUnRead(todayDataStatusVO.getUnRead());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getTodayPatternPrivacy.xcn")
	@Description("Dashboard - 패턴(개인정보)")
	@ResponseBody
	public XcnResponseVO getTodayPatternPrivacy(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO patternPrivacyVO = dashBoardPreDefineService.getTodayPatternPrivacy(vo);
		if (patternPrivacyVO != null) {
			vo.setTotal(patternPrivacyVO.getTotal());
			vo.setUnRead(patternPrivacyVO.getUnRead());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getTodayRiskBehavior.xcn")
	@Description("Dashboard - 패턴(위험행위)")
	@ResponseBody
	public XcnResponseVO getTodayRiskBehavior(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		RiskBehaviorVO vo = new RiskBehaviorVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		RiskBehaviorVO riskBehaviorVO = dashBoardPreDefineService.getTodayRiskBehavior(vo);
		if (riskBehaviorVO != null) {
			vo.setTotal(riskBehaviorVO.getTotal());
			vo.setUnRead(riskBehaviorVO.getUnRead());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getTodayKeywordDetection.xcn")
	@Description("Dashboard - 키워드(예약어)")
	@ResponseBody
	public XcnResponseVO getTodayKeywordDetection(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		KeywordDetectionVO vo = new KeywordDetectionVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		KeywordDetectionVO keywordDetectionVO = dashBoardPreDefineService.getTodayKeywordDetection(vo);
		if (keywordDetectionVO != null) {
			vo.setTotal(keywordDetectionVO.getTotal());
			vo.setUnRead(keywordDetectionVO.getUnRead());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getServiceDataLogging.xcn")
	@Description("Dashboard - 서비스별 데이터 수집건수")
	@ResponseBody
	public XcnResponseVO getServiceDataLogging(final HttpSession session) throws Exception {

		long now = System.currentTimeMillis();
		ServiceDataLoggingVO vo = new ServiceDataLoggingVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		ServiceDataLoggingVO serviceDataLoggingVO = dashBoardPreDefineService.getServiceDataLogging(vo);
		if (serviceDataLoggingVO != null) {
			vo.setFacet(serviceDataLoggingVO.getFacet());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getInterestUserMail.xcn")
	@Description("Dashboard - 관심 사용자 발신 메일 수집 건수")
	@ResponseBody
	public XcnResponseVO getInterestUserMail(final HttpServletRequest request, final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		InterestUserMailVO vo = new InterestUserMailVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));
		vo.setUserSeq(Common.getParam(request).getString("userSeq"));
		InterestUserMailVO interestUserServiceVO = dashBoardPreDefineService.getInterestUserMail(vo);
		if (interestUserServiceVO != null) {
			vo.setTotal(interestUserServiceVO.getTotal());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getInterestUserService.xcn")
	@Description("Dashboard - 관심 사용자 서비스 사용률")
	@ResponseBody
	public XcnResponseVO getInterestUserService(final HttpServletRequest request, final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		InterestUserServiceVO vo = new InterestUserServiceVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));
		vo.setUserSeq(Common.getParam(request).getString("userSeq"));

		InterestUserServiceVO interestUserServiceVO = dashBoardPreDefineService.getInterestUserService(vo);
		if (interestUserServiceVO != null) {
			vo.setFacet(interestUserServiceVO.getFacet());
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}
}
