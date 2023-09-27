package com.xcurenet.common.auditMail;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;

import javax.annotation.Resource;

import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service
@Slf4j
public class IntegrityMailSender {
	
	@Resource(name = "deviceService")
	private DeviceService deviceService;

	private static DateTimeFormatter yyyy_MM_dd = DateTimeFormat.forPattern("yyyy-MM-dd");

	private static DateTimeFormatter yyyyMMddHH = DateTimeFormat.forPattern("yyyyMMddHH");

	public boolean send(final JSONObject integrity) {
		
		DeviceVO device = deviceService.getDeviceByIp(Common.nvl(integrity.getString("DEVICE_IP")));
		String deviceName = "";
		if (device != null) {
			deviceName = device.getDeviceNm();
		}
		if (Common.isEmpty(deviceName)) deviceName = Common.nvl(integrity.getString("DEVICE_HOST"));
		else deviceName += " " + Common.nvl(integrity.getString("DEVICE_IP"));

		if (!Config.getBoolean("mail.forward.flag") || !Config.getBoolean("mail.audit.used")) return false;

		String receiver = Config.getString("mail.audit.receiver");
		if (Common.isEmpty(receiver)) {
			log.error("Receiver is empty");
			return false;
		}

		String from = Config.getString("system.mail.addr");
		if (Common.isEmpty(from)) {
			log.error("Sender is empty");
			return false;
		}

		String body = getContent(integrity, device);

		String alarmTypeStr = Prop.propFormat("trap.message.integrity.title");

		String subject = integrity.getString("DEVICE_IP") + " " + alarmTypeStr;
		saveMail(subject, from, receiver, body);

		return true;
	}

	public void saveMail(String subject, String from, String to, String body) {
		String nowTime = yyyy_MM_dd.print(DateTime.now()).toString();
		String file_name = yyyyMMddHH.print(DateTime.now()).toString() + "_audit_mail_" + Common.lpad(String.valueOf(Common.getNextSeq()), 5, "0");
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
			log.warn(directory + "에 파일 무결성 메일 알림 파일이 저장되었습니다. FileName : " + file_name);
		} catch (IOException e) {
			log.warn("메일 정보를 파일로 저장 도중 에러가 발생하였습니다.");
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(info_bw);
			IOUtils.closeQuietly(body_bw);
		}
	}

	public static String hdd(Object sizez) {
		long size = Common.nvn(sizez);
		if (size <= 0) return "0";
		final String[] units = new String[] {"MB", "GB", "TB", "PT"};
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + units[digitGroups];
	}

	public String getContent(final JSONObject integrity, final DeviceVO device) {

		String alarmTypeStr = Prop.propFormat("trap.message.integrity.title");

		String deviceTypeStr = "";
		if (Common.isEquals(device.getDeviceType(), "A")) deviceTypeStr = Prop.propFormat("deviceInfo.integraldev");
		else if (Common.isEquals(device.getDeviceType(), "L")) deviceTypeStr = Prop.propFormat("deviceInfo.analdev");
		else if (Common.isEquals(device.getDeviceType(), "C")) deviceTypeStr = Prop.propFormat("deviceInfo.loggingdev");
		
		String deviceCheckDate = Common.nvl(integrity.getString("CHECK_DATE"));
		
		JSONArray list = integrity.getJSONArray ( "MSG_DATA" );
		StringBuffer _sb = new StringBuffer();
		_sb.append(" <!DOCTYPE html> \n");
		_sb.append(" <html> \n");
		_sb.append(" <head> \n");
		_sb.append(" <meta charset=\"utf-8\"> \n");
		_sb.append(" <title>" + alarmTypeStr + "</title> \n");
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
		_sb.append(" .integrity_list {border: 1px solid #B4B4B4;} \n");
		_sb.append(" .integrity_list thead td {background-color: #548DD4;color: #fff;text-align: center;font-weight: bold;font-family: Dotum,돋움,sans-serif;font-size: 14px;height: 20px;border: 1px solid #B4B4B4;} \n");
		_sb.append(" .integrity_list td {font-family: Dotum,돋움,sans-serif;font-size: 13px;height: 20px;border: 1px solid #B4B4B4;padding: 2px;} \n");
		_sb.append(" </style> \n");
		_sb.append(" <head> \n");
		_sb.append(" </head> \n");
		_sb.append(" <body> \n");
		_sb.append(" 	<table style=\"width: 100%;\"> \n");
		_sb.append(" 		<tr> \n");
		_sb.append(" 			<td align=\"center\"> \n");
		_sb.append(" 				<table class=\"title_table\"> \n");
		_sb.append(" 					<tr><td class=\"title content\">※ " + alarmTypeStr + "</td></tr> \n");
		_sb.append(" 					<tr><td style=\"height: 20px;\">&nbsp;</td></tr> \n");
		_sb.append(" 					<tr> \n");
		_sb.append(" 						<td class=\"content\"> \n");
		_sb.append(" 							<fieldset> \n");
		_sb.append(" 								<legend>" + Prop.propFormat("audit.mail.comment") + "</legend> \n");
		_sb.append(" 								<table class=\"info_table\"> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("common.msg.device_type") + "</td><td> : " + deviceTypeStr + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">" + Prop.propFormat("deviceInfo.dev.ip") + "</td><td> : " + device.getDeviceIp() + "</td></tr> \n");
		_sb.append(" 									<tr><td class=\"content_title\">"+Prop.propFormat("trap.message.check.date")+"</td><td> : " + deviceCheckDate + "</td></tr> \n");
		_sb.append(" 								</table> \n");
		_sb.append(" 							</fieldset> \n");
		_sb.append(" 						</td> \n");
		_sb.append(" 					</tr> \n");
		_sb.append( "  					<tr><td>&nbsp;</td></tr> \n" );
		_sb.append( "  					<tr> \n" );
		_sb.append( "  						<td style=\"padding-left: 20px;\">※ "+Prop.propFormat("trap.message.list")+"</td> \n" );
		_sb.append( "  					</tr> \n" );
		_sb.append( "  					<tr> \n" );
		_sb.append( "  						<td style=\"padding-left: 13px;padding-right: 13px;\"> \n" );
		_sb.append( "  							<table class=\"integrity_list\" style=\"width: 100%;\"> \n" );
		_sb.append( "  								<thead><tr><td style=\"width: 100px;\">"+Prop.propFormat("trap.message.module")+"</td><td>"+Prop.propFormat("message.msg.file")+"</td></tr></thead> \n" );
		_sb.append( "  								<tbody> \n" );
		for ( int i = 0 ; i < list.size ( ) ; i++ )
		{
			JSONObject obj = list.getJSONObject ( i );
			String moudle = obj.getString ( "moudle" );
			String path = obj.getString ( "path" );
			_sb.append ( "  									<tr><td>" + moudle + "</td><td>" + path + "</td></tr> \n" );
		}
		_sb.append ( "  							</tbody> \n" );
		_sb.append ( "  						</table> \n" );
		_sb.append ( "  					</td> \n" );
		_sb.append ( "  				</tr> \n" );
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
