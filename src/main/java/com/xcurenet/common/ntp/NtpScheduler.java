package com.xcurenet.common.ntp;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.locale.Prop;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Controller
public class NtpScheduler {
	
	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate;
	
	private Locale locale = Locale.forLanguageTag(Locale.getDefault().getLanguage());

	private static final String NTP_COMMAND = "/usr/sbin/ntpq -pn";
	
	public static JSONObject ntpStatus = new JSONObject();
	
	@Scheduled(fixedDelay = 3600000)
	public void checkNtp() {
		if(!Common.isWindow()) {
			JSONObject socketMsg = getNtpStatus();
			simpMessagingTemplate.convertAndSend("/topic/ntpCheck", socketMsg);
		}
	}
	
	public JSONObject getNtpStatus() {
		JSONObject result = new JSONObject();
		String reach = "";
		String resultServer = "";
		boolean synchronizedNTP = false;
		boolean dataStart = false;
		log.info("[NTP Check]");
		
		if(!Common.isWindow()) {
			try {
				ProcessBuilder processBuilder = new ProcessBuilder("bash", "-c", NTP_COMMAND);
				Process process = processBuilder.start();
				String ntpServer = "";				
				BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
				
				String line;
				while((line = reader.readLine()) != null) {
					log.info(line);
					if(line.startsWith("=")) {
						dataStart = true;
					} else if(dataStart) {
						String[] tokens = line.trim().split("\\s+");
						if(tokens.length >= 10) {
							ntpServer = tokens[0];
							reach = tokens[6];
//							tmpResult.put("refid", tokens[1]);
//							tmpResult.put("st", tokens[2]);
//							tmpResult.put("t", tokens[3]);
//							tmpResult.put("when", tokens[4]);
//							tmpResult.put("poll", tokens[5]);
//							tmpResult.put("delay", tokens[7]);
//							tmpResult.put("offset", tokens[8]);
//							tmpResult.put("jitter", tokens[9]);
							
							if(ntpServer.startsWith("*") || Common.isEquals(reach, "377")) {
								synchronizedNTP = true;
							}
							
							if(ntpServer.startsWith("*")) {
								resultServer = ntpServer.substring(1, ntpServer.length());
							}
						}
					}
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		
		result.put("ntpServer", resultServer);
		result.put("title", "NTP");
		
		
		if(!dataStart) {
			result.put("ntpServer", Prop.propFormat("trap.message.ntp.server.nosearch", locale));
			result.put("status", "unconnect");
			result.put("content", "[ "+Prop.propFormat("trap.message.ntp", locale)+"] "+Prop.propFormat("trap.message.ntp.unconnect", locale));
		} else if(!synchronizedNTP || Common.isEmpty(resultServer)) {
			result.put("status", "unsync");
			result.put("content", "[ "+Prop.propFormat("trap.message.ntp", locale)+"] "+Prop.propFormat("trap.message.ntp.unsync", locale));
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
	
	public static void main(String[] args) throws IOException {
		String ntpServer = "";
		String reach = "";
		boolean synchronizedNTP = false;
		
		String result = "  remote  refid  st  t  when  poll  reach  delay  offset  jitter\n====================================\n+1.1.1.1  2.2.2.2  3  u  421  1024  377  0.125  -0.764  1.059\n*3.3.3.3  2.2.2.2  3  u  143  1024  377  0.122  0.063  0.948";
		
		BufferedReader reader = new BufferedReader(new InputStreamReader(new ByteArrayInputStream(result.getBytes())));
		
		String line;
		boolean dataStart = false;
		
		while((line = reader.readLine()) != null) {
			if(line.startsWith("=")) {
				dataStart = true;
			} else if(dataStart) {
				String[] tokens = line.trim().split("\\s+");
				System.out.println(Arrays.toString(tokens));
				if(tokens.length >= 10) {
					ntpServer = tokens[0];
					reach = tokens[6];
//					tmpResult.put("refid", tokens[1]);
//					tmpResult.put("st", tokens[2]);
//					tmpResult.put("t", tokens[3]);
//					tmpResult.put("when", tokens[4]);
//					tmpResult.put("poll", tokens[5]);
//					tmpResult.put("delay", tokens[7]);
//					tmpResult.put("offset", tokens[8]);
//					tmpResult.put("jitter", tokens[9]);
					
					if(ntpServer.startsWith("*") || Common.isEquals(reach, "377")) {
						synchronizedNTP = true;
					}
					
					if(ntpServer.startsWith("*")) {
						System.out.println(ntpServer);
						ntpServer = ntpServer.substring(1, ntpServer.length());
					}
				}
			}
		}
		
		System.out.println(ntpServer);
	}
}
