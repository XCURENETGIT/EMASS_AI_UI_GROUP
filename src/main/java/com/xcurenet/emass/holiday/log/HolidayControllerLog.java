package com.xcurenet.emass.holiday.log;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xcurenet.audit.service.AuditRequestVO;
import com.xcurenet.audit.service.AuditService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class HolidayControllerLog {
	
	@Autowired
	private AuditService auditService;
	
	public void getHolidayList(final HttpServletRequest request, AuditRequestVO auditVo){
		JSONObject param = Common.getParam(request);
		String curTab = Common.nvl(param.get("curTab"));
		String busiNm = Common.nvl(param.get("busiNm"));
		String year = Common.nvl(param.get("year"));
		
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm+ "┌"+Prop.propFormat("condition.year")+": " + year ;
		auditVo.setInformation(curTab + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void insertHoliday(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String curTab = Common.nvl(param.get("curTab"));
		String busiNm = Common.nvl(param.get("busiNm"));
		String date = Common.nvl(param.get("date"));
		String comment = Common.nvl(param.get("comment"));
		
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm+ "┌"+Prop.propFormat("condition.date")+": " + date+ "┌"+Prop.propFormat("common.msg.comment")+": " + comment ;
		auditVo.setInformation(curTab + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void updateHoliday(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String curTab = Common.nvl(param.get("curTab"));
		String busiNm = Common.nvl(param.get("busiNm"));
		String date = Common.nvl(param.get("date"));
		String comment = Common.nvl(param.get("comment"));
		
		String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm+ "┌"+Prop.propFormat("condition.date")+": " + date+ "┌"+Prop.propFormat("common.msg.comment")+": " + comment ;
		auditVo.setInformation(curTab + AllLog);
		auditService.insertAudit(request, auditVo);
	}
	public void deleteHoliday(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String busiNm = Common.nvl(param.get("busiNm"));
		String curTab = Common.nvl(param.get("curTab"));
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		String date="" ;
		String comment ="" ;
		for (int i = 0; i < data.size(); ++i) {
		    JSONObject holiday = data.getJSONObject(i);
		    date = holiday.getString("date");
		    comment = holiday.getString("comment");
		    String AllLog = "┌"+Prop.propFormat("common.org.businm")+": " + busiNm + "┌"+Prop.propFormat("condition.date")+": " + date +"┌"+Prop.propFormat("common.msg.comment")+": " + comment;
			auditVo.setInformation(curTab + AllLog);
			auditService.insertAudit(request, auditVo);
		}
	}
	
}
