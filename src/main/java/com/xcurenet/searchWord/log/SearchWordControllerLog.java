package com.xcurenet.searchWord.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;;
import com.xcurenet.searchWord.service.SearchWordService;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Component
public class SearchWordControllerLog {
	@Resource(name = "searchWordService")
	public SearchWordService searchWordService;

	@Autowired
	private AuditService auditService;



	public void getSearchWord(final HttpServletRequest request,  AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(request.getParameter(""));
		String information = "";

		information += "[" + Prop.propFormat("condition.relationKeyword") + " " + Prop.propFormat("common.msg.search") + "]";
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

}
