package com.xcurenet.emass.report.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.rename.FileRenamePolicy;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.dashboard.service.DeviceStatusService;
import com.xcurenet.emass.dashboard.service.DeviceStatusVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import net.sf.json.JSONArray;
import org.apache.solr.client.solrj.SolrQuery;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;


@Controller
@AuditParentMenu(ParentMenu.DATA_REPORT)
@AuditMenu(Menu.STAT_REPORT)
public class ReportController {

	@Resource(name = "deviceStatusService")
	public DeviceStatusService deviceStatusService;

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@RequestMapping(value = "/getReportDeviceList.xcn")
	@Description("리포트 - 장비 전체 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getReportDeviceStatusList(final HttpSession session) throws Exception {
		List<DeviceStatusVO> reportDeviceVO = deviceStatusService.getDeviceStatusList();
		return new XcnResponseVO(XcnRspCode.OK, reportDeviceVO);
	}

	@RequestMapping(value = "/getReportCnt.xcn")
	@Description("리포트 - 기간단위별 수집 건수 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getReportCnt(final HttpServletRequest request, final HttpSession session) throws Exception {

		String facet = Common.nvl(request.getParameter("facet"));
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		int limit = Common.nvz(request.getParameter("limit"));
		String query = "";

		SolrQuery sq = new SolrQuery();
		query += String.format(" +ctime:[%s TO %s]", startDate, endDate);
		sq.setQuery(query);
		sq.setFacet(true);
		sq.setRows(0);
		sq.addFacetField(facet);
		sq.setFacetMinCount(1);
		sq.setFacetLimit(limit);
		sq.setFacetSort("count");

		SolrEdcMessageVO solrReportVo = solrEdcService.getEmassMessage(sq, com.xcurenet.common.util.Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, solrReportVo, solrReportVo.getNumFound());

	}

//
//	@RequestMapping(value = "/statsXlsxWriter.do", method = RequestMethod.POST)
//	@Description("통계 - 통계XLSX Writer 호출")
//	@ResponseBody
//	public XcnResponseVO statsXlsxWriter(final HttpServletRequest request, final HttpSession session) {
//		String title = Common.nvl(request.getParameter("title"));
//		String header = Common.nvl(request.getParameter("header"));
//		String body = Common.nvl(request.getParameter("body"));
//		String svg = Common.nvl(request.getParameter("svg"));
//		JSONArray headerArray = Common.toJSONArray(header);
//		JSONArray bodyArray = Common.toJSONArray(body);
//		try {
//			String dt = Common.getCurrentDate();
//			Common.mkdirs(Common.TMP_PATH + dt);
//			File file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_data_" + Common.getCurrentTime("yyyyMMdd_hhmmss") + ".xlsx"));
//			StatsXLSXWriter xlsx = new StatsXLSXWriter(title, headerArray, bodyArray, svg, new FileOutputStream(file));
//			xlsx.execute();
//			return new XcnResponseVO(XcnRspCode.OK, file.getAbsolutePath());
//		} catch (Exception e) {
//			e.printStackTrace();
//			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage("엑셀파일 생성도중 에러가 발생 하였습니다.");
//		}
//	}
//
//	@RequestMapping(value = "/reportXlsxWriter.do", method = RequestMethod.POST)
//	@Description("리포트 - 장비Report용 XLSX Writer 호출")
//	@ResponseBody
//	public XcnResponseVO reportXlsxWriter(final HttpServletRequest request, final HttpSession session) {
//		String title = Common.nvl(request.getParameter("title"));
//		String gridDeviceTitle = Common.nvl(request.getParameter("gridDeviceTitle"));
//		String gridDeviceHeader = Common.nvl(request.getParameter("gridDeviceHeader"));
//		String gridDeviceBody = Common.nvl(request.getParameter("gridDeviceBody"));
//		String gridMonthTitle = Common.nvl(request.getParameter("gridMonthTitle"));
//		String gridMonthHeader = Common.nvl(request.getParameter("gridMonthHeader"));
//		String gridMonthBody = Common.nvl(request.getParameter("gridMonthBody"));
//		String gridDayTitle = Common.nvl(request.getParameter("gridDayTitle"));
//		String gridDayHeader = Common.nvl(request.getParameter("gridDayHeader"));
//		String gridDayBody = Common.nvl(request.getParameter("gridDayBody"));
//		String gridHourTitle = Common.nvl(request.getParameter("gridHourTitle"));
//		String gridHourHeader = Common.nvl(request.getParameter("gridHourHeader"));
//		String gridHourBody = Common.nvl(request.getParameter("gridHourBody"));
//		JSONArray deviceHeaderArray = Common.toJSONArray(gridDeviceHeader);
//		JSONArray deviceBodyArray = Common.toJSONArray(gridDeviceBody);
//		JSONArray monthHeaderArray = Common.toJSONArray(gridMonthHeader);
//		JSONArray monthBodyArray = Common.toJSONArray(gridMonthBody);
//		JSONArray dayHeaderArray = Common.toJSONArray(gridDayHeader);
//		JSONArray dayBodyArray = Common.toJSONArray(gridDayBody);
//		JSONArray hourHeaderArray = Common.toJSONArray(gridHourHeader);
//		JSONArray hourBodyArray = Common.toJSONArray(gridHourBody);
//		System.out.println("gridHourHeader="+gridHourHeader+"/////gridHourBody="+gridHourBody);
//		try {
//			String dt = Common.getCurrentDate();
//			Common.mkdirs(Common.TMP_PATH + dt);
//			File file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_data_" + Common.getCurrentTime("yyyyMMdd_hhmmss") + "_report.xlsx"));
//			ReportXLSXWriter reportxlsx = new ReportXLSXWriter(title, gridDeviceTitle, deviceHeaderArray, deviceBodyArray, gridMonthTitle, monthHeaderArray, monthBodyArray,
//					gridDayTitle, dayHeaderArray, dayBodyArray, gridHourTitle, hourHeaderArray, hourBodyArray, new FileOutputStream(file));
//			reportxlsx.execute();
//			return new XcnResponseVO(XcnRspCode.OK, file.getAbsolutePath());
//		} catch (Exception e) {
//			e.printStackTrace();
//			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage("엑셀파일 생성도중 에러가 발생 하였습니다.");
//		}
//	}

}
