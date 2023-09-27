package com.xcurenet.emass.message.component;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.emass.message.service.DownloadBatchService;
import com.xcurenet.emass.message.service.DownloadBatchVO;

import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class DownloadMonitor{

	@Value("#{'download.monitor.fixedRate'}")
	private String delay;

	public void checkDownload() {
		log.info("[Download Batch Down] Download Batch State Update Start...");
		long t = TimeUnit.MILLISECONDS.toHours(Long.valueOf(delay));
		log.info(String.valueOf(t));
		TimeUtil.start();
		DownloadBatchService batchService = SpringContextUtil.getBean(DownloadBatchService.class);
		List<DownloadBatchVO> batchList = batchService.getDownloadBatchIngList(String.valueOf(t));

		for(DownloadBatchVO batch : batchList) {
			batchService.cancelUnkown("M", batch.getDownSeq());
		}
		log.info("[Download Batch Down] Download Batch State Update End... {}", TimeUtil.print());
	}
}
