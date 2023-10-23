package com.xcurenet.minio;

import com.xcurenet.common.util.Common;
import io.minio.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


@Service
@Slf4j
public class MinioFileAdapter {

	@Autowired
	public MinioClient minioClient;

	@Value("${spring.minio.bucket}")
	public String bucket;


	//버킷 유무 찾기
	public boolean findBucket(String bucket) {

		boolean found = false;
		try {
			found = minioClient.bucketExists(BucketExistsArgs.builder()
					.bucket(bucket)
					.build());

		} catch (Exception e) {
		}
		return found;
	}


	//파일 객체 찾기 -> null 이면 객체 없음
	public InputStream findFile(String objectName) {
		try {
			//버킷 존재 유무
			boolean found = findBucket(bucket);
			if (found) { // 버킷이 존재 한다면
				//해당 파일 찾기
				InputStream object = minioClient.getObject(
						GetObjectArgs.builder()
								.bucket(bucket)
								.object(objectName)
								.build()
				);
				return object;
			} else { // 버킷 없을때
				log.warn("bucket not found ..");
			}
		} catch (Exception e) {
			log.warn("file found error ..");
		}
		return null;
	}

	// 파일 삭제 (삭제 완료 되면 true 리턴)
	public boolean fileDelete(String objectName) {

		Object object = findFile(objectName);
		try {
			if (object != null) { //파일이 존재 한다면 삭제
				minioClient.removeObject((RemoveObjectArgs) object);
				return true;
			} else { // 파일이 존재하지 않음
				log.warn("file not foud ..");
			}

		} catch (Exception e) {
			log.error("file delete error..");
		}
		return false;
	}

	//파일 업로드
	private void fileUpload(MultipartFile file, String fileName) {
		try {
			if (findBucket(bucket)) { // 이미 버킷이 있을 경우
				InputStream inputStream = file.getInputStream();
				minioClient.putObject(PutObjectArgs.builder() //파일 업로드
						.bucket(bucket)
						.object(fileName)
						.contentType(file.getContentType())
						.stream(inputStream, inputStream.available(), -1)
						.build());

			} else { // 버킷이 없을 경우
				// 버킷이 없을 경우 에러가 뜸?

				// 새로운 버킷 생성?
			}
		} catch (Exception e) {
			log.error("file upload error..");

		}
	}


//	//파일 다운로드
//	public void fileDownload(String objectName, String fileName, final HttpServletRequest request, final HttpServletResponse response) throws IOException {
//
//
//		response.setContentType("application/octet-stream");
//		response.setHeader("Content-Transfer-Encoding", "binary");
//		response.setHeader("Connection", "close");
//		response.setHeader("Content-Disposition", "attachment; filename=\"" + Common.getEncodingFileName(request, fileName) + ".html\"");
//
//		ServletOutputStream out = null;
//				try {
//					out = response.getOutputStream();
//					out.write(new EmsCre);
//
//
//				}catch (Exception e) {
//					e.printStackTrace();
//				}finally {
//					IOUtils.closeQuietly(out);
//				}
//
//	}


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
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.addCookie(new Cookie("fileDownload", "false"));
		} finally {
			IOUtils.closeQuietly(inputStream);
			IOUtils.closeQuietly(outputStream);
			response.flushBuffer();
		}
	}

}
