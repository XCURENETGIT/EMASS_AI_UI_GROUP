package com.xcurenet.emass.consent.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Service;

import com.xcurenet.common.util.Common;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ConsentFileDownload {

	@Description("파일 다운로드")
	public boolean download(final ConsentFileVO attach, final HttpServletResponse response) throws Exception {
		log.info("File download {}", attach.toString());
		response.setCharacterEncoding(Common.UTF8);

		if (attach == null || Common.isEmpty(attach.getFilePath())) {
			log.warn("File download ERROR {}", attach.toString());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.addCookie(new Cookie("fileDownload", "false"));
			return false;
		}

		File file = null;
		FileInputStream in = null;
		OutputStream out = null;
		try {
			file = new File(attach.getFilePath());
			if (file != null && file.exists()) {
				response.setContentType("application/octet-stream");
				response.setHeader("Content-Transfer-Encoding", "binary");
				response.setHeader("Connection", "close");
				Cookie f = new Cookie("fileDownload", "true");
				f.setMaxAge(1 * 24 * 60 * 60);
				f.setPath("/");
				response.addCookie(f);

				attach.setFileSize(file.length());
				response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(attach.getFileName().getBytes("KSC5601"), "ISO8859_1") + "\"");
				if (file.length() <= Integer.MAX_VALUE) response.setContentLength((int) attach.getFileSize());
				in = new FileInputStream(file);
				out = response.getOutputStream();
				IOUtils.copyLarge(in, out);
				response.flushBuffer();
				response.setStatus(HttpServletResponse.SC_OK);
			} else {
				log.warn("File download FILE NOT FOUND {}", file);
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.addCookie(new Cookie("fileDownload", "false"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.addCookie(new Cookie("fileDownload", "false"));
		} finally {
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(out);
			response.flushBuffer();
		}
		return false;
	}
}
