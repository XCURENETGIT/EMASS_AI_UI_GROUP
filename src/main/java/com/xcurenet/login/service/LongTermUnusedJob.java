package com.xcurenet.login.service;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.stereotype.Component;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.common.util.SpringContextUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LongTermUnusedJob implements Job {

	@Override
	public void execute(JobExecutionContext jobexecutioncontext) throws JobExecutionException {
		log.info("운용자 장기 미접속자 상태 체크 START..");
		AdminService adminService = SpringContextUtil.getBean(AdminService.class);
		adminService.updateAdminStatus();
		log.info("운용자 장기 미접속자 상태 체크 END..");
	}
}
