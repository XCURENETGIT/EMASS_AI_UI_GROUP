package com.xcurenet.login;

import com.xcurenet.common.util.config.Config;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.io.IOException;
import java.util.Properties;

@Configuration
public class EmailConfig {
	private static final String MAIL_DEBUG = "mail.debug";
	private static final String MAIL_SMTP_STARTTLS_REQUIRED = "mail.smtp.starttls.required";
	private static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
	private static final String MAIL_SMTP_STARTTLS_ENABLE = "mail.smtp.starttls.enable";

	public EmailConfig() throws IOException {
	}

	@Bean
	public JavaMailSender javaMailSender(){


		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		mailSender.setHost(Config.getString("mail.smtp.host"));
		mailSender.setProtocol("smtp");
		mailSender.setPort(Config.getInt("mail.smtp.port"));
		if (Config.getBoolean("mail.auth")) {
			mailSender.setUsername(Config.getString("mail.smtp.id"));
			mailSender.setPassword(Config.getString("mail.smtp.password"));
		}
		mailSender.setDefaultEncoding("UTF-8");
		Properties properties = mailSender.getJavaMailProperties();
		properties.put(MAIL_SMTP_STARTTLS_REQUIRED,  Config.getString("spring.mail.properties.mail.smtp.starttls.enable"));
		properties.put(MAIL_SMTP_STARTTLS_ENABLE, Config.getBoolean("mail.ssl"));
		properties.put(MAIL_SMTP_AUTH, Config.getBoolean("mail.auth"));
		properties.put(MAIL_DEBUG, true);
		mailSender.setJavaMailProperties(properties);
		return mailSender;

/*		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		Properties props = new Properties();

		mailSender.setHost(Config.getString("mail.smtp.host"));
		mailSender.setUsername(Config.getString("system.mail.addr"));
		if (Config.getBoolean("mail.auth")) {
			props.put("id",(Config.getBoolean("mail.smtp.id")));
			mailSender.setPassword(Config.getString("mail.smtp.password"));
		}
		mailSender.setPort(Config.getInt("mail.smtp.port"));
		mailSender.setDefaultEncoding("UTF-8");

		props.put("mail.smtp.starttls.enable",(Config.getBoolean("mail.ssl")));
		props.put("mail.smtp.starttls.enable", Config.getString("spring.mail.properties.mail.smtp.starttls.enable"));
		mailSender.setJavaMailProperties(props);*/

	/*	HtmlEmail email = new HtmlEmail();
		email.setCharset("UTF-8");
		email.setHostName(Config.getString("mail.smtp.host"));
		email.setSmtpPort(587);
		email.setStartTLSEnabled(Config.getBoolean("mail.ssl"));
		if(Config.getBoolean("mail.ssl")) {


			email.setSslSmtpPort(Config.getString("mail.smtp.port"));
		}
		if (Config.getBoolean("mail.auth")) {
			email.setAuthentication(Config.getString("mail.smtp.id"), Config.getString("mail.smtp.password"));
		}
		email.setSSLCheckServerIdentity(Config.getBoolean("mail.ssl"));
		email.setSocketTimeout(120000);
		email.setSocketConnectionTimeout(120000);
		email.setDebug(Config.getBoolean("mail.debug"));*/

	}
}