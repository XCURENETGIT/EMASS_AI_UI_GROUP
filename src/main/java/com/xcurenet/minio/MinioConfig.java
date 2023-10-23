package com.xcurenet.minio;


import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MinioConfig {

	@Value("${spring.minio.access-key}")
	String accessKey;
	@Value("${spring.minio.secret-key}")
	String accessSecret;
	@Value("${spring.minio.url}")
	String minioUrl;


	@Bean
	public MinioClient minioClient(){
		 MinioClient minioClient = MinioClient.builder()
				.credentials(accessKey,accessSecret)
				.endpoint(minioUrl)
				.build();

		 return minioClient;
	}

}
