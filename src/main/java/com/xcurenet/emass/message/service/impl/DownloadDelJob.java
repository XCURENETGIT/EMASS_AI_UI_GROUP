package com.xcurenet.emass.message.service.impl;

import java.io.File;
import java.util.List;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.stereotype.Component;

import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.emass.message.service.DownloadBatchService;
import com.xcurenet.emass.message.service.DownloadBatchVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class DownloadDelJob implements Job {

	
	@Override
	public void execute(JobExecutionContext jobexecutioncontext) throws JobExecutionException {
		TimeUtil.start();
		try {
			
			DownloadBatchService downloadService = SpringContextUtil.getBean(DownloadBatchService.class);
			
			List<DownloadBatchVO> expireList = downloadService.getExportFileExpireData();
			
			for(DownloadBatchVO expire : expireList) {
				File expireFile = new File(expire.getDownFilePath());
				
				if(expireFile.exists()) {
					if(!expireFile.delete()) {
						log.warn("DownloadDelJob file delete fail: {}", expireFile.getAbsolutePath());
					}
				}
				
				expire.setStatusStr("X");
				downloadService.updateDownloadBatch(expire);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			log.info("[EXPORT FILE EXPIRE] Export File Expire and Delete {}", TimeUtil.print());
		}
	}

	}
