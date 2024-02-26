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
import com.xcurenet.code.service.GeneralService;
import com.xcurenet.code.service.GeneralVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.ORG_MGMT)
public class GeneralController {

	@Resource(name = "generalService")
	public GeneralService generalService;

	@RequestMapping(value = "/getGeneralList.xcn")
	@Description("총괄 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getGeneralList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, generalService.getGeneralList(searchStr, offset, limit));
	}

	@RequestMapping(value = "/getGeneralListByCo.xcn")
	@Description("특정 회사 코드에 해당하는 총괄 리스트 조회")
	@ResponseBody
	public XcnResponseVO getGeneralListByCo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String coCd = Common.nvl(request.getParameter("coCd"));
		return new XcnResponseVO(XcnRspCode.OK, generalService.getGeneralListByCo(coCd));
	}

	@RequestMapping(value = "/insertGeneral.xcn")
	@Description("총괄 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertGeneral(final HttpServletRequest request, GeneralVO general) throws Exception {
		if (generalService.isGeneralCdExist(general)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.generalcd", request, general.getGeneralCd()));
		else if (generalService.isGeneralNmExist(general)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.generalnm", request, general.getGeneralNm()));
		else return new XcnResponseVO(XcnRspCode.OK, generalService.insertGeneral(general));
	}

	@RequestMapping(value = "/updateGeneral.xcn")
	@Description("총괄 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateGeneral(final HttpServletRequest request, GeneralVO general) throws Exception {
		if (generalService.isGeneralNmExist(general)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.generalnm", request, general.getGeneralNm()));
		else return new XcnResponseVO(XcnRspCode.OK, generalService.updateGeneral(general));
	}

	@RequestMapping(value = "/deleteGeneral.xcn")
	@Description("총괄 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteGeneral(GeneralVO general) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, generalService.deleteGeneral(general));
	}
}
