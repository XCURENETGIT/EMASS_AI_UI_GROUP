package com.xcurenet.common.util.locale;

import java.text.MessageFormat;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
import org.springframework.stereotype.Component;

import com.xcurenet.common.util.Common;

@Component
public class Prop implements MessageSourceAware {

	private static MessageSource msg;

	@Override
	public void setMessageSource(MessageSource msg) {
		Prop.msg = msg;
	}

	public static String prop(String key) {
		return Prop.msg(key);
	}

	public static String prop(String key, Locale locale) {
		return Prop.msg(key, locale);
	}

	public static String propFormat(String key, Object... objects) {
		return MessageFormat.format(Prop.msg(key), objects);
	}

	public static String propFormat(String key, Locale locale, Object... objects) {
		return MessageFormat.format(Prop.msg(key, locale), objects);
	}

	public static String propFormat(String key, HttpServletRequest request, Object... objects) {
		return propFormat(key, request.getSession(), objects);
	}

	public static String propFormat(String key, HttpSession session, Object... objects) {
		return propFormat(key, Common.getLocale(session), objects);
	}

	public static String msg(String key) {
		return msg.getMessage(key, null, Locale.getDefault());
	}

	public static String msg(String key, Locale locale) {
		return msg.getMessage(key, null, locale);
	}

	public static void main(String[] args) {

	}
}