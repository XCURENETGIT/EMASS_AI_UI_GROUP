package com.xcurenet.emass.dashboard.web;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.dashboard.service.*;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
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


		String query = String.format("+ctime:[%s TO %s] +(pi_CN:[ 1 TO * ] pi_FN:[ 1 TO * ] pi_SN:[ 1 TO * ] pi_PN:[ 1 TO * ] pi_DN:[ 1 TO * ])", vo.getStartDt(), vo.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setRows(0);
		sq.setParam("json.facet", FACET_QUERY);
		sq.setQuery(query.toString());
		SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, vo.getAdminId());
		SimpleOrderedMap<Object> facets = solrStatVo.getFacets();


		JSONArray jArray = new JSONArray();
		if(facets != null) {
			SimpleOrderedMap<Object> map = (SimpleOrderedMap<Object>)facets.get("result");
			if(map != null) {
				List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List<SimpleOrderedMap<Object>>)map.get("buckets");
				for (SimpleOrderedMap<Object> simpleOrderedMap : simpleOrderedMapList) {
					jArray.add(bucketsSetting(simpleOrderedMap));
				}
			}
		}
		int pi_total;
		for (int i = 0; i < jArray.size(); i++) {
			pi_total = Common.nvz(jArray.getJSONObject(i).get("pi_SN")) +  Common.nvz(jArray.getJSONObject(i).get("pi_PN")) +  Common.nvz(jArray.getJSONObject(i).get("pi_DN"))+ Common.nvz(jArray.getJSONObject(i).get("pi_FN"))+ Common.nvz(jArray.getJSONObject(i).get("pi_CN"));
			jArray.getJSONObject(i).put("pi_total", pi_total);
		}
		return new XcnResponseVO(XcnRspCode.OK, null,0);
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

	@RequestMapping(value = "/getTodayFile.xcn")
	@Description("Dashboard - 첨부파일 수집 현황")
	@ResponseBody
	public XcnResponseVO getTodayFile(final HttpSession session) throws Exception {

		long now = System.currentTimeMillis();
		TodayFileVO vo = new TodayFileVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		TodayFileVO todayFileVO = dashBoardPreDefineService.getTodayFile(vo);
		if (todayFileVO !=null){
			vo.setTotal(todayFileVO.getTotal());
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
