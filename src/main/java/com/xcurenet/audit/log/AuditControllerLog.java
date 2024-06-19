package com.xcurenet.audit.log;


import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class AuditControllerLog {

	@Autowired
	private AuditService auditService;
	public void getAuditList(final HttpServletRequest request, AuditRequestVO auditVo) {

		String startDt = Common.nvl(request.getParameter("startDt"));
		String endDt = Common.nvl(request.getParameter("endDt"));
		String pMenuId = Common.nvl(request.getParameter("pMenuId"));
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String adminId2 = Common.nvl(request.getParameter("adminId"));

		startDt = startDt.substring(0,4)+"-"+startDt.substring(4,6)+"-"+startDt.substring(6,8);
		endDt = endDt.substring(0,4)+"-"+endDt.substring(4,6)+"-"+endDt.substring(6,8);

		String information = "";
		information += "["+ Prop.propFormat("common.msg.search")+"]";
		if( Common.isNotEmpty(startDt)) information += "┌"+Prop.propFormat("condition.period")+": " + startDt + " ~ " + endDt;
		if(Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;
		if(Common.isNotEmpty(adminId2)) information += "┌"+Prop.propFormat("common.msg.admin")+": " + adminId2;
		if (Common.isNotEmpty(pMenuId)) information += "┌"+Prop.propFormat("common.msg.menu")+": "+Prop.propFormat(pMenuId);
		else  information += "┌"+Prop.propFormat("auditLog.pmenu")+": "+Prop.propFormat("common.msg.all");

		auditVo.setMenuId(Menu.AUDIT_LOG.getMenuId());
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}

}
