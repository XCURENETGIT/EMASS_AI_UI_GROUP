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
public class DeviceControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	
	public void updateDevice(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String deviceIp = Common.nvl(param.get("deviceIp"));
		String deviceNm = Common.nvl(param.get("deviceNm"));
		String comment = Common.nvl(param.get("comment"));
		
		String AllLog = "┌"+Prop.propFormat("device.msg.ip")+":" + deviceIp + "┌"+Prop.propFormat("device.msg.name")+":" + deviceNm +"┌"+Prop.propFormat("device.msg.comment")+":" + comment;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void insertDevice(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String deviceIp = Common.nvl(param.get("deviceIp"));
		String deviceNm = Common.nvl(param.get("deviceNm"));
		String comment = Common.nvl(param.get("comment"));
		String AllLog = "┌"+Prop.propFormat("device.msg.ip")+":" + deviceIp + "┌"+Prop.propFormat("device.msg.name")+":" + deviceNm +"┌"+Prop.propFormat("device.msg.comment")+":" + comment;
		auditVo.setInformation("["+Prop.propFormat("common.msg.add")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteDevice(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String deviceNm = Common.nvl(param.get("deviceNm"));
		auditVo.setInformation("["+Prop.propFormat("common.msg.delete")+"]┌" + deviceNm);
		auditService.insertAudit(request, auditVo);
	}
}
