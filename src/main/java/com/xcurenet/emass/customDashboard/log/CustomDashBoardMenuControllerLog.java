package com.xcurenet.emass.customDashboard.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class CustomDashBoardMenuControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	private static final String MENU_NAME = "menuName";
	private static final String DASHBOARD_MENU_NAME = "dashboardMenu.menuname";
	
	public void insertDashBoardMenu(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String menuName = Common.nvl(param.get(MENU_NAME));
		String menuIcon = Common.nvl(param.get("menuIcon"));
		String useYn = Common.nvl(param.get("useYn")).equals("Y") ? Prop.propFormat("dashboardMenu.use") : Prop.propFormat("dashboardMenu.unuse");
		
		String allLog = Prop.propFormat(DASHBOARD_MENU_NAME)+": " + menuName + "┌"+Prop.propFormat("dashboardMenu.icon")+": " + "<i class=\"" + menuIcon + "\"></i>" + "┌"+Prop.propFormat("dashboardMenu.useyn")+": " + useYn ;
		auditVo.setInformation(allLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateDashBoardMenu(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String menuName = Common.nvl(param.get(MENU_NAME));
		String menuIcon = Common.nvl(param.get("menuIcon"));
		String useYn = Common.nvl(param.get("useYn")).equals("Y") ? Prop.propFormat("dashboardMenu.use") : Prop.propFormat("dashboardMenu.unuse");
		
		String allLog = Prop.propFormat(DASHBOARD_MENU_NAME)+": " + menuName + "┌"+Prop.propFormat("dashboardMenu.icon")+": " + "<i class=\"" + menuIcon + "\"></i>" + "┌"+Prop.propFormat("dashboardMenu.useyn")+": " + useYn ;
		auditVo.setInformation(allLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void changeDashBoardDefaultMenu(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String menuName = Common.nvl(param.get(MENU_NAME));
		if(menuName.contains("&gt;")) menuName = menuName.substring(menuName.lastIndexOf("&gt;")).replace("&gt;", "").trim();
		String allLog = Prop.propFormat("dashboardMenu.defaultMenu")+": " + menuName;
		auditVo.setInformation(allLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteDashBoardMenu(final HttpServletRequest request, AuditRequestVO auditVo){
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); ++i) {
		    String allLog = Prop.propFormat(DASHBOARD_MENU_NAME)+": " + data.getJSONObject(i).get(MENU_NAME) + "┌";
			auditVo.setInformation(allLog);
			auditService.insertAudit(request, auditVo);
		}
	}
}
