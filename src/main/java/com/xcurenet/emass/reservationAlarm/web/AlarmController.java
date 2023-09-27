package com.xcurenet.emass.reservationAlarm.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.reservationAlarm.service.AlarmLogVO;
import com.xcurenet.emass.reservationAlarm.service.AlarmService;
import com.xcurenet.emass.reservationAlarm.service.AlarmVO;

import net.sf.json.JSONObject;

/**
 * Handles requests for the application home page.
 */
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.RESERVATION_ALARM)
public class AlarmController {

	@Resource(name = "alarmService")
	public AlarmService alarmService;
	
	@Resource(name = "adminService")
	public AdminService adminService;

	@RequestMapping(value = "/getAlarmList.xcn")
	@Description("예약알람 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getAlarmList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, alarmService.getAlarmList(searchStr));
	}
	
	@RequestMapping(value = "/getAlarm.xcn")
	@Description("예약알람 조회")
	@ResponseBody
	public XcnResponseVO getAlarm(final HttpServletRequest request) throws Exception {
		String alarmSeq = Common.nvl(Common.getParam(request).get("alarmSeq"));
		return new XcnResponseVO(XcnRspCode.OK, alarmService.getAlarm(alarmSeq));
	}
	
	@RequestMapping(value = "/getAdminEmailList.xcn")
	@Description("예약알람 관리자 메일 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAdminEmailList(final HttpServletRequest request) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, alarmService.getAdminEmailList(searchStr));
	}

	@RequestMapping(value = "/insertAlarm.xcn")
	@Description("예약알람 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertAlarm(final HttpSession session, AlarmVO alarm) throws Exception {
		AlarmVO nAlarm = alarmService.getNextAlarmSeq();
		AdminVO admin = adminService.getAdmin(Common.getAdminId(session));
		alarm.setAdminId(Common.getAdminId(session));
		alarm.setUserId(Common.getAdminId(session));
		alarm.setUserNm(admin.getAdminName());
		alarm.setUserHp(admin.getAdminHp());
		alarm.setAlarmSeq(nAlarm.getAlarmSeq());
		if(Common.isEquals(Common.nvl(alarm.getAlarmFormSeq()),"")) {
			alarm.setAlarmFormSeq("0");
		}
		if(Common.isEquals(Common.nvl(alarm.getExcelMaxCnt()),"")) {
			alarm.setExcelMaxCnt("10000");
		}
		return new XcnResponseVO(XcnRspCode.OK, alarmService.insertAlarm(alarm));
	}

	@RequestMapping(value = "/updateAlarm.xcn")
	@Description("예약알람 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateAlarm(final HttpSession session, AlarmVO alarm) throws Exception {
		alarm.setAdminId(Common.getAdminId(session));
		if(Common.isEquals(Common.nvl(alarm.getAlarmFormSeq()),"")) {
			alarm.setAlarmFormSeq("0");
		}
		if(Common.isEquals(Common.nvl(alarm.getExcelMaxCnt()),"")) {
			alarm.setExcelMaxCnt("10000");
		}
		return new XcnResponseVO(XcnRspCode.OK, alarmService.updateAlarm(alarm));
	}
	
	@RequestMapping(value = "/deleteAlarm.xcn")
	@Description("예약 알람 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteAlarm(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		String[] alarmSeqs = Common.toArray(Common.nvl(param.get("alarmSeqs")), ",");
		
		List<AlarmVO> delAlarmVo = new ArrayList<>();
		List<AlarmLogVO> delAlarmLogVo = new ArrayList<>();
		for (String alarmSeq : alarmSeqs) {
			AlarmVO alarm = new AlarmVO();
			AlarmLogVO alarmLog = new AlarmLogVO();
			alarm.setAlarmSeq(alarmSeq);
			alarmLog.setAlarmSeq(alarmSeq);
			delAlarmVo.add(alarm);
			delAlarmLogVo.add(alarmLog);
		}
		if (alarmService.deleteAlarm(delAlarmVo) == 1 && alarmService.deleteAlarmLog(delAlarmLogVo) == 1) return new XcnResponseVO(XcnRspCode.OK);
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
	}

	
	@RequestMapping(value = "/getMailFormList.xcn")
	@Description("예약알람 메일 서식 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getMailFormList(final HttpServletRequest request) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, alarmService.getMailFormList(searchStr));
	}
	
	@RequestMapping(value = "/insertMailForm.xcn")
	@Description("알람 메일 서식 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertMailForm(final AlarmVO alarm) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, alarmService.insertMailForm(alarm));
	}
	
	@RequestMapping(value = "/updateMailForm.xcn")
	@Description("알람 메일 서식 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateMailForm(final AlarmVO alarm) throws Exception {
		return new XcnResponseVO(XcnRspCode.OK, alarmService.updateMailForm(alarm));
	}
	
	@RequestMapping(value = "/deleteMailForm.xcn")
	@Description("알람 메일 서식 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteMailForm(final HttpServletRequest request) throws Exception {
		JSONObject param = Common.getParam(request);
		String[] formSeqs = Common.toArray(Common.nvl(param.get("formSeqs")), ",");
		List<AlarmVO> delAlarmVo = new ArrayList<>();
		for (String formSeq : formSeqs) {
			AlarmVO alarm = new AlarmVO();
			alarm.setFormSeq(formSeq);
			delAlarmVo.add(alarm);
		}
		if (alarmService.deleteMailForm(delAlarmVo) == 1) return new XcnResponseVO(XcnRspCode.OK);
		else return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.error.delete", request));
	}
	
	@RequestMapping(value = "/getAlarmLog.xcn")
	@Description("예약알람 실행내역 조회")
	@ResponseBody
	public XcnResponseVO getAlarmLog(final HttpServletRequest request) throws Exception {
		String alarmSeq = Common.nvl(Common.getParam(request).get("alarmSeq"));
		return new XcnResponseVO(XcnRspCode.OK, alarmService.getAlarmLog(alarmSeq));
	}
	
	@RequestMapping(value = "/getAlarmLogQuery.xcn")
	@Description("예약알람 실행결과 쿼리 조회")
	@ResponseBody
	public XcnResponseVO getAlarmLogQuery(final HttpServletRequest request) throws Exception {
		String alarmLogSeq = Common.nvl(Common.getParam(request).get("alarmLogSeq"));
		return new XcnResponseVO(XcnRspCode.OK, alarmService.getAlarmLogQuery(alarmLogSeq));
	}
}
