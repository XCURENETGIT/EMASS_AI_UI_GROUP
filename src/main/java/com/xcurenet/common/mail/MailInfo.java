package com.xcurenet.common.mail;

import com.xcurenet.common.txt.TextReader;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.File;

@Data
@NoArgsConstructor
public class MailInfo {

	public final static String MAIL_INFO_PREFIX = ":";

	public final static String MAIL_MULTI_PREFIX = ";";

	public final static String HEADER = "<html><head><title>EMASS AI</title><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/></head><body>";

	public final static String FOOTER = "</body></html>";

	public final static String ALARM_PATH = "/users/emassai/alarm_mail/";

	public final static String SLASH = "/";

	public final static String SUCCESS = "SUCCESS";

	public final static String ENTER = "\r\n";

	private String infoPath;
	private String orgInfoPath;

	private String subject;

	private String from;

	private String fromName;

	private String[] to = {};

	private String[] cc = {};

	private String[] bcc = {};

	private String body;

	private String bodyPath;

	private String errorPath;

	private String[] attachPath;

	public MailInfo(String infoPath, String orgInfoPath) throws Exception {
		this.infoPath = infoPath;
		this.orgInfoPath = orgInfoPath;
		readInfo();
	}

	private void readInfo() throws Exception {
		File _info = new File(this.infoPath);
		if (_info == null || !_info.isFile() || !_info.canRead()) {
			throw new Exception("[error] file cannot be read  file path : " + this.infoPath);
		}

		try {
			String[] infos = new TextReader().read(infoPath).split(TextReader.NEW_LINE);
			for (int i = 0; i < infos.length; i++) {
				int prefix = infos[i].indexOf(MailInfo.MAIL_INFO_PREFIX);
				if (prefix == -1) continue;

				String key = infos[i].substring(0, prefix).trim().toUpperCase();
				String value = infos[i].substring(prefix + 1, infos[i].length()).trim();
				if (value.equals("")) continue;

				if (key.equals("SUBJECT")) subject = value;
				else if (key.equals("FROM")) from = value;
				else if (key.equals("TO")) to = value.split(MailInfo.MAIL_MULTI_PREFIX);
				else if (key.equals("CC")) cc = value.split(MailInfo.MAIL_MULTI_PREFIX);
				else if (key.equals("BODY")) {
					body = new TextReader().read(value);
					bodyPath = value;
					if (value.indexOf(".") > -1) errorPath = value.substring(0, value.lastIndexOf(".")) + ".error";
					else errorPath = value + ".error";
				} else if (key.equals("ATTACH")) attachPath = value.split(MailInfo.MAIL_MULTI_PREFIX);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) throws Exception {
		MailInfo mi = new MailInfo("D:\\users\\edc\\alarm_mail\\2014-04-01\\sysadmin_20140401110601.info", "D:\\users\\edc\\alarm_mail\\2014-04-01\\sysadmin_20140401110601.info");
		System.out.println(mi.subject);
		System.out.println(mi.from);
		System.out.println(mi.to.length);
		System.out.println(mi.cc.length);
		System.out.println(mi.bcc.length);
		System.out.println(mi.body);
		System.out.println(mi.attachPath.length);
	}
}
