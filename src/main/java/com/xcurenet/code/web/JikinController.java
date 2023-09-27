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
import com.xcurenet.code.service.JikinService;
import com.xcurenet.code.service.JikinVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.ORG_MGMT)
public class JikinController {

	@Resource(name = "jikinService")
	public JikinService jikinService;

	@RequestMapping(value = "/getJikinList.xcn")
	@Description("재직 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getJikinList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, jikinService.getJikinList(searchStr, offset, limit));
	}

	@RequestMapping(value = "/insertJikin.xcn")
	@Description("재직 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertJikin(final HttpServletRequest request, JikinVO jikin) throws Exception {
		if (jikinService.isJikinCdExist(jikin)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.jikincd", request, jikin.getJikinCd()));
		else if (jikinService.isJikinNmExist(jikin)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.jikinnm", request, jikin.getJikinNm()));
		else return new XcnResponseVO(XcnRspCode.OK, jikinService.insertJikin(jikin));
	}

	@RequestMapping(value = "/updateJikin.xcn")
	@Description("재직 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateJikin(final HttpServletRequest request, JikinVO jikin) throws Exception {
		if (jikinService.isJikinNmExist(jikin)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.jikinnm", request, jikin.getJikinNm()));
		else return new XcnResponseVO(XcnRspCode.OK, jikinService.updateJikin(jikin));
	}

	@RequestMapping(value = "/deleteJikin.xcn")
	@Description("재직 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteJikin(JikinVO jikin) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, jikinService.deleteJikin(jikin));
	}
}
