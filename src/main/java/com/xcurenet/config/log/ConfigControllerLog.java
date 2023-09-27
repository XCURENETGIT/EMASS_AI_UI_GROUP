package com.xcurenet.config.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class ConfigControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void setConf(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String checkedInsaText = Common.nvl(param.get("checkedInsaText"));
		String AllLog ="┌"+Prop.propFormat("java.log.method.setup")+": " + checkedInsaText;
		auditVo.setInformation(Prop.propFormat("java.log.usermanage")+": " + AllLog);
		auditService.insertAudit(request, auditVo);
	}
}
