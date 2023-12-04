package com.xcurenet.common.snmp.schedule;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Description;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceTrafficStatService;
import com.xcurenet.device.service.DeviceTrafficStatVO;
import com.xcurenet.device.service.DeviceVO;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Data
@Service("snmpPolling")
public class SnmpPolling {

	private List<DeviceVO> devices;

	private List<SnmpThread> deviceStatusTask;

	private List<SnmpStat> trafficStatTask;

	@Resource(name = "deviceService")
	private DeviceService deviceService;

	@Resource(name = "deviceTrafficStatService")
	private DeviceTrafficStatService deviceTrafficStatService;

	@Autowired
	private ApplicationContext context;

	@PostConstruct
	public void init() {
		log.info("[장비정보] LOAD START..");
		devices = deviceService.getDeviceList(null, 0, 0);
		log.info("[장비정보] LOAD END..");
	}

	public void reload() {
		init();
	}

	public String getDeviceStatus(String deviceSeq) {
		if (devices == null || devices.size() == 0) return Common.EMPTY;
		for (DeviceVO device : devices) {
			if (Common.isEquals(device.getDeviceSeq(), deviceSeq)) {
				return device.getCurrentDeviceStatus();
			}
		}
		return Common.EMPTY;
	}

	@Scheduled(fixedDelay = 300000, initialDelay = 10000)
	@Description("장비 정보 Reload")
	public void deviceReload() throws Exception {
		log.info("장비 정보 Reload");
		init();
	}

	@Scheduled(fixedRate = 600000, initialDelay = 10000) // 10분
	@Description("iifTrafficTable 통계 스케쥴러")
	public void trafficStat() throws Exception {
		log.info("iifTrafficTable 통계 스케쥴러 START");
		if (devices == null || devices.size() == 0) return;
		ExecutorService es = Executors.newFixedThreadPool(devices.size());
		try {
			List<SnmpStat> tasks = trafficStatTask();
			List<Future<List<DeviceTrafficStatVO>>> futures = es.invokeAll(tasks, 5, TimeUnit.SECONDS);

			for (int i = 0; i < futures.size(); i++) {
				final Future<List<DeviceTrafficStatVO>> future = futures.get(i);
				try {
					if (!future.isCancelled()) {
						List<DeviceTrafficStatVO> traffics = future.get();
						for (DeviceTrafficStatVO traffic : traffics) {
							deviceTrafficStatService.updateDeviceTraffic(traffic);
						}
					}

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			log.error("trafficStat error : {}", e);
		} finally {
			es.shutdownNow();
		}
		log.info("iifTrafficTable 통계 스케쥴러 END");
	}

	@Scheduled(fixedDelay = 4000, initialDelay = 10000)
	@Description("장비 상태 모니터링 스케쥴러")
	public void deviceStatus() throws Exception {
		log.info("장비 상태 모니터링 스케쥴러 START device.size : {}", devices.size());
		if (devices == null || devices.size() == 0) return;
		ExecutorService es = Executors.newFixedThreadPool(devices.size());
		try {
			List<SnmpThread> tasks = deviceStatusTask();
			List<Future<DeviceVO>> future = es.invokeAll(tasks, 4, TimeUnit.SECONDS);
/*			statusChange(future, tasks);*/
		} catch (Exception e) {
			log.error("deviceStatus check error : {}", e);
		} finally {
			es.shutdownNow();
		}
	}

	public void statusChange(List<Future<DeviceVO>> futures, List<SnmpThread> tasks) throws InterruptedException, ExecutionException {
		try {
			for (int i = 0; i < futures.size(); i++) {
				final Future<DeviceVO> future = futures.get(i);
				try {
					DeviceVO device = null;
					if (future.isCancelled()) {
						device = tasks.get(i).getDevice();
					} else {
						device = future.get();
					}
					for (int j = 0; j < devices.size(); j++) {
						if (Common.isEquals(devices.get(j).getDeviceIp(), device.getDeviceIp())) {
							log.debug("모니터링 : {}", device);
							devices.set(j, device);
							break;
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private List<SnmpThread> deviceStatusTask() {
		deviceStatusTask = new ArrayList<>();
		for (DeviceVO device : devices) {
			SnmpThread st = this.context.getBean(SnmpThread.class);
			st.setDevice(device);
			deviceStatusTask.add(st);
		}
		return deviceStatusTask;
	}

	private List<SnmpStat> trafficStatTask() {
		trafficStatTask = new ArrayList<>();
		for (DeviceVO device : devices) {
			SnmpStat st = this.context.getBean(SnmpStat.class);
			st.setDevice(device);
			trafficStatTask.add(st);
		}
		return trafficStatTask;
	}
}
