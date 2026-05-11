package com.xcurenet.login;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.config.service.ConfigService;
import com.xcurenet.config.service.ConfigVO;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

@Service
@RequiredArgsConstructor
public class MailService {

	private final JavaMailSender javaMailSender;
	@Resource(name = "configService")
	public ConfigService configService;

	private static final String senderEmail= Config.getString("system.mail.addr");
	private static int number;

	public static void createNumber(){
		number = (int)(Math.random() * (90000)) + 100000;// (int) Math.random() * (최댓값-최소값+1) + 최소값
	}

	public MimeMessage CreateMail(String mail){
		createNumber();
		MimeMessage message = javaMailSender.createMimeMessage();

		try {
			message.setFrom(senderEmail);
			message.setRecipients(MimeMessage.RecipientType.TO, mail);
			message.setSubject("[EMASS AI] "+ Prop.propFormat("setup.long.term.unusedTitle"));
			String body = "";
			body += "<h3>" + Prop.propFormat("setup.long.term.unusedTitle") + "</h3>";
			body += "<div style='border-radius: 0.125rem; background-color: #f7f7f9; padding: 40px'";
			body+= "<p style=\"margin: 0; text-align: center; font-size: 18px; color: #758592;\">"+ Prop.propFormat("setup.long.term.code")+"</p>";
			body += "<h1>" + number + "</h1>";
			body += "</div>";
			body += "<div>" +Prop.propFormat("setup.long.term.unusedBody")+ "</div>";

			message.setText(body,"UTF-8", "html");
		} catch (MessagingException e) {
			e.printStackTrace();
		}

		return message;
	}

	public int sendMail(String mail){
		if (!Config.getBoolean("mail.forward.flag"))
			return -1;

		String hostConfig = Config.getString("mail.smtp.host");
		String portConfig = Config.getString("mail.smtp.port");
		String usernameConfig = Config.getString("mail.smtp.id");
		String passwordConfig = Config.getString("mail.smtp.password");
		boolean mailSSl = Config.getBoolean("mail.ssl");
		boolean mailAuth = Config.getBoolean("mail.auth");

		// JavaMailSender의 설정을 변경
		JavaMailSenderImpl mailSender = (JavaMailSenderImpl) javaMailSender;
		mailSender.setHost(hostConfig);
		mailSender.setPort(Integer.parseInt(portConfig));

		Properties props = mailSender.getJavaMailProperties();
		if (mailSSl) {
			mailSender.setProtocol("smtps");
			props.put("mail.smtps.auth", "true");
			props.put("mail.smtps.ssl.enable", "true");
			props.put("mail.smtps.ssl.trust", hostConfig);
			props.put("mail.smtps.starttls.enable", "true");
		} else {
			props.put("mail.smtp.auth", String.valueOf(mailAuth));
			props.put("mail.smtp.starttls.enable", String.valueOf(mailSSl));
		}

		if (mailAuth) {
			mailSender.setUsername(usernameConfig);
			mailSender.setPassword(passwordConfig);
		}

		// 메일 보내기
		MimeMessage message = CreateMail(mail);
		mailSender.send(message);



		return number;
	}
}
