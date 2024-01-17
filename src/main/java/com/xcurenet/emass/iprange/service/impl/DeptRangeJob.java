package com.xcurenet.emass.iprange.service.impl;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.stereotype.Component;

import com.xcurenet.common.csv.CsvReader;
import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.makeInfo.service.MakeInfoService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SpringContextUtil;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.iprange.service.IpRangeDeptService;
import com.xcurenet.user.service.InsaFileMerge;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Component
public class DeptRangeJob implements Job {

	@Override
	public void execute(JobExecutionContext jobexecutioncontext) throws JobExecutionException {
		TimeUtil.start();
		try {
			String auto = Config.getString("dept.auto");
			String path = Config.getString("dept.path");
			String delimiter = Config.getString("dept.sepa");

			log.info("[DEPT AUTO IMPORT] dept db auto import start....");
			log.info("[DEPT AUTO IMPORT] init config auto:{} path:{} delimiter:{}", auto, path, delimiter);

			if (Common.isNotEquals(auto, "Y")) return;
			if (Common.isEmpty(path)) return;
			if (Common.isEmpty(delimiter)) return;

			InsaFileMerge fileMerge = new InsaFileMerge();
			File insaFile = fileMerge.getInsaFile(path);
			if (!insaFile.exists()) {
				log.warn("[DEPT AUTO IMPORT] FILE NOT FOUND..PATH : {}" + insaFile);
				return;
			}

			JSONArray insas = readerDept(insaFile.getAbsolutePath(), delimiter);
			
			IpRangeDeptService ipRangeDept = SpringContextUtil.getBean(IpRangeDeptService.class);
			JSONObject result = ipRangeDept.importIpRangeDept(insas, null);
			
			if (result.getBoolean("success")) {
				String backup = insaFile.getParent() + File.separator + "backup" + File.separator;
				Common.mkdirs(backup);
				File dst = new File(backup + insaFile.getName());
				try {
					FileUtils.moveFile(insaFile, dst);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				fileMerge.backupFile(path);

				log.info("[DEPT AUTO IMPORT] dept db auto import success");

				log.info("[MAKE INFO] update make info user data start");
				MakeInfoService makeInfo = SpringContextUtil.getBean(MakeInfoService.class);
				makeInfo.addInfoIpRangeDept();
				log.info("[MAKE INFO] update make info user data end");
			} else {
				log.warn("[DEPT AUTO IMPORT] dept db auto import fail");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			log.info("[DEPT AUTO IMPORT] dept db auto import duration {}", TimeUtil.print());
		}
	}
	
	public JSONArray readerDept(final String path, final String delimiter) throws Exception {
		CsvReader reader = new CsvReader(path, DetectCharset.getCharset(path), delimiter.charAt(0));
		return reader.getList();
	}
	
}
