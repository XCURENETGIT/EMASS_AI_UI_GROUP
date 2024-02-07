package com.xcurenet.device.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.snmp.schedule.SnmpPolling;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;
import com.xcurenet.device.service.impl.DeviceScheduler;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Handles requests for the application home page.
 */
@Log4j2
@Controller
@AuditParentMenu(ParentMenu.OPERATION_MGMT)
@AuditMenu(Menu.DEV_INFO)
public class DeviceController {

	@Resource(name = "deviceService")
	public DeviceService deviceService;

	@Resource(name = "deviceScheduler")
	public DeviceScheduler deviceScheduler;

	@Resource(name = "makeInfoService")
	private MakeInfoService makeInfoService;

	@Resource(name = "configAdminService")
	public ConfigAdminService configAdminService;

	@Resource(name = "snmpPolling")
	public SnmpPolling snmpPolling;


	@RequestMapping(value = "/getDeviceList.xcn")
	@Description("장비 리스트 조회")
	@ResponseBody
	public XcnResponseVO getDeviceList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		int offset = Common.nvz(request.getParameter("offset"));
		String deviceType = Common.nvl(request.getParameter("deviceType"));
		int limit = Common.nvz(request.getParameter("limit"));

		Map<String, Object> result = new HashMap<>();
		List<DeviceVO> devices = deviceService.getDeviceList(searchStr,deviceType,offset, limit);
		for (int i = 0; i < devices.size(); i++) {
			DeviceVO device = devices.get(i);
			device.setDeviceStatus(snmpPolling.getDeviceStatus(device.getDeviceSeq()));
			devices.set(i, device);
		}
		result.put("currentTime", Common.getCurrentTime("HH시 mm분 ss초"));
		//result.put("currentTime", Common.getCurrentTime("HH"+Prop.propFormat("common.msg.hour", request)+" mm"+Prop.propFormat("common.msg.min", request)+" ss"+Prop.propFormat("common.msg.sec", request)));

		result.put("devices", devices);
		return new XcnResponseVO(XcnRspCode.OK, result);
	}



	@RequestMapping(value = "/getDeviceListDetail.xcn")
	@Description("장비 리스트 상세 조회")
	@ResponseBody
	public XcnResponseVO getDeviceListInDetail(final HttpServletRequest request) {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		String deviceType = Common.nvl(request.getParameter("deviceType"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, deviceService.getDeviceList(searchStr, deviceType, offset, limit));
	}

	@RequestMapping(value = "/getCollectionDevice.xcn")
	@Description("수집 장비 리스트 조회")
	@ResponseBody
	public XcnResponseVO getCollectionDevice(final HttpServletRequest request) {
		String searchStr = Common.nvl(request.getParameter("searchStr"));
		return new XcnResponseVO(XcnRspCode.OK, deviceService.getCollectionDevice(searchStr));
	}

	@RequestMapping(value = "/getDeviceInfo.xcn")
	@Description("특정 장비 조회")
	@ResponseBody
	public XcnResponseVO getDeviceInfo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String deviceSeq = Common.nvl(request.getParameter("deviceSeq"));
		String adminId = Common.getAdminId(session);

		DeviceVO device = deviceService.getDeviceInfo(deviceSeq);
		if (device != null) {
			ConfigAdminVO hddSms = configAdminService.getConfAdmin("device.hdd.sms." + deviceSeq, adminId);
			ConfigAdminVO hddNotify = configAdminService.getConfAdmin("device.hdd.notify." + deviceSeq, adminId);
			ConfigAdminVO processSms = configAdminService.getConfAdmin("device.process.sms." + deviceSeq, adminId);
			ConfigAdminVO processNofity = configAdminService.getConfAdmin("device.process.notify." + deviceSeq, adminId);
			ConfigAdminVO interfaceSms = configAdminService.getConfAdmin("device.interface.sms." + deviceSeq, adminId);
			ConfigAdminVO interfaceNofity = configAdminService.getConfAdmin("device.interface.notify." + deviceSeq, adminId);

			device.setHddSmsUseYn("N");
			device.setHddNotifyUseYn("N");
			device.setProcessSmsUseYn("N");
			device.setProcessNotifyUseYn("N");
			device.setInterfaceSmsUseYn("N");
			device.setInterfaceNotifyUseYn("N");

			if (hddSms != null) device.setHddSmsUseYn(Common.nvl(hddSms.getVal(), "N"));
			if (hddNotify != null) device.setHddNotifyUseYn(Common.nvl(hddNotify.getVal(), "N"));
			if (processSms != null) device.setProcessSmsUseYn(Common.nvl(processSms.getVal(), "N"));
			if (processNofity != null) device.setProcessNotifyUseYn(Common.nvl(processNofity.getVal(), "N"));
			if (interfaceSms != null) device.setInterfaceSmsUseYn(Common.nvl(interfaceSms.getVal(), "N"));
			if (interfaceNofity != null) device.setInterfaceNotifyUseYn(Common.nvl(interfaceNofity.getVal(), "N"));
		}

		return new XcnResponseVO(XcnRspCode.OK, device);
	}

	@RequestMapping(value = "/updateDevice.xcn")
	@Description("장비 수정")
	@AuditOperation(Operation.UPDATE)
	@ResponseBody
	public XcnResponseVO updateDevice(final HttpServletRequest request, DeviceVO device) {

		if (deviceService.isDeviceIpExist(device)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, device.getDeviceIp()));
		}
		deviceService.updateDevice(device);
		deviceScheduler.reload();
		makeInfoService.addInfoDevice();
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/insertDevice.xcn")
	@Description("장비 등록")
	@AuditOperation(Operation.INSERT)
	@ResponseBody
	public XcnResponseVO insertDevice(final HttpServletRequest request, DeviceVO device) throws Exception {

		if (device.getComment() == null) {
			device.setComment("");
		}
		if (deviceService.isDeviceIpExist(device)) {
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.ip", request, device.getDeviceIp()));
		}
		deviceService.insertDevice(device);
		deviceScheduler.reload();
		makeInfoService.addInfoDevice();
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/deleteDevice.xcn")
	@Description("장비 삭제")
	@AuditOperation(Operation.DELETE)
	@ResponseBody
	public XcnResponseVO deleteDevice(DeviceVO device) {
		String[] devices = Common.toArray(device.getDeviceSeq(), ",");
		for (String d : devices) {
			device.setDeviceSeq(d);
			deviceService.deleteDevice(device);
		}
		deviceScheduler.reload();
		makeInfoService.addInfoDevice();
		return new XcnResponseVO(XcnRspCode.OK);
	}
}
