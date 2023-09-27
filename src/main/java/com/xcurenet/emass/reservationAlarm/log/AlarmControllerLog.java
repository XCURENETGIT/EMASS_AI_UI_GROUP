package com.xcurenet.emass.reservationAlarm.log;

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
public class AlarmControllerLog {

	@Autowired
	private AuditService auditService;

	public void getAlarmList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String information = "";

		information += "["+Prop.propFormat("common.msg.search")+"]";
		
		if( Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertAlarm(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String alarmName = Common.nvl(param.get("alarmName"));
		String useYn = Common.nvl(param.get("useYn"));
		if(Common.isEquals(useYn,"N")) useYn = Prop.propFormat("common.msg.unuse");
		else useYn = Prop.propFormat("common.msg.use");
		String alarmType = Common.nvl(param.get("alarmType"));
		alarmType.replaceAll("M",Prop.propFormat("mail.alert_message"));
		alarmType.replaceAll("S","SMS");
		alarmType.replaceAll("E",Prop.propFormat("mail.msg"));
		String alarmMailYn = Common.nvl(param.get("alarmMailYn"));
		String formSubject = Common.nvl(param.get("formSubject"));
		String alarmCycle = Common.nvl(param.get("alarmCycle"));
		if(Common.isEquals(alarmCycle,"D")) alarmCycle = Prop.propFormat("common.msg.everyday");
		else alarmCycle = Prop.propFormat("common.msg.everyhour");
		String alarmTime = Common.nvl(param.get("alarmTime"));
		if(Common.isEquals(alarmTime,"24")) alarmTime = Prop.propFormat("common.msg.everyhour");
		else alarmTime = Prop.propFormat("condition.clock", alarmTime);
		String alarmTo = Common.nvl(param.get("alarmTo"));
		String alarmCC = Common.nvl(param.get("alarmCC"));
		String alarmValStr = Common.nvl(param.get("alarmValStr"));
		String information = "";

		information += "["+Prop.propFormat("common.msg.add")+"]";
		if (Common.isNotEmpty(alarmName)) information += "┌"+Prop.propFormat("mail.reservation.name")+": " + alarmName;
		if (Common.isNotEmpty(useYn)) information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYn;
		if (Common.isNotEmpty(alarmType)) information += "┌"+Prop.propFormat("mail.reservation.alarm_type")+": " + alarmType;
		if (Common.isNotEmpty(alarmCycle)) information += "┌"+Prop.propFormat("mail.execute_cycle")+": " + alarmCycle;
		if (Common.isNotEmpty(alarmTime)) information += "┌"+Prop.propFormat("mail.execute_time")+": " + alarmTime;
		if (Common.isNotEmpty(alarmTo)) information += "┌"+Prop.propFormat("mail.recv")+": " + alarmTo;
		if (Common.isNotEmpty(alarmCC)) information += "┌"+Prop.propFormat("mail.recv.cc")+": " + alarmCC;
		if(Common.isEquals(alarmMailYn,"Y")) {
			if (Common.isNotEmpty(formSubject)) information += "┌"+Prop.propFormat("mail.form.subject")+": " + formSubject;
		}
		if (Common.isNotEmpty(alarmValStr)) information += "┌"+Prop.propFormat("mail.selected_condition.content")+": " + alarmValStr;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateAlarm(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String alarmName = Common.nvl(param.get("alarmName"));
		String useYn = Common.nvl(param.get("useYn"));
		if(Common.isEquals(useYn,"N")) useYn = Prop.propFormat("common.msg.unuse");
		else useYn = Prop.propFormat("common.msg.use");
		String alarmType = Common.nvl(param.get("alarmType"));
		alarmType.replaceAll("M",Prop.propFormat("mail.alert_message"));
		alarmType.replaceAll("S","SMS");
		alarmType.replaceAll("E",Prop.propFormat("mail.msg"));
		String alarmMailYn = Common.nvl(param.get("alarmMailYn"));
		String formSubject = Common.nvl(param.get("formSubject"));
		String alarmCycle = Common.nvl(param.get("alarmCycle"));
		if(Common.isEquals(alarmCycle,"D")) alarmCycle = Prop.propFormat("common.msg.everyday");
		else alarmCycle = Prop.propFormat("common.msg.everyhour");
		String alarmTime = Common.nvl(param.get("alarmTime"));
		if(Common.isEquals(alarmTime,"24")) alarmTime = Prop.propFormat("common.msg.everyhour");
		else alarmTime = Prop.propFormat("condition.clock", alarmTime);
		String alarmTo = Common.nvl(param.get("alarmTo"));
		String alarmCC = Common.nvl(param.get("alarmCC"));
		String alarmValStr = Common.nvl(param.get("alarmValStr"));
		String information = "";

		information += "["+Prop.propFormat("common.msg.modify")+"]";
		if (Common.isNotEmpty(alarmName)) information += "┌"+Prop.propFormat("mail.reservation.name")+": " + alarmName;
		if (Common.isNotEmpty(useYn)) information += "┌"+Prop.propFormat("common.msg.useyn")+": " + useYn;
		if (Common.isNotEmpty(alarmType)) {
			String alarmTypeStr = "";
			if( alarmType.equals("M")) alarmTypeStr = Prop.propFormat("mail.alert_message");
			else if( alarmType.equals("S")) alarmTypeStr = "SMS";
			else alarmTypeStr = Prop.propFormat("mail.msg");
			information += "┌"+Prop.propFormat("mail.reservation.alarm_type")+": " + alarmTypeStr;
		}
		if (Common.isNotEmpty(alarmCycle)) information += "┌"+Prop.propFormat("mail.execute_cycle")+": " + alarmCycle;
		if (Common.isNotEmpty(alarmTime)) information += "┌"+Prop.propFormat("mail.execute_time")+": " + alarmTime;
		if (Common.isNotEmpty(alarmTo)) information += "┌"+Prop.propFormat("mail.recv")+": " + alarmTo;
		if (Common.isNotEmpty(alarmCC)) information += "┌"+Prop.propFormat("mail.recv.cc")+": " + alarmCC;
		if(Common.isEquals(alarmMailYn,"Y")) {
			if (Common.isNotEmpty(formSubject)) information += "┌"+Prop.propFormat("mail.form.subject")+": " + formSubject;
		}
		if (Common.isNotEmpty(alarmValStr)) information += "┌"+Prop.propFormat("mail.selected_condition.content")+": " + alarmValStr;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteAlarm(final HttpServletRequest request, AuditRequestVO auditVo) {
		String alarmNames = Common.nvl(request.getParameter("alarmNames"));
		String information = "";

		information += "["+Prop.propFormat("common.msg.delete")+"]";
		information += "┌"+Prop.propFormat("mail.reservation.name")+": " + alarmNames;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void getMailFormList(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String searchStr = Common.nvl(param.get("searchStr"));
		String information = "";

		information += "[" + Prop.propFormat("mail.mgnt.form.mail") + " " + Prop.propFormat("common.msg.search") + "]";
		
		if( Common.isNotEmpty(searchStr)) information += "┌"+Prop.propFormat("condition.search_str")+": " + searchStr;

		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void insertMailForm(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String formSubject = Common.nvl(param.get("formSubject"));
		String formContent = Common.nvl(param.get("formContent"));
		String formComment = Common.nvl(param.get("formComment"));
		String information = "";

		information += "[" + Prop.propFormat("mail.mgnt.form.mail") + " " + Prop.propFormat("common.msg.add") + "]";
		if( Common.isNotEmpty(formSubject)) information += "┌"+Prop.propFormat("mail.form.subject")+": " + formSubject;
		if( Common.isNotEmpty(formContent)) information += "┌"+Prop.propFormat("mail.form.content")+": " + formContent;
		if( Common.isNotEmpty(formComment)) information += "┌"+Prop.propFormat("mail.form.comment")+": " + formComment;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void updateMailForm(final HttpServletRequest request, AuditRequestVO auditVo) {
		JSONObject param = Common.getParam(request);
		String formSubject = Common.nvl(param.get("formSubject"));
		String formContent = Common.nvl(param.get("formContent"));
		String formComment = Common.nvl(param.get("formComment"));
		String information = "";

		information += "[" + Prop.propFormat("mail.mgnt.form.mail") + " " + Prop.propFormat("common.msg.modify") + "]";
		if( Common.isNotEmpty(formSubject)) information += "┌"+Prop.propFormat("mail.form.subject")+": " + formSubject;
		if( Common.isNotEmpty(formContent)) information += "┌"+Prop.propFormat("mail.form.content")+": " + formContent;
		if( Common.isNotEmpty(formComment)) information += "┌"+Prop.propFormat("mail.form.comment")+": " + formComment;
		
		auditVo.setInformation(information);
		auditService.insertAudit(request, auditVo);
	}
	
	public void deleteMailForm(final HttpServletRequest request, AuditRequestVO auditVo) {
		String deleteData = Common.nvl(request.getParameter("deleteData"));
		JSONArray data = Common.toJSONArray(deleteData);
		for (int i = 0; i < data.size(); i++) {
			JSONObject obj = data.getJSONObject(i);
			String formSubject = Common.nvl(obj.get("formSubject"));
			String formContent = Common.nvl(obj.get("formContent"));
			String formComment = Common.nvl(obj.get("formComment"));
			String information = "";

			information += "[" + Prop.propFormat("mail.mgnt.form.mail") + " " + Prop.propFormat("common.msg.delete") + "]";
			if( Common.isNotEmpty(formSubject)) information += "┌"+Prop.propFormat("mail.form.subject")+": " + formSubject;
			if( Common.isNotEmpty(formContent)) information += "┌"+Prop.propFormat("mail.form.content")+": " + formContent;
			if( Common.isNotEmpty(formComment)) information += "┌"+Prop.propFormat("mail.form.comment")+": " + formComment;
			
			auditVo.setInformation(information);
			auditService.insertAudit(request, auditVo);
		}
	}
}
