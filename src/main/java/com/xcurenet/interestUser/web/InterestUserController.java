package com.xcurenet.interestUser.web;

import java.util.ArrayList;
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
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.interestUser.service.InterestSimpleUserVO;
import com.xcurenet.interestUser.service.InterestUserService;
import com.xcurenet.user.service.UserVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.INTEREST_USER)
public class InterestUserController {

	@Resource(name = "interestUserService")
	public InterestUserService interestUserService;
	
	@Resource(name = "auditService")
	public AuditService auditService;

	@RequestMapping(value = "/getInterestSimpleUserList.xcn")
	@Description("관심 사용자 리스트(팝업 or 선택 처리 용도)")
	@ResponseBody
	public XcnResponseVO getInterestSimpleUserList(final HttpServletRequest request, final HttpSession session) throws Exception {
		List<InterestSimpleUserVO> result = interestUserService.getInterestSimpleUserList(Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, result);
	}
	
	@RequestMapping(value = "/getInterUserGroupList.xcn")
	@Description("관심 사용자 그룹 리스트 조회")
	@ResponseBody
	public XcnResponseVO getInterUserGroupList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, interestUserService.getInterUserGroupList(searchStr));
	}
	
	@RequestMapping(value = "/getInterestUserInfo.xcn")
	@Description("관심 사용자 정보 조회")
	@ResponseBody
	public XcnResponseVO getInterestUserInfo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String userId = Common.nvl(request.getParameter("userId"));
		return new XcnResponseVO(XcnRspCode.OK, interestUserService.getInterestUserInfo(userId));
	}
	
	@RequestMapping(value = "/getInterUserGroupUserList.xcn")
	@Description("관심 사용자 그룹 사용자 조회")
	@ResponseBody
	public XcnResponseVO getInterUserGroupUserList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String groupCodes = Common.nvl(request.getParameter("groupCodes"));
		return new XcnResponseVO(XcnRspCode.OK, interestUserService.getInterUserGroupUserList(groupCodes));
	}
	
	@RequestMapping(value = "/getInterestList.xcn")
	@Description("관심 사용자 리스트")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getInterestList(final HttpServletRequest request, final HttpSession session)
			throws Exception {
		JSONObject param = Common.getParam(request);
		String userType = Common.nvl(param.get("userType"));
		String searchType = Common.nvl(param.get("searchType"));
		String searchStr = Common.nvl(param.get("searchStr"));
		
		List<InterestSimpleUserVO> result = interestUserService.getInterestList(Common.getAdminId(request), userType, searchType, searchStr);
		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@RequestMapping(value = "/updateInterestUser.xcn")
	@Description("관심 사용자 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateInterestUser(final HttpServletRequest request, InterestSimpleUserVO user) throws Exception {
		user.setAdminId(Common.getAdminId(request));
		user.setUserIp(Common.nvl(user.getUserIp()).replaceAll(" ",""));
		user.setUserEmail(Common.nvl(user.getUserEmail()).replaceAll(" ",""));
		
		InterestSimpleUserVO result = interestUserService.getInterestIpExist(user);
		if( Common.nvn( result.getCnt() ) > 0 ) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, result.getUserIp()));
		}
		InterestSimpleUserVO resultE = interestUserService.getInterestEmailExist(user);
		if( Common.nvn( resultE.getCnt() ) > 0 ) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.email", request, resultE.getUserEmail()));
		}
		if (interestUserService.isInterestUserIdExist(user)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.id", request, user.getUserId()));
		}
		
		int rs = interestUserService.updateInterestUser(user);
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/insertInterestMultiUser.xcn")
	@Description("관심 사용자 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertInterestMultiUser(final HttpServletRequest request) throws Exception {
		JSONArray userList = Common.toJSONArray( request.getParameter("userList"));
		String userType = request.getParameter("userType");
		
		for (int i = 0; i < userList.size(); i++) {
			UserVO vo = (UserVO) JSONObject.toBean(userList.getJSONObject(i), UserVO.class);
			
			InterestSimpleUserVO user = new InterestSimpleUserVO();
			
			user.setAdminId(Common.getAdminId(request));
			user.setUserId(vo.getUserId());
			user.setUserIp(Common.nvl(vo.getUserIp()).replaceAll(" ",""));
			user.setUserEmail(Common.nvl(vo.getUserEmail()).replaceAll(" ",""));
			
			InterestSimpleUserVO result = interestUserService.getInterestIpExist(user);
			if( Common.nvn( result.getCnt() ) > 0 ) {
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, result.getUserIp()));
			}
			InterestSimpleUserVO resultE = interestUserService.getInterestEmailExist(user);
			if( Common.nvn( resultE.getCnt() ) > 0 ) {
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.email", request, resultE.getUserEmail()));
			}
			else if (interestUserService.isInterestUserIdExist(user)) {
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.id", request, user.getUserId()));
			}
		}
		
		int count = interestUserService.getInterestCount(Common.getAdminId(request));
		
		count += userList.size();
		if (count > 10) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.message.interest.max", request));
		}
		
		for (int i = 0; i < userList.size(); i++) {
			UserVO vo = (UserVO) JSONObject.toBean(userList.getJSONObject(i), UserVO.class);
			
			InterestSimpleUserVO user = new InterestSimpleUserVO();
			
			user.setAdminId(Common.getAdminId(request));
			user.setUserType(userType);
			user.setUserId(vo.getUserId());
			user.setUserNm(vo.getUserNm());
			user.setUserIp(Common.nvl(vo.getUserIp()).replaceAll(" ",""));
			user.setUserEmail(Common.nvl(vo.getUserEmail()).replaceAll(" ",""));
			user.setComment(Prop.propFormat("common.org.dept") + ":" + vo.getDeptNm() + ", "  + Prop.propFormat("common.org.jikgub") + ":" + vo.getJikgubNm());
			
			interestUserService.insertInterestUser(user);
		}
		
		return new XcnResponseVO(XcnRspCode.OK, userList.size());
	}
	
	@RequestMapping(value = "/insertInterestUser.xcn")
	@Description("관심 사용자 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertInterestUser(final HttpServletRequest request, InterestSimpleUserVO user) throws Exception {
		user.setAdminId(Common.getAdminId(request));
		user.setUserIp(Common.nvl(user.getUserIp()).replaceAll(" ",""));
		user.setUserEmail(Common.nvl(user.getUserEmail()).replaceAll(" ",""));
		
		InterestSimpleUserVO result = interestUserService.getInterestIpExist(user);
		if( Common.nvn( result.getCnt() ) > 0 ) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, result.getUserIp()));
		}
		InterestSimpleUserVO resultE = interestUserService.getInterestEmailExist(user);
		if( Common.nvn( resultE.getCnt() ) > 0 ) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.email", request, resultE.getUserEmail()));
		}
		else if (interestUserService.isInterestUserIdExist(user)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.id", request, user.getUserId()));
		} else {
			int count = interestUserService.getInterestCount(Common.getAdminId(request));
			if (count >= 10) {
				return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.message.interest.max", request));
			}
			int rs = interestUserService.insertInterestUser(user);
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deleteInterestUser.xcn")
	@Description("관심 사용자 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteInterestUser(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		String[] userSeqs = Common.toArray(Common.nvl(param.get("userSeq")), ",");

		List<InterestSimpleUserVO> userVo = new ArrayList<>();
		for (String userSeq : userSeqs) {
			InterestSimpleUserVO vo = new InterestSimpleUserVO();
			vo.setUserSeq(userSeq);
			userVo.add(vo);
		}
		int rs = interestUserService.deleteInterestUser(userVo);
		return new XcnResponseVO(XcnRspCode.OK, rs);
	}
	
	/*@RequestMapping(value = "/getInterestIpExist.xcn")
	@ResponseBody
	public XcnResponseVO getInterestIpExist(final HttpServletRequest request,String userIp) throws Exception{
		return new XcnResponseVO(XcnRspCode.OK, interestUserService.getInterestIpExist(userIp));
		
	}*/
	
}
