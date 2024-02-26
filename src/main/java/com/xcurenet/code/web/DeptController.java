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
import com.xcurenet.code.service.DeptService;
import com.xcurenet.code.service.DeptVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;

@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.ORG_MGMT)
public class DeptController {

	@Resource(name = "deptService")
	public DeptService deptService;

	@RequestMapping(value = "/getDeptList.xcn")
	@Description("부서 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getDeptList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, deptService.getDeptList(searchStr, offset, limit));
	}

	@RequestMapping(value = "/getDeptListByCo.xcn")
	@Description("특정 회사 코드에 해당하는 부서 리스트 조회")
	@ResponseBody
	public XcnResponseVO getDeptListByCo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String coCd = Common.nvl(request.getParameter("coCd"));
		return new XcnResponseVO(XcnRspCode.OK, deptService.getDeptListByCo(coCd));
	}

	@RequestMapping(value = "/insertDept.xcn")
	@Description("부서 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertDept(final HttpServletRequest request, DeptVO dept) throws Exception {
		if (deptService.isDeptCdExist(dept)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.deptcd", request, dept.getDeptCd()));
		else if (deptService.isDeptNmExist(dept)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.deptnm", request, dept.getDeptNm()));
		else return new XcnResponseVO(XcnRspCode.OK, deptService.insertDept(dept));
	}

	@RequestMapping(value = "/updateDept.xcn")
	@Description("부서 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateDept(final HttpServletRequest request, DeptVO dept) throws Exception {
		if (deptService.isDeptNmExist(dept)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.deptnm", request, dept.getDeptNm()));
		else return new XcnResponseVO(XcnRspCode.OK, deptService.updateDept(dept));
	}

	@RequestMapping(value = "/deleteDept.xcn")
	@Description("부서 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteDept(DeptVO dept) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, deptService.deleteDept(dept));
	}
}
