package com.xcurenet.device.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class DeviceTrafficStatControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getDeviceTrafficStat(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String xAxis = Common.nvl(param.get("xAxis"));
		String xAxis_str = Common.nvl(param.get("xAxis_str"));
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		
		String information = "";
		
		information += "["+Prop.propFormat("common.msg.search")+"]";
		information += "┌"+Prop.propFormat("condition.period")+": " + startDt + " ~ " + endDt;
		information += "┌"+Prop.propFormat("stat.area.stat")+": " + xAxis_str;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
