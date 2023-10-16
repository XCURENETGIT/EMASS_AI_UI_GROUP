package com.xcurenet.emass.searchLog.web;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
import com.xcurenet.emass.searchLog.service.SearchLogService;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.SEARCH_LOG)
public class SearchLogController {

	@Resource(name = "searchLogService")
	private SearchLogService searchLogService;
	
	@RequestMapping(value = "/commons/searchLog.do", method = RequestMethod.GET)
	@Description("조회 이력")
	public String searchLog(Locale locale, Model model) {
		model.addAttribute("headerYn","Y");
		return "/commons/searchLog";
	}
	
	@RequestMapping(value = "/commons/searchLogConditionPop.do", method = RequestMethod.GET)
	@Description("조회 이력")
	public String searchLogCondtion(Locale locale, Model model) {
		return "/commons/searchLogConditionPop.popup";
	}
	
	
	@RequestMapping(value = "/getSearchLogList.xcn")
	@Description("감사로그 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getSearchLogList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String startDt = Common.nvl(request.getParameter("startDt"));
		String endDt = Common.nvl(request.getParameter("endDt"));
		String adminId = Common.nvl(request.getParameter("adminId"));
		String searchType = Common.nvl(request.getParameter("searchType"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));

		return new XcnResponseVO(XcnRspCode.OK, searchLogService.getSearchLogList(startDt, endDt, adminId, searchType, offset, limit));
	}
}
