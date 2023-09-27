package com.xcurenet.emass.workday.log;


import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONObject;

@Component
public class WorkdayControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getWorkday(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String busiNm = Common.nvl(param.get("busiNm"));
		String curtab = Common.nvl(param.get("curtab"));
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm;
		auditVo.setInformation("["+Prop.propFormat("common.msg.search")+"]" +curtab+ AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void saveWorkday(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String busiNm = Common.nvl(param.get("busiNm"));
		String workDayNm = Common.nvl(param.get("workDayNm"));
		String workHourNm = Common.nvl(param.get("workHourNm"));
		
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm + "┌"+Prop.propFormat("common.msg.work_day")+": " + workDayNm +"┌"+Prop.propFormat("common.msg.work_time")+": " + workHourNm;
		auditVo.setInformation("["+Prop.propFormat("common.msg.modify")+"]" + AllLog);
		auditService.insertAudit(request, auditVo);
	}
}
