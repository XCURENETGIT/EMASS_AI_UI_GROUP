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
        String fileName = (Common.isEquals(prediction, "Y")) ? attach.getAttachName() + "." + (Common.isEquals(attach.getAttachExt(), "unknown") ? "txt" : attach.getAttachExt()) : attach.getAttachName();
        oneFileDownloadResponse(attach.getAttachPath(), fileName, request, response);
    }


    @Description("단건,다건 파일 다운로드")
    public void download(final List<EmsAttachVO> attachs, final HttpServletRequest request, final HttpServletResponse response, final String prediction) throws Exception {
        response.setCharacterEncoding(Common.UTF8);
        if (attachs == null || attachs.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }
        if (attachs.size() == 1) {
            oneFileDownload(attachs.get(0), request, response, prediction);
            return;
        }
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Transfer-Encoding", "binary");
        response.setHeader("Connection", "close");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getDateTimeFormat() + "_attachs.zip\"");
        try (OutputStream out = response.getOutputStream();
             ArchiveOutputStream os = new ArchiveStreamFactory().createArchiveOutputStream("zip", out)) {
            for (EmsAttachVO attach : attachs) {
                try (InputStream in = minioFileAdapter.findFile(attach.getAttachPath())) {
                    if (in == null) continue;
                    if (Common.isEquals(prediction, "Y")) {
                        attach.setAttachName(attach.getAttachName() + "." + attach.getAttachExt());
                    }
                    String fileName = Common.isEquals(prediction, "Y") ? attach.getAttachName() + "." + (Common.isEquals(attach.getAttachExt(), "unknown") ? "txt" : attach.getAttachExt()) : attach.getAttachName();
                    String subject = EmsReDefined.reSubject(getFileName(attach));
                    String dir = Common.getEDCFileName(attach.getCtime(), attach.getUserId(), attach.getName(), subject, attach.getMsgId());
                    os.putArchiveEntry(new ZipArchiveEntry(dir + File.separator + fileName));
                    IOUtils.copy(in, os);
                    os.closeArchiveEntry();
                } catch (Exception e) {
                    throw new Exception(e);
                }
            }
            response.flushBuffer();
        } catch (org.apache.catalina.connector.ClientAbortException cae) {
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    // 단건 파일 다운로드
	public void oneFileDownloadResponse(String filePath, String fileName, final HttpServletRequest request, final HttpServletResponse response) throws IOException {
		response.setCharacterEncoding(Common.UTF8);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");
		Cookie f = new Cookie("fileDownload", "true");
		f.setMaxAge(1 * 24 * 60 * 60);
		f.setPath("/");
		response.addCookie(f);
		try (InputStream inputStream = minioFileAdapter.findFile(filePath);
			 OutputStream outputStream = response.getOutputStream()) {
			if (inputStream == null) {
				log.warn("file not found.");
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
