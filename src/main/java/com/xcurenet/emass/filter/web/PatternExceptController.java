package com.xcurenet.emass.filter.web;

import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.filter.service.PatternExceptService;
import com.xcurenet.emass.filter.service.PatternExceptVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller

public class PatternExceptController {

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@Resource(name = "patternExceptService")
	public PatternExceptService patternExceptService;

	@RequestMapping(value = "/getPatternExceptList.xcn")
	@Description("예외 패턴 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getPatternExceptList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String privateType = Common.nvl(request.getParameter("privateType"));

		return new XcnResponseVO(XcnRspCode.OK, patternExceptService.getPatternExceptList(searchStr,privateType));
	}

	@RequestMapping(value = "/insertPatternExcept.xcn")
	@Description("예외 패턴 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertPatternExcept(final HttpServletRequest request, PatternExceptVO patternExceptVO, final HttpSession session) throws Exception {
		if (patternExceptService.isPatternExist(patternExceptVO)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.service", request));
		} else {
			String adminId = Common.getAdminId(session);
			int rs = patternExceptService.insertPatternExcept(patternExceptVO,adminId);
			makeInfoService.addInfoPatternExcept();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/updatePatternExcept.xcn")
	@Description("예외 패턴 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updatePatternExcept(final HttpServletRequest request, PatternExceptVO patternExceptVO) throws Exception {
		if (patternExceptService.isPatternExist(patternExceptVO)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.url", request, patternExceptVO.getPattern()));
		} else {
			int rs = patternExceptService.updatePatternExcept(patternExceptVO);
			makeInfoService.addInfoPatternExcept();
			return new XcnResponseVO(XcnRspCode.OK, rs);
		}
	}

	@RequestMapping(value = "/deletePatternExcept.xcn")
	@Description("예외 패턴 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deletePatternExcept(final HttpServletRequest request) throws Exception {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<PatternExceptVO> patternExceptlist = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			PatternExceptVO filter = (PatternExceptVO) JSONObject.toBean(data.getJSONObject(i), PatternExceptVO.class);
			patternExceptlist.add(filter);
		}
		if (patternExceptService.deletePatternExcept(patternExceptlist) == 1) {
			makeInfoService.addInfoPatternExcept();
			return new XcnResponseVO(XcnRspCode.OK);
		} else {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
		}
	}

}
