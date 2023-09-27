package com.xcurenet.common.mail;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MailScanner {

	public final static int BEFORE_DAYS = 7;
	public final static String DEFAULT_SCAN_DIR = "/users/emasslth/alarm_mail/";
	public final static String SUCCESS_MOVE_DIR = "/SUCCESS";
	public final static String FAIL_MOVE_DIR = "/FAIL";
	public final static String INFO_PREFIX = ".info";
	public final static int MAX_MAIL_FOUND = 50;

	@Scheduled(fixedDelay = 60000)
	public void sendMail() throws Exception {
		log.debug("[MailScanner] Scanning Alarm DIR...{}", DEFAULT_SCAN_DIR);
		if (!Config.getBoolean("mail.forward.flag")) return;
		List<MailInfo> mails = scanner();
		ExecutorService service = Executors.newFixedThreadPool(MAX_MAIL_FOUND);
		try {
			for (MailInfo mail : mails) {
				service.execute(new MailSend(mail));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			service.shutdownNow();
		}
	}

	public List<MailInfo> scanner() {
		List<MailInfo> infos = new ArrayList<MailInfo>();
		for (int i = 0; i < BEFORE_DAYS; i++) {
			String date = Common.getBeforeDay(i);
			File file = new File(DEFAULT_SCAN_DIR + date);
			if (file.isDirectory()) {
				String[] list = file.list(new FilenameFilter() {
					@Override
					public boolean accept(File dir, String name) {
						return name.endsWith(INFO_PREFIX);
					}
				});

				try {
					for (int j = 0; j < list.length; j++) {
						if (MAX_MAIL_FOUND <= j) break;
						File org = new File(file.getAbsolutePath() + File.separator + list[j]);
						String orgPath = org.getAbsolutePath();
						File tmp = new File(file.getAbsolutePath() + File.separator + list[j] + ".tmp");
						org.renameTo(tmp);
						infos.add(new MailInfo(tmp.getAbsolutePath(), orgPath));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		if (infos.size() > 0) {
			log.info("Mail Scanner Find End {}", infos.size());
		}
		return infos;
	}

}
