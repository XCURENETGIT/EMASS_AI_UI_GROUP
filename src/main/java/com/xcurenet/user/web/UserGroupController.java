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
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.user.service.UserGroupVO;
import com.xcurenet.user.service.UserService;

/**
 * Handles requests for the application home page.
 */
@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.USER_GROUP_MGMT)
public class UserGroupController {

	@Resource(name = "userService")
	public UserService userService;
	
	@RequestMapping(value = "/getUserGroupList.xcn")
	@Description("사용자 그룹 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getUserGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, userService.getUserGroupList(searchStr,Common.getAdminId(request),Common.getAdminType(session)));
	}
	
	@RequestMapping(value = "/insertUserGroup.xcn")
	@Description("사용자 그룹 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertUserGroup(final HttpServletRequest request, UserGroupVO userGroup) throws Exception {
		if (userService.isUserGroupExist(userGroup)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert", request, userGroup.getGroupCode()));
		} else {
			int rs = userService.insertUserGroup(userGroup);
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}
	
	@RequestMapping(value = "/updateUserGroup.xcn")
	@Description("사용자 그룹 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateUserGroup(UserGroupVO userGroup) throws Exception {
		int rs = userService.updateUserGroup(userGroup);
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}
	
	@RequestMapping(value = "/deleteUserGroup.xcn")
	@Description("사용자 그룹 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteUserGroup(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, userService.deleteUserGroup(request));
	}
	
	@RequestMapping(value = "/getUserGroupItemList.xcn")
	@Description("사용자 그룹 사용자 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getUserGroupItemList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String groupCode = Common.nvl(request.getParameter("groupCode"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, userService.getUserGroupItemList(groupCode, searchStr));
	}
	
	@RequestMapping(value = "/getUserGroupUserList.xcn")
	@Description("사용자 그룹 사용자 조회")
	@ResponseBody
	public XcnResponseVO getUserGroupUserList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String groupCodes = Common.nvl(request.getParameter("groupCodes"));
		return new XcnResponseVO(XcnRspCode.OK, userService.getUserGroupUserList(groupCodes));
	}
	
	@RequestMapping(value = "/insertUserGroupItem.xcn")
	@Description("사용자 그룹 사용자 저장")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertUserGroupItem(final HttpServletRequest request, final HttpSession session) throws Exception {
		String duplicatedStr = userService.isUserGroupItemExist(request);

		if (Common.isEmpty(duplicatedStr)) {
			return new XcnResponseVO(XcnRspCode.OK,
					userService.insertUserGroupItem(request));
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM)
					.setMessage(Prop.propFormat("errors.duplicated", Common.getLocale(session), duplicatedStr));
		}
	}
	
	@RequestMapping(value = "/deleteUserGroupItem.xcn")
	@Description("사용자 그룹 사용자 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteUserGroupItem(final HttpServletRequest request, final HttpSession session) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, userService.deleteUserGroupItem(request));
	}
	
	@RequestMapping(value = "/getConUserGroupList.xcn")
	@Description("사용자 그룹 리스트 조회 - 조건 설정 용")
	@ResponseBody
	public XcnResponseVO getConUserGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String itemList = request.getParameter("itemList");
		return new XcnResponseVO(XcnRspCode.OK, userService.getConUserGroupList(itemList));
	}
}
