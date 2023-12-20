package com.xcurenet.common.snmp.schedule;

import com.xcurenet.common.snmp.get.GetSnmp;
import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceVO;
import lombok.Data;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import java.util.concurrent.Callable;

@Data
@Log4j2
@Service("snmpThread")
@Scope("prototype")
public class SnmpThread implements Callable<DeviceVO> {

	public static final String CRITICAL = "X"; // 치명
	public static final String ERROR = "E"; // 에러
	public static final String WARN = "W"; // 경고
	public static final String NORMAL = "I"; // 관심
	public static final String SUCCESS = "S"; // 정상
	public static final String NOT_CONNECT = "C"; // 연결오류

	private DeviceVO device;

	@Autowired
	private ApplicationContext context;

	@Override
	public DeviceVO call() throws Exception {
		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		JSONObject obj = snmp.getDeviceStatus(device.getDeviceIp());
		obj.put("currentDeviceStatusDt", Common.getTime());
		obj.put("deviceType", device.getDeviceType());
		obj.put("deviceIP", device.getDeviceIp());
		obj.put("deviceName", device.getDeviceNm());

		log.debug("SNMP GET {}", obj);
		if (!obj.getBoolean("isConnection")) {
			device.setCurrentDeviceStatus(NOT_CONNECT);
		} else {
			JSONArray hdds = obj.getJSONArray("hdd");
			JSONArray process = obj.getJSONArray("process");
			JSONArray interfaces = obj.getJSONArray("interface");
			String hddStatus = getHddStatus(hdds);
			String procStatus = getProcessStatus(process, device.getDeviceType());
			String interStatus = getInterfaceStatus(interfaces);
			if (Common.isOrEquals(ERROR, hddStatus, procStatus, interStatus)) device.setCurrentDeviceStatus(ERROR);
			else if (Common.isOrEquals(WARN, hddStatus, procStatus, interStatus)) device.setCurrentDeviceStatus(WARN);
			else if (Common.isOrEquals(NORMAL, hddStatus, procStatus, interStatus)) device.setCurrentDeviceStatus(NORMAL);
			else device.setCurrentDeviceStatus(SUCCESS);
		}

		obj.put("currentDeviceStatus", device.getCurrentDeviceStatus());
		device.setCurrentDevice(obj);
		return device;
	}

	private String getHddStatus(JSONArray hdds) {
		boolean danger = false;
		boolean warn = false;
		boolean info = false;
		for (int i = 0; i < hdds.size(); i++) {
			JSONObject obj = hdds.getJSONObject(i);
			double hddAlarmLimit = Double.parseDouble(Common.nvl(obj.get("hddAlarmLimit"), "0"));
			double hddInfoUsage = Double.parseDouble(Common.nvl(obj.get("hddInfoUsage"), "0"));
			double hddWarnLimit = Double.parseDouble(Common.nvl(obj.get("hddWarnLimit"), "0"));
			double hddNotifyLimit = Double.parseDouble(Common.nvl(obj.get("hddNotifyLimit"), "0"));
			if (hddAlarmLimit > 0 && hddAlarmLimit <= hddInfoUsage) {
				danger = true;
				break;
			} else if (hddWarnLimit > 0 && hddWarnLimit <= hddInfoUsage) {
				warn = true;
			} else if (hddNotifyLimit > 0 && hddNotifyLimit <= hddInfoUsage) {
				info = true;
			}
		}
		if (hdds.isEmpty()) return WARN;
		else if (danger) return ERROR;
		else if (warn) return WARN;
		else if (info) return NORMAL;
		else return "";
	}

	private String getProcessStatus(JSONArray process, String deviceType) {
		if (process.isEmpty()) {
			if (deviceType.equals("H")) return "";
			else return WARN;
		}
		for (int i = 0; i < process.size(); i++) {
			JSONObject proc = process.getJSONObject(i);
			if (Common.isEquals(proc.get("procEmassStatus"), "1")) return WARN;
		}
		return "";
	}

	private String getInterfaceStatus(JSONArray interfaces) {
		if (interfaces.isEmpty()) return WARN;
		for (int i = 0; i < interfaces.size(); i++) {
			JSONObject proc = interfaces.getJSONObject(i);
			if (Common.isEquals(proc.get("netConfState"), "0")) return ERROR;
		}
		return "";
	}

}
