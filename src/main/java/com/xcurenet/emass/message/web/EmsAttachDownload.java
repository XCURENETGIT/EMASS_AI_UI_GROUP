package com.xcurenet.emass.message.web;

import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.crypto.CryptoKey;
import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.message.service.EmsAttachVO;
import com.xcurenet.emass.message.service.EmsMessageVO;
import com.xcurenet.emass.message.service.EmsReDefined;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.slf4j.Slf4j;
import org.apache.catalina.connector.ClientAbortException;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Service;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
public class EmsAttachDownload {

	@Autowired
	public MinioFileAdapter minioFileAdapter;


	@Description("단건 파일 다운로드")
	public void oneFileDownload(final EmsAttachVO attach, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		if (attach.getAttachSize() <= Integer.MAX_VALUE) response.setContentLength((int) attach.getAttachSize());
		if (attach == null) {
			log.warn("file not found..attach is null");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}
		String objectName = attach.getAttachPath();
		log.info("file object path:{}", objectName);
		String fileName = (Common.isEquals(prediction, "Y")) ? attach.getAttachName() + "." + (Common.isEquals(attach.getAttachExt(), "unknown") ? "txt" : attach.getAttachExt()) : attach.getAttachName();
		oneFileDownloadResponse(objectName, fileName, request, response,CryptoKey.isEncrypt);
	}


	@Description("단건,다건 파일 다운로드")
	public void download(final List<EmsAttachVO> attachs, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		if (attachs == null || attachs.size() == 0) {
			log.warn("file not found..attach is null");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}
		OutputStream out = null;
		ArchiveOutputStream os = null;
		if (attachs.size() == 1) oneFileDownload(attachs.get(0), request, response, prediction);
		else if(attachs.size() > 1) {
			try {
				out = response.getOutputStream();
				response.setContentType("application/octet-stream");
				response.setHeader("Content-Transfer-Encoding", "binary");
				response.setHeader("Connection", "close");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_attachs.zip\"");

				os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
				InputStream in = null;
				for (EmsAttachVO attach : attachs) {
					String objectName = attach.getAttachPath();
					if (CryptoKey.isEncrypt) {
						String randomStr = Common.nvl(UUID.randomUUID());
						String fileName = (Common.isEquals(prediction, "Y")) ? attach.getAttachName() + "." + (Common.isEquals(attach.getAttachExt(), "unknown") ? "txt" : attach.getAttachExt()) : attach.getAttachName();
						in = minioFileAdapter.decryptedInputStream(objectName, randomStr, fileName);
					}else{
						in = minioFileAdapter.findFile(objectName);
					}
					try {
						String path = attach.getAttachPath();
						log.info("path:{}", path);
						if (in == null) continue;
						if (Common.isEquals(prediction, "Y")) attach.setAttachName(attach.getAttachName() + "." + attach.getAttachExt());
						String fileName = (Common.isEquals(prediction, "Y")) ? attach.getAttachName() + "." + (Common.isEquals(attach.getAttachExt(), "unknown") ? "txt" : attach.getAttachExt()) : attach.getAttachName();
						String subject = EmsReDefined.reSubject(getFileName(attach));
						String dir = Common.getEDCFileName(attach.getCtime(), attach.getUserId(), attach.getName(), subject, attach.getMsgId());
						os.putArchiveEntry(new ZipArchiveEntry(dir + File.separatorChar + fileName));
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
			catch (Exception e) {
				e.printStackTrace();
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			} finally {
				IOUtils.closeQuietly(os);
				IOUtils.closeQuietly(out);
				response.flushBuffer();
			}
		}
	}


	public InputStream getAttach(String path, String harPath) {
		SFTPUtil ftp = null;
		CryptoCommon crypto = new CryptoCommon();
		InputStream in = null;
		try {
			File file = new File(path);
			if (file.exists()) {
				in = new FileInputStream(file);
			} else {
				if (Common.isWindow()) {
					File f = null;
					FileOutputStream fout = null;
					ftp = new SFTPUtil();
					ftp.init(Config.DB_IP, Config.DB_USER, Config.DB_PASSWORD, 22);

					try {
						log.debug("path:{}", path);
						in = ftp.download(path.substring(0, path.lastIndexOf('/') + 1), new File(path).getName());
						f = new File( Common.TMP_PATH + new File(path).getName());
						fout = new FileOutputStream(f);
						IOUtils.copy(in, fout);

						return crypto.decrypt(new FileInputStream(f));
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						IOUtils.closeQuietly(fout);
						if (!f.delete()) f.deleteOnExit();
					}
				}
				return in;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(in);
			if (ftp != null && ftp.isConnected()) ftp.disconnection();
		}

		return null;
	}

	private EmsMessageVO getFileName(EmsAttachVO edc) {
		EmsMessageVO msg = new EmsMessageVO();
		msg.setSubject(edc.getSubject());
		msg.setSvc(edc.getSvc());
		msg.setSrcIp(edc.getSrcIp());
		msg.setDstIp(edc.getDstIp());
		msg.setHost(edc.getHost());
		msg.setPath(edc.getPath());
		return msg;
	}



	// 단건 파일 다운로드
	public void oneFileDownloadResponse(String objectName, String fileName, final HttpServletRequest request, final HttpServletResponse response, boolean isEncrypt) throws IOException {
		response.setCharacterEncoding(Common.UTF8);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");
		Cookie f = new Cookie("fileDownload", "true");
		f.setMaxAge(1 * 24 * 60 * 60);
		f.setPath("/");
		response.addCookie(f);

		String randomStr = Common.nvl(UUID.randomUUID());
		try (
				InputStream inputStream = (isEncrypt) ? minioFileAdapter.decryptedInputStream(objectName, randomStr, fileName) : minioFileAdapter.findFile(objectName);
				OutputStream outputStream = response.getOutputStream()
		) {
			if (inputStream == null) { // 파일이 존재하지 않을때
				log.warn("file not found..attach {} {} ", fileName, randomStr, objectName);
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.addCookie(new Cookie("fileDownload", "false"));
				return;
			}
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Connection", "close");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getEncodingFileName(request, fileName) + "\"");
			IOUtils.copyLarge(inputStream, outputStream);
			response.flushBuffer();
			response.setStatus(HttpServletResponse.SC_OK);
		} catch (Exception e) {
			log.error("", e);
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.addCookie(new Cookie("fileDownload", "false"));
		}


	}




}
