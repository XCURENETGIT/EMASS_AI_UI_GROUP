package com.xcurenet.common.makeInfo.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class MakeInfoControllerLog {

	@Autowired
	private AuditService auditService;

	public void makeInfoUser(final HttpServletRequest request, AuditRequestVO auditVo) {

		// log.info("audit request {}", request);
		// log.info("audit vo {}", auditVo);

		JSONObject param = Common.getParam(request);
		String comment = Common.nvl(param.get("comment"));

		auditVo.setInformation(Prop.propFormat("OPERATION_MGMT.USER_MGMT")+"┌" + comment);
		auditService.insertAudit(request, auditVo);
	}
}
