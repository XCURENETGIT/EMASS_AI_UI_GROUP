package com.xcurenet.emass.customDashboard.web;


import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.CollectionUtils;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
import com.xcurenet.emass.customDashboard.service.CustomDashboardMenuVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.DASHBOARD_MENU)
public class CustomDashBoardMenuController {

	@Resource(name = "customDashBoardService")
	private CustomDashBoardService customDashBoardService;

	@RequestMapping(value = "/ems/dashboard.do", method = RequestMethod.GET)
	@Description("DashBoard 페이지")
	public String dashboard(final CustomDashboardMenuVO customDashboardMenuVo, final HttpSession session) {
		customDashboardMenuVo.setAdminId(Common.getAdminId(session));
		List<CustomDashboardMenuVO> result = customDashBoardService.getDashBoardMenuList(customDashboardMenuVo);

		if(CollectionUtils.isNotEmpty(result)) {
			if (Common.isEquals("0", result.get(0).getMenuKey())) return "/emass/dashboard_default";
			else return "/emass/dashboard";
		}
		else {
			return "/error/403";
		}
	}
	
	@RequestMapping(value = "/getDashBoardMenu.xcn")
	@Description("Dashboard - 메뉴 목록 조회")
	@ResponseBody
	public XcnResponseVO getDashBoardMenu(final CustomDashboardMenuVO customDashboardMenuVo, final HttpSession session) throws Exception {
		customDashboardMenuVo.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.getDashBoardMenuList(customDashboardMenuVo));
	}

	@RequestMapping(value = "/insertDashBoardMenu.xcn")
	@Description("Dashboard - 메뉴 추가")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertDashBoardMenu(CustomDashboardMenuVO customDashboardMenuVo, final HttpSession session) throws Exception {
		customDashboardMenuVo.setAdminId(Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveDashBoardMenu(customDashboardMenuVo));
	}
	
	@RequestMapping(value = "/updateDashBoardMenu.xcn")
	@Description("Dashboard - 메뉴 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateDashBoardMenu(CustomDashboardMenuVO customDashboardMenuVo, final HttpSession session) throws Exception {
		customDashboardMenuVo.setAdminId(Common.getAdminId(session));
		
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.saveDashBoardMenu(customDashboardMenuVo));
	}
	
	@RequestMapping(value = "/changeDashBoardDefaultMenu.xcn")
	@Description("Dashboard - 메뉴 시작화면 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO changeDashBoardDefaultMenu(CustomDashboardMenuVO customDashboardMenuVo, final HttpSession session) throws Exception {
		customDashboardMenuVo.setAdminId(Common.getAdminId(session));
		
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.changeDashBoardDefaultMenu(customDashboardMenuVo));
	}
	
	@RequestMapping(value = "/deleteDashBoardMenu.xcn")
	@Description("Dashboard - 메뉴 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteDashBoardMenu(final HttpServletRequest request) throws Exception {
		List<CustomDashboardMenuVO> customDashboardMenuVos = new ArrayList<>();
		
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			CustomDashboardMenuVO vo= (CustomDashboardMenuVO) JSONObject.toBean(obj, CustomDashboardMenuVO.class);
			customDashboardMenuVos.add(i, vo);
		}
		
		return new XcnResponseVO(XcnRspCode.OK, customDashBoardService.deleteDashBoardMenu(customDashboardMenuVos));
	}
}