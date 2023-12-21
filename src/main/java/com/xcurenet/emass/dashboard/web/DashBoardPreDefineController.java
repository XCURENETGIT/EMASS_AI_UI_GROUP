package com.xcurenet.emass.dashboard.web;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.dashboard.service.*;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.minio.MinioFileAdapter;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.common.util.SimpleOrderedMap;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.net.http.HttpRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class DashBoardPreDefineController {

	@Resource(name = "dashBoardPreDefineService")
	private DashBoardPreDefineService dashBoardPreDefineService;

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;


	private final static String FACET_QUERY = "{result: {type: terms,limit: -1,field: \"user_str\",sort: \"count desc\",facet: {pi_SN:\"sum(pi_SN)\", pi_PN:\"sum(pi_PN)\", pi_DN:\"sum(pi_DN)\", pi_FN:\"sum(pi_FN)\", pi_CN:\"sum(pi_CN)\"}}}";

	@RequestMapping(value = "/getTodayDataStatus.xcn")
	@Description("Dashboard - 금일 첨부파일 수집 현황")
	@ResponseBody
	public XcnResponseVO getTodayDataStatus(final HttpSession session, final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		long now = System.currentTimeMillis();
		String range = Common.nvl(param.get("range"));
		if (range == null) range = "0,10,50,100,150,200";

		TodayDataStatusVO vo = new TodayDataStatusVO();
		vo.setRange(range);
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));


		TodayDataStatusVO todayDataStatusVO = dashBoardPreDefineService.getTodayDataStatus(vo);
		if (todayDataStatusVO != null) {
			vo.setPivotData(todayDataStatusVO.getPivotData());
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
	private static JSONObject bucketsSetting(SimpleOrderedMap<Object> simpleOrderedMap) {
		List<String> column = new ArrayList<>();

		JSONObject json = new JSONObject();
		for(Map.Entry e : simpleOrderedMap) {
			Object value = e.getValue();
			if(column.contains(e.getKey())) {
				json.put("buckets", bucketsSetting((SimpleOrderedMap<Object>)e.getValue()).get("buckets"));
			} else if(value instanceof List) {
				List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List)value;
				JSONArray jsonArray = new JSONArray();
				for (SimpleOrderedMap<Object> simpleOrderedMap2 : simpleOrderedMapList) {
					jsonArray.add(bucketsSetting(simpleOrderedMap2));
				}
				json.put(e.getKey(), jsonArray);
			} else {
				if(value instanceof String || value instanceof Long || value instanceof Integer) {
					json.put(e.getKey(), value);
				} else {
					json.put(e.getKey(), Math.round((Double)value));
				}
			}
		}
		return json;
	}

	@RequestMapping(value = "/getAllTodayPatternPrivacy.xcn")
	@Description("Dashboard - 전체 패턴(개인정보)")
	@ResponseBody
	public XcnResponseVO getAllTodayPatternPrivacy(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.getAllTodayPatternPrivacy(vo);

		return new XcnResponseVO(XcnRspCode.OK, null,0);
	}

	@RequestMapping(value = "getBodySize.xcn")
	@Description("Dashboard - 일별 용량")
	@ResponseBody
	public XcnResponseVO getBodySize(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		BodySizeVO vo = new BodySizeVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		return new XcnResponseVO(XcnRspCode.OK, dashBoardPreDefineService.getBodySize(vo));
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

	@RequestMapping(value = "/getTodayNotWork.xcn")
	@Description("Dashboard - 비 업무시간 데이터")
	@ResponseBody
	public XcnResponseVO getTodayNotWork(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		TodayNotWorkVO vo = new TodayNotWorkVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		TodayNotWorkVO todayNotWorkVO = dashBoardPreDefineService.getTodayNotWork(vo);
		if (todayNotWorkVO != null) {
			vo.setTotal(todayNotWorkVO.getTotal());
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
	@RequestMapping(value = "/getTodayFileTop.xcn")
	@Description("Dashboard - 금일 첨부파일 용량 top10")
	@ResponseBody
	public XcnResponseVO getTodayFileTop(final HttpSession session) throws Exception {

		long now = System.currentTimeMillis();
		FileTopVO vo = new FileTopVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		FileTopVO todayFileVO = dashBoardPreDefineService.getTodayFileTop(vo);
		return new XcnResponseVO(XcnRspCode.OK, todayFileVO);
	}

	@RequestMapping(value = "/getTodayFilePerson.xcn")
	@Description("Dashboard - 금일 파일 다 사용자 TOP 10")
	@ResponseBody
	public XcnResponseVO getTodayFilePerson(final HttpSession session) throws Exception {

		long now = System.currentTimeMillis();
		FileTopVO vo = new FileTopVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		FileTopVO todayFileVO = dashBoardPreDefineService.getTodayFilePerson(vo);
		return new XcnResponseVO(XcnRspCode.OK, todayFileVO);
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
