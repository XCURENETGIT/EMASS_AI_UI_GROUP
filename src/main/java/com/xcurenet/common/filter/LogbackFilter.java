package com.xcurenet.common.filter;

import java.util.Map;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.filter.Filter;
import ch.qos.logback.core.spi.FilterReply;

public class LogbackFilter extends Filter<ILoggingEvent> {

	@Override
	public FilterReply decide(ILoggingEvent event) {
		Map<String, String> mdc = event.getMDCPropertyMap();
		return FilterReply.ACCEPT;
	}
}
