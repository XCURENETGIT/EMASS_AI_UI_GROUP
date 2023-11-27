package com.xcurenet.common.ntp;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Locale;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

/**
 * CentOS8 부터는 ntp 서비스는 지원하지 않으며 Chrony라는 유틸리티를 권장한다.
 * 따라서 각 서버의 Time 체크는 Chrony 서비스를 기준으로 작성한다.
 */
@Log4j2
@Controller
public class NtpScheduler {

	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate;

	private final Locale locale = Locale.forLanguageTag(Locale.getDefault().getLanguage());

	private static final String NTP_COMMAND = "chronyc sources";

	public static JSONObject ntpStatus = new JSONObject();

	@Scheduled(fixedDelay = 5000)
	public void checkNtp() {
		JSONObject socketMsg = getNtpStatus();
		simpMessagingTemplate.convertAndSend("/topic/ntpCheck", socketMsg);
	}

	public JSONObject getNtpStatus() {
		JSONObject result = new JSONObject();
		String resultServer = "";
		boolean synchronizedNTP = false;
		boolean dataStart = false;
		log.info("[NTP Check]");

		try {
			String message = Common.commandRunner(NTP_COMMAND);
			if (Common.isNotEmpty(message)) {
				String[] lines = Common.toArray(message, "\n");
				for (String line : lines) {
					if (line.startsWith("=")) {
						dataStart = true;
					} else if (dataStart) {
						String[] tokens = line.trim().split("\\s+");
						if (tokens.length >= 10) {
							if (tokens[0].startsWith("^*") || Common.isEquals(tokens[4], "377")) synchronizedNTP = true;
							if (tokens[0].startsWith("^*")) resultServer = tokens[1];
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("", e);
		}

		result.put("ntpServer", resultServer);
		result.put("title", "NTP");

		if (!dataStart) {
			result.put("ntpServer", Prop.propFormat("trap.message.ntp.server.nosearch", locale));
			result.put("status", "unconnect");
			result.put("content", "[ " + Prop.propFormat("trap.message.ntp", locale) + "] " + Prop.propFormat("trap.message.ntp.unconnect", locale));
		} else if (!synchronizedNTP || Common.isEmpty(resultServer)) {
			result.put("status", "unsync");
			result.put("content", "[ " + Prop.propFormat("trap.message.ntp", locale) + "] " + Prop.propFormat("trap.message.ntp.unsync", locale));
		} else {
			result.put("status", "sync");
		}

		log.info(result.toString());
		ntpStatus = result;
		return ntpStatus;
	}

	public static JSONObject getNtpInfo() {
		return ntpStatus;
	}
}
