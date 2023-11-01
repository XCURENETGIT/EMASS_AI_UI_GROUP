package com.xcurenet.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.xcurenet.common.util.Common;
import com.xcurenet.interceptor.AuthorityInterceptor;
import com.xcurenet.interceptor.LoggerInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Autowired
	private AuthorityInterceptor authorityInterceptor;

	@Autowired
	private LoggerInterceptor loggerInterceptor;

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(authorityInterceptor).addPathPatterns("/**").excludePathPatterns("/statusUpdate","/updateStatus.xcn","/login.do", "/loginSSO.do", "/loginAuth.do", "/error.do", "/blank.do", "/loginSSOProcess.do"
			,"/deleteSession.xcn","/logoutSSOProcess.do", "/getUacsRule.xcn", "/loginProcess.xcn", "/getRSAKey.xcn","/confirmNumber",
				"/updateAdminPassword.xcn", "/secretKeySave.xcn","/reloadGoogleOTP.xcn","/mailSend.xcn","/sendmail","/makeInfo", "/getRSAKey.xcn", "/loginProcess.xcn", "/admin/updateAdminPassword.vns", "/passwordChange", "/process/**", "/css/**", "/img/**", "/js/**", "/lib/**", "/favicon.ico");
		registry.addInterceptor(loggerInterceptor).addPathPatterns("/**").excludePathPatterns("/css/**", "/img/**", "/js/**", "/lib/**", "/favicon.ico", "/error");
		registry.addInterceptor(localeChangeInterceptor());
	}

	@Bean
	public ReloadableResourceBundleMessageSource messageSource() {
		ReloadableResourceBundleMessageSource source = new ReloadableResourceBundleMessageSource();
		source.setBasename("classpath:/com/message/message");
		source.setDefaultEncoding(Common.UTF8);
		// Properties file reload period
		source.setCacheSeconds(60);
		// when not found message, code is default message
		source.setUseCodeAsDefaultMessage(true);

		return source;
	}

	@Bean
	public SessionLocaleResolver localeResolver() {
		return new SessionLocaleResolver();
	}

	@Bean
	public LocaleChangeInterceptor localeChangeInterceptor() {
		LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
		interceptor.setParamName("lang");
		return interceptor;
	}

}
