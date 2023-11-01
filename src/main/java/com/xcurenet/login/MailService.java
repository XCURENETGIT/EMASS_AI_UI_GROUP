package com.xcurenet.login;

import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.mail.MailSend;
import com.xcurenet.common.util.config.Config;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

@Service
@RequiredArgsConstructor
public class MailService {

	private final JavaMailSender javaMailSender;


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
			message.setSubject("[LTH PRO] 운용자 계정 잠금해제 이메일 인증");
			String body = "";
			body += "<h3>" + "운용자 계정 잠금해제 이메일 인증" + "</h3>";
			body += "<div style='border-radius: 0.125rem; background-color: #f7f7f9; padding: 40px'";
			body+= "<p style=\"margin: 0; text-align: center; font-size: 18px; color: #758592;\">인증 코드</p>";
			body += "<h1>" + number + "</h1>";
			body += "</div>";
			body += "<div>" + "안녕하세요, LTHPRO 입니다!\n" +
					"인증 코드를 입력하여 이메일 주소를 인증해 주세요. " +
					"인증 코드를 입력하는 데 문제가 있거나, 다른 문제가 발생하면 관리자에게 연락주시기 바랍니다." + "</div>";

			message.setText(body,"UTF-8", "html");
		} catch (MessagingException e) {
			e.printStackTrace();
		}

		return message;
	}

	public int sendMail(String mail){

		if (!Config.getBoolean("mail.forward.flag"))
			return -1;

		MimeMessage message = CreateMail(mail);
		javaMailSender.send(message);

		return number;
	}
}
