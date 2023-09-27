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
public class CustomDashBoardSetupControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	private static final String DASH_NAME = "dashName";
	private static final String DASH_SETUP_NAME = "dashboardSetup.dashname";
	
	public void getDashBoardContentList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		
		String allLOg = "";
		allLOg += "["+Prop.propFormat("common.msg.search")+"]";
		if(Common.isNotEmpty(searchStr)) allLOg += "┌" + Prop.propFormat("condition.search_str")+": " + searchStr;
		auditVo.setInformation(allLOg);
		if( Common.nvl(param.get("menuKey")).isEmpty() ) auditService.insertAudit(request, auditVo);
	}
	
	public void insertDashBoardContent(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String dashName = Common.nvl(param.get(DASH_NAME));
		String dashType = Common.nvl(param.get("dashType"));
		String dashTypeStr = "";
		
		if( dashType.equals("S") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.single");
		else if( dashType.equals("D") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.multi");
		else if( dashType.equals("C") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.chart");
		else if( dashType.equals("L") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.list");
		
		String dashChart = Common.nvl(param.get("dashChart"));
		String dashChartStr = "";
		if( dashChart.equals("P") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.pie");
		else if( dashChart.equals("L") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.line");
		else if( dashChart.equals("A") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.area");
		else if( dashChart.equals("B") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.bar");
		
		String dashIcon = Common.nvl(param.get("dashIcon"));
		String dashComment = Common.nvl(param.get("dashComment"));
		String useYn = Common.nvl(param.get("useYn")).equals("Y") ? Prop.propFormat("dashboardSetup.use") : Prop.propFormat("dashboardSetup.unuse");
		
		String allLog = Prop.propFormat(DASH_SETUP_NAME)+": " + dashName + "┌" + Prop.propFormat("dashboardSetup.dashtype")+": " + dashTypeStr + "┌";
		if(dashType.equals("C")) allLog += Prop.propFormat("dashboardSetup.dashchart")+": " + dashChartStr + "┌"; 
		allLog += Prop.propFormat("dashboardSetup.dashicon")+": " + "<i class=\"" + dashIcon + "\"></i>" + "┌"+Prop.propFormat("dashboardSetup.useyn")+": " + useYn + "┌"
		+ Prop.propFormat("dashboardSetup.dashcomment")+": " + dashComment;
		auditVo.setInformation(allLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateDashBoardContent(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String dashName = Common.nvl(param.get(DASH_NAME));
		String dashType = Common.nvl(param.get("dashType"));
		String dashTypeStr = "";
		
		if( dashType.equals("S") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.single");
		else if( dashType.equals("D") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.multi");
		else if( dashType.equals("C") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.chart");
		else if( dashType.equals("L") ) dashTypeStr = Prop.propFormat("dashboardSetup.dashtype.list");
		
		String dashChart = Common.nvl(param.get("dashChart"));
		String dashChartStr = "";
		if( dashChart.equals("P") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.pie");
		else if( dashChart.equals("L") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.line");
		else if( dashChart.equals("A") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.area");
		else if( dashChart.equals("B") ) dashChartStr = Prop.propFormat("dashboardSetup.dashchart.bar");
		
		String dashIcon = Common.nvl(param.get("dashIcon"));
		String dashComment = Common.nvl(param.get("dashComment"));
		String useYn = Common.nvl(param.get("useYn")).equals("Y") ? Prop.propFormat("dashboardSetup.use") : Prop.propFormat("dashboardSetup.unuse");
		
		String allLog = Prop.propFormat(DASH_SETUP_NAME)+": " + dashName + "┌" + Prop.propFormat("dashboardSetup.dashtype")+": " + dashTypeStr + "┌";
		if(dashType.equals("C")) allLog += Prop.propFormat("dashboardSetup.dashchart")+": " + dashChartStr + "┌"; 
		allLog += Prop.propFormat("dashboardSetup.dashicon")+": " + "<i class=\"" + dashIcon + "\"></i>" + "┌"+Prop.propFormat("dashboardSetup.useyn")+": " + useYn + "┌"
		+ Prop.propFormat("dashboardSetup.dashcomment")+": " + dashComment;
		auditVo.setInformation(allLog);
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteDashBoardContent(final HttpServletRequest request, AuditRequestVO auditVo){
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); ++i) {
		    String allLOg = Prop.propFormat(DASH_SETUP_NAME)+": " + data.getJSONObject(i).get(DASH_NAME) + "┌";
			auditVo.setInformation(allLOg);
			auditService.insertAudit(request, auditVo);
		}
	}
}
