package com.xcurenet.device.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;
import lombok.Data;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Description;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

@Log4j2
@Data
@Service
public class DeviceScheduler {

	private static final List<DeviceVO> devices = Collections.synchronizedList(new ArrayList<>());

	@Resource(name = "deviceService")
	private DeviceService deviceService;

	@Autowired
	private ApplicationContext context;

	@PostConstruct
	public void init() {
		synchronized (devices) {
			devices.clear();
			devices.addAll(deviceService.getDeviceList(null, null, 0, 0));
			deviceStatus();
			log.info("[DEVICE] SIZE : {}", devices.size());
		}
	}

	public void reload() {
		init();
	}

	@Scheduled(fixedDelay = 300000, initialDelay = 2000)
	@Description("장비 정보 Reload")
	public void deviceReload() {
		init();
	}

	@Scheduled(fixedDelay = 10000, initialDelay = 10000)
	@Description("장비 상태 모니터링 스케쥴러")
	public void deviceStatus() {
		synchronized (devices) {
			if (devices.isEmpty()) return;
			ExecutorService es = Executors.newFixedThreadPool(devices.size());
			try {
				List<DeviceStatusWorker> tasks = deviceStatusTask();
				List<Future<DeviceVO>> future = es.invokeAll(tasks, 8, TimeUnit.SECONDS);
				statusChange(future, tasks);
			} catch (Exception e) {
				log.error("deviceStatus check error : ", e);
			} finally {
				es.shutdownNow();
			}
		}
	}

	private List<DeviceStatusWorker> deviceStatusTask() {
		List<DeviceStatusWorker> deviceStatusTask = new ArrayList<>();
		synchronized (devices) {
			for (DeviceVO device : devices) {
				DeviceStatusWorker st = this.context.getBean(DeviceStatusWorker.class);
				st.setDevice(device);
				deviceStatusTask.add(st);
			}
		}
		return deviceStatusTask;
	}

	public void statusChange(List<Future<DeviceVO>> futures, List<DeviceStatusWorker> tasks) {
		try {
			synchronized (devices) {
				for (int i = 0; i < futures.size(); i++) {
					final Future<DeviceVO> future = futures.get(i);
					try {
						DeviceVO device;
						if (future.isCancelled()) device = tasks.get(i).getDevice();
						else device = future.get();

						for (int j = 0; j < devices.size(); j++) {
							if (Common.isEquals(devices.get(j).getDeviceIp(), device.getDeviceIp())) {
								devices.set(j, device);
								break;
							}
						}
					} catch (Exception e) {
						log.error("", e);
					}
				}
			}
		} catch (Exception e) {
			log.error("", e);
		}
	}


	public JSONObject getDeviceStatus(String deviceSeq) {
		synchronized (devices) {
			if (devices.isEmpty()) return new JSONObject();
			for (DeviceVO device : devices) {
				if (Common.isEquals(device.getDeviceSeq(), deviceSeq)) {
					return device.getCurrentDevice();
				}
			}
		}
		return new JSONObject();
	}
}
