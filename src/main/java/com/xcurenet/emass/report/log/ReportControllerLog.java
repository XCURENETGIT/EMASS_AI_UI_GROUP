package com.xcurenet.emass.report.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class ReportControllerLog {

	@Autowired
	private AuditService auditService;

	public void getReportDeviceStatusList(final HttpServletRequest request, AuditRequestVO auditVo) {
		String information = "";

		information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("OPERATION_MGMT.DEV_INFO")+" ";

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getReportCnt(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		String facet = Common.nvl(param.get("facet"));
		String information = "";
		
		if(Common.isEquals(facet,"user_str")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("consent.user")+" TOP10";
		else if(Common.isEquals(facet,"sender_str")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("condition.sender")+" TOP10";
		else if(Common.isEquals(facet,"svc12")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("condition.service_type")+" TOP10";
		else if(Common.isEquals(facet,"kwds")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("condition.keyword")+" TOP10";
		else if(Common.isEquals(facet,"attachtype")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("condition.attach_type")+" TOP10";
		else if(Common.isEquals(facet,"attachname_str")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" "+Prop.propFormat("condition.attach_name")+" TOP10";
		else if(Common.isEquals(facet,"host_str")) information += "["+Prop.propFormat("common.msg.search")+"]┌"+Prop.propFormat("DATA_MONITOR.STAT_REPORT")+" URL TOP10";

		if (Common.isNotEmpty(startDate)) information += "┌"+Prop.propFormat("condition.period")+": " + startDate + " ~ " + endDate;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
