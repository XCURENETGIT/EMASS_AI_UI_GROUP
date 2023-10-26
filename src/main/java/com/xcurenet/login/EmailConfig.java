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
@PropertySource("classpath:/application.properties")
public class EmailConfig {


	public EmailConfig() throws IOException {
	}

	@Value("${spring.mail.transport.protocol}")
	private String protocol;

	@Value("${spring.mail.properties.mail.smtp.auth}")
	private boolean auth;

	@Value("${spring.mail.properties.mail.smtp.starttls.enable}")
	private boolean starttls;

	@Value("${spring.mail.debug}")
	private boolean debug;

	@Value("${spring.mail.host}")
	private String host;

	@Value("${spring.mail.port}")
	private int port;

	@Value("${spring.mail.username}")
	private String username;

	@Value("${spring.mail.password}")
	private String password;

	@Value("${spring.mail.default.encoding}")
	private String encoding;


	@Bean
	public HtmlEmail javaMailSender(){
/*		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		Properties properties = new Properties();
		properties.put("mail.transport.protocol", protocol);
		properties.put("mail.smtp.auth", auth);
		properties.put("mail.smtp.starttls.enable", starttls);
		properties.put("mail.smtp.debug", debug);

		mailSender.setHost(host);
		mailSender.setUsername(username);
		mailSender.setPassword(password);
		mailSender.setPort(port);
		mailSender.setDefaultEncoding(encoding);
		mailSender.setJavaMailProperties(properties);*/

		HtmlEmail email = new HtmlEmail();
		email.setCharset("UTF-8");
		email.setHostName(Config.getString("mail.smtp.host"));
		email.setSmtpPort(587);
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

		return email;
	}
}