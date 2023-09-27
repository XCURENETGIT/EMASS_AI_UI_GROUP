package com.xcurenet.emass.dashboard.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class DashBoardControllerLog {

	@Autowired
	private AuditService auditService;

	public void saveDeviceStatus(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String dashKey = Common.nvl(param.get("dashKey"));
		String dashVal = Common.nvl(param.get("dashVal"));
		String dashValStr = Common.nvl(param.get("dashValStr"));
		String information = "";
		
		if( Common.isEquals(dashKey, "device.status1" ) || Common.isEquals(dashKey, "device.status2") ) {
			auditVo.setOperation(Operation.CHG_DEV.getOperation());
			information += "["+Prop.propFormat("dashboard.setting.device")+"]┌"+Prop.propFormat("common.msg.device_name")+": " + dashValStr;
		} else if(Common.isEquals(dashKey, "file.send") ) {
			auditVo.setOperation(Operation.CHG_FILESIZE.getOperation());
			information += "["+Prop.propFormat("dashboard.msg.setting.filesize")+"]┌"+Prop.propFormat("message.msg.attach_size")+": " + dashVal + " MB";
		}
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
