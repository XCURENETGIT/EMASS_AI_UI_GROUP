package com.xcurenet.emass.analysis.web;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.analysis.service.AnalysisRelationService;
import com.xcurenet.emass.analysis.service.SearchVO;
import com.xcurenet.emass.analysis.service.UsageChartVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Controller
@RequestMapping("/analysis")
@Description("데이터 관계 분석")
@AuditParentMenu(ParentMenu.DATA_ANALYSIS)
@AuditMenu(Menu.ANALYSIS_FLUCTUATION)
public class AnalysisUsageCompareController {

	@Autowired public AnalysisRelationService analysisRelationService;

	@RequestMapping("/usageCompare.do")
	@Description("분석 - 사용량 증가 분석 Main")
	public String usageCompare(Locale locale, Model model) {
		return "/analysis/usageCompare";
	}

	@RequestMapping("/selectUsageChart.xcn")
	@AuditOperation(Operation.SEARCH)
	@Description("분석 - 사용량 증가 분석 비교 차트 조회")
	@ResponseBody
	public XcnResponseVO selectUsageChart(SearchVO searchVO, HttpSession session) throws Exception {
		searchVO.setAdminId(Common.getAdminId(session));
		List<UsageChartVO> list = analysisRelationService.selectUsageChart(searchVO);
		JSONObject chartData = new JSONObject();
		JSONObject seriesAvg = new JSONObject();
		JSONObject seriesData = new JSONObject();
		JSONArray categories = new JSONArray();
		JSONArray units = new JSONArray();
		JSONArray avgs = new JSONArray();
		JSONArray seriesArray = new JSONArray();
		for (UsageChartVO usageChartVO : list) {
			categories.add(usageChartVO.getKey());
			units.add(usageChartVO.getValue());
			avgs.add(usageChartVO.getAverage());
		}
		chartData.put("categories", categories);
		seriesAvg.put("name", Prop.propFormat("analysis.freedom.avg", Common.getLocale(session)));
		seriesAvg.put("data", avgs);
		seriesData.put("name", searchVO.getItemName());
		seriesData.put("data", units);
		seriesArray.add(seriesAvg);
		seriesArray.add(seriesData);
		chartData.put("series", seriesArray);
		return new XcnResponseVO(XcnRspCode.OK, chartData);
	}

	@RequestMapping("/selectUsageList.xcn")
	@AuditOperation(Operation.SEARCH)
	@Description("분석 - 사용량 증가 분석 - 차트 선택 목록")
	@ResponseBody
	public XcnResponseVO selectUsageList(SearchVO searchVO, HttpSession session) throws Exception {
		searchVO.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, analysisRelationService.selectUsageList(searchVO).getBuckets());
	}

	@RequestMapping("/selectDetailList.xcn")
	@AuditOperation(Operation.SEARCH)
	@Description("분석 - 사용량 증가 분석 - 목록 상세조회")
	@ResponseBody
	public XcnResponseVO selectDetailList(SearchVO searchVO, HttpSession session) throws Exception {
		searchVO.setAdminId(Common.getAdminId(session));

		searchVO.setDate(searchVO.getDate().replaceAll("-", "").replaceAll(" ", "").replaceAll("시", ""));
		String chartName = "";

		switch(searchVO.getUnit()) {
			case "t" :
				chartName = Prop.propFormat("analysis.usagecompare.timeunit", session);
				break;
			case "d" :
				chartName = Prop.propFormat("analysis.usagecompare.dayunit", session);
				break;
			case "w" :
				chartName = Prop.propFormat("analysis.usagecompare.weekunit", session);
				break;
			case "m" :
				chartName = Prop.propFormat("analysis.usagecompare.monthunit", session);
				break;
		}


		return new XcnResponseVO(XcnRspCode.OK, analysisRelationService.selectDetailList(searchVO, chartName));
	}

}

