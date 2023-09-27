package com.xcurenet.code.web;

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
import com.xcurenet.code.service.JikgubService;
import com.xcurenet.code.service.JikgubVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.ORG_MGMT)
public class JikgubController {

	@Resource(name = "jikgubService")
	public JikgubService jikgubService;

	@RequestMapping(value = "/getJikgubList.xcn")
	@Description("직급 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getJikgubList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, jikgubService.getJikgubList(searchStr, offset, limit));
	}

	@RequestMapping(value = "/insertJikgub.xcn")
	@Description("직급 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertJikgub(final HttpServletRequest request, JikgubVO jikgub) throws Exception {
		if (jikgubService.isJikgubCdExist(jikgub)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.jikgubcd", request, jikgub.getJikgubCd()));
		else if (jikgubService.isJikgubNmExist(jikgub)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.jikgubnm", request, jikgub.getJikgubNm()));
		else return new XcnResponseVO(XcnRspCode.OK, jikgubService.insertJikgub(jikgub));
	}

	@RequestMapping(value = "/updateJikgub.xcn")
	@Description("직급 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateJikgub(final HttpServletRequest request, JikgubVO jikgub) throws Exception {
		if (jikgubService.isJikgubNmExist(jikgub)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.jikgubnm", request, jikgub.getJikgubNm()));
		else return new XcnResponseVO(XcnRspCode.OK, jikgubService.updateJikgub(jikgub));
	}

	@RequestMapping(value = "/deleteJikgub.xcn")
	@Description("직급 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteJikgub(JikgubVO jikgub) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, jikgubService.deleteJikgub(jikgub));
	}
}
