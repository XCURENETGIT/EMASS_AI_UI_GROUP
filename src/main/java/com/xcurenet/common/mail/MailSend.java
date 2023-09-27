package com.xcurenet.common.mail;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.HtmlEmail;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MailSend implements Runnable {

	private MailInfo mailInfo;

	public MailSend(MailInfo mi) {
		this.mailInfo = mi;
	}

	public void send() throws Exception {
		try {
			log.info("[mail send] host:{}, port:{}, subject:{}", Config.getString("mail.smtp.host"), Config.getInt("mail.smtp.port"), mailInfo.getSubject());
			HtmlEmail email = new HtmlEmail();
			email.setCharset("UTF-8");
			email.setHostName(Config.getString("mail.smtp.host"));
			email.setSmtpPort(Config.getInt("mail.smtp.port"));
			email.setStartTLSEnabled(Config.getBoolean("mail.ssl"));
			if(Config.getBoolean("mail.ssl")) {
				email.setSSLOnConnect(true);
				email.setSslSmtpPort(Config.getString("mail.smtp.port"));
			}
			if (Config.getBoolean("mail.auth")) {
				email.setAuthentication(Config.getString("mail.smtp.id"), Config.getString("mail.smtp.password"));
			}
			email.setSSLCheckServerIdentity(Config.getBoolean("mail.ssl"));
			email.setSocketTimeout(120000);
			email.setSocketConnectionTimeout(120000);
			email.setDebug(Config.getBoolean("mail.debug"));

			email.setFrom(mailInfo.getFrom());
			if (Common.isNotEmpty(mailInfo.getTo()) && mailInfo.getTo().length > 0) {
				email.addTo(mailInfo.getTo());
			}
			if (Common.isNotEmpty(mailInfo.getCc()) && mailInfo.getCc().length > 0) {
				email.addCc(mailInfo.getCc());
			}
			if (Common.isNotEmpty(mailInfo.getBcc()) && mailInfo.getBcc().length > 0) {
				email.addBcc(mailInfo.getBcc());
			}
			email.setSubject(Common.nvl(Config.getString("mail.subject.prefix")) + " " + Common.nvl(mailInfo.getSubject()));
			email.setHtmlMsg(Common.nvl(mailInfo.getBody()));

			if (mailInfo.getAttachPath() != null) {
				for (String attach : mailInfo.getAttachPath()) {
					File ata = new File(attach);
					EmailAttachment attachment = new EmailAttachment();
					attachment.setPath(ata.getAbsolutePath());
					attachment.setDisposition(EmailAttachment.ATTACHMENT);
					attachment.setDescription(ata.getName());
					attachment.setName(ata.getName());
					email.attach(attachment);
				}
			}
			email.setSentDate(new Date());

			Map<String, String> map = new HashMap<>();
			map.put("X-PROPHET_ADMIN-FORWARD", "EMASSLTHUI");
			map.put("X-EMASS_ADMIN-FORWARD", "EMASSLTHUI");
			email.setHeaders(map);

			String sendResult = email.send();
			log.info("mail send : {}\nsendResult:{}", mailInfo.getSubject(), sendResult);

			moveFile();

		} catch (Exception e) {
			PrintWriter _pw = null;
			try {
				_pw = new PrintWriter(new File(mailInfo.getErrorPath()));
				e.printStackTrace(_pw);
			} catch (Exception e1) {
				e1.printStackTrace();
			} finally {
				IOUtils.closeQuietly(_pw);
			}
			e.printStackTrace();
			moveFailFile();
		}
	}

	@Override
	public void run() {
		try {
			send();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void moveFailFile() throws IOException {
		if (Common.isNotEquals(mailInfo.getOrgInfoPath(), mailInfo.getInfoPath())) {
			File org = new File(mailInfo.getOrgInfoPath());
			File info = new File(mailInfo.getInfoPath());
			info.renameTo(org);
			mailInfo.setInfoPath(org.getAbsolutePath());
		}

		File _info = new File(mailInfo.getInfoPath());
		File _body = new File(mailInfo.getBodyPath());
		File _error = new File(mailInfo.getErrorPath());
		Common.mkdirs(_info.getParent() + MailScanner.FAIL_MOVE_DIR);

		FileUtils.deleteQuietly(new File(_info.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _info.getName()));
		FileUtils.deleteQuietly(new File(_body.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _body.getName()));
		FileUtils.deleteQuietly(new File(_error.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _error.getName()));

		FileUtils.moveFile(_info, new File(_info.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _info.getName()));
		FileUtils.moveFile(_body, new File(_body.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _body.getName()));
		FileUtils.moveFile(_error, new File(_error.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _error.getName()));
		for (int i = 0; i < mailInfo.getAttachPath().length; i++) {
			File _attach = new File(mailInfo.getAttachPath()[i]);
			FileUtils.deleteQuietly(new File(_attach.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _attach.getName()));
			FileUtils.moveFile(_attach, new File(_attach.getParent() + MailScanner.FAIL_MOVE_DIR + File.separator + _attach.getName()));
		}
	}

	private void moveFile() throws IOException {
		if (Common.isNotEquals(mailInfo.getOrgInfoPath(), mailInfo.getInfoPath())) {
			File org = new File(mailInfo.getOrgInfoPath());
			File info = new File(mailInfo.getInfoPath());
			info.renameTo(org);
			mailInfo.setInfoPath(org.getAbsolutePath());
		}

		File _info = new File(mailInfo.getInfoPath());
		File _body = new File(mailInfo.getBodyPath());
		Common.mkdirs(_info.getParent() + MailScanner.SUCCESS_MOVE_DIR);

		FileUtils.deleteQuietly(new File(_info.getParent() + MailScanner.SUCCESS_MOVE_DIR + File.separator + _info.getName()));
		FileUtils.deleteQuietly(new File(_body.getParent() + MailScanner.SUCCESS_MOVE_DIR + File.separator + _body.getName()));

		FileUtils.moveFile(_info, new File(_info.getParent() + MailScanner.SUCCESS_MOVE_DIR + File.separator + _info.getName()));
		FileUtils.moveFile(_body, new File(_body.getParent() + MailScanner.SUCCESS_MOVE_DIR + File.separator + _body.getName()));

		if (mailInfo.getAttachPath() != null) {
			for (int i = 0; i < mailInfo.getAttachPath().length; i++) {
				File _attach = new File(mailInfo.getAttachPath()[i]);
				FileUtils.deleteQuietly(new File(_attach.getParent() + MailScanner.SUCCESS_MOVE_DIR + File.separator + _attach.getName()));
				FileUtils.moveFile(_attach, new File(_attach.getParent() + MailScanner.SUCCESS_MOVE_DIR + File.separator + _attach.getName()));
			}
		}
	}
}
