package com.xcurenet.pattern.web;


import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.makeInfo.service.impl.MakeInfoServiceMysql;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.pattern.service.PatternService;
import com.xcurenet.pattern.service.PatternVO;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@Log4j2
@Controller
@AuditParentMenu(ParentMenu.SETTING)
@AuditMenu(Menu.PATTERN_INFO)
public class PatternController {
	@Resource(name = "patternService")
	public PatternService patternService;

	@Autowired
	public MakeInfoServiceMysql infoServiceMysql;

	@Autowired
	public Config config;

	@RequestMapping(value = "/getPattern.xcn")
	@Description("패턴 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getPattern(final HttpServletRequest request, final HttpSession httpSession) throws Exception{
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String patternType = Common.nvl(request.getParameter("patternType"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, patternService.getPatternService(searchStr, offset, limit, patternType));
	}

	@RequestMapping(value = "/insertPattern.xcn")
	@Description("패턴 추가")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertPattern(final HttpServletRequest request, PatternVO patternVO, final HttpSession session) throws Exception{
		if (patternService.isPatternCode(patternVO)){
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.patternCode", request, patternVO.getCode()));
		}

		patternService.insertPattern(patternVO, Common.getAdminId(session));
		config.reloadPattern();
		return new XcnResponseVO((XcnRspCode.OK));
	}

	@RequestMapping(value = "/updatePattern.xcn")
	@Description("패턴 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updatePattern(final HttpServletRequest request, PatternVO patternVO, final HttpSession session) throws Exception{
		patternService.updatePattern(patternVO, Common.getAdminId(session));
		config.reloadPattern();
		return new XcnResponseVO((XcnRspCode.OK));
	}

	@RequestMapping(value = "/deletePattern.xcn")
	@Description("패턴 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deletePattern(final HttpServletRequest request) throws Exception{
		String deleteData = request.getParameter("deleteData");
		JSONArray data = Common.toJSONArray(deleteData);
		List<PatternVO> patternVOS = new ArrayList<>();
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			PatternVO patternVO = new PatternVO();
			patternVO.setName(obj.getString("name"));
			patternVO.setRegex(obj.getString("regex"));
			patternVO.setCode(obj.getString("code"));
			log.info("{}", patternVO);
			patternVOS.add(patternVO);
		}
		config.reloadPattern();
		return new XcnResponseVO(XcnRspCode.OK, patternService.deletePattern(patternVOS));

	}
}
