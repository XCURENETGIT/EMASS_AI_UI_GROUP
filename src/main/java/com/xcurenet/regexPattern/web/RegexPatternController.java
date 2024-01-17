package com.xcurenet.regexPattern.web;

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
import com.xcurenet.emass.keyword.service.KeywordVO;
import com.xcurenet.regexPattern.service.RegexPatternService;
import com.xcurenet.regexPattern.service.RegexPatternVO;
import lombok.extern.slf4j.Slf4j;
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
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.RELATION_PATTERN)
@Slf4j
public class RegexPatternController {

	@Resource(name = "regexPatternService")
	public RegexPatternService regexPatternService;

	@RequestMapping(value = "/getRegexPattern.xcn")
	@Description("정규식 패턴 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getRegexPattern(final HttpServletRequest request, final HttpSession httpSession) throws Exception{
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, regexPatternService.getRegexPatternList(searchStr, offset, limit));
	}

	@RequestMapping(value = "/insertRegexPattern.xcn")
	@Description("정규식 패턴 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertRegexPattern(final HttpServletRequest request, RegexPatternVO regexPattern) throws Exception{
		regexPattern.setRegexUser(Common.getAdminId(request));
		if (regexPatternService.isRegexPatternName(regexPattern)){
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.regexPatternName", request, regexPattern.getRegexPatternName()));
		}
		return new XcnResponseVO(XcnRspCode.OK, regexPatternService.insertRegexPattern(regexPattern));
	}

	@RequestMapping(value = "/updateRegexPattern.xcn")
	@Description("정규식 패턴 이름 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateRegexPattern(final HttpServletRequest request, RegexPatternVO regexPattern) throws Exception{
		regexPattern.setRegexUser(Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, regexPatternService.updateRegexPattern(regexPattern));
	}

	@RequestMapping(value = "/deleteRegexPattern.xcn")
	@Description("정규식 패턴 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteKeyword(final HttpServletRequest request) throws Exception{
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		List<RegexPatternVO> regexPatterns = new ArrayList<>();

		for (int i = 0; i<data.size(); i++){
			RegexPatternVO regexPatternVO =(RegexPatternVO) JSONObject.toBean(data.getJSONObject(i), RegexPatternVO.class);
			regexPatterns.add(regexPatternVO);
		}
		return new XcnResponseVO(XcnRspCode.OK, regexPatternService.deleteRegexPattern(regexPatterns));
	}


}
