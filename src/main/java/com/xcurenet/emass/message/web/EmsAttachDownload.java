package com.xcurenet.emass.message.web;

import com.xcurenet.common.crypto.CryptoCommon;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.List;

@Service
@Slf4j
public class EmsAttachDownload {

	@Autowired
	public MinioFileAdapter minioFileAdapter;


//	@Description("파일 다운로드")
//	public void download(final EmsAttachVO attach, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
//		response.setCharacterEncoding(Common.UTF8);
//		if (attach == null) {
//			log.warn("file not found..attach is null");
//			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//			return;
//		}
//		InputStream in = null;
//		OutputStream out = null;
//		try {
//			out = response.getOutputStream();
//			response.setContentType("application/octet-stream");
//			response.setHeader("Content-Transfer-Encoding", "binary");
//			response.setHeader("Connection", "close");
//
//			Cookie f = new Cookie("fileDownload", "true");
//			f.setMaxAge(1 * 24 * 60 * 60);
//			f.setPath("/");
//			response.addCookie(f);
//
//			String path = attach.getAttachPath();
//			String harPath = attach.getAttachHarPath();
//			log.info("path:{}, harPath:{}", path, harPath);
//			in = getAttach(path, harPath);
//			if (in == null) {
//				log.warn("file not found..attach {} {} {}", attach.getMsgId(), attach.getAttachId(), attach.getAttachPath());
//				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//				response.addCookie(new Cookie("fileDownload", "false"));
//			} else {
//				if (Common.isEquals(prediction, "Y")) attach.setAttachName(attach.getAttachName() + "." + (Common.isEquals(attach.getAttachExt(), "unknown") ? "txt" : attach.getAttachExt()));
//				response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getEncodingFileName(request, attach.getAttachName()) + "\"");
//				if (attach.getAttachSize() <= Integer.MAX_VALUE) response.setContentLength((int) attach.getAttachSize());
//				IOUtils.copyLarge(in, out);
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//			log.error("file download error.. attach {} {}", attach.getMsgId(), attach.getAttachId());
//			response.addCookie(new Cookie("fileDownload", "false"));
//		} finally {
//			IOUtils.closeQuietly(in);
//			IOUtils.closeQuietly(out);
//			response.flushBuffer();
//		}
//	}

	@Description("파일 다운로드")
	public void download(final EmsAttachVO attach, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		if (attach == null) {
			log.warn("file not found..attach is null");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}
		String objectName = attach.getAttachPath();
		String fileName = attach.getAttachName();
		minioFileAdapter.fileDownload(objectName, fileName, request, response);
	}



//	@Description("파일 다운로드")
//	public void download(final List<EmsAttachVO> attachs, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
//		response.setCharacterEncoding(Common.UTF8);
//		if (attachs == null || attachs.size() == 0) {
//			log.warn("file not found..attach is null");
//			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//			return;
//		}
//		if (attachs.size() == 1) {
//			download(attachs.get(0), request, response, prediction);
//			return;
//		}
//
//		OutputStream out = null;
//		ArchiveOutputStream os = null;
//		try {
//			out = response.getOutputStream();
//			response.setContentType("application/octet-stream");
//			response.setHeader("Content-Transfer-Encoding", "binary");
//			response.setHeader("Connection", "close");
//			response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_attachs.zip\"");
//
//			os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
//			for (EmsAttachVO attach : attachs) {
//				InputStream in = null;
//				try {
//					String path = attach.getAttachPath();
//					String harPath = attach.getAttachHarPath();
//					log.info("path:{}, harPath:{}", path, harPath);
//					in = getAttach(path, harPath);
//					if (in == null) continue;
//					if (Common.isEquals(prediction, "Y")) attach.setAttachName(attach.getAttachName() + "." + attach.getAttachExt());
//
//					String subject = EmsReDefined.reSubject(getFileName(attach));
//					String dir = Common.getEDCFileName(attach.getCtime(), attach.getUserId(), attach.getName(), subject, attach.getMsgId());
//
//					os.putArchiveEntry(new ZipArchiveEntry(dir + File.separatorChar + attach.getAttachName()));
//
//					IOUtils.copy(in, os);
//					os.closeArchiveEntry();
//				} catch (ClientAbortException e) {
//					throw new Exception(e);
//				} catch (Exception e) {
//					e.printStackTrace();
//				} finally {
//					IOUtils.closeQuietly(in);
//				}
//			}
//
//		} catch (Exception e) {
//			e.printStackTrace();
//			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//		} finally {
//			IOUtils.closeQuietly(os);
//			IOUtils.closeQuietly(out);
//			response.flushBuffer();
//		}
//	}


	@Description("파일 다운로드")
	public void download(final List<EmsAttachVO> attachs, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
		response.setCharacterEncoding(Common.UTF8);
		if (attachs == null || attachs.size() == 0) {
			log.warn("file not found..attach is null");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}
		if (attachs.size() == 1) {
			download(attachs.get(0), request, response, prediction);
			return;
		}

		OutputStream out = null;
		ArchiveOutputStream os = null;
		try {
			out = response.getOutputStream();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Connection", "close");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_attachs.zip\"");

			os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out);
			for (EmsAttachVO attach : attachs) {
				System.out.println(attach.getAttachName());
				System.out.println(attach.getAttachPath());
				InputStream in = null;
				try {
					String path = attach.getAttachPath();
					String harPath = attach.getAttachHarPath();
					log.info("path:{}, harPath:{}", path, harPath);
					in = getAttach(path, harPath);
					in = minioFileAdapter.findFile(attach.getAttachPath());
					if (in == null) continue;
					if (Common.isEquals(prediction, "Y")) attach.setAttachName(attach.getAttachName() + "." + attach.getAttachExt());

					String subject = EmsReDefined.reSubject(getFileName(attach));
					String dir = Common.getEDCFileName(attach.getCtime(), attach.getUserId(), attach.getName(), subject, attach.getMsgId());

					os.putArchiveEntry(new ZipArchiveEntry(dir + File.separatorChar + attach.getAttachName()));

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

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} finally {
			IOUtils.closeQuietly(os);
			IOUtils.closeQuietly(out);
			response.flushBuffer();
		}
	}

	/*
	 * public InputStream getAttach(String path, String harPath) { return
	 * Common.getHdfsAttach(path, harPath); }
	 */

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
						f = new File("/users/apache/temp/" + new File(path).getName());
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
}

