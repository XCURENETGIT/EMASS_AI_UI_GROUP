package com.xcurenet.common.listener;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextClosedEvent;
import org.springframework.stereotype.Service;

import com.xcurenet.emass.message.service.DownloadBatchService;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class TomcatDestroy implements ApplicationListener<ContextClosedEvent>{
	
	@Autowired
	public DownloadBatchService downloadBatchService;
	
	@Override
	public void onApplicationEvent(ContextClosedEvent event) {
		log.info("Download Batch Status Update....");
		downloadBatchService.shutdownDownloadBatch("H");
		downloadBatchService.shutdownDownloadBatchMessenger("H");
	}
}
