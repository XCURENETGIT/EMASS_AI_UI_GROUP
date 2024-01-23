package com.xcurenet.emass.customDashboard.web;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.customDashboard.service.CustomDashBoardService;
import com.xcurenet.emass.customDashboard.service.CustomDashboardVO;
import com.xcurenet.emass.dashboard.service.DeviceStatusService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.DASHBOARD)
@AuditMenu(Menu.DASHBOARD_SETUP)
public class CustomDashBoardSetupController {

	@Resource(name = "customDashBoardService")
	private CustomDashBoardService customDashBoardService;

	@Resource(name = "deviceStatusService")
	public DeviceStatusService deviceStatusService;
	
	@RequestMapping(value = "/getDashBoardContentList.xcn")
	@Description("Dashboard - 항목 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getDashBoardContentList(final CustomDashboardVO customDashboardVo, final HttpSession session) throws Exception {
		customDashboardVo.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getDashBoardContentList(customDashboardVo));
	}
	
	@RequestMapping(value = "/insertDashBoardContent.xcn")
	@Description("Dashboard - 항목 추가")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertDashBoardContent(final CustomDashboardVO customDashboardVo, final HttpSession session) throws Exception {
		customDashboardVo.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveDashBoardContent(customDashboardVo));
	}
	
	@RequestMapping(value = "/insertDashboardShare.xcn")
	@Description("Dashboard - 항목 공유")
	@ResponseBody
	public XcnResponseVO insertDashboardShare(final HttpServletRequest request, final HttpSession session) throws Exception {
		List<String> dashKey = Common.toList(request.getParameter("dashKeys"), ",");
		List<String> adminId = Common.toList(request.getParameter("adminIds"), ",");
		List<String> oldAdmin = Common.toList(Common.nvl(request.getParameter("deleteData")), ",");
		if(Common.isNotEmpty(oldAdmin)) customDashBoardService.deleteDashBoardaAdminShare(dashKey, oldAdmin);
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.insertDashboardShare(dashKey, adminId));
	}
	
	@RequestMapping(value = "/updateDashBoardContent.xcn")
	@Description("Dashboard - 항목 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateDashBoardContent(final CustomDashboardVO customDashboardVo, final HttpSession session) throws Exception {
		customDashboardVo.setAdminId(Common.getAdminId(session));
		if(Common.isNotEquals(Common.getAdminId(session), "sysadmin")) customDashBoardService.deleteDashboardShare(Common.getAdminId(session), "", customDashboardVo.getDashKey());
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveDashBoardContent(customDashboardVo));
	}
	
	@RequestMapping(value = "/deleteDashBoardContent.xcn")
	@Description("Dashboard - 항목 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteDashBoardContent(final HttpServletRequest request) throws Exception {
		List<CustomDashboardVO> customDashboardVos = new ArrayList<>();
		
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			CustomDashboardVO vo= (CustomDashboardVO) JSONObject.toBean(obj, CustomDashboardVO.class);
			if(Common.isNotEquals(Common.getAdminId(request), "sysadmin")) customDashBoardService.deleteDashboardShare(Common.getAdminId(request), "", vo.getDashKey());
			else if (Common.isEquals(Common.getAdminId(request), "sysadmin")) customDashBoardService.deleteAdminShare(vo.getDashKey());
			customDashboardVos.add(i, vo);
		}
		
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.deleteDashBoardContent(customDashboardVos));
	}
	
	@RequestMapping(value = "/deleteDashBoardContentBatch.xcn")
	@Description("Dashboard - 항목 일괄 삭제")
	@ResponseBody
	public XcnResponseVO deleteDashBoardContentBatch(final HttpServletRequest request) throws Exception {
		List<CustomDashboardVO> customDashboardVos = new ArrayList<>();
		
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			CustomDashboardVO vo= (CustomDashboardVO) JSONObject.toBean(obj, CustomDashboardVO.class);
			customDashBoardService.deleteDashBoardContentBatch(vo, Common.getAdminId(request));
			customDashboardVos.add(i, vo);
		}
		
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.deleteDashBoardContent(customDashboardVos));
	}
	
	@RequestMapping(value = "/getShareAdmin.xcn")
	@Description("Dashboard - 배포 사용중인 운용자 조회")
	@ResponseBody
	public XcnResponseVO getShareAdmin(final HttpServletRequest request, final HttpSession session) throws Exception {
		List<String> dashKey = Common.toList(request.getParameter("dashKey"), ",");
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getShareAdmin(dashKey));
	}
}