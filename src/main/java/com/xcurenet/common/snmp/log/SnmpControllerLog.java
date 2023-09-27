package com.xcurenet.common.snmp.log;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.snmp.get.GetSnmp;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.device.service.DeviceVO;

import net.sf.json.JSONObject;

@Component
public class SnmpControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	
	public void setHddAlarm(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String emgaechi = Common.nvl(param.get("emgaechi"));
		String deviceNm = Common.nvl(param.get("deviceNm"));
		String hddNotifyLimit = Common.nvl(param.get("hddNotifyLimit"));
		String hddWarnLimit = Common.nvl(param.get("hddWarnLimit"));
		String hddAlarmLimit = Common.nvl(param.get("hddAlarmLimit"));
		String information = "["+Prop.propFormat("java.log.limit.setting")+"]";
		information += "┌"+Prop.propFormat("common.msg.setting")+": "+emgaechi +"┌"+Prop.propFormat("common.msg.device_name")+": " +deviceNm+"┌"+Prop.propFormat("dashboard.interest")+": " +hddNotifyLimit+"┌"+Prop.propFormat("dashbaord.warn")+": " +hddWarnLimit+"┌"+Prop.propFormat("dashboard.danger")+": " +hddAlarmLimit ;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void setCpuAlarm(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String emgaechi = Common.nvl(param.get("emgaechi"));
		String deviceNm = Common.nvl(param.get("deviceNm"));
		String cpuLoadLimit = Common.nvl(param.get("cpuLoadLimit"));
		String information = "["+Prop.propFormat("java.log.limit.setting")+"]";
		information += "┌"+Prop.propFormat("common.msg.setting")+": "+emgaechi +"┌"+Prop.propFormat("common.msg.device_name")+": " +deviceNm+"┌"+Prop.propFormat("dashbaord.warn")+": " +cpuLoadLimit;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void setMemoryAlarm(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String emgaechi = Common.nvl(param.get("emgaechi"));
		String deviceNm = Common.nvl(param.get("deviceNm"));
		String memInfoLimit = Common.nvl(param.get("memInfoLimit"));
		String information = "["+Prop.propFormat("java.log.limit.setting")+"]";
		information += "┌"+Prop.propFormat("common.msg.setting")+": "+emgaechi +"┌"+Prop.propFormat("common.msg.device_name")+": " +deviceNm+"┌"+Prop.propFormat("dashbaord.warn")+": " +memInfoLimit;
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
