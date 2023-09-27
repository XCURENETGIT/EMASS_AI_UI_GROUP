package com.xcurenet.common.snmp.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class SnmpTrapControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	
	public void getSnmpTrapList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String startDt = Common.nvl(param.get("startDt"));
		String endDt = Common.nvl(param.get("endDt"));
		String deviceNm = Common.nvl(param.get("deviceNm"));
		String eventLevelNm = Common.nvl(param.get("eventLevelNm"));
		String information = "["+Prop.propFormat("common.msg.search")+"]";
		information += "┌"+Prop.propFormat("condition.period")+": "+startDt +"~"+ endDt;
		if(Common.isNotEmpty(deviceNm)) information += "┌"+Prop.propFormat("common.msg.device")+": " + deviceNm;
		if(Common.isNotEmpty(eventLevelNm)) information += "┌"+Prop.propFormat("common.msg.event_level")+": " + eventLevelNm;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
