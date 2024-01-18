package com.xcurenet.common.snmp.schedule;

import com.xcurenet.common.util.Common;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceTrafficStatService;
import com.xcurenet.device.service.DeviceTrafficStatVO;
import com.xcurenet.device.service.DeviceVO;
import lombok.Data;
import lombok.extern.log4j.Log4j2;
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
import java.util.concurrent.*;

@Log4j2
@Data
@Service
public class SnmpPolling {

	protected final List<DeviceVO> devices = Collections.synchronizedList(new ArrayList<>());

	private List<SnmpThread> deviceStatusTask;

	private List<SnmpStat> trafficStatTask;

	@Resource(name = "deviceService")
	private DeviceService deviceService;

	@Resource(name = "deviceTrafficStatService")
	private DeviceTrafficStatService deviceTrafficStatService;

	@Autowired
	private ApplicationContext context;

	public List<DeviceVO> getDevices() {
		synchronized (devices) {
			return devices;
		}
	}

	@PostConstruct
	public void init() {
		log.info("[장비정보] LOAD START..");
		synchronized (devices) {
			devices.clear();
			devices.addAll(deviceService.getDeviceList(null, null, 0, 0));
		}
		log.info("[장비정보] LOAD END..");
	}

	public void reload() {
		init();
	}

	public String getDeviceStatus(String deviceSeq) {
		if (devices.isEmpty()) return Common.EMPTY;
		for (DeviceVO device : devices) {
			if (Common.isEquals(device.getDeviceSeq(), deviceSeq)) {
				return device.getCurrentDeviceStatus();
			}
		}
		return Common.EMPTY;
	}

	@Scheduled(fixedDelay = 300000, initialDelay = 10000)
	@Description("장비 정보 Reload")
	public void deviceReload() {
		log.info("장비 정보 Reload");
		init();
	}

	@Scheduled(fixedRate = 600000, initialDelay = 10000) // 10분
	@Description("iifTrafficTable 통계 스케쥴러")
	public void trafficStat() {
		log.info("iifTrafficTable 통계 스케쥴러 START");
		if (devices.isEmpty()) return;
		ExecutorService es = Executors.newFixedThreadPool(devices.size());
		try {
			List<SnmpStat> tasks = trafficStatTask();
			List<Future<List<DeviceTrafficStatVO>>> futures = es.invokeAll(tasks, 10, TimeUnit.SECONDS);
			for (final Future<List<DeviceTrafficStatVO>> future : futures) {
				try {
					if (!future.isCancelled()) {
						List<DeviceTrafficStatVO> traffics = future.get();
						if(traffics == null) continue;
						for (DeviceTrafficStatVO traffic : traffics) {
							deviceTrafficStatService.updateDeviceTraffic(traffic);
						}
					}
				} catch (Exception e) {
					log.error("", e);
				}
			}
		} catch (Exception e) {
			log.error("", e);
		} finally {
			es.shutdownNow();
		}
		log.info("iifTrafficTable 통계 스케쥴러 END");
	}

	@Scheduled(fixedDelay = 4000, initialDelay = 10000)
	@Description("장비 상태 모니터링 스케쥴러")
	public void deviceStatus() throws Exception {
		log.info("장비 상태 모니터링 스케쥴러 START device.size : {}", devices.size());
		if (devices.isEmpty()) return;
		ExecutorService es = Executors.newFixedThreadPool(devices.size());
		try {
			List<SnmpThread> tasks = deviceStatusTask();
			List<Future<DeviceVO>> future = es.invokeAll(tasks, 4, TimeUnit.SECONDS);
			statusChange(future, tasks);
		} catch (Exception e) {
			log.error("", e);
		} finally {
			es.shutdownNow();
		}
		for (DeviceVO device : devices) {
			log.debug("DeviceVO {}", device);
		}
	}

	public void statusChange(List<Future<DeviceVO>> futures, List<SnmpThread> tasks) throws InterruptedException, ExecutionException {
		synchronized (devices) {
			try {
				for (int i = 0; i < futures.size(); i++) {
					final Future<DeviceVO> future = futures.get(i);
					try {
						DeviceVO device = future.isCancelled() ? tasks.get(i).getDevice() : future.get();
						for (int j = 0; j < devices.size(); j++) {
							if (Common.isEquals(devices.get(j).getDeviceIp(), device.getDeviceIp())) {
								log.debug("모니터링 : {}", device);
								devices.set(j, device);
								break;
							}
						}
					} catch (Exception e) {
						log.error("", e);
					}
				}
			} catch (Exception e) {
				log.error("", e);
			}
		}
	}

	private List<SnmpThread> deviceStatusTask() {
		deviceStatusTask = new ArrayList<>();
		synchronized (devices) {
			for (DeviceVO device : devices) {
				SnmpThread st = this.context.getBean(SnmpThread.class);
				st.setDevice(device);
				deviceStatusTask.add(st);
			}
		}
		return deviceStatusTask;
	}

	private List<SnmpStat> trafficStatTask() {
		trafficStatTask = new ArrayList<>();
		synchronized (devices) {
			for (DeviceVO device : devices) {
				SnmpStat st = this.context.getBean(SnmpStat.class);
				st.setDevice(device);
				trafficStatTask.add(st);
			}
		}
		return trafficStatTask;
	}
}
