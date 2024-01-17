package com.xcurenet.regexPattern.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.regexPattern.service.RegexPatternService;
import com.xcurenet.regexPattern.service.RegexPatternVO;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Component
public class RegexPatternControllerLog {
	@Autowired
	private AuditService auditService;

	@Resource(name = "regexPatternService")
	public RegexPatternService regexPatternService;


	public void getRegexPattern(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String information = "";

		information += "["+ Prop.propFormat("regexPattern.msg.part_name") + " " + Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void insertRegexPattern(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String regexPatternName = Common.nvl(param.get("regexPatternName"));
		String regexPattern = Common.nvl(param.get("regexPattern"));
		String information = "";
		RegexPatternVO regexPatternVO = new RegexPatternVO();
		regexPatternVO.setRegexPattern(regexPattern);
		regexPatternVO.setRegexPatternName(regexPatternName);
		if (!regexPatternService.isRegexPatternName(regexPatternVO)){
			information += "["+Prop.propFormat("common.msg.add")+"]";
			if(Common.isNotEmpty(regexPatternName))information += "┌"+Prop.propFormat("regexPattern.name")+": " + regexPatternName;
			if(Common.isNotEmpty(regexPattern))information += "┌"+Prop.propFormat("regexPattern.pattern")+": " + regexPattern;
		}
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);

	}



}
