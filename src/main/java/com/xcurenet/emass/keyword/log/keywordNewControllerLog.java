package com.xcurenet.emass.keyword.log;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class keywordNewControllerLog {
	@Autowired
	private AuditService auditService;

	public void  getKeywordNew(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);

		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String coreKeyword = Common.nvl(request.getParameter("coreKeyword"));

		StringBuffer info = new StringBuffer();

		info.append("[").append(Prop.propFormat("common.msg.search")).append("]");
		info.append("┌").append(Prop.propFormat("condition.period")).append(": ").append(startDate).append(" ~ ").append(endDate);
		info.append("┌").append(Prop.propFormat("keyword.msg.coreKeyword")).append(": ").append(coreKeyword);

		auditVo.setInformation(info.toString());
		auditService.insertAudit(request, auditVo);
	}
}
