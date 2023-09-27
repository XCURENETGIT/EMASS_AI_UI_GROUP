package com.xcurenet.login.service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class LockRelease extends Thread {

	@Resource(name = "adminService")
	public AdminService adminService;

	private AdminVO admin;

	@PostConstruct
	public void init() {
		log.info("update all user password fail count clear..");
		adminService.updateAllUserPasswordWrongCount();
	}

	@Override
	public void run() {
		try {
			log.info("update {} user password fail count clear time wait", admin.getAdminId());
			int restore = Config.getInt("password.restore.minute") * 60000;
			Thread.sleep(restore);
			admin.setAccessFailCnt(0);
			adminService.updateUserPasswordWrongCount(admin);
			log.info("update {} user password fail count clear success..", admin.getAdminId());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public AdminService getAdminService() {
		return adminService;
	}

	public void setAdminService(AdminService adminService) {
		this.adminService = adminService;
	}

	public AdminVO getAdmin() {
		return admin;
	}

	public void setAdmin(AdminVO admin) {
		this.admin = admin;
	}

}
