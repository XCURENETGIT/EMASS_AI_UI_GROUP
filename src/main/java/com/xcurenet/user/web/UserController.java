package com.xcurenet.user.web;

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
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.user.service.UserService;
import com.xcurenet.user.service.UserVO;

/**
 * Handles requests for the application home page.
 */
@Controller
@AuditParentMenu(ParentMenu.POLICY_SETUP)
@AuditMenu(Menu.USER_MGMT)
public class UserController {

	@Resource(name = "userService")
	public UserService userService;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@RequestMapping(value = "/getUserList.xcn")
	@Description("사용자 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getUserList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String userType = Common.nvl(request.getParameter("userType"));
		String searchType = Common.nvl(request.getParameter("searchType"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		String adminId = Common.getAdminId(request);
		return new XcnResponseVO(XcnRspCode.OK, userService.getUserList(adminId, userType, searchType, searchStr, offset, limit));
	}

	@RequestMapping(value = "/updateUser.xcn")
	@Description("사용자 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateUser(UserVO user) throws Exception {
		int rs = userService.updateUser(user);
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/insertUser.xcn")
	@Description("사용자 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertUser(final HttpServletRequest request, UserVO user) throws Exception {
		if (userService.isUserIdExist(user)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.id", request, user.getUserId()));
		} else {
			int rs = userService.insertUser(user);
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteUser.xcn")
	@Description("사용자 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteUser(UserVO user) throws Exception {
		int rs = userService.deleteUser(user);
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

}
