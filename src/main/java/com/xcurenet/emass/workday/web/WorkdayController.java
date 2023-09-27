package com.xcurenet.emass.workday.web;

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
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.workday.service.WorkdayService;
import com.xcurenet.emass.workday.service.WorkdayVO;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.HOLIDAY_BUSI)
public class WorkdayController {

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@Resource(name = "workdayService")
	public WorkdayService workdayService;

	@RequestMapping(value = "/getWorkday.xcn")
	@Description("사업장별 업무일/업무시간 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getWorkday(final HttpServletRequest request, final HttpSession session) throws Exception {
		String busiCd = Common.nvl(request.getParameter("busiCd"));
		return new XcnResponseVO(XcnRspCode.OK, workdayService.getWorkday(busiCd));
	}

	@RequestMapping(value = "/saveWorkday.xcn")
	@Description("사업장별 업무일/업무시간 등록")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO saveWorkday(WorkdayVO workday) throws Exception {
		int rs = workdayService.saveWorkday(workday);
		makeInfoService.addInfoWorkDay();
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}
}
