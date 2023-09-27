package com.xcurenet.common.util.locale;

import java.text.MessageFormat;
import java.util.Locale;

import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

public class CustomReloadableResourceBundleMessageSource extends ReloadableResourceBundleMessageSource {

	@Override
	protected MessageFormat resolveCode(String code, Locale locale) {
		return super.resolveCode(code, locale);
	}

	@Override
	protected String resolveCodeWithoutArguments(String code, Locale locale) {
		if(Common.isEquals(Config.getString("info.feedback.mode"), "E")) {
			if(Common.isOrEquals(code, "condition.info.class1", "condition.info.class2", "condition.info.class3", "condition.info.class4", "condition.info.feedback1", "condition.info.feedback2", "condition.info.feedback3", "condition.info.feedback4")) {
				code += "E";
			}
		}
		return super.resolveCodeWithoutArguments(code, locale);
	}
}
