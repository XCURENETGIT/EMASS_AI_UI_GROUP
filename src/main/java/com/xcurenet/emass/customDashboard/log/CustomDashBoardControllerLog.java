package com.xcurenet.emass.customDashboard.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class CustomDashBoardControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void saveDashBoard(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
//		String menuName = Common.nvl(param.get("menuName"));
		String menuName = Common.nvl(param.get("menuName"));
		String allLog = "";
		allLog += "["+Prop.propFormat("common.msg.save")+"]";
		allLog += "┌" + Prop.propFormat("dashboardMenu.menuname") + ": " + menuName;
		auditVo.setInformation(allLog);
		auditService.insertAudit(request, auditVo);
	}
}
