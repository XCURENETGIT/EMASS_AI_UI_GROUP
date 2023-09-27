package com.xcurenet.emass.searchLog.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class SearchLogControllerLog {

	@Autowired
	private AuditService auditService;

	public void getSearchLogList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String adminId = Common.nvl(param.get("adminId"));
		String searchType = Common.nvl(param.get("searchType"));
		String searchTypeStr = "";
		if( searchType.equals("Y")) searchTypeStr = Prop.propFormat("searchLog.consent.assigned");
		else searchTypeStr = Prop.propFormat("searchLog.consent.unassigned");
		
		String information = "["+Prop.propFormat("common.msg.search")+"]";
		information += "";
		information += "┌"+Prop.propFormat("condition.period")+": " + startDt + " ~ " + endDt;
		information += "┌"+Prop.propFormat("java.log.type.search")+": " + searchTypeStr;
		information += "┌"+Prop.propFormat("common.msg.id")+": " + adminId;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
