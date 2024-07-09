package com.xcurenet.common.util.locale;

import java.text.MessageFormat;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.xcurenet.common.util.config.Config;
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

	public static String msg(String key) {return msg.getMessage(keyChange(key), null, Locale.getDefault());}

	public static String msg(String key, Locale locale) {return msg.getMessage(keyChange(key), null, locale);}

	private static String keyChange(final String key) {
		String str = key;
		if(Common.isEquals(Config.getString("info.feedback.mode"), "E")) {
			if(Common.isOrEquals(str, "condition.info.class1", "condition.info.class2", "condition.info.class3", "condition.info.class4", "condition.info.feedback1", "condition.info.feedback2", "condition.info.feedback3", "condition.info.feedback4")) {
				str += "E";
			}
		}
		return str;
	}

	public static void main(String[] args) {

	}
}