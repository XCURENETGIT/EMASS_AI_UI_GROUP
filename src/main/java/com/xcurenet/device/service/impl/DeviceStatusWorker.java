package com.xcurenet.device.service.impl;

import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceVO;
import lombok.Data;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.Callable;

@Data
@Log4j2
@Service
@Scope("prototype")
public class DeviceStatusWorker implements Callable<DeviceVO> {

	public static final String CRITICAL = "X"; // 치명
	public static final String ERROR = "E"; // 에러
	public static final String WARN = "W"; // 경고
	public static final String NORMAL = "I"; // 관심
	public static final String SUCCESS = "S"; // 정상
	public static final String NOT_CONNECT = "C"; // 연결오류

	private int port = 22;

	private DeviceVO device;

	@Override
	public DeviceVO call() throws Exception {
		log.info("[STATUS] device : {}", device.getDeviceIp());
		JSONObject item = device.getCurrentDevice();
		if (item == null) device.setCurrentDevice(new JSONObject());

		SFTPUtil sftp = new SFTPUtil();
		try {
			sftp.init(device.getDeviceIp(), device.getSshId(), device.getSshPw(), port);

			loadAvg(sftp);
			memory(sftp);
			dateTime(sftp);
			disk(sftp);
			netWork(sftp);

			log.debug("info : {} {}", device.getDeviceIp(), device.getCurrentDevice());
		} finally {
			sftp.disconnection();
		}
		return device;
	}


	/**
	 * GET CentOS load average
	 *
	 * @param sftp SSH Util
	 */
	private void loadAvg(SFTPUtil sftp) {
		String load = sftp.getCommand("cat /proc/loadavg");
		if (load.isEmpty()) device.getCurrentDevice().put("load", "");
		else device.getCurrentDevice().put("load", String.join(", ", Common.toList(load, " ").subList(0, 3)));
	}

	/**
	 * GET CentOS Memory Usage
	 *
	 * @param sftp SSH Util
	 */
	private void memory(SFTPUtil sftp) {
		String mem = sftp.getCommand("free -w | grep Mem");
		if (mem.isEmpty()) {
			device.getCurrentDevice().put("total", "0");
			device.getCurrentDevice().put("used", "0");
			device.getCurrentDevice().put("free", "0");
			device.getCurrentDevice().put("available", "0");
			device.getCurrentDevice().put("usedRate", "0");
		} else {
			List<String> infos = Common.toList(mem, " ");
			int total = Common.nvz(infos.get(1), 0);
			int available = Common.nvz(infos.get(7), 0);
			device.getCurrentDevice().put("total", Common.convertSnmpSize(total));
			device.getCurrentDevice().put("used", Common.convertSnmpSize(infos.get(2)));
			device.getCurrentDevice().put("free", Common.convertSnmpSize(infos.get(3)));
			device.getCurrentDevice().put("shared", Common.convertSnmpSize(infos.get(4)));
			device.getCurrentDevice().put("buffers", Common.convertSnmpSize(infos.get(5)));
			device.getCurrentDevice().put("cache", Common.convertSnmpSize(infos.get(6)));
			device.getCurrentDevice().put("available", Common.convertSnmpSize((available)));
			device.getCurrentDevice().put("usedRate", Common.calculatePercentage(total, available));
			device.getCurrentDevice().put("used_a", Common.convertSnmpSize(total - available));
		}
	}

	/**
	 * GET CentOS date time
	 *
	 * @param sftp SSH Util
	 */
	private void dateTime(SFTPUtil sftp) {
		device.getCurrentDevice().put("date", sftp.getCommand("date +\"%F %T\""));
	}

	/**
	 * GET CentOS Disk
	 *
	 * @param sftp SSH Util
	 */
	private void disk(SFTPUtil sftp) {
		String hdd = sftp.getCommand("df -h | grep -e /$ -e /users -e /var$ -e /data -e /index");
		List<String> infos = Common.toList(hdd, "\n");
		JSONArray items = new JSONArray();
		for (String h : infos) {
			List<String> partition = Common.toList(h, " ");
			JSONObject item = new JSONObject();
			item.put("total", partition.get(1));
			item.put("used", partition.get(2));
			item.put("avail", partition.get(3));
			item.put("use", partition.get(4));
			item.put("mount", partition.get(5));
			items.add(item);
		}
		device.getCurrentDevice().put("disk", items);
	}


	/**
	 * GET CentOS netWork
	 *
	 * @param sftp SSH Util
	 */
	private void netWork(SFTPUtil sftp) {
		String result = sftp.getCommand("ifconfig -a");
		List<String> infos = Common.toList(result, "\n");
		JSONArray items = new JSONArray();
		JSONObject item = new JSONObject();
		boolean filter = false;
		for (String h : infos) {
			List<String> cols = Common.toList(h, " ");
			if (h.startsWith("e")) {
				filter = true;
				if (item.get("name") != null) {
					items.add(item);
					item = new JSONObject();
				}
				item.put("name", cols.get(0).replace(":", ""));
				item.put("status", cols.get(1).contains("UP") ? "UP" : "DOWN");
				item.put("mtu", cols.get(3));
			} else if (!h.startsWith(" ")) {
				filter = false;
			}

			if (filter) {
				if (cols.get(2).contains("netmask")) {
					item.put("ip", cols.get(1));
					item.put("netmask", cols.get(3));
					item.put("broadcast", cols.get(5));
				} else if (cols.get(0).contains("ether")) {
					item.put("mac", cols.get(1));
				} else if (cols.get(0).contains("RX") && cols.get(1).contains("packets")) {
					item.put("rx_packets", cols.get(2));
					item.put("rx_bytes", Common.convertSnmpSize(cols.get(4)));
				} else if (cols.get(0).contains("RX") && cols.get(1).contains("errors")) {
					item.put("rx_errors", cols.get(2));
					item.put("rx_dropped", cols.get(4));
					item.put("rx_overruns", cols.get(6));
				} else if (cols.get(0).contains("TX") && cols.get(1).contains("packets")) {
					item.put("tx_packets", cols.get(2));
					item.put("tx_bytes", Common.convertSnmpSize(cols.get(4)));
				} else if (cols.get(0).contains("TX") && cols.get(1).contains("errors")) {
					item.put("tx_errors", cols.get(2));
					item.put("tx_dropped", cols.get(4));
					item.put("tx_overruns", cols.get(6));
				}
			}
		}
		items.add(item);
		device.getCurrentDevice().put("network", items);
	}
}
