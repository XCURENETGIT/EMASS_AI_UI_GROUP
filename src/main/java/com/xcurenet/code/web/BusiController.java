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
import com.xcurenet.code.service.BusiService;
import com.xcurenet.code.service.BusiVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.ORG_MGMT)
public class BusiController {

	@Resource(name = "busiService")
	public BusiService busiService;
	
	@RequestMapping(value = "/getBusiList.xcn")
	@Description("사업장 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getBusiList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, busiService.getBusiList(searchStr, offset, limit));
	}

	@RequestMapping(value = "/getAllBusiList.xcn")
	@Description("사업장 전체 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAllBusiList(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, busiService.getBusiList(null, 0, 0));
	}

	@RequestMapping(value = "/getBusiListByCo.xcn")
	@Description("특정 회사 코드에 해당하는 사업장 리스트 조회")
	@ResponseBody
	public XcnResponseVO getBusiListByCo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String coCd = Common.nvl(request.getParameter("coCd"));
		return new XcnResponseVO(XcnRspCode.OK, busiService.getBusiListByCo(coCd));
	}

	@RequestMapping(value = "/insertBusi.xcn")
	@Description("사업장 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertBusi(final HttpServletRequest request, BusiVO busi) throws Exception {
		if (busiService.isBusiCdExist(busi)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.busicd", request, busi.getBusiCd()));
		else if (busiService.isBusiNmExist(busi)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.businm", request, busi.getBusiNm()));
		else return new XcnResponseVO(XcnRspCode.OK, busiService.insertBusi(busi));
	}

	@RequestMapping(value = "/updateBusi.xcn")
	@Description("사업장 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateBusi(final HttpServletRequest request, BusiVO busi) throws Exception {
		if (busiService.isBusiNmExist(busi)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.businm", request, busi.getBusiNm()));
		else return new XcnResponseVO(XcnRspCode.OK, busiService.updateBusi(busi));
	}

	@RequestMapping(value = "/deleteBusi.xcn")
	@Description("사업장 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteBusi(final HttpServletRequest request, BusiVO busi) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, busiService.deleteBusi(busi));
	}
}
