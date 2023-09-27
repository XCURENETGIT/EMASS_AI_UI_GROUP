package com.xcurenet.common.snmp.schedule;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.xcurenet.common.snmp.get.GetSnmp;
import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceTrafficStatVO;
import com.xcurenet.device.service.DeviceVO;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Data
@Slf4j
@Service("snmpStat")
@Scope("prototype")
public class SnmpStat implements Callable<List<DeviceTrafficStatVO>> {

	private DeviceVO device;

	@Autowired
	private ApplicationContext context;

	@Override
	public List<DeviceTrafficStatVO> call() throws Exception {
		//if (!Common.isEquals(device.getDeviceType(), "C")) return null;

		List<DeviceTrafficStatVO> traffics = new ArrayList<>();
		GetSnmp snmp = this.context.getBean(GetSnmp.class);
		JSONArray tables = snmp.getIifTrafficTable(device.getDeviceIp());
		for (int i = 0; i < tables.size(); i++) {
			JSONObject obj = tables.getJSONObject(i);
			DeviceTrafficStatVO vo = new DeviceTrafficStatVO();
			vo.setDeviceSeq(device.getDeviceSeq());
			vo.setPort(Common.nvl(obj.get("iifTrafficPort")));
			vo.setDirection(Common.nvz(obj.get("iifTrafficDirection")));
			vo.setHourCnt(Common.nvz(obj.get("iifTraffic10MinCnt")));
			vo.setHourSize(Common.nvz(obj.get("iifTraffic10MinSize")));
			vo.setUpdateDt(Common.getCurrentFullHour());

			log.info("GET Device IIF Traffic Static : {} {} ", device.getDeviceNm(), vo);
			traffics.add(vo);
		}
		return traffics;
	}
}
