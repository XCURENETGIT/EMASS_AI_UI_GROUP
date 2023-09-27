package com.xcurenet.admin.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.admin.service.AdminGridService;
import com.xcurenet.admin.service.AdminGridVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
public class AdminGridController {

	@Resource(name = "adminGridService")
	public AdminGridService adminGridService;

	@RequestMapping(value = "/getGridHeader.xcn")
	@Description("운용자별 그리드 헤더 조회")
	@ResponseBody
	public XcnResponseVO getGridHeader(final HttpServletRequest request) throws Exception {
		AdminGridVO grid = new AdminGridVO();
		grid.setAdminId(Common.getAdminId(request));
		grid.setGridId(Common.nvl(request.getParameter("gridId")));
		return new XcnResponseVO(XcnRspCode.OK, adminGridService.getGridHeader(grid));
	}

	@RequestMapping(value = "/updateGridHeader.xcn")
	@Description("운용자별 그리드 헤더 저장")
	@ResponseBody
	public XcnResponseVO updateGridHeader(final HttpServletRequest request) throws Exception {
		AdminGridVO grid = new AdminGridVO();
		grid.setAdminId(Common.getAdminId(request));
		grid.setGridId(Common.nvl(request.getParameter("gridId")));
		grid.setHeader(Common.nvl(request.getParameter("header")));
		return new XcnResponseVO(XcnRspCode.OK, adminGridService.updateGridHeader(grid));
	}
}
