package com.xcurenet.pattern.log;


import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.pattern.service.PatternService;
import com.xcurenet.pattern.service.PatternVO;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.regex.Pattern;

@Component
public class PatternControllerLog {

	@Autowired
	private AuditService auditService;


	@Resource(name = "patternService")
	public PatternService patternService;


	public void getPattern(final HttpServletRequest request,AuditRequestVO auditVo){

		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(request.getParameter(""));
		String information = "";

		information += "[" + Prop.propFormat("SETTING.PATTERN_INFO") + " " + Prop.propFormat("common.msg.search") + "]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void insertPattern(final HttpServletRequest request,AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String code = Common.nvl(param.get("code"));
		String patternName = Common.nvl(param.get("name"));
		String patternRegex = Common.nvl(param.get("regex"));
		String information = "";
		information += "["+Prop.propFormat("common.msg.add")+"]";
		if(Common.isNotEmpty(code))information += "┌"+Prop.propFormat("selectCodeAll.code")+": " + code;
		if(Common.isNotEmpty(patternName))information += "┌"+Prop.propFormat("pattern.name")+": " + patternName;
		if(Common.isNotEmpty(patternRegex))information += "┌"+Prop.propFormat("pattern.regexPattern")+": " + patternRegex;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

	public void updatePattern(final HttpServletRequest request,AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);


		String code = Common.nvl(param.get("code"));
		String patternName = Common.nvl(param.get("name"));
		String patternRegex = Common.nvl(param.get("regex"));
		PatternVO patternVO = new PatternVO();
		patternVO.setCode(code);
		patternVO.setName(patternName);
		patternVO.setRegex(patternRegex);
		String information = "";
		if (patternService.isPatternCode(patternVO)){
			information += "["+Prop.propFormat("common.msg.modify")+"]";
			if(Common.isNotEmpty(code))information += "┌"+Prop.propFormat("selectCodeAll.code")+": " + code;
			if(Common.isNotEmpty(patternName))information += "┌"+Prop.propFormat("pattern.name")+": " + patternName;
			if(Common.isNotEmpty(patternRegex))information += "┌"+Prop.propFormat("pattern.regexPattern")+": " + patternRegex;
		}
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);

	}

}
