package com.xcurenet.common.sms;

import java.net.URLEncoder;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.stereotype.Service;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.extern.slf4j.Slf4j;

@Service("smsSender")
@Slf4j
public class SmsSender {

	public boolean sendSms(final SmsVO sms) {
		boolean smsEnable = Config.getBoolean("sms.enable");
		if(!smsEnable) return false;

		String smsServer = Config.getString("sms.server.url");
		String smsToken = Config.getString("sms.token");
		HttpClient client = HttpClientBuilder.create().build();
		HttpResponse response = null;
		try {
			String url = String.format("%s?token=%s&receiver=%s&smsType=007&content=%s", smsServer, smsToken, sms.getReceiver(), URLEncoder.encode(sms.getContent(), Common.UTF8));
			log.info("SMS Send : {}", url);
			HttpGet request = new HttpGet(url);
			response = client.execute(request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (response.getStatusLine().getStatusCode() == 200) return true;
		else return false;
	}
}
