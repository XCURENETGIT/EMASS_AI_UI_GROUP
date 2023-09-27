package com.xcurenet.common.snmp.web;

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
import com.xcurenet.common.snmp.service.SnmpTrapService;
import com.xcurenet.common.snmp.service.SnmpTrapVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.DEV_EVENTLOG)
public class SnmpTrapController {

	@Resource(name = "snmpTrapService")
	public SnmpTrapService snmpTrapService;

	@RequestMapping(value = "/getSnmpTrapList.xcn")
	@Description("SNMP TRAP 목록 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSnmpTrapList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String startDt = Common.nvl(request.getParameter("startDt"));
		String endDt = Common.nvl(request.getParameter("endDt"));
		String deviceIp = Common.nvl(request.getParameter("deviceIp"));
		String devision = Common.nvl(request.getParameter("devision"));
		String eventLevel = Common.nvl(request.getParameter("eventLevel"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, snmpTrapService.getSnmpTrapList(startDt, endDt, deviceIp, devision, eventLevel, offset, limit));
	}

	@RequestMapping(value = "/insertSnmpTrap.xcn")
	@Description("SNMP TRAP 등록")
	@ResponseBody
	public XcnResponseVO insertSnmpTrap(SnmpTrapVO trap) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, snmpTrapService.insertSnmpTrap(trap));
	}
}
