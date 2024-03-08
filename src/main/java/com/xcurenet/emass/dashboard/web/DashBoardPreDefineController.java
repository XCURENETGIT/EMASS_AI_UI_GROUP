package com.xcurenet.emass.dashboard.web;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.device.service.DeviceTrafficStatService;
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

	@Resource(name = "deviceTrafficStatService")
	private DeviceTrafficStatService deviceTrafficStatService;

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
		if (range == "" || range == null) range = "0,10485760,52428800,104857600,157286400,209715200,2147483647";

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
	@RequestMapping(value = "/getTrafficData.xcn")
	@Description("Dashboard - 최근 7일 트래픽 정보")
	@ResponseBody
	public XcnResponseVO getTrafficData(final HttpSession session) throws Exception {
		List<Map<String, Object>> result = dashBoardPreDefineService.getTrafficSize();

		return new XcnResponseVO(XcnRspCode.OK, result);
	}


	@RequestMapping(value = "/getTodayTrafficData.xcn")
	@Description("Dashboard - 당일 트래픽 정보")
	@ResponseBody
	public XcnResponseVO getTodayTrafficData(final HttpSession session) throws Exception {
		List<Map<String, Object>> result = dashBoardPreDefineService.getTodayTrafficSize();

		return new XcnResponseVO(XcnRspCode.OK, result);
	}


	@RequestMapping(value = "/getTodayPassportData.xcn")
	@Description("Dashboard - 여권번호 수집 건수")
	@ResponseBody
	public XcnResponseVO getTodayPassportData(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.getTodayPassportData(vo);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/getTodayDriveData.xcn")
	@Description("Dashboard - 운전면허 수집 건수")
	@ResponseBody
	public XcnResponseVO getTodayDriveData(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.getTodayDriveData(vo);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/getExtensionModulation.xcn")
	@Description("Dashboard - 확장자 변조 파일 건수")
	@ResponseBody
	public XcnResponseVO getExtensionModulation(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.getExtensionModulation(vo);

		return new XcnResponseVO(XcnRspCode.OK, result);
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

	@RequestMapping(value = "/TodayForeignerData.xcn")
	@Description("Dashboard - 외국인 등록 번호 수집 건수")
	@ResponseBody
	public XcnResponseVO TodayForeignerData(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.TodayForeignerData(vo);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/TodaySecurityData.xcn")
	@Description("Dashboard - 주민  번호 수집 건수")
	@ResponseBody
	public XcnResponseVO TodaySecurityData(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.TodaySecurityData(vo);

		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/TodayCardNumberData.xcn")
	@Description("Dashboard - 주민  번호 수집 건수")
	@ResponseBody
	public XcnResponseVO TodayCardNumberData(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		PatternPrivacyVO vo = new PatternPrivacyVO();
		vo.setAdminId(Common.getAdminId(session));
		vo.setStartDt(Common.getCurrentDate() + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMddHHmmss"));
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));

		PatternPrivacyVO result = dashBoardPreDefineService.TodayCardNumberData(vo);

		return new XcnResponseVO(XcnRspCode.OK, result);
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
}
