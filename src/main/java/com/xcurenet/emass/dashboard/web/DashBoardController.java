 package com.xcurenet.emass.dashboard.web;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.adminFilter.service.AdminFilterService;
import com.xcurenet.emass.adminFilter.service.AdminFilterVO;
import com.xcurenet.emass.dashboard.service.AdminFilterAmountVO;
import com.xcurenet.emass.dashboard.service.DashBoardService;
import com.xcurenet.emass.dashboard.service.DashboardVO;
import com.xcurenet.emass.dashboard.service.DeviceStatusService;
import com.xcurenet.emass.dashboard.service.FileSendVO;

@Controller
@AuditParentMenu(ParentMenu.DASHBOARD)
@AuditMenu(Menu.DASHBOARD)
public class DashBoardController {

	@Resource(name = "dashBoardService")
	private DashBoardService dashBoardService;

	@Autowired
	private AdminFilterService adminFilterService;

	@Resource(name = "deviceStatusService")
	public DeviceStatusService deviceStatusService;

	@RequestMapping(value = "/getDashBoardConfigs.xcn")
	@Description("Dashboard - 설정 파일 목록 조회")
	@ResponseBody
	public XcnResponseVO getDashBoardConfigs(final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, dashBoardService.getDashBoardConfigs(Common.getAdminId(session)));
	}

	@RequestMapping(value = "/getDashBoardConfig.xcn")
	@Description("Dashboard - 설정 파일 조회")
	@ResponseBody
	public XcnResponseVO getDashBoardConfig(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(session);
		String dashKey = Common.nvl(Common.getParam(request).get("dashKey"));
		return new XcnResponseVO(XcnRspCode.OK, dashBoardService.getDashBoardConfig(adminId, dashKey));
	}

	@RequestMapping(value = "/getDeviceStatus.xcn")
	@Description("Dashboard - 장비 관리")
	@ResponseBody
	public XcnResponseVO getDeviceStatus(final HttpServletRequest request, final HttpSession session) throws Exception {
		String deviceSeq = Common.nvl(Common.getParam(request).get("deviceSeq"));
		return new XcnResponseVO(XcnRspCode.OK, deviceStatusService.getDeviceStatus(deviceSeq));
	}

	@RequestMapping(value = "/getDeviceStatusList.xcn")
	@Description("Dashboard - 장비 전체 목록")
	@ResponseBody
	public XcnResponseVO getDeviceStatusList(final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, deviceStatusService.getDeviceStatusList());
	}

	@RequestMapping(value = "/saveDashBoardConfig.xcn")
	@Description("Dashboard - 설정 저장")
	@AuditOperation(Operation.CHG_FILESIZE)
	@ResponseBody
	public XcnResponseVO saveDeviceStatus(DashboardVO dashboardVO) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, dashBoardService.saveDashBoardConfig(dashboardVO));
	}

	@RequestMapping(value = "/getFileSendTotal.xcn")
	@Description("Dashboard - 파일전송 메시지 건수")
	@ResponseBody
	public XcnResponseVO getFileSendTotal(final HttpSession session) throws Exception {
		long now = System.currentTimeMillis();
		String adminId = Common.getAdminId(session);
		String dashKey = "file.send";

		FileSendVO vo = new FileSendVO();
		vo.setAdminId(adminId);

		String dashboardPeriod = Config.getString("dashboard.period");
		vo.setStartDt(LocalDate.parse(Common.getCurrentDate(), DateTimeFormatter.ofPattern("yyyyMMdd"))
				.minusDays(dashboardPeriod.equals("W") ? 7 : 0)
				.minusMonths(dashboardPeriod.equals("1M") ? 1 : dashboardPeriod.equals("2M") ? 2 : 0)
				.format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "000000");
		vo.setEndDt(Common.getDateTime(now, "yyyyMMdd")+"235959");
		vo.setTermDtStr(Prop.propFormat("condition.hour", session, "00")+" ~ " + Common.getDateTime(now, Prop.propFormat("condition.time", session, "HH", "mm", "ss")));
		vo.setFileSize(1);
		FileSendVO rs = dashBoardService.getFileSend(vo);
		if (rs != null) {
			vo.setTotal(rs.getTotal());
		} else {
			vo.setTotal("0");
		}
		return new XcnResponseVO(XcnRspCode.OK, vo);
	}

	@RequestMapping(value = "/getAdminFilterAmount.xcn")
	@Description("Dashboard - 사용자 조건 필터 건수")
	@ResponseBody
	public XcnResponseVO getAdminFilterAmount(final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(session);
		Map<String, AdminFilterAmountVO> rs = new HashMap<>();
		rs.put("user.filter1", getAdminFilter(session, adminId, "user.filter1"));
		rs.put("user.filter2", getAdminFilter(session, adminId, "user.filter2"));
		rs.put("user.filter3", getAdminFilter(session, adminId, "user.filter3"));
		rs.put("user.filter4", getAdminFilter(session, adminId, "user.filter4"));
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	private AdminFilterAmountVO getAdminFilter(final HttpSession session, final String adminId, final String dashKey) throws Exception {
		AdminFilterAmountVO vo = new AdminFilterAmountVO();
		vo.setAdminId(adminId);
		vo.setFilterNm(Prop.propFormat("dashboard.message.setting.filter", session));
		DashboardVO dashboard = dashBoardService.getDashBoardConfig(adminId, dashKey);
		if (dashboard != null && Common.isNotEmpty(dashboard.getDashVal())) {
			AdminFilterVO filter = adminFilterService.getAdminFilter(Common.nvn(dashboard.getDashVal()));
			filter.setAdminId(adminId);
			vo.setFilterSeq(filter.getId());
			vo.setFilterNm(filter.getName());
			if (Common.isEquals(filter.getUserDtCd(), "1")) { // 고정날짜
				long total = dashBoardService.getAdminFilterAmount(filter);
				vo.setStartDt(Common.formatDate3(filter.getStartDt()));
				vo.setEndDt(Common.formatDate3(filter.getEndDt()));
				vo.setTermDtStr(vo.getStartDt() + "~" + vo.getEndDt());
				vo.setTotal(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(total) : Common.numberFormatter(total));
			} else if (Common.isEquals(filter.getUserDtCd(), "2")) { // 변동날짜
				String now = Common.getCurrentDate();
				long total = dashBoardService.getAdminFilterAmount(filter);
				vo.setStartDt(Common.plusDays(now, (Common.nvz(filter.getStartDt()) * -1)));
				vo.setEndDt(Common.plusDays(now, (Common.nvz(filter.getEndDt()) * -1)));
				vo.setTermDtStr(Common.formatDate(vo.getStartDt()) + "~" + Common.formatDate(vo.getEndDt()));
				vo.setTotal(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(total) : Common.numberFormatter(total));
			}
		}
		return vo;
	}
}






















































