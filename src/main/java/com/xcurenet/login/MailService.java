package com.xcurenet.login;

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
/*		System.out.println(((JavaMailSenderImpl) javaMailSender).getHost()+"호스트");
		System.out.println(((JavaMailSenderImpl) javaMailSender).getPort()+"포트");
		System.out.println(((JavaMailSenderImpl) javaMailSender).getUsername()+"이름");
		System.out.println(((JavaMailSenderImpl) javaMailSender).getPassword()+"비밀번호 ");*/

		if (!Config.getBoolean("mail.forward.flag"))
			return -1;

		ConfigVO hostConfig = configService.getConf("mail.smtp.host");
		ConfigVO portConfig = configService.getConf("mail.smtp.port");
		ConfigVO usernameConfig = configService.getConf("mail.smtp.id");
		ConfigVO passwordConfig = configService.getConf("mail.smtp.password");

		// JavaMailSender의 설정을 변경
		JavaMailSenderImpl mailSender = (JavaMailSenderImpl) javaMailSender;
		mailSender.setHost(hostConfig.getVal());
		mailSender.setPort(Integer.parseInt(portConfig.getVal()));
		mailSender.setUsername(usernameConfig.getVal());
		mailSender.setPassword(passwordConfig.getVal());

		// 메일 보내기
		MimeMessage message = CreateMail(mail);
		mailSender.send(message);



		return number;
	}
}
