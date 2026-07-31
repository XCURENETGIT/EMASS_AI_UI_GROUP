package com.xcurenet.admin.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Slf4j
@Component
public class AdminMfaScheduler {

    @Resource(name = "adminService")
    public AdminService adminService;

    @Scheduled(cron="0 0 * * * ?")
    public void clearAdminMfa() throws Exception {
        adminService.clearAdminMfa();
    }
}
