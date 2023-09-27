package com.xcurenet.config.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class ConfigAdminControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void setConfAdmin(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		
		String deviceConfName = Common.nvl(param.get("deviceConfName"));
		String deviceStatus = Common.nvl(param.get("deviceStatus"));
		String confId = Common.nvl(param.get("confId"));
		String val = Common.nvl(param.get("val"));
		String auditInterUserYn = Common.nvl(param.get("auditInterUserYn"));
		
		String information = "";
		if(Common.isEquals(confId, "interestUser.user")) {
			if(Common.isNotEquals(auditInterUserYn, "Y")) {
				auditVo.setPMenuId(ParentMenu.DATA_MONITOR.getParentMenuId());
				auditVo.setMenuId(Menu.DASHBOARD.getMenuId());
				auditVo.setOperation(Operation.CHG_INTEREST.getOperation());
				information = Prop.propFormat("java.log.change.interest")+"┌"+Prop.propFormat("interest.user")+": "+(val.equals("") ? Prop.propFormat("condition.unselect") : Common.nvl(param.get("interestUserNm")));
			} else {
				return;
			}
		} else {
			information = Prop.propFormat("java.log.admin.setting")+": " + (deviceConfName + deviceStatus);
		}
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
}
