package com.xcurenet.emass.reservationAlarm.service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import lombok.extern.log4j.Log4j2;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;

import com.xcurenet.common.csv.CsvWriter;
import com.xcurenet.common.excel.XLSXWriter;
import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.rename.FileRenamePolicy;
import com.xcurenet.common.sms.SmsSender;
import com.xcurenet.common.sms.SmsType;
import com.xcurenet.common.sms.SmsVO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.emass.service.service.ServiceTypeService;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Log4j2
@Controller
public class AlarmJob {

	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate;

	@Autowired
	private SmsSender smsSender;

	@Autowired
	public ServiceTypeService serviceTypeService;

	@Autowired
	public ConfigAdminService configAdminService;

	@Autowired
	public AlarmService alarmService;

	@Autowired
	private SolrEdcService solrEdcService;

	private static DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");

	private static DateTimeFormatter yyyy_MM_dd = DateTimeFormat.forPattern("yyyy-MM-dd");

	private static DateTimeFormatter yyyyMMddHH = DateTimeFormat.forPattern("yyyyMMddHH");

	private static DateTimeFormatter yyyyMMddHHmmss = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

	private static final int EXCEL_MAX_ROW_CNT = 10000;
	private static final int CSV_MAX_ROW_CNT = 10000000;

	private static List<AlarmVO> alarmList;

	private Locale locale = Locale.forLanguageTag(Locale.getDefault().getLanguage());

	@Scheduled(cron="0 10 * * * ?")
	private void execute ( ) throws Exception {
		log.info("[Scheduler execute] Alarm mail");
		if(Common.isWindow()) return;
		try {
			alarmList = alarmService.getNowExecuteList();
			if (alarmList == null) return;

			for (AlarmVO alarm : alarmList) {
				log.info("[Alarm Name] : "+Common.nvl(alarm.getAlarmName()) + " [Alarm Seq] : " + Common.nvl(alarm.getAlarmSeq()));
				String alarm_name = Common.nvl(alarm.getAlarmName());
				String alarmSeq = Common.nvl(alarm.getAlarmSeq());
				// String email = objFixNull ( alarm.get ( "EMAIL" ) );
				String alarm_cycle = Common.nvl(alarm.getAlarmCycle());
				String alarm_to = Common.nvl(alarm.getAlarmTo());
				String alarm_cc = Common.nvl(alarm.getAlarmCC());
				String adminId = Common.nvl(alarm.getUserId());
				String csvYn = Common.nvl(alarm.getCsvYn());

				String subject = Common.nvl(alarm.getFormSubject());
				String form_content = Common.nvl(alarm.getFormContent());

				ConfigAdminVO vo = configAdminService.getConfAdmin("language", adminId);
				if (vo != null && Common.isNotEmpty(vo.getVal())) {
					Locale lo = Locale.forLanguageTag(vo.getVal());
					if (lo != null) locale = lo;
				}

				JSONObject alarm_val = Common.toJSONObject(alarm.getAlarmVal());
				String startDateSelect = Common.nvl(alarm_val.get("startDateSelect"));
				int startTimeSelect = Common.nvz(alarm_val.get("startTimeSelect"));
				String endDateSelect = Common.nvl(alarm_val.get("endDateSelect"));
				int endTimeSelect = Common.nvz(alarm_val.get("endTimeSelect"));

				if(alarm_cycle.equals("H")) {
					startDateSelect = "";
					startTimeSelect = 0;
					endDateSelect = "";
					endTimeSelect = 0;
					alarm_val.put("startDateSelect", startDateSelect);
					alarm_val.put("startTimeSelect", startTimeSelect);
					alarm_val.put("endDateSelect", endDateSelect);
					alarm_val.put("endTimeSelect", endTimeSelect);
				}

				String searchStr = Common.nvl(alarm_val.get("searchStr")); // 검색어
				String searchField = Common.nvl(alarm_val.get("searchField")); // 검색어
				String senders = Common.nvl(alarm_val.get("senders")); // 발신자
				String receivers = Common.nvl(alarm_val.get("receivers")); // 수신자
				String rcvTo = Common.nvl(alarm_val.get("rcvTo")); // 받는사람
				String rcvCc = Common.nvl(alarm_val.get("rcvCc")); // 참조
				String rcvBcc = Common.nvl(alarm_val.get("rcvBcc")); // 숨은참조
				String rcvJikgub = Common.nvl(alarm_val.get("rcvJikgub")); // 수신자 직급
				String allOfus = Common.nvl(alarm_val.get("allOfus")); // 수신자 중 외부인
				String busi = Common.nvl(alarm_val.get("busi")); // 사업장
				String dept = Common.nvl(alarm_val.get("dept")); // 부서
				String jikgub = Common.nvl(alarm_val.get("jikgub")); // 직급
				String readYn = Common.nvl(alarm_val.get("readYn")); // 읽음여부
				String receiveSend = Common.nvl(alarm_val.get("receiveSend")); // 수/발신
				String serviceType = Common.nvl(alarm_val.get("serviceType")); // 서비스타입
				String infoType = Common.nvl(alarm_val.get("infoType")); // 정보 분류
				String feedbackType = Common.nvl(alarm_val.get("feedbackType")); // 피드백
				String probType = Common.nvl(alarm_val.get("probType")); // 판정확률
				String interGroup = Common.nvl(alarm_val.get("interGroup")); // 관심 사용자
				String attachYn = Common.nvl(alarm_val.get("attachYn")); // 첨부여부
				String attachStr = Common.nvl(alarm_val.get("attachStr")); // 첨부 확장자
				String keywordYn = Common.nvl(alarm_val.get("keywordYn")); // 키워드 여부
				String keywordStr = Common.nvl(alarm_val.get("keywordStr"));// 키워드
				String secretYn = Common.nvl(alarm_val.get("secretYn")); // 문서 분류
				String regexpYn = Common.nvl(alarm_val.get("regexpYn")); // 패턴 검출 여부
				String regexpStr = Common.nvl(alarm_val.get("regexpStr")); // 패턴
				String sizeStartVal = Common.nvl(alarm_val.get("sizeStartVal")); // 메시지시작크기
				String sizeEndVal = Common.nvl(alarm_val.get("sizeEndVal")); // 메시지종료크기
				String sizeOption = Common.nvl(alarm_val.get("sizeOption")); // 메시지조건 옵션(B:범위,L:이상,S:이하)
				String ocrYn = Common.nvl(alarm_val.get("ocrYn")); // OCR 여부
				String reprocessYn = Common.nvl(alarm_val.get("reprocessYn")); // 재처리 여부

				String startDt = getStartDt(startDateSelect, startTimeSelect, alarm_cycle);
				String endDt = getEndDt(endDateSelect, endTimeSelect, alarm_cycle);

				alarm_val.put("period", "1");
				alarm_val.put("startDt", startDt);
				alarm_val.put("endDt", endDt);

				JSONArray conditions = new JSONArray();
				conditions.add(alarm_val);
				JSONObject param = new JSONObject();
				param.put("conditions", conditions);

				SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
				SolrQuery sq = solrCreateQuery.createQuery(param, adminId);
				sq.setStart(0);

				if (Common.isEquals(csvYn, "Y")) {
					sq.setRows(Common.nvz(alarm.getExcelMaxCnt(), CSV_MAX_ROW_CNT));
				} else {
					sq.setRows(Common.nvz(alarm.getExcelMaxCnt(), EXCEL_MAX_ROW_CNT));
				}

				String sqToString = sq.getQuery();


				SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, adminId,readYn, null);
				if (solrVo.getNumFound() < 1) {
					log.warn("adminid : " + adminId + "\t메시지 목록 조회 완료 0건 검출");
				} else {
					long totalCnt = solrVo.getNumFound();
					String form_subject = Common.nvl(setSubjectData(subject, alarm_name, totalCnt, startDt, endDt), Prop.propFormat("SETTING.RESERVATION_ALARM")+"Mail. (" + alarm_name + ")"); // 서식 제목

					log.warn("userid : " + adminId + "\t알림 쿼리 실행 결과 : " + totalCnt);

					if (Common.isEquals(alarm.getAlarmMailYn(), "Y")) { // 메일을 받고자 하는 경우
 						createMailContent(alarm_name, alarmSeq, csvYn, alarm_to, alarm_cc, searchStr, searchField, senders, receivers, rcvTo, rcvCc, rcvBcc, rcvJikgub, allOfus, busi, dept, jikgub, readYn, receiveSend, serviceType, infoType, feedbackType, probType, interGroup, attachYn, attachStr, keywordYn, keywordStr, regexpYn, regexpStr, sizeStartVal, sizeEndVal, sizeOption, startDt, endDt, solrVo, totalCnt, form_subject, form_content);
					}
					if (Common.isEquals(alarm.getAlarmSmsYn(), "Y")) {
						if (Common.isEmpty(alarm.getUserHp())) {
							log.error("[SMS SEND ERROR] NOT FOUND USER HP {}", alarm);
						} else {
							SmsVO sms = new SmsVO();
							if(alarm_name.length() > 20) alarm_name = alarm_name.substring(0, 20) + "...";
							sms.setReceiver(alarm.getUserHp());
							sms.setContent("[" + alarm_name + " "+Prop.propFormat("mail.excute.result", locale)+"] "+Prop.propFormat("mail.detect.count", locale, totalCnt));
							sms.setSmsType(SmsType.ADMIN_ALERT);
							smsSender.sendSms(sms);
						}
					}
					if (Common.isEquals(alarm.getAlarmMonitorYn(), "Y")) {
						JSONObject msg = new JSONObject();
						msg.put("title", form_subject);
						msg.put("content", "[" + alarm_name + " "+Prop.propFormat("mail.excute.result", locale)+"] "+Prop.propFormat("mail.detect.count", locale, totalCnt));
						simpMessagingTemplate.convertAndSendToUser(adminId, "/trap", msg);
					}
					alarmService.insertAlarmLog(alarmSeq, totalCnt, sqToString);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void createMailContent(String alarm_name, String alarmSeq, String csvYn, String alarm_to, String alarm_cc, String searchStr, String searchField, String senders, String receivers, String rcvTo, String rcvCc, String rcvBcc, String rcvJikgub, String allOfus, String busi, String dept, String jikgub, String readYn, String receiveSend, String serviceType, String infoType, String feedbackType, String probType, String interGroup, String attachYn, String attachStr, String keywordYn, String keywordStr, String regexpYn, String regexpStr, String sizeStartVal, String sizeEndVal, String sizeOption, String startDt, String endDt, SolrEdcMessageVO solrVo, long totalCnt, String form_subject, String form_content) throws Exception, FileNotFoundException {
		String body = "";
		if (form_content.isEmpty()) body = getHTMLBody(alarm_name, totalCnt, startDt, endDt, searchStr, senders, receivers, receiveSend, rcvTo, rcvCc, rcvBcc, rcvJikgub, searchField, allOfus, sizeStartVal, sizeOption, sizeEndVal, attachYn, attachStr, keywordYn, keywordStr, busi, dept, jikgub, readYn, serviceType, infoType, feedbackType, probType, interGroup, regexpYn, regexpStr);
		else body = setBodyData(form_content, alarm_name, totalCnt, startDt, endDt, searchStr, senders, receivers, receiveSend, rcvTo, rcvCc, rcvBcc, rcvJikgub, searchField, allOfus, sizeStartVal, sizeOption, sizeEndVal, attachYn, attachStr, keywordYn, keywordStr, busi, dept, jikgub, readYn, serviceType, infoType, feedbackType, probType, interGroup, regexpYn, regexpStr);

		String headerStr = "[{\"key\":\"NUM\",\"title\":\"No\",\"width\":75,\"align\":\"center\"},";
		headerStr += "{\"key\":\"msgid\",\"title\":\""+Prop.propFormat("common.msg.msgid", locale)+"\",\"width\":200,\"align\":\"left\"},";
		headerStr += "{\"key\":\"interestUserYn\",\"title\":\""+Prop.propFormat("message.msg.interest", locale)+"\",\"width\":40,\"align\":\"center\"},";
		headerStr += "{\"key\":\"readYn\",\"title\":\""+Prop.propFormat("condition.read", locale)+"\",\"width\":40,\"align\":\"center\"},";
		headerStr += "{\"key\":\"attachcnt\",\"title\":\""+Prop.propFormat("message.msg.file", locale)+"\",\"width\":35,\"align\":\"center\"},";
		headerStr += "{\"key\":\"inside\",\"title\":\""+Prop.propFormat("message.msg.inout", locale)+"\",\"width\":55,\"align\":\"center\"},";
		headerStr += "{\"key\":\"direction_svc\",\"title\":\""+Prop.propFormat("condition.receive_send", locale)+"\",\"width\":55,\"align\":\"center\"},";
		headerStr += "{\"key\":\"svcNm\",\"title\":\""+Prop.propFormat("condition.service", locale)+"\",\"width\":175,\"align\":\"center\"},";
		headerStr += "{\"key\":\"subject\",\"title\":\""+Prop.propFormat("condition.subject", locale)+"\",\"width\":410,\"align\":\"left\"},";
		headerStr += "{\"key\":\"ctimeFormat\",\"title\":\""+Prop.propFormat("condition.date", locale)+"\",\"width\":130,\"align\":\"center\"},";
		headerStr += "{\"key\":\"user\",\"title\":\""+Prop.propFormat("consent.user", locale)+"\",\"width\":170,\"align\":\"center\"},";
		headerStr += "{\"key\":\"deptnm\",\"title\":\""+Prop.propFormat("common.org.dept", locale)+"\",\"width\":120,\"align\":\"center\"},";
		headerStr += "{\"key\":\"jikgubnm\",\"title\":\""+Prop.propFormat("common.org.jikgub", locale)+"\",\"width\":120,\"align\":\"center\"},";
		headerStr += "{\"key\":\"sender\",\"title\":\""+Prop.propFormat("condition.sender", locale)+"\",\"width\":240,\"align\":\"left\"},";
		headerStr += "{\"key\":\"recvs\",\"title\":\""+Prop.propFormat("condition.recv", locale)+"\",\"width\":438,\"align\":\"left\"},";
		headerStr += "{\"key\":\"srcip\",\"title\":\""+Prop.propFormat("condition.source", locale)+" IP\",\"width\":100,\"align\":\"left\"},";
		headerStr += "{\"key\":\"dstip\",\"title\":\""+Prop.propFormat("condition.destination", locale)+" IP\",\"width\":100,\"align\":\"left\"},";
		headerStr += "{\"key\":\"attachname\",\"title\":\""+Prop.propFormat("condition.attach_name", locale)+"\",\"width\":200,\"align\":\"left\"},";
		headerStr += "{\"key\":\"sizeStr\",\"title\":\""+Prop.propFormat("condition.size.all", locale)+"\",\"width\":80,\"align\":\"left\"},";
		headerStr += "{\"key\":\"bodySizeStr\",\"title\":\""+Prop.propFormat("condition.size.body", locale)+"\",\"width\":80,\"align\":\"left\"},";
		headerStr += "{\"key\":\"kwds\",\"title\":\""+Prop.propFormat("condition.keyword", locale)+"\",\"width\":221,\"align\":\"left\"},";
		headerStr += "{\"key\":\"pi_total\",\"title\":\""+Prop.propFormat("condition.regexp", locale)+"\",\"width\":70,\"align\":\"center\"}";
		headerStr += "]";

		List<SolrEdcVO> datalist = solrVo.getEmass();
		JSONArray header = (JSONArray) JSONSerializer.toJSON(headerStr);
		JSONArray data = new JSONArray();

		for (int i = 0; i < datalist.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("NUM", i + 1);
			obj.put("msgid", datalist.get(i).getMsgid());
			obj.put("interestUserYn", datalist.get(i).getInterestUserYn());
			obj.put("readYn", datalist.get(i).getReadYn());
			obj.put("attachcnt", datalist.get(i).getAttachcnt());
			String insideStr = Prop.propFormat("message.msg.out", locale);
			if (datalist.get(i).getInside() == "Y") insideStr = Prop.propFormat("message.msg.in", locale);

			obj.put("inside", insideStr);
			String directionStr = Prop.propFormat("condition.send", locale);
			if (datalist.get(i).getDirection_svc() == "I") directionStr = Prop.propFormat("condition.receive", locale);

			obj.put("direction_svc", directionStr);
			obj.put("svcNm", datalist.get(i).getSvcNm());
			obj.put("subject", datalist.get(i).getSubject());
			obj.put("ctimeFormat", datalist.get(i).getCtimeFormat());
			obj.put("user", datalist.get(i).getUser());
			obj.put("deptnm", datalist.get(i).getDeptnm());
			obj.put("jikgubnm", datalist.get(i).getJikgubnm());
			obj.put("sender", datalist.get(i).getSender());
			obj.put("recvs", datalist.get(i).getRecvs());
			obj.put("srcip", datalist.get(i).getSrcip());
			obj.put("dstip", datalist.get(i).getDstip());
			obj.put("attachname", datalist.get(i).getAttachname());
			obj.put("sizeStr", datalist.get(i).getSizeStr());
			obj.put("bodySizeStr", datalist.get(i).getBodySizeStr());
			obj.put("kwds", datalist.get(i).getKwds());
			obj.put("pi_total", datalist.get(i).getPi_total());
			data.add(i, obj);
		}

		String dt = Common.getCurrentDate();
		Common.mkdirs(Common.TMP_PATH + dt);
		File file = null;
		if(Common.isEquals(csvYn, "Y")) {
			file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_data_" + Common.getCurrentTime("yyyyMMdd_HHmmss") + ".csv"));
			new CsvWriter(header, data, new OutputStreamWriter(new FileOutputStream(file), Charset.forName("EUC-KR")));
			log.info("[Alarm mail] CsvWriter " + file.getName() + "파일 생성 완료");
		} else {
			file = new FileRenamePolicy().rename(new File(Common.TMP_PATH + dt + "/export_data_" + Common.getCurrentTime("yyyyMMdd_HHmmss") + ".xlsx"));
			XLSXWriter xlsx = new XLSXWriter(Prop.propFormat("SETTING.RESERVATION_ALARM", locale)+" Mail", header, data, new FileOutputStream(file));
			xlsx.execute();
			log.info("[Alarm mail] XLSXWriter " + file.getName() + "파일 생성 완료");
		}
		createMailInfoFiles(alarmSeq, totalCnt, csvYn, form_subject, Common.nvl(Config.getString("system.mail.addr")), alarm_to, alarm_cc, body, file.getPath(), "");
	}

	public void createMailInfoFiles(String alarmSeq, long totalCnt, String csvYn, String subject, String from, String to, String cc, String body, String attach_path, String type) {
		String nowTime = yyyy_MM_dd.print(DateTime.now()).toString();
		String file_name = yyyyMMddHH.print(DateTime.now()).toString() + "_" + Common.lpad(alarmSeq, 5, "0");
		String info_file_name = file_name + ".info";
		String body_file_name = file_name + ".body";
		String attach_file_name = "";
		if(Common.isEquals(csvYn, "Y")) {
			attach_file_name = file_name + ".csv";
		} else {
			attach_file_name = file_name + ".xlsx";
		}

		String directory = MailInfo.ALARM_PATH + nowTime + MailInfo.SLASH;
		Common.mkdirs(directory + MailInfo.SUCCESS);

		StringBuffer info = new StringBuffer();
		info.append("RESULT : ").append(totalCnt).append(MailInfo.ENTER);
		info.append("SUBJECT : ")/* .append ( "[EMASS_LT]" ) */.append(subject).append(MailInfo.ENTER);
		info.append("FROM : ").append(from).append(MailInfo.ENTER);
		info.append("TO : ").append(to).append(MailInfo.ENTER);
		info.append("CC : ").append(cc).append(MailInfo.ENTER);
		info.append("BODY : ").append(directory + body_file_name).append(MailInfo.ENTER);
		info.append("ATTACH : ").append(directory + attach_file_name);

		BufferedWriter info_bw = null;
		BufferedWriter body_bw = null;
		try {
			// Body파일 해당 경로에 저장
			body_bw = new BufferedWriter(new FileWriter(directory + body_file_name));
			body_bw.write(body);

			// 첨부파일 해당경로로 복사
			FileUtils.moveFile(new File(attach_path), new File(directory + attach_file_name));

			// Info파일 해당 경로에 저장
			info_bw = new BufferedWriter(new FileWriter(directory + info_file_name));
			info_bw.write(info.toString());

			log.warn(directory + "에 메일 알림 파일이 저장되었습니다. FileName : " + file_name);
		} catch (IOException e) {
			log.warn("메일 정보를 파일로 저장 도중 에러가 발생하였습니다.");
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(info_bw);
			IOUtils.closeQuietly(body_bw);
		}
	}

	private String getStartDt(String startDateSelect, int startTimeSelect, String alarm_cycle) {
		String result = "";
		DateTime _dt = new DateTime(DateTimeZone.forID("Asia/Seoul"));
		if (Common.isOrEquals(alarm_cycle, "D", "W")) {
			if (startDateSelect.equals("Y")) result = String.format("%s%02d0000", yyyyMMdd.print(_dt.minusHours(1)), startTimeSelect);
			else if(startDateSelect.equals("T")) result = String.format("%s%02d0000", yyyyMMdd.print(DateTime.now()), startTimeSelect);
			else if(startDateSelect.equals("W")) result = String.format("%s%02d0000", yyyyMMdd.print(_dt.minusDays(7)), startTimeSelect);
			else if (startDateSelect.equals("M")) result = String.format("%s%02d0000", yyyyMMdd.print(_dt.minusMonths(1)), startTimeSelect);
		} else if (alarm_cycle.equals("H")) result = String.format("%s0000", yyyyMMddHH.print(_dt.minusHours(1))); /*변경해야함*/

		return result;
	}

	private String getEndDt(String endDateSelect, int endTimeSelect, String alarm_cycle) {
		String result = "";
		DateTime _dt = new DateTime(DateTimeZone.forID("Asia/Seoul"));
		if (Common.isOrEquals(alarm_cycle, "D", "W")) {
			if (endDateSelect.equals("Y")) result = String.format("%s%02d5959", yyyyMMdd.print(_dt.minusDays(1)), endTimeSelect);
			else if(endDateSelect.equals("T")) result = String.format("%s%02d5959", yyyyMMdd.print(DateTime.now()), endTimeSelect);
			else if(endDateSelect.equals("W")) result = String.format("%s%02d5959", yyyyMMdd.print(_dt.minusDays(7)), endTimeSelect);
			else if (endDateSelect.equals("M")) result = String.format("%s%02d5959", yyyyMMdd.print(_dt.minusMonths(1)), endTimeSelect); // 한 달 전
		} else if (alarm_cycle.equals("H")) result = String.format("%s5959", yyyyMMddHH.print(_dt.minusHours(1)));


		return result;
	}

	private String setSubjectData(String subject, String alarmName, long totalCount, String startDt, String endDt) {
		String period = getDateFormat(startDt) + " ~ " + getDateFormat(endDt);

		String[] keys = {"#SUBJECT#", "#SEND_DATE#", "#RESULTCOUNT#", "#PERIOD#"};
		String[] vals = {alarmName, yyyyMMddHHmmss.print(DateTime.now()), String.valueOf(totalCount), period};

		for (int i = 0; i < keys.length; i++) {
			while (subject.indexOf(keys[i]) > -1) {
				String start = subject.substring(0, subject.indexOf(keys[i]));
				String end = subject.substring(subject.indexOf(keys[i]) + keys[i].length(), subject.length());
				subject = start + vals[i] + end;
			}
		}

		return subject;
	}

	/**
	 *
	 * @return
	 */
	public String getHTMLBody(String alarmName, long totalCount, String startDt, String endDt, String searchStr, String senders, String receivers, String receiveSend, String rcvTo, String rcvCc, String rcvBcc, String rcvJikgub, String searchField, String allOfus, String sizeStartVal, String sizeOption, String sizeEndVal, String attachYn, String attachStr, String keywordYn, String keywordStr, String busi, String dept, String jikgub, String readYn, String serviceType, String infoType, String feedbackType, String probType, String interGroup, String regexpYn, String regexpStr) {
		// LOG.warn (alarmName+" "+totalCount+" "+ startDt+" "+ endDt+" "+
		// searchStr+" "+ sender+" "+ receiver+" "+ receiveSend+" "+ chkField+"
		// "+ mustSearchKey+" "+ nonSearchKey+" "+
		// not_sender+" "+ not_receiver+" "+ url+" "+ not_url+" "+ receive_out+"
		// "+ min_msg_size+" "+ max_msg_size+" "+
		// attachedYn+" "+ attach_list+" "+ not_attach+" "+ keywordYn+" "+
		// keyword_list+" "+ not_keyword+" "+ busi_list+" "+ not_busi+" "+
		// dept_list+" "+ not_dept+" "+ service_list+" "+ not_service+" "+
		// usergroup_list+" "+ not_usergroup+" "+ personalInfo_list);

		if (receiveSend.equals("S")) receiveSend = Prop.propFormat("condition.send", locale);
		else if (receiveSend.equals("R")) receiveSend = Prop.propFormat("condition.receive", locale);
		else receiveSend = Prop.propFormat("common.msg.all", locale);

		startDt = getDateFormat(startDt);
		endDt = getDateFormat(endDt);

		String total = String.format("%,d", totalCount);
		String msgSize = "";
		if (sizeEndVal != "") {
			if (sizeStartVal != "") msgSize = Common.numberFormatter(sizeStartVal) + " KB ~" + Common.numberFormatter(sizeEndVal) + " KB";
			else {
				msgSize = "~ " + Common.numberFormatter(sizeEndVal) + "KB";
				if (sizeOption.equals("L")) msgSize += Prop.propFormat("condition.over", locale);
				else if (sizeOption.equals("S")) msgSize += Prop.propFormat("condition.below", locale);
			}
		}

		StringBuffer _sb = new StringBuffer();
		_sb.append(" <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> ");
		_sb.append(" <html> ");
		_sb.append(" <head> ");
		_sb.append(" <title>EMASS LTH</title> ");
		_sb.append(" <meta http-equiv='Content-Type' content='text/html; charset=utf-8' /> ");
		_sb.append(" <base target='_blank' /> ");
		_sb.append(" <style type='text/css'> ");
		_sb.append(" body ");
		_sb.append(" { ");
		_sb.append(" 	font-family		: 돋움,나눔고딕,Tahoma, Verdana, Arial, sans-serif; ");
		_sb.append(" 	font-size		: 12px; padding-left	: 10px; ");
		_sb.append(" 	padding-right	: 5px; ");
		_sb.append(" 	padding-top		: 10px; ");
		_sb.append(" } ");
		_sb.append(" </style> ");
		_sb.append(" </head> ");
		_sb.append(" <body> ");
		_sb.append(" <table style='width: 800px;' border='0' cellspacing='0' cellpadding='0'> ");
		_sb.append("	<tr> ");
		_sb.append("		<td> ");
		_sb.append("			<span style='color:#3565BD;font-weight: bold;'>▒ EMASS LTH "+Prop.propFormat("SETTING.RESERVATION_ALARM", locale)+" </span> ");
		_sb.append("		</td> ");
		_sb.append("	</tr> ");
		_sb.append("	<tr> ");
		_sb.append("		<td style='background-color: #cccccc'> ");
		_sb.append("			<table style='width: 100%;' border='0' align='center' cellpadding='4' cellspacing='1'> ");
		_sb.append("				<colgroup> ");
		_sb.append("					<col width='100' /> ");
		_sb.append("					<col width='*' /> ");
		_sb.append("				</colgroup> ");
		_sb.append("				<tr style='height: 1px;background-color: #5BC6FF'> ");
		_sb.append("					<td style='height: 1px;background-color: #5BC6FF' colspan='2'></td> ");
		_sb.append("				</tr> ");
		_sb.append("				<tr style='background-color: #ffffff'> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("mail.reservation.name", locale)+"</span> ");
		_sb.append("					</td> ");
		_sb.append("					<td style='background-color: #fdfdf5;'>" + alarmName + "</td> ");
		_sb.append("				</tr> ");
		_sb.append("				<tr style='background-color: #ffffff'> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("mail.send.time", locale)+"</span> ");
		_sb.append("					</td> ");
		_sb.append("					<td style='background-color: #fdfdf5;'>" + yyyyMMddHHmmss.print(DateTime.now()) + "</td> ");
		_sb.append("				</tr> ");
		_sb.append("				<tr style='background-color: #ffffff'> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("mail.excute.result", locale)+"</span> ");
		_sb.append("					</td> ");
		_sb.append("					<td style='background-color: #fdfdf5;'>" + total + "</td> ");
		_sb.append("				</tr> ");
		_sb.append("				<tr style='background-color: #ffffff'> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.period", locale)+"</span> ");
		_sb.append("					</td> ");
		_sb.append("					<td style='background-color: #fdfdf5;'>" + startDt + " ~ " + endDt + "</td> ");
		_sb.append("				</tr> ");
		_sb.append("				<tr style='background-color: #ffffff'> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.receive_send", locale)+"</span> ");
		_sb.append("					</td> ");
		_sb.append("					<td style='background-color: #fdfdf5;'>" + receiveSend + "</td> ");
		_sb.append("				</tr> ");
		if (!searchStr.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.search_str", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + searchStr + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!searchField.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.field.search", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + searchField + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!senders.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.sender", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + senders + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!receivers.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.recv", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + receivers + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!rcvTo.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.recv", locale)+"("+Prop.propFormat("condition.to", locale)+")</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + rcvTo + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!rcvCc.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.recv", locale)+"("+Prop.propFormat("condition.cc", locale)+")</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + rcvCc + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!rcvBcc.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.recv", locale)+"("+Prop.propFormat("condition.bcc", locale)+")</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + rcvBcc + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!rcvJikgub.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.recv_jikgub", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + rcvJikgub.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!msgSize.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("common.msg.message_size", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + msgSize + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!attachYn.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.isattached", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + attachYn + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!attachStr.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("consent.attach", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + attachStr + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!keywordYn.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.iskeyword", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + keywordYn + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!keywordStr.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.keyword", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + keywordStr.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!regexpYn.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.regexp.isdetect", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + regexpYn + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!regexpStr.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.regexp", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + regexpStr.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!busi.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("common.org.busi", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + busi.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!dept.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("common.org.dept", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + dept.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!readYn.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.isread", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + readYn + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!serviceType.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("filterInfo.servicetype", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + serviceType.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!infoType.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.infotype", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + infoType.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!feedbackType.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.feedback", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + feedbackType.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!probType.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.prob", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + probType.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		if (!interGroup.equals("")) {
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #EDF9FE;'> ");
			_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("interest.user", locale)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'>" + interGroup.replace("|", ", ") + "</td> ");
			_sb.append("				</tr> ");
		}
		_sb.append ( "				<tr style='height: 1px;background-color: #ffffff'> " );
		_sb.append ( "					<td height='1' colspan='2' bgcolor='#5BC6FF'></td> " );
		_sb.append ( "				</tr> " );
		_sb.append ( "			</table> " );
		_sb.append ( "		</td> " );
		_sb.append ( "	</tr> " );
		_sb.append ( "	<tr> " );
		_sb.append ( "		<td>&nbsp;</td> " );
		_sb.append ( "	</tr> " );
		_sb.append ( "</table> " );
		_sb.append ( "</body> " );
		_sb.append ( "</html> " );

		return _sb.toString();
	}

	public String getAlarmHTMLBody(Map<String, List<String>> param) {

		log.info("getAlarmHTMLBody start!!!!!");

		List<String> msgIdList = new ArrayList<String>();
		List<String> attachNameList = new ArrayList<String>();
		List<String> securityYnList = new ArrayList<String>();
		List<String> securityPctList = new ArrayList<String>();

		//list별로 map에서 값 꺼내기
		msgIdList = param.get("msgIdList");
		attachNameList = param.get("attachNameList");
		securityYnList = param.get("securityYnList");
		securityPctList = param.get("securityPctList");

		StringBuffer _sb = new StringBuffer();
		_sb.append(" <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> ");
		_sb.append(" <html> ");
		_sb.append(" <head> ");
		_sb.append(" <title>EMASS LTH</title> ");
		_sb.append(" <meta http-equiv='Content-Type' content='text/html; charset=utf-8' /> ");
		_sb.append(" <base target='_blank' /> ");
		_sb.append(" <style type='text/css'> ");
		_sb.append(" body ");
		_sb.append(" { ");
		_sb.append(" 	font-family		: 돋움,나눔고딕,Tahoma, Verdana, Arial, sans-serif; ");
		_sb.append(" 	font-size		: 12px; padding-left	: 10px; ");
		_sb.append(" 	padding-right	: 5px; ");
		_sb.append(" 	padding-top		: 10px; ");
		_sb.append(" } ");
		_sb.append(" </style> ");
		_sb.append(" </head> ");
		_sb.append(" <body> ");
		_sb.append(" <table style='width: 1250px;' border='0' cellspacing='0' cellpadding='0'> ");
		_sb.append("	<tr> ");
		_sb.append("		<td> ");
		_sb.append("			<p style='color:#000000;font-weight: bold;'> 외부로 발송되는 첨부파일이 포함된 메일을 대상으로 비밀문서로 판단된 메일 리스트입니다. </p> ");
		_sb.append("		</td> ");
		_sb.append("	</tr> ");
		_sb.append("	<tr> ");
		_sb.append("	<tr> ");
		_sb.append("		<td> ");
		_sb.append("			<span style='color:#3565BD;font-weight: bold;'>▒ EMASS LTH "+Prop.propFormat("SETTING.RESERVATION_ALARM", locale)+" </span> ");
		_sb.append("		</td> ");
		_sb.append("	</tr> ");
		_sb.append("	<tr> ");
		_sb.append("		<td style='background-color: #cccccc'> ");
		_sb.append("			<table style='width: 100%;' border='0' align='center' cellpadding='5' cellspacing='1'> ");
		_sb.append("				<colgroup> ");
		_sb.append("					<col width='100' /> ");
		_sb.append("					<col width='*' /> ");
		_sb.append("				</colgroup> ");
		_sb.append("				<tr style='height: 1px;background-color: #5BC6FF'> ");
		_sb.append("					<td style='height: 1px;background-color: #5BC6FF' colspan='5'></td> ");
		_sb.append("				</tr> ");
		_sb.append("				<tr style='background-color: #ffffff'> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+"NUM"+"</span> ");	//테이블 맨 위의 내용, num 숫자 나타냄
		_sb.append("					</td> ");
		_sb.append("					<td style='background-color: #EDF9FE;'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("common.msg.msgid", locale)+"</span> ");	//테이블 맨 위의 내용, msgid
		_sb.append("					</td> ");
		_sb.append("					<td style='width:4000px; background-color: #EDF9FE'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.attach_name", locale)+"</span> ");	//첨부 파일명
		_sb.append("					</td> ");
		_sb.append("					<td style='width:800px; background-color: #EDF9FE'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.itype", locale)+"</span> ");	//문서분류
		_sb.append("					</td> ");
		_sb.append("				<td style='width:1010px; background-color: #EDF9FE'> ");
		_sb.append("						<span style='color: #003366'>&nbsp;&nbsp;&#8226;&nbsp;"+Prop.propFormat("condition.sprob", locale)+"(%)</span> ");	//비밀확률
		_sb.append("					</td> ");
		_sb.append("				</tr> ");

		for(int i=0; i < msgIdList.size(); i++) {
			int j = i + 1;
			String s = securityYnList.get(i);
			if(s.equals("Y")){
				s = "비밀 문서";
			}else {
				s = "대외비 문서";
			}
			_sb.append("				<tr style='background-color: #ffffff'> ");
			_sb.append("					<td style='background-color: #fdfdf5;'> ");
			_sb.append("						<span style='color: #003366'>"+j+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'> ");
			_sb.append("						<a href='http://localhost:8998/emass/ems/contentBodyNew.do?msgid="+msgIdList.get(i)+"'>"+msgIdList.get(i)+"</a> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='background-color: #fdfdf5;'> ");
			_sb.append("						<span style='color: #003366'>"+attachNameList.get(i)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='text-align:center; background-color: #fdfdf5;'> ");
			_sb.append("						<span style='color: #003366'>"+s+"</span> ");
			_sb.append("					</td> ");
			_sb.append("					<td style='text-align:right; background-color: #fdfdf5;'> ");
			_sb.append("						<span style='color: #003366'>"+securityPctList.get(i)+"</span> ");
//			_sb.append("						<span style='color: #003366'>"+securityPctList.get(i)+"</span> ");
			_sb.append("					</td> ");
			_sb.append("				</tr> ");
		}

		_sb.append ( "				<tr style='height: 1px;background-color: #ffffff'> " );
		_sb.append ( "					<td height='1' colspan='5' bgcolor='#5BC6FF'></td> " );
		_sb.append ( "				</tr> " );
		_sb.append ( "			</table> " );
		_sb.append ( "		</td> " );
		_sb.append ( "	</tr> " );
		_sb.append ( "	<tr> " );
		_sb.append ( "		<td>&nbsp;</td> " );
		_sb.append ( "	</tr> " );
		_sb.append ( "</table> " );
		_sb.append ( "</body> " );
		_sb.append ( "</html> " );

		String s = _sb.toString();
		byte[] bytes;
		try {
			bytes = s.getBytes("euc-kr");
			String newStr = new String(bytes,"utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return _sb.toString();
	}

	private String setBodyData(String form, String alarmName, long totalCount, String startDt, String endDt, String searchStr, String senders, String receivers, String receiveSend, String rcvTo, String rcvCc, String rcvBcc, String rcvJikgub, String searchField, String allOfus, String sizeStartVal, String sizeOption, String sizeEndVal, String attachYn, String attachStr, String keywordYn, String keywordStr, String busi, String dept, String jikgub, String readYn, String serviceType, String infoType, String feedbackType, String probType, String interGroup, String regexpYn, String regexpStr) {

		String period = getDateFormat(startDt) + " ~ " + getDateFormat(endDt);
		String msgSize = "";
		if (sizeEndVal != "") {
			if (sizeStartVal != "") msgSize = Common.numberFormatter(sizeStartVal) + " KB ~" + Common.numberFormatter(sizeEndVal) + " KB";
			else {
				msgSize = "~ " + Common.numberFormatter(sizeEndVal) + "KB";
				if (sizeOption.equals("L")) msgSize += Prop.propFormat("condition.over", locale);
				else if (sizeOption.equals("S")) msgSize += Prop.propFormat("condition.below", locale);
			}
		}

		if (receiveSend.equals("S")) receiveSend = Prop.propFormat("condition.send", locale);
		else if (receiveSend.equals("R")) receiveSend = Prop.propFormat("condition.receive", locale);
		else receiveSend = Prop.propFormat("common.msg.all", locale);

		String[] keys = {"#SUBJECT#", "#SEND_DATE#", "#RESULTCOUNT#", "#PERIOD#", "#RECEIVESEND#", "#SEARCHKEY#", "#SEARCHFIELD#", "#SENDERS#", "#RECEIVERS#", "#RCVTO#", "#RCVCC#", "#RCVBCC#", "#RCVJIKGUB#", "#MESSAGE_SIZE#", "#ATTACHEYN#", "#ATTACHSTR#", "#KEYWORDYN#", "#KEYWORDSTR#", "#REGEXPYN#", "#REGEXPSTR#", "#BUSI#", "#DEPT#", "#READYN#", "#SERVICETYPE#", "#INFOTYPE#", "#FEEDBACKTYPE#", "#PROBTYPE#", "#INTERGROUP#"};
		String[] vals = {alarmName, yyyyMMddHHmmss.print(DateTime.now()), String.valueOf(totalCount), period, receiveSend, searchStr, searchField, senders, receivers, rcvTo, rcvCc, rcvBcc, rcvJikgub.replace("|", ", "), msgSize, attachYn, attachStr, keywordYn, keywordStr.replace("|", ", "), regexpYn, regexpStr.replace("|", ", "), busi.replace("|", ", "), dept.replace("|", ", "), readYn, serviceType.replace("|", ", "), infoType.replace("|", ", "), feedbackType.replace("|", ", "), probType.replace("|", ", "), interGroup.replace("|", ", ")};
		for (int i = 0; i < keys.length; i++) {
			while (form.indexOf(keys[i]) > -1) {
				String start = form.substring(0, form.indexOf(keys[i]));
				String end = form.substring(form.indexOf(keys[i]) + keys[i].length(), form.length());
				form = start + vals[i] + end;
			}
		}

		return form;

	}

	public String getDateFormat(String str) {
		return String.format("%s-%s-%s %s:%s:%s", str.substring(0, 4), str.substring(4, 6), str.substring(6, 8), str.substring(8, 10), str.substring(10, 12), str.substring(12, 14));
	}
}
