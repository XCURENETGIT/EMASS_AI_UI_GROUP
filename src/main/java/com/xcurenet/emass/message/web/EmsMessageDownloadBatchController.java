package com.xcurenet.emass.message.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.compress.ZipUtils;
import com.xcurenet.common.csv.CsvWriterEMASS;
import com.xcurenet.common.excel.XLSXWriterEMASS;
import com.xcurenet.common.pdf.PdfWriterEMASS;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.log.SolrEdcControllerLog;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.io.IOUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.MESSAGE_INFO)
@Slf4j
public class EmsMessageDownloadBatchController {

	private final static int PAGE_BREAK = 1000;

	@Resource(name = "emsMessageService")
	public EmsMessageService emsMessageService;

	@Autowired
	public MessengerController messengerController;

	@Resource(name = "solrEdcService")
	public SolrEdcService solrEdcService;

	@Autowired
	public EmsAttachDownload emsAttachDownload;

	@Autowired
	public DownloadBatchService downloadBatchService;

	@Autowired
	private SimpMessagingTemplate template;

	@Autowired
	private SolrEdcControllerLog solrEdcControllerLog;

	@Autowired
	public MinioFileAdapter minioFileAdapter;

	@RequestMapping(value = "/getEmassMessageSaveBatchZip.xcn")
	@Description("EMASS 메시지 전체 저장")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassMessageSaveBatchZip(final HttpServletRequest request, final HttpServletResponse response) throws Exception {

		JSONObject param = Common.getParam(request);
		JSONArray header = Common.toJSONArray(param.get("searchHeader"));
		Locale locale = Common.getLocale(request.getSession());

		final String title = Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale);
		final String adminId = Common.getAdminId(request);
		final String searchType = Common.nvl(param.get("searchType"));
		final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
		final String searchTime = Common.nvl(param.get("searchTime"));
		final String exportFileExt = Common.nvl(param.get("exportFileExt"), "xlsx");
		final String firstAdminYn = Common.getFirstAdminYn(request.getSession());

		final boolean listFlag = searchType.indexOf("L") > -1;
		final boolean bodyFlag = searchType.indexOf("B") > -1;
		final boolean attachFlag = searchType.indexOf("A") > -1;

		log.info("bodyFlag {} / attachFlag {}", bodyFlag, attachFlag);

		File exportDir = new File(Common.makeFilepath(Config.getString("ui.export.batchPath", Config.MESSAGE_EXPORT_PATH) , Common.getCurrentDate(), Common.getDateTimeFormat() + "_message"));
		String exporFileName = exportDir.getPath() + ".zip";

		int dataLength = Common.nvz(param.get("dataLength"), 50000); //각 파일별 건수 50000
		long total = Common.nvz(param.get("searchTotal"));
		int queryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); //쿼리 실행 횟수
		int solrCnt = dataLength / PAGE_BREAK; //파일별 solr 검색 횟수
		if (dataLength > total) solrCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0));

		IOUtils.closeQuietly(response.getOutputStream());

		XLSXWriterEMASS xlsxWriter = null;
		//SFTPUtil ftp = null;
		DownloadBatchVO downloadBatchVO = new DownloadBatchVO();

		File rootFolder = getRootFolder();
		long totalSpace = rootFolder.getTotalSpace();
		long skipCnt = 0;
		long sucCnt = 0;

		String ctime = null;
		String msgId = null;

		boolean isSpaceChk = true;
		boolean isCancel = false;
		try {
			//if (Common.isWindow() && attachFlag) {
			//	ftp = new SFTPUtil();
			//	ftp.init(Config.DB_IP, Config.DB_USER, Config.DB_PASSWORD, 22);
			//}
			inserDB(downloadBatchVO, param, searchType, exportFileExt, adminId, total, exporFileName);

			isSpaceChk = isFreeSpace(totalSpace, rootFolder.getUsableSpace());
			if (!isSpaceChk) {
				log.error("system disk check! total:{}, used:{}", totalSpace, rootFolder.getUsableSpace());
				updateErrorDB(downloadBatchVO, "S");
				alarmMessage(adminId, downloadBatchVO);
				return;
			}
			Common.mkdirs(exportDir.getPath());
			EmsAttachDownload attachDown = new EmsAttachDownload();
			for (int i = 1; i <= queryCnt; i++) {
				List<SolrEdcVO> emass = EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1, ctime, msgId).getEmass(), locale);
				if (listFlag) xlsxWriter = createExcelZipFile(exportDir, xlsxWriter, emass, header, title, total, i, solrCnt, bodyFlag, attachFlag, exportFileExt, dataLength);
				if (bodyFlag || attachFlag) {
					for (SolrEdcVO edc : emass) {
						isCancel = checkCancel(downloadBatchVO);
						if(isCancel) {
							log.info("Download Cancel..");
							log.info("Download Seq : {} , Download Try Cnt : {}", downloadBatchVO.getDownSeq(), sucCnt + skipCnt);
							break;
						}
						try {
							if (bodyFlag) downloadBody(locale, firstAdminYn, exportDir, edc, Common.getAdminId(request), Common.getAdmin(request).getAdminType());
							//if (attachFlag) downloadAttach(exportDir, attachDown, edc, ftp);
							if (attachFlag) downloadAttach(exportDir, attachDown, edc);
							sucCnt++;
							ctime  = edc.getCtime();
							msgId = edc.getMsgid();

						} catch(Exception e) {
							skipCnt++;
							log.info("Skip Message ID : {} ", edc.getMsgid());
							e.printStackTrace();
							continue;
						}
					}
				}

				if (i != queryCnt) {
					isCancel = checkCancel(downloadBatchVO);
					if(isCancel) {
						log.info("Download Cancel..");
						log.info("Download Seq : {} , Download Try Cnt : {}", downloadBatchVO.getDownSeq(), (PAGE_BREAK * (i - 1)));
						break;
					}

					updateIngDB(downloadBatchVO, i, queryCnt, sucCnt, skipCnt);
					isSpaceChk = isFreeSpace(totalSpace, rootFolder.getUsableSpace());

					if (!isSpaceChk) {
						log.error("system disk check! total:{}, used:{}", totalSpace, rootFolder.getUsableSpace());
						break;
					}
				}
			}

			if (isSpaceChk && !isCancel) {
				Long folderSize = getFolderSize(exportDir);
				log.info("folderSize : {}, used : {}", folderSize, rootFolder.getUsableSpace());
				if(folderSize < rootFolder.getUsableSpace()) {
					File dest = new File(exporFileName);
					pack(exportDir, dest);
					updateSucessDB(downloadBatchVO, dest.length(), sucCnt == 0 ? total : sucCnt, skipCnt);
				} else {
					log.error("system disk check! folder Size:{}, used:{}", folderSize, rootFolder.getUsableSpace());
					updateErrorDB(downloadBatchVO, "S");
				}
			} else if(!isCancel) {
				updateErrorDB(downloadBatchVO, "S");
			}
			log.info("Sucess Count : {}", sucCnt);
			log.info("Skip Count : {}", skipCnt);
			alarmMessage(adminId, downloadBatchVO);

			deleteFolder(exportDir.getPath());


		} catch (Exception e) {
			updateErrorDB(downloadBatchVO, "S");
			e.printStackTrace();
		} finally {

			//if (ftp != null) ftp.disconnection();
		}
	}

	private File getRootFolder () {
		String exportPath = Config.getString("ui.export.batchPath", Config.MESSAGE_EXPORT_PATH);
		String[] pathArr = Common.toArray(exportPath, "/");
		if(pathArr.length > 0) {
			return new File("/"+pathArr[0]);
		} else {
			return new File("/");
		}
	}

	private void downloadBody(Locale locale, final String firstAdminYn, File exportDir, SolrEdcVO edc, String adminId, String adminType) throws Exception{
		InputStream in = null;
		FileOutputStream out = null;
		try {
			EmsBodyVO emsBody = emsMessageService.getEmassBody(edc.getMsgid(), firstAdminYn, adminType);
			String body = new EmsCreateMessage(locale).getHeaderMessage(edc.getMsgid(), EmsMessageController.getBodyStr(null, emsBody), null, locale, firstAdminYn, adminId, adminType);
			if (body == null) body = "no data";
			in = new ByteArrayInputStream(body.getBytes());

			File file = new File(Common.makeFilepath(exportDir.getPath(), "messages", edc.getMsgid(), "body.html"));
			Common.mkdirs(file.getParent());
			out = new FileOutputStream(file);
			IOUtils.copy(in, out);
		} finally {
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(out);
		}
	}

	//private void downloadAttach(File exportDir, EmsAttachDownload attachDown, SolrEdcVO edc, SFTPUtil ftp) {
	private void downloadAttach(File exportDir, EmsAttachDownload attachDown, SolrEdcVO edc) throws Exception{
		File dir = new File(Common.makeFilepath(exportDir.getPath(), "messages", edc.getMsgid(), "attachs"));
		Common.mkdirs(dir.getPath());
		List<EmsAttachVO> attachs = emsMessageService.getEmassAttachInfo4Down(edc.getMsgid(), null);
		for (EmsAttachVO attach : attachs) {
			InputStream in = null;
			FileOutputStream out = null;
			try {
				//in = attachDown.getAttach(attach.getAttachPath(), ftp);
				in = minioFileAdapter.findFile(attach.getAttachPath());
				File file = new File(Common.makeFilepath(dir.getPath(), Common.removeInvalidName(attach.getAttachName())));
				out = new FileOutputStream(file);
				if ( in != null) IOUtils.copyLarge(in, out);
				else throw new Exception("Har Undefined");
			} finally {
				IOUtils.closeQuietly(in);
				IOUtils.closeQuietly(out);
			}
		}
	}

	private String pack(File src, File dest) {
		ZipUtils.compressZip(src.getPath(), dest.getPath(), "UTF-8");
		return dest.getAbsolutePath();
	}

	private boolean isFreeSpace(long total, long used) {
		boolean rtn = true;
		if (total / 100 * Config.MESSAGE_EXPORT_USED_RATE > used) rtn = false;
		return rtn;
	}

	private XLSXWriterEMASS createExcelZipFile(File exportDir, XLSXWriterEMASS xlsxWriter, List<SolrEdcVO> emass, JSONArray header, String title, long total, int queryCnt, int solrCnt, boolean bodyFlag, boolean attachFlag, String exportFileExt, int dataLength) throws Exception {
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
				if (queryCnt == 1 || dataLength >= total) startNum = 1;
				else startNum = (totalQueryCnt - (totalQueryCnt % solrCnt)) * PAGE_BREAK + 1;
			}
			if (lastNum > total) lastNum = total;
			String fileName = "list_" + startNum + "-" + lastNum + "." + exportFileExt;

			FileOutputStream out = null;
			try {
				out = new FileOutputStream(new File(exportDir + "/" + fileName));
				xlsxWriter.write(out);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				IOUtils.closeQuietly(out);
			}
		}
		return xlsxWriter;
	}

	private SolrEdcMessageVO getEmassData(String adminId, final JSONObject condition, final String searchTime, int page, String ctime, String msgid) throws Exception, IOException{
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = null;
		if (Common.isNotEmpty(condition.get("msgids"))) {
			sq = new SolrQuery();
			sq.setQuery(String.format("msgid:(%s)", Common.joinj(Common.toJSONArray(condition.get("msgids")), " ")));

			String sort = Common.nvl(condition.get("sort"));
			if (Common.isEmpty(sort)) {
				sq.setSort(SolrQuery.SortClause.desc("ctime"));
				sq.addSort(SolrQuery.SortClause.desc("msgid"));
			}
			String[] sorts = sort.split(" ");
			if (sorts.length > 1 && Common.isNotEmpty(sorts[1])) {
				if (Common.isEquals(sorts[1], "desc")) {
					sq.setSort(SolrQuery.SortClause.desc(sorts[0]));
					sq.addSort(SolrQuery.SortClause.desc("msgid"));
				} else {
					sq.setSort(SolrQuery.SortClause.asc(sorts[0]));
					sq.addSort(SolrQuery.SortClause.asc("msgid"));
				}
			}
		} else {
			sq = solrCreateQuery.createQuery(condition, adminId, searchTime);
		}
		String searchAfter = null;
		if (ctime!= null && msgid!=null){
			searchAfter = ctime+","+msgid;
		}
		sq.setParam("searchAfter", Common.nvl(searchAfter));
		sq.setStart(PAGE_BREAK * page);
		sq.setRows(PAGE_BREAK);
		log.info("offset : {}", PAGE_BREAK * page);
		return solrEdcService.getEmassMessage(sq, adminId, solrCreateQuery.getFinalReadYn(), solrCreateQuery.getConsentNo());
	}

	@RequestMapping(value = "/getEmassMessageSaveBatchCSV.xcn")
	@Description("EMASS 메시지 전체 목록 저장 CSV")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassMessageSaveBatchCSV(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		JSONObject param = Common.getParam(request);
		JSONArray header = Common.toJSONArray(param.get("searchHeader"));
		Locale locale = Common.getLocale(request.getSession());

		final String adminId = Common.getAdminId(request);
		final String searchType = Common.nvl(param.get("searchType"));
		final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
		final String searchTime = Common.nvl(param.get("searchTime"));
		final String exportFileExt = Common.nvl(param.get("exportFileExt"), "csv");
		final String firstAdminYn = Common.getFirstAdminYn(request.getSession());

		final boolean bodyFlag = searchType.indexOf("B") > -1;
		final boolean attachFlag = searchType.indexOf("A") > -1;

		log.info("bodyFlag {} / attachFlag {}", bodyFlag, attachFlag);

		File exportDir = new File(Common.makeFilepath(Config.getString("ui.export.batchPath", Config.MESSAGE_EXPORT_PATH) , Common.getCurrentDate(), Common.getDateTimeFormat() + "_message"));
		String exporFileName = exportDir.getPath() + ".zip";

		int dataLength = Common.nvz(param.get("dataLength"), 50000); //각 파일별 건수 50000
		long total = Common.nvz(param.get("searchTotal"));
		int queryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); //쿼리 실행 횟수
		int solrCnt = dataLength / PAGE_BREAK; //파일별 solr 검색 횟수
		if (dataLength > total) solrCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0));

		IOUtils.closeQuietly(response.getOutputStream());

		CsvWriterEMASS csvWriter = null;
		//SFTPUtil ftp = null;
		DownloadBatchVO downloadBatchVO = new DownloadBatchVO();

		File rootFolder = getRootFolder();
		long totalSpace = rootFolder.getTotalSpace();

		boolean isSpaceChk = true;
		boolean isCancel = false;
		long skipCnt = 0;
		long sucCnt = 0;
		try {
			//if (Common.isWindow() && attachFlag) {
			//	ftp = new SFTPUtil();
			//	ftp.init(Config.DB_IP, Config.DB_USER, Config.DB_PASSWORD, 22);
			//}
			inserDB(downloadBatchVO, param, searchType, exportFileExt, adminId, total, exporFileName);

			isSpaceChk = isFreeSpace(totalSpace, rootFolder.getUsableSpace());
			if (!isSpaceChk) {
				log.error("system disk check! total:{}, used:{}", totalSpace, rootFolder.getUsableSpace());
				updateErrorDB(downloadBatchVO, "S");
				alarmMessage(adminId, downloadBatchVO);
				return;
			}
			String ctime = null;
			String msgid = null;

			Common.mkdirs(exportDir.getPath());
			EmsAttachDownload attachDown = new EmsAttachDownload();
			for (int i = 1; i <= queryCnt; i++) {
				List<SolrEdcVO> emass = EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1, ctime, msgid).getEmass(), locale);

				csvWriter = createCsvZipFile(exportDir, csvWriter, emass, header, total, i, solrCnt, dataLength);

				if (bodyFlag || attachFlag) {
					for (SolrEdcVO edc : emass) {
						isCancel = checkCancel(downloadBatchVO);
						if(isCancel) {
							log.info("Download Cancel..");
							log.info("Download Seq : {} , Download Try Cnt : {}", downloadBatchVO.getDownSeq(), sucCnt + skipCnt);
							break;
						}
						try {
							if (bodyFlag) downloadBody(locale, firstAdminYn, exportDir, edc, Common.getAdminId(request), Common.getAdmin(request).getAdminType());
							//if (attachFlag) downloadAttach(exportDir, attachDown, edc, ftp);
							if (attachFlag) downloadAttach(exportDir, attachDown, edc);
							sucCnt++;
							ctime  = edc.getSvc();
							msgid = edc.getMsgid();
						} catch(Exception e) {
							skipCnt++;
							log.info("Skip Message ID : {} ", edc.getMsgid());
							e.printStackTrace();
							continue;
						}
					}
				}

				if (i != queryCnt) {
					isCancel = checkCancel(downloadBatchVO);
					if(isCancel) {
						log.info("Download Cancel..");
						log.info("Download Seq : {} , Download Try Cnt : {}", downloadBatchVO.getDownSeq(), (PAGE_BREAK * (i - 1)));
						break;
					}

					updateIngDB(downloadBatchVO, i, queryCnt, sucCnt, skipCnt);
					isSpaceChk = isFreeSpace(totalSpace, rootFolder.getUsableSpace());
					if (!isSpaceChk) {
						log.error("system disk check! total:{}, used:{}", totalSpace, rootFolder.getUsableSpace());
						break;
					}
				}
			}

			if (isSpaceChk && !isCancel) {
				Long folderSize = getFolderSize(exportDir);
				if(folderSize < rootFolder.getUsableSpace()) {
					File dest = new File(exporFileName);
					pack(exportDir, dest);
					updateSucessDB(downloadBatchVO, dest.length(), sucCnt == 0 ? total : sucCnt, skipCnt);
				} else {
					log.error("system disk check! folder Size:{}, used:{}", folderSize, rootFolder.getUsableSpace());
					updateErrorDB(downloadBatchVO, "S");
				}
			} else if(!isCancel){
				updateErrorDB(downloadBatchVO, "S");
			}
			log.info("Sucess Count : {}", sucCnt);
			log.info("Skip Count : {}", skipCnt);
			alarmMessage(adminId, downloadBatchVO);

			deleteFolder(exportDir.getPath());


		} catch (Exception e) {
			updateErrorDB(downloadBatchVO, "S");
			e.printStackTrace();
		} finally {

			//if (ftp != null) ftp.disconnection();
		}
	}

	private CsvWriterEMASS createCsvZipFile(File exportDir, CsvWriterEMASS csvWriter, List<SolrEdcVO> emass, JSONArray header, long total, int queryCnt, int solrCnt, int dataLength) throws Exception {
		int totalQueryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); // 쿼리 실행 횟수
		FileOutputStream os = null;
		String fileName = "";
		if (queryCnt % solrCnt == 1 || queryCnt == 1) {
			long lastNum = (queryCnt + solrCnt - 1) * PAGE_BREAK;
			long startNum = lastNum - (solrCnt) * PAGE_BREAK + 1;
			if (queryCnt == totalQueryCnt) {
				if (queryCnt == 1 || dataLength >= total) startNum = 1;
				else startNum = (queryCnt - (queryCnt % solrCnt)) * PAGE_BREAK + 1;
			}
			if (lastNum > total) lastNum = total;
			fileName = "list_" + startNum + "-" + lastNum + ".csv";
			os = new FileOutputStream(exportDir + "/" + fileName);
			csvWriter = new CsvWriterEMASS(header, new OutputStreamWriter(os, Common.EUCKR));
			log.info("[CSV Write] Create New file start - {}", fileName);
		}

		csvWriter.appendData(emass, (queryCnt - 1) * PAGE_BREAK);

		if (queryCnt % solrCnt == 0 || queryCnt == totalQueryCnt) {
			try {
				csvWriter.close();
				IOUtils.closeQuietly(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				csvWriter = null;
				log.info("[CSV Write] Create New file end - {}", fileName);
			}
		}
		return csvWriter;
	}

	@RequestMapping(value = "/getEmassMessageSaveBatchPDF.xcn")
	@Description("EMASS 메시지 전체 목록 저장 PDF")
	@AuditOperation(Operation.DOWNLOAD)
	@ResponseBody
	public void getEmassMessageSaveBatchPDF(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		JSONObject param = Common.getParam(request);
		JSONArray header = Common.toJSONArray(param.get("searchHeader"));
		Locale locale = Common.getLocale(request.getSession());

		final String title = Prop.propFormat("DATA_MONITOR.MESSAGE_INFO", locale);
		final String adminId = Common.getAdminId(request);
		final String searchType = Common.nvl(param.get("searchType"));
		final JSONObject condition = Common.toJSONObject(param.get("searchCondition"));
		final String searchTime = Common.nvl(param.get("searchTime"));
		final String exportFileExt = Common.nvl(param.get("exportFileExt"), "pdf");
		final String firstAdminYn = Common.getFirstAdminYn(request.getSession());

		final boolean bodyFlag = searchType.indexOf("B") > -1;
		final boolean attachFlag = searchType.indexOf("A") > -1;

		log.info("bodyFlag {} / attachFlag {}", bodyFlag, attachFlag);

		File exportDir = new File(Common.makeFilepath(Config.getString("ui.export.batchPath", Config.MESSAGE_EXPORT_PATH) , Common.getCurrentDate(), Common.getDateTimeFormat() + "_message"));
		String exporFileName = exportDir.getPath() + ".zip";

		int dataLength = Common.nvz(param.get("dataLength"), 50000); //각 파일별 건수 50000
		long total = Common.nvz(param.get("searchTotal"));
		int queryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); //쿼리 실행 횟수
		int solrCnt = dataLength / PAGE_BREAK; //파일별 solr 검색 횟수
		if (dataLength > total) solrCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0));

		IOUtils.closeQuietly(response.getOutputStream());

		PdfWriterEMASS pdfWriter = null;
		//SFTPUtil ftp = null;
		DownloadBatchVO downloadBatchVO = new DownloadBatchVO();

		File rootFolder = getRootFolder();
		long totalSpace = rootFolder.getTotalSpace();

		boolean isSpaceChk = true;
		boolean isCancel = false;
		long skipCnt = 0;
		long sucCnt = 0;

		try {
			if (Common.isWindow() && attachFlag) {
				//ftp = new SFTPUtil();
				//ftp.init(Config.DB_IP, Config.DB_USER, Config.DB_PASSWORD, 22);
			}
			inserDB(downloadBatchVO, param, searchType, exportFileExt, adminId, total, exporFileName);

			isSpaceChk = isFreeSpace(totalSpace, rootFolder.getUsableSpace());
			if (!isSpaceChk) {
				log.error("system disk check! total:{}, used:{}", totalSpace, rootFolder.getUsableSpace());
				updateErrorDB(downloadBatchVO, "S");
				alarmMessage(adminId, downloadBatchVO);
				return;
			}

			String ctime = null;
			String msgid = null;
			Common.mkdirs(exportDir.getPath());
			EmsAttachDownload attachDown = new EmsAttachDownload();
			for (int i = 1; i <= queryCnt; i++) {
				List<SolrEdcVO> emass = EmsReDefined.reDefined(getEmassData(adminId, condition, searchTime, i - 1, ctime, msgid).getEmass(), locale);

				pdfWriter = createPdfZipFile(exportDir, pdfWriter, emass, header, total, i, solrCnt, title, dataLength);

				if (bodyFlag || attachFlag) {
					for (SolrEdcVO edc : emass) {
						isCancel = checkCancel(downloadBatchVO);
						if(isCancel) {
							log.info("Download Cancel..");
							log.info("Download Seq : {} , Download Try Cnt : {}", downloadBatchVO.getDownSeq(), sucCnt + skipCnt);
							break;
						}
						try {
							if (bodyFlag) downloadBody(locale, firstAdminYn, exportDir, edc, Common.getAdminId(request), Common.getAdmin(request).getAdminType());
							//if (attachFlag) downloadAttach(exportDir, attachDown, edc, ftp);
							if (attachFlag) downloadAttach(exportDir, attachDown, edc);
							sucCnt++;
							ctime = edc.getCtime();
							msgid = edc.getMsgid();
						} catch(Exception e) {
							skipCnt++;
							log.info("Skip Message ID : {} ", edc.getMsgid());
							e.printStackTrace();
							continue;
						}
					}
				}

				if (i != queryCnt) {
					isCancel = checkCancel(downloadBatchVO);
					if(isCancel) {
						log.info("Download Cancel..");
						log.info("Download Seq : {} , Download Try Cnt : {}", downloadBatchVO.getDownSeq(), (PAGE_BREAK * (i - 1)));
						break;
					}

					updateIngDB(downloadBatchVO, i, queryCnt, sucCnt, skipCnt);
					isSpaceChk = isFreeSpace(totalSpace, rootFolder.getUsableSpace());
					if (!isSpaceChk) {
						log.error("system disk check! total:{}, used:{}", totalSpace, rootFolder.getUsableSpace());
						break;
					}
				}
			}

			if (isSpaceChk && !isCancel) {
				Long folderSize = getFolderSize(exportDir);
				if(folderSize < rootFolder.getUsableSpace()) {
					File dest = new File(exporFileName);
					pack(exportDir, dest);
					updateSucessDB(downloadBatchVO, dest.length(), sucCnt == 0 ? total : sucCnt, skipCnt);
				} else {
					log.error("system disk check! folder Size:{}, used:{}", folderSize, rootFolder.getUsableSpace());
					updateErrorDB(downloadBatchVO, "S");
				}
			} else if(!isCancel) {
				updateErrorDB(downloadBatchVO, "S");
			}
			log.info("Sucess Count : {}", sucCnt);
			log.info("Skip Count : {}", skipCnt);
			alarmMessage(adminId, downloadBatchVO);

			deleteFolder(exportDir.getPath());


		} catch (Exception e) {
			updateErrorDB(downloadBatchVO, "S");
			e.printStackTrace();
		} finally {

			//if (ftp != null) ftp.disconnection();
		}
	}

	private PdfWriterEMASS createPdfZipFile(File exportDir, PdfWriterEMASS pdfWriter, List<SolrEdcVO> emass, JSONArray header, long total, int queryCnt, int solrCnt, String title, int dataLength) throws Exception {
		int totalQueryCnt = (int) Math.ceil(total / (PAGE_BREAK * 1.0)); // 쿼리 실행 횟수
		FileOutputStream os = null;
		String fileName = "";

		if (queryCnt % solrCnt == 1 || queryCnt == 1) {
			long lastNum = (queryCnt + solrCnt - 1) * PAGE_BREAK;
			long startNum = lastNum - (solrCnt) * PAGE_BREAK + 1;
			if (queryCnt == totalQueryCnt) {
				if (queryCnt == 1 || dataLength >= total) startNum = 1;
				else startNum = (queryCnt - (queryCnt % solrCnt)) * PAGE_BREAK + 1;
			}
			if (lastNum > total) lastNum = total;
			fileName = "list_" + startNum + "-" + lastNum + ".pdf";
			os = new FileOutputStream(exportDir + "/" + fileName);

			pdfWriter = new PdfWriterEMASS(title, header, os);

			log.info("[PDF Write] Create New file start - {}", fileName);
		}

		pdfWriter.appendData(emass, (queryCnt - 1) * PAGE_BREAK);

		if (queryCnt % solrCnt == 0 || queryCnt == totalQueryCnt) {
			try {
				pdfWriter.close();
				IOUtils.closeQuietly(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pdfWriter = null;
				log.info("[PDF Write] Create New file end - {}", fileName);
			}
		}
		return pdfWriter;
	}

	private void inserDB(DownloadBatchVO vo, JSONObject param, String searchType, String exportFileExt, String adminId, long total, String exporFileName) {
		param.put("callType", "D");

		vo.setDownSeq(downloadBatchService.getMaxDownSeq());
		vo.setExportType(searchType);
		vo.setExportFileExt(exportFileExt);
		vo.setDownVal(solrEdcControllerLog.getListAudit(param));
		vo.setAdminId(adminId);
		vo.setDownStatus("0");
		vo.setStatusStr("S");
		vo.setTotalRows(total);
		vo.setIngRows(0);
		vo.setDownFilePath(exporFileName);
		downloadBatchService.inserDownloadBatch(vo);
	}

	private void updateIngDB(DownloadBatchVO vo, int i, int queryCnt, long sucCnt, long skipCnt) {
		vo.setDownStatus(String.valueOf((int) Math.floor((double) i / (double) queryCnt * 100)));
		vo.setStatusStr("I");
		vo.setIngRows(sucCnt == 0 ? (i * PAGE_BREAK) : sucCnt);
		vo.setSkipCnt(skipCnt);
		downloadBatchService.updateDownloadBatch(vo);
	}

	private void updateSucessDB(DownloadBatchVO vo, long fileSize, long total, long skipCnt ) {
		vo.setDownStatus("100");
		vo.setStatusStr("Y");
		vo.setDownFileSize(String.valueOf(fileSize));
		vo.setIngRows(total);
		vo.setSkipCnt(skipCnt);
		downloadBatchService.updateDownloadBatch(vo);
	}

	private void updateErrorDB(DownloadBatchVO vo, String errorType ) {

		if(Common.isEquals(errorType, "S")) {
			StringBuffer info = new StringBuffer();
			info.append(Prop.propFormat("download.message.export.check.used")).append("┌").append(vo.getDownVal());
			vo.setDownVal(info.toString());
		}
		vo.setStatusStr("E");
		downloadBatchService.updateDownloadBatch(vo);
	}

	private boolean checkCancel(DownloadBatchVO vo) {
		boolean cancel = false;
		String stat = downloadBatchService.chackCancel(vo);

		if(Common.isOrEquals(stat, "C", "M", "H")) {
			cancel = true;
			vo.setStatusStr(stat);
		}

		return cancel;
	}

	private void alarmMessage(String adminId, DownloadBatchVO vo) {
		log.info("alarmMessage VO : {}", vo);
		template.convertAndSendToUser(adminId, "/exportEnd", vo);
	}

	private void deleteFolder(String parentPath) {
		File file = new File(parentPath);
		String[] fnameList = file.list();
		int fCnt = fnameList.length;
		String childPath = "";

		for(int i = 0; i < fCnt; i++) {
			childPath = parentPath+"/"+fnameList[i];
			File f = new File(childPath);
			if( ! f.isDirectory()) {
				f.delete();
			}
			else {
				deleteFolder(childPath);
			}
		}
		File f = new File(parentPath);
		f.delete();
	}

	private Long getFolderSize(File file) {
		Long folderSize = new Long(0);
		File[] list = file.listFiles();
		for (int i=0; i<list.length; i++) {
			if (list[i].isDirectory()) {
				folderSize = new Long(folderSize.longValue() + getFolderSize(list[i]).longValue());
			} else {
				folderSize = new Long(folderSize.longValue() + list[i].length());
			}
		}
		return folderSize;
	}

	@RequestMapping(value = "/checkDownloadBatchExist.xcn")
	@Description("EMASS 메시지 전체 목록 저장 중복체크")
	@ResponseBody
	public XcnResponseVO checkDownloadBatchExist(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		JSONObject param = Common.getParam(request);
		String adminId = Common.getAdminId(request);
		String searchType = Common.nvl(param.get("searchType"));
		String exportFileExt = Common.nvl(param.get("exportFileExt"), "xlsx");
		long total = Common.nvz(param.get("searchTotal"));

		param.put("callType", "D");

		DownloadBatchVO downloadBatchVO = new DownloadBatchVO();

		downloadBatchVO.setExportType(searchType);
		downloadBatchVO.setExportFileExt(exportFileExt);
		downloadBatchVO.setDownVal(solrEdcControllerLog.getListAudit(param));
		downloadBatchVO.setAdminId(adminId);
		downloadBatchVO.setTotalRows(total);

		return new XcnResponseVO(XcnRspCode.OK, downloadBatchService.checkDownloadBatchExist(downloadBatchVO));
	}

	@RequestMapping(value = "/removeDownInfoData.xcn")
	@Description("EMASS 내보내기 이력 삭제")
	@ResponseBody
	public XcnResponseVO removeDownInfoData(final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		JSONArray deleteData= Common.toJSONArray(request.getParameter("data"));
		List<String> downList = new ArrayList<>();

		if(deleteData.size() == 0) return new XcnResponseVO(XcnRspCode.OK_CUSTOM, Prop.propFormat("download.msg.delete.noexist", request));

		String adminId = Common.getAdminId(request);
		for (int i = 0; i < deleteData.size(); i++) {
			JSONObject donwInfo = deleteData.getJSONObject(i);
			String downSeq = donwInfo.optString("downSeq");
			if (downSeq != null && !downSeq.isEmpty()) {
				downList.add(downSeq);
			}
		}

		return new XcnResponseVO(XcnRspCode.OK, downloadBatchService.removeDownInfoData(adminId, downList));
	}

}