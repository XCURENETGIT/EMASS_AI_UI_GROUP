package com.xcurenet.code.web;

import java.util.List;

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
import com.xcurenet.code.service.CoService;
import com.xcurenet.code.service.CoVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.ORG_MGMT)
public class CoController {

	@Resource(name = "coService")
	public CoService coService;
	
	@RequestMapping(value = "/getCoList.xcn")
	@Description("회사 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getCoList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		List<CoVO> co = coService.getCoList(searchStr, offset, limit);
		if (offset == 0) {
			int total = coService.getCoListTotal(searchStr, offset, limit);
			return new XcnResponseVO(XcnRspCode.OK, co, total);
		}
		return new XcnResponseVO(XcnRspCode.OK, co);
	}

	@RequestMapping(value = "/insertCo.xcn")
	@Description("회사 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertCo(CoVO co, HttpSession session) throws Exception {
		if (coService.isCoCdExist(co)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("errors.duplicated", Common.getLocale(session), co.getCoCd()));
		}
		else if (coService.isCoNmExist(co)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("errors.duplicated", Common.getLocale(session), co.getCoNm()));
		}
		else {
			return new XcnResponseVO(XcnRspCode.OK, coService.insertCo(co));
		}
	}

	@RequestMapping(value = "/updateCo.xcn")
	@Description("회사 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateCo(CoVO co, HttpSession session) throws Exception {
		if (coService.isCoNmExist(co)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.conm", Common.getLocale(session), co.getCoNm()));
		else return new XcnResponseVO(XcnRspCode.OK, coService.updateCo(co));
	}

	@RequestMapping(value = "/deleteCo.xcn")
	@Description("회사 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteCo(CoVO co) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, coService.deleteCo(co));
	}
}
