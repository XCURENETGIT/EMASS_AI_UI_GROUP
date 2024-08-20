package com.xcurenet.emass.message.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.csv.CsvWriterEMASS;
import com.xcurenet.common.detect.DetectCharset;
import com.xcurenet.common.detect.DetectHtml;
import com.xcurenet.common.excel.XLSXWriterEMASS;
import com.xcurenet.common.mail.MailInfo;
import com.xcurenet.common.parser.mime.MimeParser;
import com.xcurenet.common.parser.mime.MimeVo;
import com.xcurenet.common.pdf.PdfWriterEMASS;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.KafkaProducerService;
import com.xcurenet.common.util.TimeUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.consent.web.ConsentFileDownload;
import com.xcurenet.emass.consent.web.ConsentFileVO;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.util.JSONUtils;
import org.apache.catalina.connector.ClientAbortException;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.io.IOUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.SortClause;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;
import org.jsoup.select.Elements;
import org.jsoup.select.NodeVisitor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.charset.Charset;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Log4j2
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.MESSAGE_INFO)
public class EmsMessageController {

	public static String DEFAULT_HTML = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n<html>\n<head>\n<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">\n<base target=\"_blank\"/>\n<style type=\"text/css\">*{font-family:\"굴림\",\"돋움\",Dotum,Helvetica,\"Apple SD Gothic Neo\",Sans-serif;font-size:9.5pt;}\nbody{padding-left:10px;padding-right:5px;padding-top:10px;}</style>\n<body>%s</body>\n</html>";
	public static final String DEFAULT_ENCODING = "EUC-KR";
	private static DateTimeFormatter yyyy_MM_dd = DateTimeFormat.forPattern("yyyy-MM-dd");
	private static int PAGE_BREAK = 10000;

	private static String bodyhtmlPrefix = "<table class='response'><tbody>";
	private static String bodyhtmlSuffix = "</tbody></table>";


	@Resource(name = "emsMessageService")
	public EmsMessageService emsMessageService;

	@Autowired
	public MessengerController messengerController;

	@Resource(name = "solrEdcService")
	public SolrEdcService solrEdcService;

	@Resource(name = "configAdminService")
	private ConfigAdminService configAdminService;

	@Autowired
	public SolrCheckedService solrCheckedService;

	@Autowired
	public EmsAttachDownload emsAttachDownload;

	@Autowired
	public DownloadBatchService downloadBatchService;

	@Autowired
	public ConsentFileDownload consentFileDownload;

	@Autowired
	public Config conf;

	@Resource
	private KafkaProducerService kafkaProducerService; // kafka

	private String kafka_feedback_idx = "ems_ui_ml_feedback_index";


	@Autowired
	public MinioFileAdapter minioFileAdapter;


	@RequestMapping(value = "/getEmassBody.xcn")
	@Description("EMASS 메시지 본문 조회")
	@ResponseBody
	public void getEmassBody(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Disposition", "inline");

		String msgId = Common.nvl(request.getParameter("msgId"));
		String userCharset = Common.nvl(request.getParameter("userCharset"));

		InputStream in = null;
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
			if (emsBody != null) {
				in = getBodyStream(response, userCharset, emsBody);
			}
			if (in == null) {
				in = new ByteArrayInputStream(Prop.propFormat("common.msg.nocontent", request).getBytes());
			}
			IOUtils.copy(in, out);
		} catch (Exception e) {
			log.error("", e);
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
		}
	}

	@RequestMapping(value = "/emassMailForward.xcn")
	@Description("EMASS 메일 전달")
	@AuditOperation(Operation.MAIL_SEND)
	@ResponseBody
	public XcnResponseVO emassMailForward(final HttpServletRequest request) throws Exception {
		String xRootMtr = Common.nvl(request.getParameter("xRootMtr"));
		String msgId = Common.nvl(request.getParameter("msgId"));
		String userCharset = Common.nvl(request.getParameter("userCharset"));
		String subject = Common.nvl(request.getParameter("subject"));
		String bodyStr = Common.nvl(request.getParameter("body"));
		String from = Common.nvl(request.getParameter("from"));
		String to = Common.nvl(request.getParameter("to"));
		String cc = Common.nvl(request.getParameter("cc"));

		Document bodyDoc = Jsoup.parse(bodyStr);

		String emsBodyStr = "";
		try {
			if (Common.isNotEmpty(msgId)) {
				EmsMessageVO msg = emsMessageService.getEmassMessage(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
				EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
				if (Common.isNotEmpty(emsBody.getBody())) {
					emsBodyStr = getBodyStrProc(userCharset, emsBody);
					if (Common.isEmpty(emsBodyStr)) {
						String svc = Common.nvl(msg.getSvc());
						if (Common.nvl(svc).startsWith("Q")) {
							if (Common.nvl(svc).indexOf("J") == 3) emsBodyStr = Prop.propFormat("common.messenger.join");
							else if (Common.nvl(svc).indexOf("L") == 3) emsBodyStr = Prop.propFormat("common.messenger.leave");
						}
					}
				}
			} else {
				Locale locale = Common.getLocale(request.getSession());
				MessengerEdcGroupVO groups = messengerController.getMessengerMsgTotal(request);
				List<MessengerGroupVO> list = groups.getGroups();
				emsBodyStr = getGroupStyle() + messengerController.getGroupBody(list, xRootMtr, locale);
			}
			if (Common.isNotEmpty(emsBodyStr)) {
				Document doc = Jsoup.parse(emsBodyStr, Common.UTF8);
				Elements meta = doc.getElementsByTag("meta");
				if (!meta.isEmpty()) {
					meta.before("<meta charset='UTF-8'>");
				} else {
					Elements head = doc.getElementsByTag("head");
					if (!head.isEmpty()) {
						head.get(0).append("<meta charset='UTF-8'>");
					}
				}
				emsBodyStr = doc.html();
			}

			String nowTime = yyyy_MM_dd.print(DateTime.now()).toString();
			String directory = MailInfo.ALARM_PATH + nowTime + MailInfo.SLASH;
			Common.mkdirs(directory + MailInfo.SUCCESS);

			String name = Common.getNextID();
			String info = directory + name + ".info";
			String body = directory + name + ".body";
			//String attach = directory + name + ".html";

			StringBuffer infoSb = new StringBuffer();
			infoSb.append("SUBJECT : ").append(subject).append(MailInfo.ENTER);
			infoSb.append("FROM : ").append(from).append(MailInfo.ENTER);
			infoSb.append("TO : ").append(to).append(MailInfo.ENTER);
			infoSb.append("CC : ").append(cc).append(MailInfo.ENTER);
			infoSb.append("BODY : ").append(body).append(MailInfo.ENTER);
			//if(Common.isNotEmpty(emsBodyStr)) infoSb.append("ATTACH : ").append(attach);


			/* body load */


			createInfo(bodyDoc.html(), body);
			//if(Common.isNotEmpty(emsBodyStr)) createInfo(emsBodyStr, attach);
			createInfo(infoSb.toString(), info);

			return new XcnResponseVO(XcnRspCode.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new XcnResponseVO(XcnRspCode.OK_CUSTOM, Prop.propFormat("java.error.create.mail", request));
	}

	@RequestMapping(value = "/emassWarningMail.xcn")
	@Description("EMASS 경고 메일")
	@AuditOperation(Operation.MAIL_SEND)
	@ResponseBody
	public XcnResponseVO emassWarningMail(final HttpServletRequest request) throws Exception {
		String xRootMtr = Common.nvl(request.getParameter("xRootMtr"));
		String msgId = Common.nvl(request.getParameter("msgId"));
		String userCharset = Common.nvl(request.getParameter("userCharset"));
		String subject = Common.nvl(request.getParameter("subject"));
		String bodyStr = Common.nvl(request.getParameter("body"));
		String from = Common.nvl(request.getParameter("from"));
		String to = Common.nvl(request.getParameter("to"));
		String cc = Common.nvl(request.getParameter("cc"));
		Document bodyDoc = Jsoup.parse(bodyStr);

		String emsBodyStr = "";
		try {
			if (Common.isNotEmpty(msgId)) {
				EmsMessageVO msg = emsMessageService.getEmassMessage(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
				EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
				if (Common.isNotEmpty(emsBody.getBody())) {
					emsBodyStr = getBodyStrProc(userCharset, emsBody);
					if (Common.isEmpty(emsBodyStr)) {
						String svc = Common.nvl(msg.getSvc());
						if (Common.nvl(svc).startsWith("Q")) {
							if (Common.nvl(svc).indexOf("J") == 3) emsBodyStr = Prop.propFormat("common.messenger.join");
							else if (Common.nvl(svc).indexOf("L") == 3) emsBodyStr = Prop.propFormat("common.messenger.leave");
						}
					}
				}
			} else {
				Locale locale = Common.getLocale(request.getSession());
				MessengerEdcGroupVO groups = messengerController.getMessengerMsgTotal(request);
				List<MessengerGroupVO> list = groups.getGroups();
				emsBodyStr = getGroupStyle() + messengerController.getGroupBody(list, xRootMtr, locale);
			}
			if (Common.isNotEmpty(emsBodyStr)) {
				Document doc = Jsoup.parse(emsBodyStr, Common.UTF8);
				Elements meta = doc.getElementsByTag("meta");
				if (meta != null && meta.size() > 0) {
					meta.before("<meta charset='UTF-8'>");
				} else {
					Elements head = doc.getElementsByTag("head");
					if (head != null && head.size() > 0) {
						head.get(0).append("<meta charset='UTF-8'>");
					}
				}
				emsBodyStr = doc.html();
			}

			String nowTime = yyyy_MM_dd.print(DateTime.now()).toString();
			String directory = MailInfo.ALARM_PATH + nowTime + MailInfo.SLASH;
			Common.mkdirs(directory + MailInfo.SUCCESS);

			String name = Common.getNextID();
			String info = directory + name + ".info";
			String body = directory + name + ".body";
			String attach = directory + name + ".html";

			StringBuffer infoSb = new StringBuffer();
			infoSb.append("SUBJECT : ").append(subject).append(MailInfo.ENTER);
			infoSb.append("FROM : ").append(from).append(MailInfo.ENTER);
			infoSb.append("TO : ").append(to).append(MailInfo.ENTER);
			infoSb.append("CC : ").append(cc).append(MailInfo.ENTER);
			infoSb.append("BODY : ").append(body).append(MailInfo.ENTER);
//			if (Common.isNotEmpty(emsBodyStr)) infoSb.append("ATTACH : ").append(attach);

			createInfo(bodyDoc.html(), body);
			if (Common.isNotEmpty(emsBodyStr)) createInfo(emsBodyStr, attach);
			createInfo(infoSb.toString(), info);

			return new XcnResponseVO(XcnRspCode.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new XcnResponseVO(XcnRspCode.OK_CUSTOM, Prop.propFormat("java.error.create.mail", request));
	}

	private String getGroupStyle() {
		String str = "<style>";
		str += "table.g_response, table.g_request {border-collapse: collapse !important;font-family: Dotum, \"Apple SD Gothic Neo\", Helvetica, sans-serif !important;border-top: 2px solid #036 !important;width: 100% !important;}";
		str += ".g_request th, .g_response th {padding: 7px !important;font-weight: bold !important;border-bottom: 1px solid #ccc !important;font-size: 13px !important;text-align:center !important;}";
		str += ".g_request th {background-color: #F6F6F6}";
		str += ".g_response th {background-color: #2DBDDC !important;}";
		str += ".g_response td, .g_request td {padding: 7px !important;border-bottom: 1px solid #ccc !important;word-break: break-all !important;font-size: 13px !important;}";
		str += ".date_title{background-color: #F2F8FD !important;font-size: 13px !important;text-align:center !important;}";
		str += "</style>";
		return str;
	}

	public void createInfo(String content, String path) throws Exception {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), Common.UTF8));
			bw.write(content);
			bw.flush();
		} finally {
			IOUtils.closeQuietly(bw);
		}
	}

	@RequestMapping(value = "/getEmassMessageSaveZip.xcn")
	@Description("EMASS 메시지 전체 저장")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassMessageSaveZip(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");

		JSONObject param = Common.getParam(request);

		String adminId = Common.getAdminId(request);
		Locale locale = Common.getLocale(request.getSession());

		JSONArray header = Common.toJSONArray(param.get("searchHeader"));
		String searchType = Common.nvl(param.get("searchType"));

		final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
		final String searchTime = Common.nvl(param.get("searchTime"));
		final String exportFileExt = Common.nvl(param.get("exportFileExt"), "xlsx");

		int dataLength = Common.nvz(param.get("dataLength"), 50000); //각 파일별 건수 50000
		long total = Common.nvz(param.get("searchTotal"));
		int queryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); //쿼리 실행 횟수
		int solrCnt = dataLength / PAGE_BREAK; //파일별 solr 검색 횟수
		if (dataLength > total) solrCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0));

		boolean listFlag = false;
		boolean bodyFlag = false;
		boolean attachFlag = false;

		if (searchType.indexOf("L") > -1) listFlag = true;
		if (searchType.indexOf("B") > -1) bodyFlag = true;
		if (searchType.indexOf("A") > -1) attachFlag = true;

		ServletOutputStream out = null;
		XLSXWriterEMASS xlsxWriter = null;
		try {
			out = response.getOutputStream();

			if (listFlag) log.info("{} [EXCEL/CELL Write] START", adminId);
			if (bodyFlag) log.info("{} [Body Write] START", adminId);
			if (attachFlag) log.info("{} [Attach Write] START", adminId);

			if (!bodyFlag && !attachFlag && total <= dataLength) { //본문만 1개 파일로 내려줌
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message." + exportFileExt + "\"");

				for (int i = 1; i <= queryCnt; i++) {
					xlsxWriter = createExcelFile(out, xlsxWriter, EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1).getEmass(), locale), header, Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale), total, i, solrCnt);
				}
			} else { //압축
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.zip\"");
				ArchiveOutputStream os = null;
				EmsAttachDownload attachDown = new EmsAttachDownload();
				try {
					os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
					for (int i = 1; i <= queryCnt; i++) {
						List<SolrEdcVO> emass = EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1).getEmass(), locale);

						for (SolrEdcVO edc : emass) {
							if (bodyFlag) inputZipBody(os, locale, edc, Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession()));
							if (attachFlag) inputAttach(os, attachDown, edc);
						}
						if (listFlag)
							xlsxWriter = createExcelZipFile(os, xlsxWriter, emass, header, Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale), total, i, solrCnt, bodyFlag, attachFlag, exportFileExt);
					}

				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					IOUtils.closeQuietly(os);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			response.flushBuffer();
			log.info("{} [Write] END...TOTAL : {}", adminId, total);
		}
	}

	private XLSXWriterEMASS createExcelFile(ServletOutputStream out, XLSXWriterEMASS xlsxWriter, List<SolrEdcVO> emass, JSONArray header, String title, long total, int queryCnt, int solrCnt) throws Exception {
		int totalQueryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); // 쿼리 실행 횟수

		if (queryCnt == 1) {
			xlsxWriter = new XLSXWriterEMASS(title, header, PAGE_BREAK * (queryCnt - 1));
			xlsxWriter.init();
			log.info("[Excel Write] Create New file");
		}

		xlsxWriter.appendData(emass, false, false);

		if (queryCnt == totalQueryCnt) {
			xlsxWriter.write(out);
		}

		return xlsxWriter;
	}

	private XLSXWriterEMASS createExcelZipFile(ArchiveOutputStream os, XLSXWriterEMASS xlsxWriter, List<SolrEdcVO> emass, JSONArray header, String title, long total, int queryCnt, int solrCnt, boolean bodyFlag, boolean attachFlag, String exportFileExt) throws Exception {
		int totalQueryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); // 쿼리 실행 횟수

		if (queryCnt % solrCnt == 1 || queryCnt == 1) {
			xlsxWriter = new XLSXWriterEMASS(title, header, PAGE_BREAK * (queryCnt - 1));
			xlsxWriter.init();
			log.info("[Excel Write] Create New file start");
		}

		xlsxWriter.appendData(emass, bodyFlag, attachFlag);

		if (queryCnt % solrCnt == 0 || queryCnt == totalQueryCnt) {
			long lastNum = queryCnt * PAGE_BREAK;
			long startNum = lastNum - (solrCnt) * PAGE_BREAK + 1;
			if (queryCnt == totalQueryCnt) {
				if (queryCnt == 1) startNum = 1;
				else startNum = (totalQueryCnt - (totalQueryCnt % solrCnt)) * PAGE_BREAK + 1;
			}
			if (lastNum > total) lastNum = total;
			String fileName = "list_" + startNum + "-" + lastNum + "." + exportFileExt;

			os.putArchiveEntry(new ZipArchiveEntry(fileName));
			ByteArrayInputStream bIn = null;
			ByteArrayOutputStream xOut = null;
			try {
				xOut = new ByteArrayOutputStream();
				xlsxWriter.write(xOut);
				bIn = new ByteArrayInputStream(xOut.toByteArray());

				IOUtils.copy(bIn, os);
				os.closeArchiveEntry();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				xlsxWriter = null;
				IOUtils.closeQuietly(bIn);
				IOUtils.closeQuietly(xOut);
				log.info("[Excel Write] Create New file end : {}", fileName);
			}
		}

		return xlsxWriter;
	}

	private void close(CsvWriterEMASS csvWriter, ArchiveOutputStream os) {
		try {
			if (csvWriter != null) csvWriter.close();
			if (os != null) os.closeArchiveEntry();
		} catch (Exception e) {
		}
	}

	private void close(PdfWriterEMASS pdfWriter, ArchiveOutputStream os) {
		try {
			if (pdfWriter != null) pdfWriter.close();
			if (os != null) os.closeArchiveEntry();
		} catch (Exception e) {
		}
	}

	@RequestMapping(value = "/getEmassMessageSaveCSV.xcn")
	@Description("EMASS 메시지 전체 목록 저장 CSV")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassMessageSaveCSV(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");

		String adminId = Common.getAdminId(request);
		JSONObject param = Common.getParam(request);
		Locale locale = Common.getLocale(request.getSession());
		String searchType = Common.nvl(param.get("searchType"));

		boolean bodyFlag = false;
		boolean attachFlag = false;

		if (searchType.indexOf("B") > -1) bodyFlag = true;
		if (searchType.indexOf("A") > -1) attachFlag = true;

		JSONArray header = Common.toJSONArray(param.get("searchHeader"));
		int dataLength = Common.nvz(param.get("dataLength"), 50000); //각 파일별 건수 50000
		final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
		final String searchTime = Common.nvl(param.get("searchTime"));
		long total = Common.nvz(param.get("searchTotal"));
		int queryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); //쿼리 실행 횟수
		int cnt = dataLength / PAGE_BREAK; //파일별 solr 검색 횟수
		if (dataLength > total) cnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0));

		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			log.info("{} [CSV Write] START", adminId);
			CsvWriterEMASS csvWriter = null;
			if (!bodyFlag && !attachFlag && total <= dataLength) { //본문만 1개 파일로 내려줌
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.csv\"");

				for (int i = 1; i <= queryCnt; i++) {
					if (i == 1) {
						csvWriter = new CsvWriterEMASS(header, new OutputStreamWriter(out, Common.EUCKR));
						log.info("[CSV Write] Create New file start");
					}

					csvWriter.appendData(EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1).getEmass(), locale), (i - 1) * PAGE_BREAK);

					if (i == queryCnt) {
						close(csvWriter, null);
						log.info("[CSV Write] Create New file end");
					}
				}
			} else { //zip
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.zip\"");
				ArchiveOutputStream os = null;
				EmsAttachDownload attachDown = new EmsAttachDownload();
				ByteArrayOutputStream xOut = null;
				try {
					os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);

					for (int i = 1; i <= queryCnt; i++) {
						List<SolrEdcVO> emass = EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1).getEmass(), locale);

						for (SolrEdcVO edc : emass) {
							if (bodyFlag) inputZipBody(os, locale, edc, Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession()));
							if (attachFlag) inputAttach(os, attachDown, edc);
						}

						if (i % cnt == 1 || i == 1) {
							xOut = new ByteArrayOutputStream();
							csvWriter = new CsvWriterEMASS(header, new OutputStreamWriter(xOut, Common.EUCKR));
							log.info("[CSV Write] Create New file start");
						}

						csvWriter.appendData(emass, (i - 1) * PAGE_BREAK);

						if (i % cnt == 0 || i == queryCnt) {

							long lastNum = i * PAGE_BREAK;
							long startNum = lastNum - (cnt) * PAGE_BREAK + 1;
							if (i == queryCnt) {
								if (i == 1) startNum = 1;
								else startNum = (queryCnt - (queryCnt % cnt)) * PAGE_BREAK + 1;
							}
							if (lastNum > total) lastNum = total;

							String fileName = "list_" + startNum + "-" + lastNum + ".csv";


							ByteArrayInputStream bIn = null;
							try {
								csvWriter.close();
								os.putArchiveEntry(new ZipArchiveEntry(fileName));
								bIn = new ByteArrayInputStream(xOut.toByteArray());
								IOUtils.copy(bIn, os);
								os.closeArchiveEntry();
							} catch (Exception e) {
								e.printStackTrace();
							} finally {
								csvWriter = null;
								IOUtils.closeQuietly(bIn);
								log.info("[PDF Write] Create New file end - {}", fileName);
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					IOUtils.closeQuietly(xOut);
					IOUtils.closeQuietly(os);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			response.flushBuffer();
			log.info("{} [CSV Write] END...TOTAL : {}", adminId, total);
		}
	}

	@RequestMapping(value = "/getEmassMessageSavePDF.xcn")
	@Description("EMASS 메시지 전체 목록 저장 PDF")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassMessageSavePDF(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");

		String adminId = Common.getAdminId(request);
		JSONObject param = Common.getParam(request);
		Locale locale = Common.getLocale(request.getSession());
		String searchType = Common.nvl(param.get("searchType"));

		boolean bodyFlag = false;
		boolean attachFlag = false;

		if (searchType.indexOf("B") > -1) bodyFlag = true;
		if (searchType.indexOf("A") > -1) attachFlag = true;

		JSONArray header = Common.toJSONArray(param.get("searchHeader"));
		int dataLength = Common.nvz(param.get("dataLength"), 50000); //각 파일별 건수 50000
		final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
		final String searchTime = Common.nvl(param.get("searchTime"));
		long total = Common.nvz(param.get("searchTotal"));
		int queryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); //쿼리 실행 횟수
		int solrCnt = dataLength / PAGE_BREAK; //파일별 solr 검색 횟수
		if (dataLength > total) solrCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0));

		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();

			log.info("{} [PDF Write] START", adminId);
			PdfWriterEMASS pdfWriter = null;
			if (!bodyFlag && !attachFlag && total <= dataLength) { //본문만 1개 파일로 내려줌
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.pdf\"");

				for (int i = 1; i <= queryCnt; i++) {
					if (i == 1) {
						pdfWriter = new PdfWriterEMASS(Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale), header, out);
						log.info("[PDF Write] Create New file start");
					}

					pdfWriter.appendData(EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1).getEmass(), locale), (i - 1) * PAGE_BREAK);

					if (i == queryCnt) {
						close(pdfWriter, null);
						log.info("[PDF Write] Create New file end");
					}
				}
			} else { //zip
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.zip\"");
				ArchiveOutputStream os = null;
				EmsAttachDownload attachDown = new EmsAttachDownload();
				ByteArrayOutputStream xOut = null;
				try {
					os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);

					for (int i = 1; i <= queryCnt; i++) {
						List<SolrEdcVO> emass = EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1).getEmass(), locale);

						for (SolrEdcVO edc : emass) {
							if (bodyFlag) inputZipBody(os, locale, edc, Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession()));
							if (attachFlag) inputAttach(os, attachDown, edc);
						}

						log.info("PDF TEST {} == {}", solrCnt, i);
						if (i % solrCnt == 1 || i == 1) {
							log.info("??");
							xOut = new ByteArrayOutputStream();
							pdfWriter = new PdfWriterEMASS(Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale), header, xOut);
							log.info("[PDF Write] Create New file start");
						}

						log.info("emass {}", emass.size());
						pdfWriter.appendData(emass, (i - 1) * PAGE_BREAK);


						if (i % solrCnt == 0 || i == queryCnt) {
							long lastNum = i * PAGE_BREAK;
							long startNum = lastNum - (solrCnt) * PAGE_BREAK + 1;
							if (i == queryCnt) {
								if (i == 1) startNum = 1;
								else startNum = (queryCnt - (queryCnt % solrCnt)) * PAGE_BREAK + 1;
							}
							if (lastNum > total) lastNum = total;

							log.info("PDF DOWNLOAD ?");

							String fileName = "list_" + startNum + "-" + lastNum + ".pdf";
							ByteArrayInputStream bIn = null;
							try {
								pdfWriter.close();
								os.putArchiveEntry(new ZipArchiveEntry(fileName));
								bIn = new ByteArrayInputStream(xOut.toByteArray());
								IOUtils.copy(bIn, os);
								os.closeArchiveEntry();
							} catch (Exception e) {
								e.printStackTrace();
							} finally {
								pdfWriter = null;
								IOUtils.closeQuietly(bIn);
								log.info("[Excel Write] Create New file end : {}", fileName);
							}
							log.info("[PDF Write] Create New file end - {}", fileName);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					IOUtils.closeQuietly(xOut);
					IOUtils.closeQuietly(os);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			response.flushBuffer();
			log.info("{} [PDF Write] END...TOTAL : {}", adminId, total);
		}
	}

	private SolrEdcMessageVO getEmassData(String adminId, final JSONObject condition, final String searchTime, int page) throws Exception, IOException, SolrServerException {
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = null;
		if (Common.isNotEmpty(condition.get("msgids"))) {
			sq = new SolrQuery();
			String query = Common.joinj(Common.toJSONArray(condition.get("msgids")), " ");
			String[] querys = query.split(" ");
			sq.setQuery(String.format("+msgid:(%s)", Arrays.stream(querys).map(s -> "(" + s + ")").collect(Collectors.joining(" "))));

			String sort = Common.nvl(condition.get("sort"));
			if (Common.isEmpty(sort)) {
				sq.setSort(SortClause.desc("ctime"));
				sq.addSort(SortClause.desc("msgid"));
			}
			String[] sorts = sort.split(" ");
			if (sorts.length > 1 && Common.isNotEmpty(sorts[1])) {
				if (Common.isEquals(sorts[1], "desc")) {
					sq.setSort(SortClause.desc(sorts[0]));
					sq.addSort(SortClause.desc("msgid"));
				} else {
					sq.setSort(SortClause.asc(sorts[0]));
					sq.addSort(SortClause.asc("msgid"));
				}
			}
		} else {
			sq = solrCreateQuery.createQuery(condition, adminId, searchTime);
		}

		sq.setStart(PAGE_BREAK * page);
		sq.setRows(PAGE_BREAK);
		log.info("offset : {}", PAGE_BREAK * page);
		return solrEdcService.getEmassMessage(sq, adminId, solrCreateQuery.getFinalReadYn(), solrCreateQuery.getConsentNo());
	}

	private void inputAttach(ArchiveOutputStream os, EmsAttachDownload attachDown, SolrEdcVO edc) throws Exception {
		List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(edc.getMsgid(), null);
		for (EmsAttachVO attach : attachs) {
			InputStream in = null;
			try {
				in = minioFileAdapter.findFile(attach.getAttachPath());
				//파일이 실제로 없는 경우를 대비해서 attach 폴더를 우선 생성
				String filePath = Common.makeFilepath("messages", edc.getMsgid(), "attachs", Common.removeInvalidName(attach.getAttachName()));
				if (in == null) continue;
				os.putArchiveEntry(new ZipArchiveEntry(filePath));
				IOUtils.copy(in, os);
				os.closeArchiveEntry();
			} catch (ClientAbortException e) {
				throw new Exception(e);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				IOUtils.closeQuietly(in);
			}
		}
	}

	private void inputZipBody(ArchiveOutputStream os, Locale locale, SolrEdcVO edc, String firstAdminYn, String adminId, String adminType) throws Exception {
		EmsBodyVO emsBody = emsMessageService.getEmassBody(edc.getMsgid(), firstAdminYn, adminType);
		InputStream in = null;
		try {
			String body = new EmsCreateMessage(locale).getHeaderMessage(edc.getMsgid(), getBodyStr(null, emsBody), null, locale, firstAdminYn, adminId, adminType);
			if (body != null) {
				in = new ByteArrayInputStream(body.getBytes());

				os.putArchiveEntry(new ZipArchiveEntry(String.format("/messages/%s/body.html", edc.getMsgid())));
				IOUtils.copy(in, os);
				os.closeArchiveEntry();
			} else {
				in = new ByteArrayInputStream("no data".getBytes());
				os.putArchiveEntry(new ZipArchiveEntry(String.format("/messages/%s/", edc.getMsgid())));
				IOUtils.copy(in, os);
				os.closeArchiveEntry();
			}
		} catch (ClientAbortException e) {
			throw new Exception(e);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
		}
	}



	@RequestMapping(value = "/getEmassBodyStr.xcn")
	@Description("EMASS 메시지 본문 조회")
	@AuditOperation(Operation.BODY_VIEW)
	@ResponseBody
	public XcnResponseVO getEmassBodyStr(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String userCharset = Common.nvl(request.getParameter("userCharset"));
		EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
		return new XcnResponseVO(XcnRspCode.OK, getBodyStr(userCharset, emsBody));
	}




//	@RequestMapping(value = "/getEmassBodyStr.xcn")
//	@Description("EMASS 메시지 본문 조회")
//	@AuditOperation(Operation.BODY_VIEW)
//	@ResponseBody
//	public XcnResponseVO getEmassBodyStr(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
//		List<String> keywordList = new ArrayList<>();
//		String msgId = Common.nvl(request.getParameter("msgId"));
//		String userCharset = Common.nvl(request.getParameter("userCharset"));
//
//
//		//  검출 내역 미리보기에 사용될 검색어,예약어
//		String keywords = Common.nvl(request.getParameter("keywords"));  // 예약어
//		String searchStrInput = Common.nvl(request.getParameter("searchStrInput")); // 검색어
//
//		//본문 탐지 키워드 리스트 추가
//		if (Common.isNotEmpty(keywords)) {
//			String[] keywordArr = keywords.split(", ");
//			for (String keyword : keywordArr) keywordList.add(keyword.trim());
//		}
//
//		//검색 키워드 리스트 추가
//		if (Common.isNotEmpty(searchStrInput)) keywordList.addAll(emsMessageService.keywordSeparation(searchStrInput));
//
//		//검출을 위한 리스트 all 소문자화
//		if(keywordList.size() > 0){
//			keywordList = keywordList.stream().map(m -> m.toLowerCase()).collect(Collectors.toList());
//		}
//
//		String adminId = Common.getAdminId(request);
//		ConfigAdminVO bodyPrettyOption = configAdminService.getConfAdmin("bodyPretty", adminId);
//		String bodyPretty = (Common.isNotEmpty(bodyPrettyOption)) ? Common.nvl(bodyPrettyOption.getVal()) : "N";
//		ConfigAdminVO detectPreviewOption = configAdminService.getConfAdmin("detectPreview", adminId);
//		String detectPreview = (Common.isNotEmpty(detectPreviewOption)) ? Common.nvl(detectPreviewOption.getVal()) : "N";
//
//		EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
//		return new XcnResponseVO(XcnRspCode.OK, getBodyStr(bodyPretty, detectPreview, keywordList, userCharset, emsBody));
//	}




	@RequestMapping(value = "/getEmassBodySave.xcn")
	@Description("EMASS grid 메시지 본문 저장")
	@ResponseBody
	public void getEmassBodySave(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Disposition", "inline");

		String msgId = Common.nvl(request.getParameter("msgId"));
		String userCharset = Common.nvl(request.getParameter("userCharset"));
		String print = Common.nvl(request.getParameter("print"));

		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();

			EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));


			if (Common.isNotEquals(print, "Y")) {

				String subject = EmsReDefined.reSubject(getFileName(emsBody));
				String fileName = Common.getEDCFileName(emsBody.getCtime(), emsBody.getUserId(), emsBody.getName(), subject, msgId);

				response.setContentType("application/octet-stream");
				response.setHeader("Content-Transfer-Encoding", "binary");
				response.setHeader("Connection", "close");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getEncodingFileName(request, fileName) + ".html\"");
			}
			out.write(new EmsCreateMessage(request).getHeaderMessage(msgId, getBodyStr(userCharset, emsBody), print, Common.getLocale(request.getSession()), Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession())).getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
		}
	}

	@RequestMapping(value = "/getMailEmassBody.xcn")
	@Description("전달 메일용 메시지 본문")
	@ResponseBody
	public String getMailEmassBody(final HttpServletRequest request) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String userCharset = Common.nvl(request.getParameter("userCharset"));
		String print = Common.nvl(request.getParameter("print"));

		EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
		String result = Common.nvl(new EmsCreateMessage(request).getHeaderMessage(msgId, getBodyStr(userCharset, emsBody), print, Common.getLocale(request.getSession()), Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession())));
		/*
		try {
			EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()));
			result = new EmsCreateMessage(request).getHeaderMessage(msgId, getBodyStr(userCharset, emsBody), print, Common.getLocale(request.getSession()), Common.getFirstAdminYn(request.getSession()));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}*/
		return result;
	}

	@RequestMapping(value = "/getEmassBodySaveZip.xcn")
	@Description("EMASS grid 메시지 본문 저장")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassBodySaveZip(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");

		ServletOutputStream out = null;
		ArchiveOutputStream os = null;
		try {
			out = response.getOutputStream();
			os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
			String[] msgIds = Common.toArray(request.getParameter("msgIds"), ",");
			if (msgIds.length > 0) {
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_message.zip\"");
				Locale locale = Common.getLocale(request.getSession());
				for (String msgId : msgIds) {
					EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
					InputStream in = null;
					try {
						String body = new EmsCreateMessage(locale).getHeaderMessage(msgId, getBodyStr(null, emsBody), null, locale, Common.getFirstAdminYn(request.getSession()), Common.getAdminId(request), Common.getAdminType(request.getSession()));
						if (body != null) {
							in = new ByteArrayInputStream(body.getBytes());

							String subject = EmsReDefined.reSubject(getFileName(emsBody));

							String fileName = Common.getEDCFileName(emsBody.getCtime(), emsBody.getUserId(), emsBody.getName(), subject, msgId);
							os.putArchiveEntry(new ZipArchiveEntry(fileName + ".html"));
							IOUtils.copy(in, os);
							os.closeArchiveEntry();
						}
					} catch (ClientAbortException e) {
						throw new Exception(e);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						IOUtils.closeQuietly(in);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(os);
			IOUtils.closeQuietly(out);
			response.flushBuffer();
		}
	}

	private EmsMessageVO getFileName(EmsBodyVO edc) {
		EmsMessageVO msg = new EmsMessageVO();
		if (edc == null) return msg;
		msg.setSubject(edc.getSubject());
		msg.setSvc(edc.getSvc());
		msg.setSrcIp(edc.getSrcIp());
		msg.setDstIp(edc.getDstIp());
		msg.setHost(edc.getHost());
		msg.setPath(edc.getPath());
		return msg;
	}

	@Description("EMASS 원문 내용 조회")
	public String getEmassOriginalBody(final HttpServletRequest request, final String msgId) throws Exception {
		EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
		if (emsBody == null || emsBody.getBody() == null) return Prop.propFormat("common.msg.nocontent", request);

		String charset = DetectCharset.getCharset(emsBody.getBody());
		if (charset == null || (charset != "UTF-8" && charset != "EUC-KR")) charset = DEFAULT_ENCODING;
		return Common.toString(emsBody.getBody(), charset);
	}

	@Description("EMASS 헤더 내용 조회")
	public String getEmassHeader(final HttpServletRequest request, final String msgId) throws Exception {
		EmsHeaderVO headerVo = emsMessageService.getEmassHeader(msgId);
		if (headerVo == null || headerVo.getHeader() == null) return Prop.propFormat("common.msg.nocontent", request);

		String charset = DetectCharset.getCharset(headerVo.getHeader());
		if (charset == null || (charset != "UTF-8" && charset != "EUC-KR")) charset = DEFAULT_ENCODING;
		return Common.toString(headerVo.getHeader(), charset);
	}

	@RequestMapping(value = "/getEmassHeaderDown.xcn")
	@Description("EMASS 헤더 다운로드")
	@AuditOperation(Operation.HEADER_SAVE)
	@ResponseBody
	public void getEmassHeaderDown(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Disposition", "inline");
		response.setContentType("application/octet-stream;");
		response.setHeader("Content-Disposition", "attachment; filename=" + msgId + ".txt");

		InputStream in = null;
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			EmsHeaderVO header = emsMessageService.getEmassHeader(msgId);
			if (header != null) {
				in = new ByteArrayInputStream(header.getHeader());
			}
			if (in == null) {
				in = new ByteArrayInputStream(Prop.propFormat("common.msg.nocontent", request).getBytes());
			}
			IOUtils.copy(in, out);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
		}
	}

	@RequestMapping(value = "/getEmassOriginalBodyDown.xcn")
	@Description("EMASS 원문 내용 다운로드")
	@AuditOperation(Operation.ORI_BODY_SAVE)
	@ResponseBody
	public void getEmassOriginalBodyDown(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Disposition", "inline");
		response.setContentType("application/octet-stream;");
		response.setHeader("Content-Disposition", "attachment; filename=" + msgId + ".html");

		InputStream in = null;
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			EmsBodyVO emsBody = emsMessageService.getEmassBody(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));
			if (emsBody != null) {
				String bodyStr = Common.toString(emsBody.getBody());
				EmsBodyType contentType = getEmsBodyType(bodyStr);
				if (contentType == EmsBodyType.MIME) {
					response.setHeader("Content-Disposition", "attachment; filename=" + msgId + ".eml");
				}
				in = new ByteArrayInputStream(emsBody.getBody());
			}
			if (in == null) {
				in = new ByteArrayInputStream(Prop.propFormat("common.msg.nocontent", request).getBytes());
			}
			IOUtils.copy(in, out);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(in);
		}
	}

	public static String getBodyStr(String userCharset, EmsBodyVO emsBody) throws UnsupportedEncodingException {
		if (emsBody == null) return Prop.propFormat("common.msg.nocontent");
		String body = getBodyStrProc(userCharset, emsBody);
		if (body == null) {
			return Prop.propFormat("common.msg.nocontent");
		} else if (emsBody.getSvc().startsWith("Q")) return body;
		else {
//			log.info(Jsoup.parse("&lttable&gt&lt/table&gt").body().html());
//			log.info(Jsoup.parse("&ltdiv&gt&lt/div&gt").body().html());
//			log.info(Jsoup.parse("&ltstyle&gt&lt/style&gt").body().html());
//			log.info(Jsoup.parse("&ltbutton&gt&lt/button&gt").body().html());
//			log.info(Jsoup.parse("&ltspan&gt&lt/span&gt").body().html());
//			log.info(Jsoup.parse("&lth&gt&lt/h&gt").body().html());
//			log.info(Jsoup.parse("&ltinput&gt&lt/input&gt").body().html());
//			log.info(Jsoup.parse("&ltiframe&gt&lt/iframe&gt").body().html());
//			log.info(Jsoup.parse("&ltform&gt&lt/form&gt").body().html());
//			log.info(Jsoup.parse("&lthtml&gt&lt/html&gt").body().html());
//			log.info(Jsoup.parse("&lt&gt&lt&gt").body().html()); //check
//			log.info(Jsoup.parse("dfgdfgdfg&lt&amp;&gt&lt/ffff&gt").body().html());
//			log.info(Jsoup.parse("dfgdfgdfg&lt &gt&lt/ffff&gt").body().html()); //check
//			log.info(Jsoup.parse("dfgdfgdfg&lt dfgdfg&gt&lt/ffff&gt").body().html()); //check
//			log.info(Jsoup.parse("dfgdfgdfg&ltsdfsdf &gt&lt/ffff&gt").body().html());
			Document doc = Jsoup.parse(body); //태그 변환을 위한 Jsoup Parser
			String uri = emsBody.getHost();
			if (Common.isEmpty(uri)) uri = emsBody.getSrcIp();

			doc.setBaseUri("http://" + uri);
			changeLink(doc);

			Element bodyEl = doc.body();

			reValueTag(bodyEl, "input", "type", "button");    /* submit방지 */

			replaceTagNames(bodyEl, "div#header", "div", true);
			replaceTagNames(bodyEl, "header", "xheader", true);

			replaceTagNames(bodyEl, "HTML", "XHTML", false);
			replaceTagNames(bodyEl, "META", "XMETA", false);
			replaceTagNames(bodyEl, "STYLE", "XSTYLE", true);
			replaceTagNames(bodyEl, "SCRIPT", "TEXTAREA", true);
			replaceTagNames(bodyEl, "LINK", "XLINK", true);
			replaceTagNames(bodyEl, "BUTTON", "XBUTTON", false);
			replaceTagNames(bodyEl, "BASE", "XBASE", true);
			replaceTagNames(bodyEl, "IFRAME", "XIFRAME", true);

			return doc.body().html();
		}
	}





	public static String getBodyStr(final String bodyPretty, final String previewFlag, List<String> keywordList, String userCharset, EmsBodyVO emsBody) throws UnsupportedEncodingException {
		if (emsBody == null) return Prop.propFormat("common.msg.nocontent");
		String body = getBodyStrProc(userCharset, emsBody);
		if (body == null) {
			return Prop.propFormat("common.msg.nocontent");
		}
		else if (emsBody.getSvc().startsWith("Q")) return body;
		else if(body.length() > Common.BODY_CONTEXT_SIZE ) return Common.BODY_CONTEXT_SIZE_OVER;
		else {
			if (Common.isEquals(bodyPretty, "Y")) {
				/* sanitizeAndEscape()    body 내용에 꺽쇠<>가 들어갈시 escape처리 */
				body = unknownSvcRemoveHtmlBody(emsBody, sanitizeAndEscape(body, Common.allowedTags)); // 문서 정돈 기능
			}else{
				body = sanitizeAndEscape(body, Common.allowedTags);
			}
			if (Common.isEquals(previewFlag, "Y") && (emsBody.getSvc().startsWith("U") || emsBody.getSvc().startsWith("X"))) body = bodyPreviewDetect(body, keywordList); // 키워드 검출 미리보기 기능

			Document doc = Jsoup.parse(body); //태그 변환을 위한 Jsoup Parser
			String uri = emsBody.getHost();
			if (Common.isEmpty(uri)) uri = emsBody.getSrcIp();

			doc.setBaseUri("http://" + uri);
			changeLink(doc);

			Element bodyEl = doc.body();

			reValueTag(bodyEl, "input", "type", "button");    /* submit방지 */
			replaceTagNames(bodyEl, "div#header", "div", true);
			replaceTagNames(bodyEl, "header", "xheader", true);

			replaceTagNames(bodyEl, "HTML", "XHTML", false);
			replaceTagNames(bodyEl, "META", "XMETA", false);
			replaceTagNames(bodyEl, "STYLE", "XSTYLE", true);
			replaceTagNames(bodyEl, "SCRIPT", "TEXTAREA", true);
			replaceTagNames(bodyEl, "LINK", "XLINK", true);
			replaceTagNames(bodyEl, "BUTTON", "XBUTTON", false);
			replaceTagNames(bodyEl, "BASE", "XBASE", true);
			replaceTagNames(bodyEl, "IFRAME", "XIFRAME", true);

			return doc.body().html();
		}
	}














	private static void changeLink(Document doc) {
		Elements elems = doc.select("[src]");
		for (Element elem : elems) {
			if (!elem.attr("src").equals(elem.attr("abs:src"))) {
				if (!elem.attr("src").startsWith("data:")) {
					elem.attr("src", elem.attr("abs:src"));
				}
			}
			elem.removeAttr("onerror");
		}
		elems = doc.select("[href]");
		for (Element elem : elems) {
			if (!elem.attr("href").equals(elem.attr("abs:href"))) {
				elem.attr("href", elem.attr("abs:href"));
			}
		}
		elems = doc.select("a");
		for (Element elem : elems) {
			elem.attr("target", "_blank");
		}
	}

	public static void replaceTagNames(Element els, String find, String change, boolean displayNone) {
		if (els == null) return;
		Elements findEls = els.select(find);
		if (findEls == null) return;
		findEls = findEls.tagName(change);
		if (displayNone) findEls.attr("style", "display:none");
	}

	public static void reValueTag(Element els, String find, String key, String value) {
		if (els == null) return;
		Elements findEls = els.select(find);
		if (findEls == null) return;
		findEls.attr(key, value);
	}


	public static String getBodyStrProc(String userCharset, EmsBodyVO emsBody) throws UnsupportedEncodingException {
		byte[] body = emsBody.getBody();
		String charset = Common.EMPTY;
		String bodyStr = "";
		if (Common.isEmpty(userCharset)) {
			if (body != null) {
				charset = DetectCharset.getCharset(body, 50);
			}
			if (Common.isEmpty(charset)) charset = emsBody.getBodyCharset();
			if (Common.isEmpty(charset) || charset.equals("IBM424_rtl") || charset.equals("IBM424_ltr")) charset = DEFAULT_ENCODING;
			bodyStr = Common.toString(body, Charset.forName(charset).toString());
		} else {
			charset = userCharset;
			bodyStr = Common.toString(body, charset);
		}


		EmsBodyType contentType = getEmsBodyType(bodyStr);
		log.debug("message Type : {} final chrset : {} msgId : {}", contentType, charset, emsBody.getMsgId());

		if (emsBody.getSvc().startsWith("Q")) {
			return textParser(bodyStr);
		}

		switch (contentType) {
			case MAYBE_HTML:
				return bodyStr;
			case HTML:
				return bodyStr;
			case MIME:
				MimeParser parser = new MimeParser(body, userCharset);
				MimeVo mimeVo = parser.getMimeBodyVo();
				byte[] rs = null;
				try {
					rs = IOUtils.toByteArray(mimeVo.getBody());
				} catch (IOException e) {
					e.printStackTrace();
				}
				return Common.toString(rs, Common.nvl(mimeVo.getCharset(), DEFAULT_ENCODING));
			case JSON:
				bodyStr = bodyStr.replaceAll("\r\n", "");
				return textParser(JSONSerializer.toJSON(bodyStr).toString(4, 1));
			case OTHER: // etc...
				return textParser(bodyStr);
			default:
				break;
		}
		return null;
	}

	private InputStream getBodyStream(final HttpServletResponse response, String userCharset, EmsBodyVO emsBody) throws UnsupportedEncodingException {

		byte[] body = emsBody.getBody();
		String charset = Common.EMPTY;
		log.info("mysql charset {}", charset);
		String bodyStr = "";
		if (Common.isEmpty(userCharset)) {
			if (body != null) {
				charset = DetectCharset.getCharset(body, 50);
			}
			if (Common.isEmpty(charset)) charset = emsBody.getBodyCharset();
			if (Common.isEmpty(charset)) charset = DEFAULT_ENCODING;
			log.info("final chrset {}", charset);
			bodyStr = Common.toString(body, Charset.forName(charset).toString());
		} else {
			log.info("user chrset {}", charset);
			charset = userCharset;
			bodyStr = Common.toString(body, charset);
		}

		EmsBodyType contentType = getEmsBodyType(bodyStr);
		log.info("message contentType {}", contentType);
		switch (contentType) {
			case MAYBE_HTML:
				response.setHeader("Content-Type", "text/html");
				return new ByteArrayInputStream(String.format(DEFAULT_HTML, bodyStr).getBytes());
			case HTML:
				response.setHeader("Content-Type", "text/html");
				return new ByteArrayInputStream(new String(body, charset).getBytes());
			case MIME:
				MimeParser parser = new MimeParser(body, userCharset);
				MimeVo mimeVo = parser.getMimeBodyVo();
				response.setHeader("Content-Type", "text/html");
				response.setCharacterEncoding(mimeVo.getCharset());
				return mimeVo.getBody();
			case JSON:
				response.setHeader("Content-Type", "text/plain");
				return new ByteArrayInputStream(textParser(JSONSerializer.toJSON(bodyStr).toString(4, 1)).getBytes());
			case OTHER: // messenger, etc...
				response.setHeader("Content-Type", "text/html");
				return new ByteArrayInputStream(String.format(DEFAULT_HTML, textParser(bodyStr)).getBytes());
			default:
				break;
		}
		return null;
	}

	@RequestMapping(value = "/getEmassBodyHash.xcn")
	@Description("EMASS 메시지 본문 해쉬 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassBodyHash(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassBodyHash(msgId));
	}

	@RequestMapping(value = "/getEmassKeyword.xcn")
	@Description("EMASS 예약어 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassKeyword(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassKeyword(msgId));
	}

	@RequestMapping(value = "/getEmassMessage.xcn")
	@Description("EMASS 메시지 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassMessage(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassMessage(msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession())));
	}

	@RequestMapping(value = "/getEmassMessageNew.xcn")
	@Description("EMASS 메시지 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassMessageNew(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));
//		Map<String,Object> regexpHighlight = (Map<String, Object>) param.get("regexpHighlight");
		EmsMessageVO emass = emsMessageService.getEmassMessageNew(Common.getAdminId(request), msgId, Common.getFirstAdminYn(request.getSession()), Common.getAdminType(request.getSession()));

		if (emass != null && emass.isConsentFlag()) {
			solrCheckedService.setRead(msgId, Common.getAdminId(session));
		}
//		// 정규식검색 하이라이트
//		if(emass.isConsentFlag() && !Common.isEmpty(regexpHighlight)) {
//			emass = emsMessageService.highlightCheck(emass, regexpHighlight);
//		}
		return new XcnResponseVO(XcnRspCode.OK, emass);
	}


	@RequestMapping(value = "/getEmassUserInfo.xcn")
	@Description("EMASS 사용자, 수신자, 발신자 조회")
	@ResponseBody
	public XcnResponseVO getEmassUserInfo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String uType = Common.nvl(request.getParameter("uType"));
		if (Common.isEmpty(uType)) {
			return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassUserInfo(msgId));
		} else {
			return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassUserInfo(msgId, uType));
		}
	}

	@RequestMapping(value = "/getEmassAttachInfo.xcn")
	@Description("EMASS 첨부파일 조회")
	@ResponseBody
	public XcnResponseVO getEmassAttachInfo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String msgIds = Common.nvl(request.getParameter("msgIds"));
		String attachId = Common.nvl(request.getParameter("attachId"));
		if (Common.isNotEmpty(msgIds)) {
			return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassAttachInfoConsent(msgIds, null, Common.getAdminType(request.getSession())));
		} else if (Common.isEmpty(attachId)) {
			return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassAttachInfoConsent(msgId, null, Common.getAdminType(request.getSession())));
		} else {
			return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassAttachInfo(msgId, attachId));
		}
	}

	@RequestMapping(value = "/findKeywordPages.xcn")
	@Description("EMASS 첨부파일 내용에 키워드(검색어, 예약어)가 포함된 페이지 넘버")
	@ResponseBody
	public XcnResponseVO findKeywordPages(final HttpServletRequest request) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String attachId = Common.nvl(request.getParameter("attachId"));
		String ocrYn = Common.nvl(request.getParameter("ocrYn"));
		int limit = Common.nvz(request.getParameter("limit"));
		String searchkey = Common.nvl(request.getParameter("searchkey"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.findKeywordPages(msgId, attachId, ocrYn, limit, searchkey));
	}

	@RequestMapping(value = "/getEmassAttachText.xcn")
	@Description("EMASS 첨부파일 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassAttachText(final HttpServletRequest request) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String attachId = Common.nvl(request.getParameter("attachId"));
		String ocrYn = Common.nvl(request.getParameter("ocrYn"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassAttachText(msgId, attachId, ocrYn, offset, limit));
	}

	@RequestMapping(value = "/getEmassPattern.xcn")
	@Description("EMASS 패턴 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassPattern(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassPattern(msgId));
	}

	@RequestMapping(value = "/getEmassPatternDetail.xcn")
	@Description("EMASS 패턴 상세 정보 조회")
	@ResponseBody
	public XcnResponseVO getEmassPatternDetail(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String piId = Common.nvl(request.getParameter("piId"));
		String type = Common.nvl(request.getParameter("type"));
		String attachName = Common.nvl(request.getParameter("attachName"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getEmassPatternDetail(msgId, piId, type, attachName));
	}

	@RequestMapping(value = "/downEmassAttachOne.xcn")
	@Description("EMASS 파일 다운로드")
	@ResponseBody
	public void downEmassAttachOne(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String attachId = Common.nvl(request.getParameter("attachId"));
		String prediction = Common.nvl(request.getParameter("prediction"));
		EmsAttachVO attach = emsMessageService.getEmassAttachInfo(msgId, attachId);
		emsAttachDownload.download(attach, request, response, prediction);
	}

	@RequestMapping(value = "/downEmassAttach.xcn")
	@Description("EMASS 파일 다운로드")
	@ResponseBody
	public void downEmassAttach(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String attachId = Common.nvl(request.getParameter("attachId"));
		String prediction = Common.nvl(request.getParameter("prediction"));
		List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(msgId, attachId);
		emsAttachDownload.download(attachs, request, response, prediction);
	}

	@RequestMapping(value = "/getEmassAttachInfo4DownHash.xcn")
	@Description("EMASS 파일 다운로드")
	@ResponseBody
	public void getEmassAttachInfo4DownHash(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String msgIds = Common.nvl(request.getParameter("msgIds"));
		String attachHash = Common.nvl(request.getParameter("attachHash"));
		String prediction = Common.nvl(request.getParameter("prediction"));
		List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4DownHash(msgIds, attachHash);
		emsAttachDownload.download(attachs, request, response, prediction);
	}

	@RequestMapping(value = "/downEmassAttachByMsgId.xcn")
	@Description("EMASS 파일 다운로드")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void downEmassAttachByMsgId(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String[] msgIds = Common.toArray(request.getParameter("msgIds"), ",");
		List<EmsAttachVO> attachs = new ArrayList<>();
		for (int i = 0; i < msgIds.length; i++) {
			List<EmsAttachVO> list = emsMessageService.getEmassAttachInfo4Down(msgIds[i], null);
			if (list != null) attachs.addAll(list);
		}
		emsAttachDownload.download(attachs, request, response, null);
	}

	@RequestMapping(value = "/getMessengerGroupAllSave.xcn")
	@Description("메신저 대화내용 저장(본문)")
	@ResponseBody
	public void getMessengerGroupAllSave(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		JSONObject param = Common.getParam(request);
		String msgId = Common.nvl(param.get("msgId"));
		String xRootMtr = Common.nvl(param.get("xRootMtr"));
		String print = Common.nvl(param.get("print"));

		response.setCharacterEncoding(Common.UTF8);
		response.setHeader("Cache-control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setHeader("Content-Disposition", "inline");

		if (Common.isEmpty(xRootMtr)) {
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Content-Disposition", "attachment; filename=notfound.txt\"");
			return;
		}

		Locale locale = Common.getLocale(request.getSession());

		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();

			MessengerEdcGroupVO groups = messengerController.getMessengerMsgTotal(request);
			MessengerGroupUserVO users = messengerController.getMessengerGroupUserList(request, 30000);
			List<MessengerGroupVO> list = groups.getGroups();

			String body = messengerController.getGroupBody(list, xRootMtr, locale);

			if (Common.isNotEquals(print, "Y")) {
				response.setContentType("application/octet-stream");
				response.setContentLength(body.toString().getBytes().length);
				response.setHeader("Content-Transfer-Encoding", "binary");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(messengerController.getFileName(xRootMtr, users, Common.getLocale(request.getSession())).getBytes("KSC5601"), "ISO8859_1") + ".html\"");
			}
			String htmlText = new EmsCreateMessage(request).getHeaderMessage(msgId, body, print, Common.getLocale(request.getSession()), Common.getFirstAdminYn(request.getSession()), users, Common.getAdminId(request), Common.getAdminType(request.getSession()));
			out.write(htmlText.getBytes());

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(out);
		}
	}

	@RequestMapping(value = "/getMessageGroupDetail.xcn")
	@Description("메신저 대화방 상세 목록 조회")
	@AuditOperation(Operation.BODY_VIEW)
	@ResponseBody
	public XcnResponseVO getMessageGroupDetail(final HttpServletRequest request, final HttpSession session) throws Exception {
		MessengerEdcGroupVO solrEdcGroupVO = messengerController.getMessengerMsgTotal(request);
		return new XcnResponseVO(XcnRspCode.OK, solrEdcGroupVO, solrEdcGroupVO.getNumFound());
	}

	protected static boolean mayBeJSON(String str) {
		str = str.replaceAll("\\n", "");
		if (JSONUtils.mayBeJSON(str)) {
			try {
				JSONSerializer.toJSON(str);
				return true;
			} catch (Exception e) {
				return false;
			}
		} else return false;
	}

	public static EmsBodyType getEmsBodyType(String str) {
		if (str == null) return EmsBodyType.NONE;

		String strTmp = str.toLowerCase().replaceAll(" ", "").trim();
		if (strTmp == null || strTmp.equals("")) return EmsBodyType.NONE;
			//if (Common.isEmpty(strTmp)) return EmsBodyType.NONE;
		else if (mayBeJSON(strTmp)) return EmsBodyType.JSON;
		else if (str.startsWith("<!DOCTYPE html")) return EmsBodyType.HTML;
		else if (strTmp.startsWith("mime-version") || strTmp.indexOf("message-id") > -1 || strTmp.indexOf("mime-version") > -1 || strTmp.indexOf("content-type:text/html") > -1)
			return EmsBodyType.MIME;
		else if (DetectHtml.isHtml(str)) return EmsBodyType.HTML;
		else if (strTmp.startsWith("<table") || strTmp.startsWith("<div") || strTmp.startsWith("<p") || strTmp.indexOf("<styletype='text/css'>") > -1 || strTmp.indexOf("<table") > -1 || strTmp.indexOf("<style") > -1)
			return EmsBodyType.MAYBE_HTML;
		else return EmsBodyType.OTHER;
	}

	public static String textParser(String text) {
		text = Common.escapeTag(text);
//		text = Common.nvl(text);
		return "<pre style='word-wrap: break-word;white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-break:break-all;font-size:11px;'><code>" + text + "</code></pre>";
	}

	@RequestMapping(value = "/downloadMessageFile.do")
	@Description("Background File Export Download")
	public void downloadMessageFile(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String filePath = Common.nvl(request.getParameter("downFilePath"));
		if (Common.isEmpty(filePath)) {
			log.warn(Prop.propFormat("java.error.filenotfound"));
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			response.addCookie(new Cookie("fileDownload", "false"));
			return;
		}
		File file = new File(filePath);
		if (!file.exists()) {
			log.warn(Prop.propFormat("java.error.filenotfound"));
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			response.addCookie(new Cookie("fileDownload", "false"));
			return;
		}

		ConsentFileVO attach = new ConsentFileVO();
		attach.setFileName(file.getName());
		attach.setFilePath(filePath);
		attach.setFileSize(file.length());
		consentFileDownload.download(attach, response);
	}

	@RequestMapping(value = "/getDownBatchList.xcn")
	@Description("다운로드 배치 목록 조회")
	/* @AuditOperation(Operation.SEARCH) */
	@ResponseBody
	public XcnResponseVO getDownBatchList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String exportTypeSel = Common.nvl(request.getParameter("exportTypeSel"));
		String fileExtSel = Common.nvl(request.getParameter("fileExtSel"));
		String statusSel = Common.nvl(request.getParameter("statusSel"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, downloadBatchService.getDownloadBatchList(adminId, exportTypeSel, fileExtSel, statusSel, offset, limit));
	}

	@RequestMapping(value = "/cancelDownFile.xcn")
	@Description("다운로드 배치 취소")
	@ResponseBody
	public XcnResponseVO cancelDownFile(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String statusSel = Common.nvl(request.getParameter("statusSel"));
		String downSeq = Common.nvl(request.getParameter("downSeq"));
		return new XcnResponseVO(XcnRspCode.OK, downloadBatchService.cancelDownFile(adminId, statusSel, downSeq));
	}

	@RequestMapping(value = "/cancelDownFileMessenger.xcn")
	@Description("다운로드 배치 취소")
	@ResponseBody
	public XcnResponseVO cancelDownFileMessenger(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String statusSel = Common.nvl(request.getParameter("statusSel"));
		String downSeq = Common.nvl(request.getParameter("downSeq"));
		return new XcnResponseVO(XcnRspCode.OK, downloadBatchService.cancelDownFileMessenger(adminId, statusSel, downSeq));
	}


	@RequestMapping(value = "/getDownBatchListMessenger.xcn")
	@Description("메신저다운로드 배치 목록 조회")
	/* @AuditOperation(Operation.SEARCH) */
	@ResponseBody
	public XcnResponseVO getDownBatchListMessenger(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		return new XcnResponseVO(XcnRspCode.OK, downloadBatchService.getDownloadBatchListMessenger(adminId, offset, limit));
	}


	@RequestMapping(value = "/setRead.xcn")
	@Description("메시지 읽음 여부 처리")
	@ResponseBody
	public XcnResponseVO setRead(final HttpServletRequest request, final HttpSession session) throws Exception {
		solrCheckedService.setRead(Common.nvl(request.getParameter("msgId")), Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/getHostDescription.xcn")
	@Description("HOST 설명")
	@ResponseBody
	public XcnResponseVO getHostDescription(final HttpServletRequest request, final HttpSession session) throws Exception {
		String host = Common.nvl(request.getParameter("host"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getHostDescription(host));
	}

	@RequestMapping(value = "/getHostCategory.xcn")
	@Description("HOST category")
	@ResponseBody
	public XcnResponseVO getHostCategory(final HttpServletRequest request, final HttpSession session) throws Exception {
		String host = Common.nvl(request.getParameter("host"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getHostCategory(host));
	}

	@RequestMapping(value = "/updateEmsFeedback.xcn")
	@Description("메시지 피드백 설정")
	@ResponseBody
	public XcnResponseVO updateEmsFeedback(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String[] msgId = Common.toArray(Common.nvl(request.getParameter("msgId")), ",");
		String feedback = Common.nvl(request.getParameter("feedback"));

		for (int i = 0; i < msgId.length; i++) {
			boolean isProc = emsMessageService.updateEmsFeedback(msgId[i], feedback, adminId); // mongoDB 문서 update
			if (isProc) kafkaProducerService.send(kafka_feedback_idx, "_id", msgId[i]);
		}


		return new XcnResponseVO(XcnRspCode.OK);
	}

	@RequestMapping(value = "/getSearchKeywordAuto.xcn")
	@Description("운용자별 검색어 자동완성 조회")
	@ResponseBody
	public XcnResponseVO getSearchKeywordAuto(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String searchKeyword = Common.nvl(request.getParameter("searchKeyword"));
		searchKeyword = searchKeyword.replace("/", "");

		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getSearchKeywordAuto(adminId, searchKeyword));
	}


	@RequestMapping(value = "/getRelationKeywordList.xcn")
	@Description("연관검색어 자동완성 조회")
	@ResponseBody
	public XcnResponseVO getRelationKeywordList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String searchKeyword = Common.nvl(request.getParameter("searchKeyword"));

		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getRelationKeywordList(searchKeyword));
	}


	@RequestMapping(value = "/getSearchKeywordList.xcn")
	@Description("운용자별 검색어 조회")
	@ResponseBody
	public XcnResponseVO getSearchKeywordList(final HttpServletRequest request, final HttpSession session) throws Exception {
		String adminId = Common.getAdminId(request);
		String searchKeyword = Common.nvl(request.getParameter("searchKeyword"));

		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getSearchKeywordList(adminId, searchKeyword));
	}

	@RequestMapping(value = "/insertSearchKeywordList.xcn")
	@Description("운용자별 검색어 추가")
	@ResponseBody
	public XcnResponseVO insertSearchKeywordList(final HttpServletRequest request, final EmsSearchKeywordVO searchKeyword) throws Exception {
		searchKeyword.setAdminId(Common.getAdminId(request));
		if (emsMessageService.isSearchKeywordExist(searchKeyword))
			return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("java.already.insert.searchKeyword", request, searchKeyword.getSearchKeyword()));
		else return new XcnResponseVO(XcnRspCode.OK, emsMessageService.insertSearchKeywordList(searchKeyword));
	}

	@RequestMapping(value = "/deleteSearchKeywordList.xcn")
	@Description("운용자별 검색어 삭제")
	@ResponseBody
	public XcnResponseVO deleteSearchKeywordList(final HttpServletRequest request, final EmsSearchKeywordVO searchKeyword) throws Exception {
		searchKeyword.setAdminId(Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.deleteSearchKeywordList(searchKeyword));
	}


	@RequestMapping(value = "/getRecvDomainInfo.xcn")
	@Description("수신자 도메인 조회")
	@ResponseBody
	public XcnResponseVO getRecvDomainInfo(final HttpServletRequest request, final HttpSession session) throws Exception {
		String msgId = Common.nvl(request.getParameter("msgId"));
		String inside = Common.nvl(request.getParameter("inside"));
		String recvsType = Common.nvl(request.getParameter("recvsType"));
		return new XcnResponseVO(XcnRspCode.OK, emsMessageService.getRecvDomainInfo(msgId, inside, recvsType));
	}

	@RequestMapping(value = "/getLLMAnalysis.xcn")
	@Description("LLM 내용 분석")
	@ResponseBody
	public XcnResponseVO getLLMAnalysis(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		String chat = Common.nvl(request.getParameter("chat"));

		JSONObject param = new JSONObject();
		param.put("model", conf.getLlmModel());
		param.put("prompt", chat);
		param.put("stream", false);
		log.info("llm get : {}", param.toString());

		Document doc = Jsoup.connect(conf.getLlmUrl())
				.timeout(conf.getLlmTimeout())
				.header("Content-Type", "application/json;charset=UTF-8")
				.method(Connection.Method.POST)
				.requestBody(param.toString())
				.ignoreContentType(true)
				.post();
		log.info("llm response : {}", doc.body().text());
		return new XcnResponseVO(XcnRspCode.OK, Common.toJSONObject(doc.body().text()));
	}

	@RequestMapping(value = "/insertLlmHost.xcn")
	@Description("LLM 내용 분석")
	@ResponseBody
	public XcnResponseVO insertLlmHost(final HostDescriptionVO hostDescriptionVO, final HttpServletResponse response) throws Exception {
		if (emsMessageService.isHostExist(hostDescriptionVO.getHost()))emsMessageService.updateHost(hostDescriptionVO);
		else emsMessageService.insertHost(hostDescriptionVO);

		return new XcnResponseVO(XcnRspCode.OK);
	}



	////////////////////////////////* 미분류, 모니터링 제외 추가기능 관련 메서드 *//////////////////////////

	public static List<String> getDetectContextList(List<String> keywordList, String userCharset, EmsBodyVO emsBody) throws UnsupportedEncodingException {
		List<String> resultList = new ArrayList<>();
		if (emsBody == null) return resultList;
		String body = getBodyStrProc(userCharset, emsBody);
		if (body == null)  return resultList;
		else if (emsBody.getSvc().startsWith("Q")) return null;
		else {
			String cleanBody = Common.stripNonValidChar(body);
			try {
				cleanBody = Common.stripTags(cleanBody);
				String originalText = cleanBody.replaceAll("\\n+", "");
				String compareBodyText = originalText.toLowerCase(); // 키워드 검출을 위한 소문자화
				resultList.addAll(extractKeywordsAndContext(originalText,compareBodyText, keywordList, Common.DETECT_CONTEXT_RANGE));
			} catch (final Exception e) { // jsoup 에서 처리 못하는 데이터는 무시하고 그냥 넣음
				log.info("",e);
			}
			return  resultList;
		}
	}


	/**
	 * 키워드 검출 기능
	 *
	 * @param bodyText
	 * @param keywordList
	 * @return
	 */
	private static String bodyPreviewDetect(String bodyText, List<String> keywordList) {
		String cleanBody = Common.stripNonValidChar(bodyText);
		try {
			cleanBody = Common.stripTags(cleanBody);
		} catch (final Exception e) { // jsoup 에서 처리 못하는 데이터는 무시하고 그냥 넣음
			log.info("",e);
		}

		String originalText = cleanBody.replaceAll("\\n+", "");
		String compareBodyText = originalText.toLowerCase(); // 키워드 검출을 위한 소문자화

		int mapidx = 0;
		Map<String,String> reqMap = new HashMap<>();
		List<String> contents  = extractKeywordsAndContext(originalText,compareBodyText,keywordList,30);
		for (String content : contents) {
			mapidx++;
			reqMap.put(String.format("match_%s",mapidx),String.format("<tr><th>%s</th><td>%s</td></tr>", "", content));
		}
		return bodyPreviewParse(reqMap);
	}

	/**
	 * String 리턴
	 * @param detectMap
	 * @return
	 */
	private static String bodyPreviewParse(final Map<String, String> detectMap) {
		String resultBody = "";
		if (Common.isEmpty(detectMap)) return resultBody;
		if (detectMap.size() > 0) {
			resultBody = detectMap.values().stream().collect(Collectors.joining());
			return bodyhtmlPrefix.concat(resultBody).concat(bodyhtmlSuffix);
		} else return resultBody;
	}


	public static String escapeHtmlEntities(String html) {
		return html.replace("<", "&lt;")
				.replace(">", "&gt;");
	}



	/***
	 *  내용에 태그가 아닌형식에 꺽쇠 <>가 들어올때 태그로 인식안되도록 유니코드 변환처리
	 * @param html
	 * @param allowedTags
	 * @return
	 */
	public static String sanitizeAndEscape(String html, String allowedTags) {
		StringBuilder result = new StringBuilder();
		Pattern pattern = Pattern.compile("<!DOCTYPE[^>]*>|<(/?)(\\w+)([^>]*?)>", Pattern.DOTALL);
		Matcher matcher = pattern.matcher(html);
		int lastEnd = 0;
		while (matcher.find()) {
			// 텍스트와 태그를 분리하여 처리
			result.append(escapeHtmlEntities(html.substring(lastEnd, matcher.start())));
			if (matcher.group(0).startsWith("<!DOCTYPE")) {
				result.append(matcher.group(0));
			} else {
				String slash = matcher.group(1);
				String tagName = matcher.group(2);
				String attributes = matcher.group(3);

				if (allowedTags.contains(tagName)) {
					result.append("<").append(slash).append(tagName).append(attributes).append(">");
				} else {
					// 허용되지 않는 태그의 꺽쇠를 유니코드로 변환
					result.append("\\u003C").append(slash).append(tagName).append(attributes).append("\\u003E");
				}
			}

			lastEnd = matcher.end();
		}

		// 마지막 남은 텍스트 처리
		result.append(escapeHtmlEntities(html.substring(lastEnd)));

		return result.toString();
	}

	/***
	 * Range 관리용 중첩 클래스
	 */
	public static class Range {
		int start;
		int end;

		Range(int start, int end) {
			this.start = start;
			this.end = end;
		}

		// Check if the given range overlaps with this range
		boolean isOverlapping(int newStart, int newEnd) {
			return newStart <= end && newEnd >= start;
		}

		// Expand this range to include the new range
		void expand(int newStart, int newEnd) {
			this.start = Math.min(this.start, newStart);
			this.end = Math.max(this.end, newEnd);
		}
	}


	/***
	 * 텍스트 검출
	 * @param text
	 * @param compareBodyText
	 * @param keywords
	 * @param contextLength
	 * @return
	 */
	public static List<String> extractKeywordsAndContext(String text,String compareBodyText,List<String> keywords, int contextLength) {
		List<String> results = new ArrayList<>();
		List<Range> ranges = new ArrayList<>();

		for (String keyword : keywords) {
			int index = 0;
			while ((index = compareBodyText.indexOf(keyword, index)) != -1) {
				int start = Math.max(0, index - contextLength);
				int end = Math.min(text.length(), index + keyword.length() + contextLength);
				boolean added = false;
				for (Range r : ranges) {
					if (r.isOverlapping(start, end)) {
						r.expand(start, end);
						added = true;
						break;
					}
				}
				if (!added) {
					ranges.add(new Range(start, end));
				}
				index += keyword.length(); // Move past the current keyword
			}
		}

		// Collect results based on merged ranges
		for (Range r : ranges) {
			results.add(text.substring(r.start, r.end));
		}

		return results;
	}


	/**
	 * 미분류 서비스 타입 본문 처리
	 * 본문 내용의 key - value 내용에서 value 내용이 html 태그인 경우 body.text 내용만 리턴
	 *
	 * @return 본문 내용
	 */
	private static String unknownSvcRemoveHtmlBody(EmsBodyVO emsBody, String body) {
		if (emsBody.getSvc().startsWith("U") || emsBody.getSvc().startsWith("X")) {
			//허용된 태그가 아닌것 검출하기

			Document doc = Jsoup.parse(body);
			Elements tds = doc.select("table.response td,table.request td");
			for(Element td : tds) {
				td.html(getTextWithLineBreaks(td));
			}
			return doc.html();
		}
		return body;
	}

	private static String getTextWithLineBreaks(Element element) {
		StringBuilder textBuilder = new StringBuilder();
		element.traverse(new NodeVisitor() {
			@Override
			public void head(Node node, int depth) {
				if (node instanceof TextNode) {
					textBuilder.append(getJsonTextPrettyPrint(((TextNode) node).text()));
				} else if (node instanceof Element) {
					Element el = (Element) node;
					if (el.tagName().equals("p") || el.tagName().matches("h[1-6]") || el.tagName().equals("br") || el.tagName().equals("strong") || el.tagName().equals("div") || el.tagName().equals("span")) {
						if(Common.isNotEmpty(el.text())) textBuilder.append("<br>");
					}
				}
			}

			@Override
			public void tail(Node node, int depth) {
				// TODO document why this method is empty
			}
		});
		return textBuilder.toString().trim();
	}

	private static String getJsonTextPrettyPrint(final String text) {
		EmsBodyType contentType = getEmsBodyType(text);
		if(contentType == EmsBodyType.JSON) {
			return textParser(JSONSerializer.toJSON(text.replaceAll("\\n", "").replaceAll(" ", "").trim()).toString(4, 1));
		}
		return text;
	}


	///////////////////////////////////////////////////////////////////////////////////////////////////


}
