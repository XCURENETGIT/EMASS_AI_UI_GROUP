package com.xcurenet.minio;

import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.util.Common;
import io.minio.*;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


@Log4j2
@Service
public class MinioFileAdapter {

	public final MinioClient minioClient;

	@Value("${spring.minio.bucket}")
	public String bucket;

	@Autowired
	public MinioFileAdapter(MinioClient minioClient) {
		this.minioClient = minioClient;
	}


	/**
	 * Bucket Exists
	 *
	 * @param bucket name
	 * @return Exists
	 */
	public boolean findBucket(String bucket) {
		try {
			return minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucket).build());
		} catch (Exception ignored) {
		}
		return false;
	}


	public byte[] open(String objectName) {
		InputStream in = null;
		try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
			boolean found = findBucket(bucket);
			if (found) {
				in = minioClient.getObject(GetObjectArgs.builder().bucket(bucket).object(objectName).build());
				CryptoCommon crypto = new CryptoCommon();
				if (in != null) {
					IOUtils.copy(crypto.decrypt(in), out);
					return out.toByteArray();
				}
			} else {
				log.warn("bucket not found. {}", objectName);
			}
		} catch (Exception e) {
			log.warn("file found error : {} {}", e.getMessage(), objectName);
		} finally {
			IOUtils.closeQuietly(in);
		}
		return new byte[0];
	}


	public InputStream findFile(String objectName) {
		try {
			boolean found = findBucket(bucket);
			if (found) {
				CryptoCommon crypto = new CryptoCommon();
				return crypto.decrypt(minioClient.getObject(GetObjectArgs.builder().bucket(bucket).object(objectName).build()));
			} else {
				log.warn("bucket not found : {}", objectName);
			}
		} catch (Exception e) {
			log.warn("file found error : {} {}", e.getMessage(), objectName);
		}
		return null;
	}


	//파일 다운로드 - 단건
	public void fileDownload(String objectName, String fileName, final HttpServletRequest request, final HttpServletResponse response) throws IOException {
		response.setCharacterEncoding(Common.UTF8);

		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Connection", "close");
		Cookie f = new Cookie("fileDownload", "true");
		f.setMaxAge(1 * 24 * 60 * 60);
		f.setPath("/");
		response.addCookie(f);

		InputStream inputStream = null;
		OutputStream outputStream = null;

		try {
			//파일 찾기
			inputStream = findFile(objectName);
			outputStream = response.getOutputStream();

			if (inputStream == null) { // 파일이 존재하지 않을때
				log.warn("file not found..attach {} {} ", fileName, objectName);
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

			inputStream.close();

		} catch (Exception e) {
			log.error("", e);
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.addCookie(new Cookie("fileDownload", "false"));
		} finally {
			IOUtils.closeQuietly(inputStream);
			IOUtils.closeQuietly(outputStream);
			response.flushBuffer();
		}
	}

}
