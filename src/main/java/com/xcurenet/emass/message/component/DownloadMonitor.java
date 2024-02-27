package com.xcurenet.emass.message.component;

import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.emass.message.service.DownloadBatchService;
import com.xcurenet.emass.message.service.DownloadBatchVO;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Log4j2
@Component
public class DownloadMonitor {

	@Value("${download.monitor.fixedRate}")
	private String delay;

	@Scheduled(fixedRateString = "${download.monitor.fixedRate}")
	public void checkDownload() {
		/* 배치 다운로드가 중지된 내역을 찾는다. */
		log.info("[Download Batch Down] Download Batch State Update Start...");
		long t = TimeUnit.MILLISECONDS.toHours(Long.valueOf(delay));
		log.info("Time : " + t) ;
		TimeUtil.start();
		DownloadBatchService batchService = SpringContextUtil.getBean(DownloadBatchService.class);
		List<DownloadBatchVO> batchList = batchService.getDownloadBatchIngList(String.valueOf(t));

		for (DownloadBatchVO batch : batchList) {
			batchService.cancelUnkown("M", batch.getDownSeq());
		}
		log.info("[Download Batch Down] Download Batch State Update End... {}", TimeUtil.print());
	}
}
