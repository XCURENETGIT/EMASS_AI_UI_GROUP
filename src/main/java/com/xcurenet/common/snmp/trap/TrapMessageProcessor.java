package com.xcurenet.common.snmp.trap;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.common.auditMail.AuditMailSender;
import com.xcurenet.common.sms.SmsSender;
import com.xcurenet.common.sms.SmsType;
import com.xcurenet.common.sms.SmsVO;
import com.xcurenet.common.snmp.service.SnmpTrapService;
import com.xcurenet.common.snmp.service.SnmpTrapVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Log4j2
@Controller
public class TrapMessageProcessor {

	@Autowired
	private SimpMessagingTemplate template;

	@Autowired
	private SmsSender smsSender;

	@Autowired
	private AuditMailSender auditMailSender;

	@Resource(name = "snmpTrapService")
	private SnmpTrapService snmpTrapService;

	@Resource(name = "deviceService")
	private DeviceService deviceService;

	@Resource(name = "adminService")
	public AdminService adminService;


	public void insertTrapMessage(JSONObject param, JSONObject trap_data) throws Exception {
		SnmpTrapVO trap = new SnmpTrapVO();
		try {
			DeviceVO device = deviceService.getDeviceByIp(Common.nvl(param.get("deviceIp")));
			String deviceName = "";
			if (device != null) {
				deviceName = device.getDeviceNm();
			} else {
				log.warn("[SNMP TRAP] can not find the equipment : {}", param);
			}
			if (Common.isEmpty(deviceName)) deviceName = Common.nvl(param.get("deviceIp"));
			else deviceName += " " + Common.nvl(param.get("deviceIp"));

			trap.setDeviceIp(Common.nvl(param.get("deviceIp")));
			trap.setMasterIp(Common.nvl(param.get("masterIp")));
			if(Common.isEquals(Common.nvl(param.get("devision")),"CLR")) return;
			trap.setDevision(Common.nvl(param.get("devision")));
			trap.setEventLevel(Common.nvl(param.get("eventLevel")));
			trap.setTitle("[" + deviceName + "] " + Common.nvl(param.get("title")));
			trap.setContent(Common.nvl(param.get("content")));
			snmpTrapService.insertSnmpTrap(trap);

			if (device != null) {
				if (Common.isOrEquals(trap.getDevision(), TrapMessageParser.TRAP_MESSAGE_CLR, TrapMessageParser.TRAP_MESSAGE_HDD)) { // 감사증적메일
					auditMailSender.send(trap, trap_data, device);
				}

				String smsType = getSmsType(trap.getDevision(), trap.getEventLevel());
				SmsVO sms = new SmsVO();
				sms.setContent("[" + deviceName + "] " + trap.getContent());
				sms.setSmsType(smsType);

				List<Map<String, Object>> admins = new ArrayList<>();
				if (Common.isEquals(smsType, SmsType.DISK_THRESHOLD)) {
					admins = adminService.getAdminHpByConfId("device.hdd.sms." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.PROCESS_SHUTDOWN, SmsType.PROCESS_STARTUP)) {
					admins = adminService.getAdminHpByConfId("device.process.sms." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.COLLECTION_STATUS_PROBLEM)) {
					admins = adminService.getAdminHpByConfId("device.interface.sms." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.MEMORY_THRESHOLD)) {
					admins = adminService.getAdminNotifyByConfId("device.mem.sms." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.CPU_THRESHOLD)) {
					admins = adminService.getAdminNotifyByConfId("device.cpu.sms." + device.getDeviceSeq());
				}

				for (Map<String, Object> admin : admins) {
					sms.setReceiver(Common.nvl(admin.get("ADMIN_HP")));
					smsSender.sendSms(sms);
				}

				if (Common.isEquals(smsType, SmsType.DISK_THRESHOLD)) {
					admins = adminService.getAdminNotifyByConfId("device.hdd.notify." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.PROCESS_SHUTDOWN, SmsType.PROCESS_STARTUP)) {
					admins = adminService.getAdminNotifyByConfId("device.process.notify." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.COLLECTION_STATUS_PROBLEM)) {
					admins = adminService.getAdminNotifyByConfId("device.interface.notify." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.MEMORY_THRESHOLD)) {
					admins = adminService.getAdminNotifyByConfId("device.mem.notify." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.CPU_THRESHOLD)) {
					admins = adminService.getAdminNotifyByConfId("device.cpu.notify." + device.getDeviceSeq());
				}

				for (int i = 0; i < admins.size(); i++) {
					template.convertAndSendToUser(Common.nvl(admins.get(i).get("ADMIN_ID")), "/trap", trap);
				}

				if (Common.isEquals(smsType, SmsType.DISK_THRESHOLD)) {
					admins = adminService.getAdminEmailByConfId("device.hdd.email." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.PROCESS_SHUTDOWN, SmsType.PROCESS_STARTUP)) {
					admins = adminService.getAdminEmailByConfId("device.process.email." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.COLLECTION_STATUS_PROBLEM)) {
					admins = adminService.getAdminEmailByConfId("device.interface.email." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.MEMORY_THRESHOLD)) {
					admins = adminService.getAdminEmailByConfId("device.mem.email." + device.getDeviceSeq());
				} else if (Common.isOrEquals(smsType, SmsType.CPU_THRESHOLD)) {
					admins = adminService.getAdminEmailByConfId("device.cpu.email." + device.getDeviceSeq());
				}

				for (Map<String, Object> admin : admins) {
					auditMailSender.saveSnmpMail(trap,Common.nvl(admin.get("ADMIN_EMAIL")));
				}

			}
		} catch (Exception e) {
			log.error("", e);
		}

		log.info("[SNMP TRAP] Insert Event Table Finish...");
	}

	private String getSmsType(String trapMessage, String level) {
		if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_HDD)) {
			return SmsType.DISK_THRESHOLD;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_SVC)) {
			if (Common.isEquals(level, "E")) return SmsType.PROCESS_SHUTDOWN;
			else return SmsType.PROCESS_STARTUP;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_PROC)) {
			if (Common.isEquals(level, "E")) return SmsType.PROCESS_SHUTDOWN;
			else return SmsType.PROCESS_STARTUP;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_LINK)) {
			return SmsType.COLLECTION_STATUS_PROBLEM;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_SNMP)) {
			if (Common.isEquals(level, "E")) return SmsType.PROCESS_SHUTDOWN;
			else return SmsType.PROCESS_STARTUP;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_TRA)) {
			return SmsType.COLLECTION_STATUS_PROBLEM;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_MEM)) {
			return SmsType.MEMORY_THRESHOLD;
		} else if (Common.isEquals(trapMessage, TrapMessageParser.TRAP_MESSAGE_CPU)) {
			return SmsType.CPU_THRESHOLD;
		} else {
			return SmsType.UKNOW;
		}
	}
}