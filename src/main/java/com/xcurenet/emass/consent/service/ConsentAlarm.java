package com.xcurenet.emass.consent.service;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.sms.SmsSender;
import com.xcurenet.common.sms.SmsType;
import com.xcurenet.common.sms.SmsVO;
import com.xcurenet.common.snmp.service.SnmpTrapService;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Controller
public class ConsentAlarm {
	
	@Autowired
	private SimpMessagingTemplate template;

	@Autowired
	private SmsSender smsSender;

	@Resource(name = "snmpTrapService")
	private SnmpTrapService snmpTrapService;

	@Resource(name = "adminService")
	public AdminService adminService;

	private static DateTimeFormatter yyyy_MM_dd = DateTimeFormat.forPattern("yyyy-MM-dd");

	private static DateTimeFormatter yyyyMMddHH = DateTimeFormat.forPattern("yyyyMMddHH");
	
	public void sendConsentAlarm(final ConsentVO consent, String flag) {
		String registrantYn = Common.nvl(consent.getRegistrantYn());
		String createId = Common.nvl(consent.getCreateId());
		AdminVO searchAdmin = new AdminVO();
		if(Common.isEquals(registrantYn, "Y")) {
			searchAdmin.setSearchStr(createId);
		} else {
			searchAdmin.setSearchStr(createId);
			searchAdmin.setApprobator("A");
		}
		String appCd = Common.nvl(consent.getAppCd());
		String appCdStr = "";
		if (Common.isEquals(appCd, "A")) appCdStr = Prop.propFormat("consent.approved");
		else if (Common.isEquals(appCd, "R")) appCdStr = Prop.propFormat("consent.rejected");
		else if (Common.isEquals(appCd, "C")) appCdStr = Prop.propFormat("common.msg.cancel");
		else appCdStr = Prop.propFormat("consent.wait");
			
		List<AdminVO> adminList = adminService.getApprobatorList(searchAdmin);
		String toMailList = "";
		for (AdminVO admin : adminList) {
			toMailList += admin.getAdminEmail() + ";";
			if (Common.isEquals(consent.getAlarmSmsYn(), "Y")) {
				if (Common.isEmpty(admin.getAdminHp())) {
					log.error("[SMS SEND ERROR] NOT FOUND ADMIN HP {}", createId);
				} else {
					SmsVO sms = new SmsVO();
					sms.setReceiver(admin.getAdminHp());
					String smsContent = "";
					String smsUser = consent.getName();
					if(smsUser.length() > 5) smsUser = smsUser.substring(0, 4) + "...";
					if(Common.isEquals(flag, "I")) {
						smsContent = Prop.propFormat("consent.alarm.addmsg", consent.getNo(), smsUser);
					} else {
						smsContent = Prop.propFormat("consent.alarm.approvalmsg", consent.getNo(), smsUser, appCdStr);
					}
					sms.setContent(smsContent);
					sms.setSmsType(SmsType.ADMIN_ALERT);
					smsSender.sendSms(sms);
				}
			}
			if (Common.isEquals(consent.getAlarmMonitorYn(), "Y")) {
				JSONObject msg = new JSONObject();
				String msgTitle = "";
				String msgContent = "";
				if(Common.isEquals(flag, "I")) {
					msgTitle = Prop.propFormat("consent.alarm.addtitle");
					msgContent = Prop.propFormat("consent.alarm.addmsg", consent.getNo(), consent.getName());;
				} else {
					msgTitle = Prop.propFormat("consent.alarm.approvaltitle");
					msgContent = Prop.propFormat("consent.alarm.approvalmsg", consent.getNo(), consent.getName(), appCdStr);
				}
				msg.put("title", msgTitle);
				msg.put("content", msgContent);
				template.convertAndSendToUser(admin.getAdminId(), "/trap", msg);
			}
		}
		
		if (Common.isEquals(consent.getAlarmMailYn(), "Y")) { // 메일을 받고자 하는 경우
			mailSend(consent, toMailList, flag, appCdStr);
		}
	}
	
	public boolean mailSend(ConsentVO consent, String to, String flag, String appCdStr) {
		if (Common.isEmpty(to)) {
			log.error("Receiver is empty");
			return false;
		}

		String from = Config.getString("system.mail.addr");
		if (Common.isEmpty(from)) {
			log.error("Sender is empty");
			return false;
		}

		String body = getContent(consent, flag, appCdStr);

		String subject = "";
				
		if(Common.isEquals(flag, "I")) {
			subject = Prop.propFormat("consent.alarm.addtitle");
		} else {
			subject = Prop.propFormat("consent.alarm.approvaltitle");
		}
				
		saveMail(subject, from, to, body);

		return true;
	}
	
	public void saveMail(String subject, String from, String to, String body) {
		String nowTime = yyyy_MM_dd.print(DateTime.now()).toString();
		String file_name = yyyyMMddHH.print(DateTime.now()).toString() + "_consent_alarm_mail_" + Common.lpad(String.valueOf(Common.getNextSeq()), 5, "0");
		String info_file_name = file_name + ".info";
		String body_file_name = file_name + ".body";
		String directory = MailInfo.ALARM_PATH + nowTime + MailInfo.SLASH;

		Common.mkdirs(directory + MailInfo.SUCCESS);

		StringBuffer info = new StringBuffer();
		info.append("RESULT : ").append(MailInfo.ENTER);
		info.append("SUBJECT : ").append(subject).append(MailInfo.ENTER);
		info.append("FROM : ").append(from).append(MailInfo.ENTER);
		info.append("TO : ").append(to).append(MailInfo.ENTER);
		info.append("CC : ").append(MailInfo.ENTER);
		info.append("BODY : ").append(directory + body_file_name).append(MailInfo.ENTER);
		info.append("ATTACH : ");

		BufferedWriter info_bw = null;
		BufferedWriter body_bw = null;
		try {
			body_bw = new BufferedWriter(new FileWriter(directory + body_file_name));
			body_bw.write(body);

			info_bw = new BufferedWriter(new FileWriter(directory + info_file_name));
			info_bw.write(info.toString());
			log.warn(directory + "에 동의서 메일 알림 파일이 저장되었습니다. FileName : " + file_name);
		} catch (IOException e) {
			log.warn("동의서 메일 알림 정보를 파일로 저장 도중 에러가 발생하였습니다.");
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(info_bw);
			IOUtils.closeQuietly(body_bw);
		}
	}
	
	public String getContent(final ConsentVO consent, String flag, String appCdStr) {

		String consentTypeStr = Prop.propFormat("consent.informed.consent");
		if (Common.isEquals(consent.getType(), "B")) consentTypeStr = Prop.propFormat("consent.informed.consent");
		else if (Common.isEquals(consent.getType(), "A")) consentTypeStr = Prop.propFormat("consent.post.consent");
		else if (Common.isEquals(consent.getType(), "M")) consentTypeStr = Prop.propFormat("consent.monitoring.consent");
		else if (Common.isEquals(consent.getType(), "E")) consentTypeStr = Prop.propFormat("consent.retire.consent");

		StringBuffer _sb = new StringBuffer();
		_sb.append(" <!DOCTYPE html> \n");
		_sb.append(" <html> \n");
		_sb.append(" <head> \n");
		_sb.append(" <meta charset=\"utf-8\"> \n");
		if (Common.isEquals(flag, "I")) {
			_sb.append(" <title>" + Prop.propFormat("consent.alarm.addtitle") + "</title> \n");
		} else {
			_sb.append(" <title>" + Prop.propFormat("consent.alarm.approvaltitle") + "</title> \n");
		}
		
		_sb.append(" <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\" /> \n");
		_sb.append(" <style type=\"text/css\"> \n");
		_sb.append(" * {font-family: \"Dotum\",Helvetica,Arial,sans-serif,돋움;font-size: 14px;} \n");
		_sb.append(" table {border-collapse:collapse;border-spacing: 0px;} \n");
		_sb.append(" legend {font-family: Dotum,돋움,sans-serif;padding-bottom: 10px;padding-top: 12px;font-size: 18px;font-weight: bold;color: #727272;} \n");
		_sb.append(" fieldset {border: 2px solid #B4B4B4;} \n");
		_sb.append(" .content {padding: 0 10px 0 10px;text-align: left;} \n");
		_sb.append(" .title_table {width: 680px;height: 100%;border: 2px solid #8BA932;text-align: left;} \n");
		_sb.append(" .title {background-color: #8BA932;font-size: 24px;font-weight: bold;color: #914F26;height: 50px;} \n");
		_sb.append(" .content_title {width: 120px;font-weight: bold;line-height: 20px;} \n");
		_sb.append(" .info_table td {font-family: Gulim,굴림,Dotum,돋움,sans-serif;font-size: 12px;color: #333333;} \n");
		_sb.append(" .color td {background-color: #F6D7C6;color: #DB5F1C;font-weight: bold;} \n");
		_sb.append(" .message {height: 80px;} \n");
		_sb.append(" .message div {color: #5A98CB;} \n");
		_sb.append(" </style> \n");
		_sb.append(" <head> \n");
		_sb.append(" </head> \n");
		_sb.append(" <body> \n");
		_sb.append(" 	<table style=\"width: 100%;\"> \n");
		_sb.append(" 		<tr> \n");
		_sb.append(" 			<td align=\"center\"> \n");
		_sb.append(" 				<table class=\"title_table\"> \n");
		if (Common.isEquals(flag, "I")) {
			_sb.append(" 					<tr><td class=\"title content\">※ " + Prop.propFormat("consent.alarm.addtitle") + "</td></tr> \n");
		} else {
			_sb.append(" 					<tr><td class=\"title content\">※ " + Prop.propFormat("consent.alarm.approvaltitlemsg", appCdStr) + "</td></tr> \n");
		}
		_sb.append(" 					<tr><td style=\"height: 20px;\">&nbsp;</td></tr> \n");
		_sb.append(" 					<tr> \n");
		_sb.append(" 						<td class=\"content\"> \n");
		_sb.append(" 							<fieldset> \n");
		_sb.append(" 								<legend>" + Prop.propFormat("audit.mail.comment") + "</legend> \n");
		_sb.append(" 								<table class=\"info_table\"> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("consent.number") + "</td><td> : " + consent.getNo() + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("consent.type") + "</td><td> : " + consentTypeStr + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("common.msg.id") + "</td><td> : " + consent.getUserId() + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("consent.user") + "</td><td> : " + consent.getName() + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("common.org.dept") + "</td><td> : " + consent.getDeptNm() + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("consent.expiration.date") + "</td><td> : " + consent.getEdate() + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("consent.registrant") + "</td><td> : " + consent.getCreateId()+"(" + consent.getCreateNm()+ ")</td></tr> \n");
		if (Common.isEquals(flag, "A")) {
			_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("consent.status.approved") + "</td><td> : " + appCdStr+ "</td></tr> \n");
		}
		_sb.append(" 								</table> \n");
		_sb.append(" 							</fieldset> \n");
		_sb.append(" 						</td> \n");
		_sb.append(" 					</tr> \n");
		_sb.append(" 					<tr><td style=\"height: 20px;\">&nbsp;</td></tr> \n");
		_sb.append(" 				</table> \n");
		_sb.append(" 			</td> \n");
		_sb.append(" 		</tr> \n");
		_sb.append(" 		<tr><td align=\"center\"><div style=\"width: 680px;text-align: left;font-size: 11px;color: #A2A2A2;\">" + Prop.propFormat("audit.mail.warn4") + "</div></td></tr> \n");
		_sb.append(" 	</table> \n");
		_sb.append(" </body> \n");
		_sb.append(" </html> \n");
		return _sb.toString();
	}
}
