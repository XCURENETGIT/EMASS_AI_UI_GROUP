package com.xcurenet.common.snmp.web;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Description;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.snmp.get.GetSnmp;
import com.xcurenet.common.snmp.schedule.SnmpPolling;
import com.xcurenet.common.snmp.schedule.SnmpThread;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;

@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.DEV_INFO)
@Scope("prototype")
public class SnmpController {

	@Autowired
	private ApplicationContext context;

	@Autowired
	private SnmpPolling snmpPolling;

	@Resource(name = "deviceService")
	public DeviceService deviceService;

	@RequestMapping(value = "/device/getDeviceStatus.xcn")
	@Description("Device 정보 조회- SNMP")
	@ResponseBody
	public XcnResponseVO getDeviceStatus(final HttpServletRequest request, final HttpSession session) throws Exception {
		String deviceIp = Common.nvl(request.getParameter("deviceIp"));
		List<DeviceVO> devices = snmpPolling.getDevices();
		for (int i = 0; i < devices.size(); i++) {
			if (Common.isEquals(deviceIp, devices.get(i).getDeviceIp())) {
				return new XcnResponseVO(XcnRspCode.OK, devices.get(i).getCurrentDevice());
			}
		}
		return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "not found device");
	}

	@RequestMapping(value = "/device/getDeviceStatusByDeviceSeq.xcn")
	@Description("Device 정보 조회- SNMP")
	@ResponseBody
	public XcnResponseVO getDeviceStatusByDeviceSeq(final HttpServletRequest request, final HttpSession session) throws Exception {
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));
		List<DeviceVO> devices = snmpPolling.getDevices();
		for (int i = 0; i < devices.size(); i++) {
			if (Common.isEquals(deviceSeq, devices.get(i).getDeviceSeq())) {
				return new XcnResponseVO(XcnRspCode.OK, devices.get(i).getCurrentDevice());
			}
		}
		return new XcnResponseVO(XcnRspCode.OK_CUSTOM, "not found device");
	}

	@RequestMapping(value = "/device/setProcessRestart.xcn")
	@Description("Device Process 재시작 - SNMP")
	@ResponseBody
	public XcnResponseVO setProcessRestart(final HttpServletRequest request, final HttpSession session) throws Exception {
		String ip = Common.nvl(request.getParameter("deviceIp"));
		int index = Common.nvz(request.getParameter("index"));
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));

		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		boolean rs = snmp.setProcessRestart(ip, index);

		DeviceVO device = deviceService.getDeviceInfo(deviceSeq);
		getDeviceStatus(device);

		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/device/setProcessStop.xcn")
	@Description("Device Process 종료 - SNMP")
	@ResponseBody
	public XcnResponseVO setProcessStop(final HttpServletRequest request, final HttpSession session) throws Exception {
		String ip = Common.nvl(request.getParameter("deviceIp"));
		int index = Common.nvz(request.getParameter("index"));
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));

		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		boolean rs = snmp.setProcessStop(ip, index);

		DeviceVO device = deviceService.getDeviceInfo(deviceSeq);
		getDeviceStatus(device);

		return new XcnResponseVO(XcnRspCode.OK, rs);
	}

	@RequestMapping(value = "/device/setHddAlarm.xcn")
	@Description("Device HDD Alarm 설정 - SNMP")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO setHddAlarm(final HttpServletRequest request, final HttpSession session) throws Exception {
		String ip = Common.nvl(request.getParameter("deviceIp"));
		int index = Common.nvz(request.getParameter("index"));
		int hddNotifyLimit = Common.nvz(request.getParameter("hddNotifyLimit")); //관심
		int hddWarnLimit = Common.nvz(request.getParameter("hddWarnLimit"));     //주의
		int hddAlarmLimit = Common.nvz(request.getParameter("hddAlarmLimit"));   //위험
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));

		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		boolean rs = snmp.setHddAlarm(ip, index, hddNotifyLimit, hddWarnLimit, hddAlarmLimit);

		DeviceVO device = deviceService.getDeviceInfo(deviceSeq);
		getDeviceStatus(device);

		return new XcnResponseVO(XcnRspCode.OK, rs);
	}
	
	@RequestMapping(value = "/device/setCpuAlarm.xcn")
	@Description("Device CPU Alarm 설정 - SNMP")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO setCpuAlarm(final HttpServletRequest request, final HttpSession session) throws Exception {
		String ip = Common.nvl(request.getParameter("deviceIp"));
		int index = Common.nvz(request.getParameter("index"));
		int cpuLoadLimit = Common.nvz(request.getParameter("cpuLoadLimit"));     //주의
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));

		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		boolean rs = snmp.setCpuAlarm(ip, index, cpuLoadLimit);

		DeviceVO device = deviceService.getDeviceInfo(deviceSeq);
		getDeviceStatus(device);

		return new XcnResponseVO(XcnRspCode.OK, rs);
	}
	
	@RequestMapping(value = "/device/setMemoryAlarm.xcn")
	@Description("Device Memory Alarm 설정 - SNMP")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO setMemoryAlarm(final HttpServletRequest request, final HttpSession session) throws Exception {
		String ip = Common.nvl(request.getParameter("deviceIp"));
		int index = Common.nvz(request.getParameter("index"));
		int memInfoLimit = Common.nvz(request.getParameter("memInfoLimit"));     //주의
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));

		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		boolean rs = snmp.setMemoryAlarm(ip, index, memInfoLimit);

		DeviceVO device = deviceService.getDeviceInfo(deviceSeq);
		getDeviceStatus(device);

		return new XcnResponseVO(XcnRspCode.OK, rs);
	}
	
	@RequestMapping(value = "/device/setHddAlarmCC.xcn")
	@Description("Device HDD Alarm 설정 CC버전용 - SNMP")
	@ResponseBody
	public XcnResponseVO setHddAlarmCC(final HttpServletRequest request, final HttpSession session) throws Exception {
		String ip = Common.nvl(request.getParameter("deviceIp"));
		int hddNotifyLimit = Common.nvz(request.getParameter("hddNotifyLimit")); //관심
		int hddWarnLimit = Common.nvz(request.getParameter("hddWarnLimit"));     //주의
		int hddAlarmLimit = Common.nvz(request.getParameter("hddAlarmLimit"));   //위험

		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		boolean rs = snmp.setHddAlarmCC(ip, hddNotifyLimit, hddWarnLimit, hddAlarmLimit);

		return new XcnResponseVO(XcnRspCode.OK, rs);
		
		
	}

	private void getDeviceStatus(DeviceVO device) {
		ExecutorService es = Executors.newFixedThreadPool(1);
		try {
			SnmpThread st = this.context.getBean(SnmpThread.class);
			st.setDevice(device);
			List<SnmpThread> deviceStatusTask = new ArrayList<>();
			deviceStatusTask.add(st);

			List<Future<DeviceVO>> futures = es.invokeAll(deviceStatusTask, 4, TimeUnit.SECONDS);
			snmpPolling.statusChange(futures, deviceStatusTask);
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		} finally {
			es.shutdownNow();
		}
	}
}
