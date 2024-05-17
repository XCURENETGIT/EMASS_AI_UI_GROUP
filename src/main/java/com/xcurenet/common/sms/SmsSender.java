package com.xcurenet.common.sms;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;

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

//	public static void main(String[] args){
//		/* test */
//
//		SmsVO sms = new SmsVO();
//		sms.setReceiver("1231231313");
//		sms.setSmsType("");
//		sms.setContent("테스트 입니다.");
//
//		String smsServer = "http://218.234.36.39:2931/api/send/sms/";
//		String smsToken = "030f1cab-12d9-4b38-bf63-89bff40f0a3c";
//		HttpClient client = HttpClientBuilder.create().build();
//		HttpResponse response = null;
//		try {
//			String url = String.format("%s?token=%s&receiver=%s&smsType=007&content=%s", smsServer, smsToken, sms.getReceiver(), URLEncoder.encode(sms.getContent(), Common.UTF8));
//			log.info("SMS Send : {}", url);
//			HttpGet request = new HttpGet(url);
//			response = client.execute(request);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}

}
