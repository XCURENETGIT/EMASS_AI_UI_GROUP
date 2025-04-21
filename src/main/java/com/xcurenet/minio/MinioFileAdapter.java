package com.xcurenet.minio;

import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.util.Common;
import io.minio.*;
import io.minio.messages.Item;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.Files;


@Log4j2
@Service
public class MinioFileAdapter {

    public final MinioClient minioClient;

    @Value("${spring.minio.bucket}")
    public String bucket;


    @Value("${spring.minio.decoderBucket}")
    public String decoderBucket;



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


    /***
     *  파일 열기 (10MB 이하의 파일 읽을시 사용 권장 ex:사진 미리보기)
     * @param objectName
     * @return
     */
    public byte[] open(String objectName) {
        InputStream in = null;
        try {
            boolean found = findBucket(bucket);
            if (found) {
                in = minioClient.getObject(GetObjectArgs.builder().bucket(bucket).object(objectName).build());
                CryptoCommon crypto = new CryptoCommon();
                return crypto.decrypt(in.readAllBytes());
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


    /**
     * decoderFileUpload
     * @param inputStream
     * @param fileName
     * @return
     */
    public InputStream decoderFileUpload(InputStream inputStream, String fileName) {
        try {
            boolean found = findBucket(bucket);
            if (found) {
                minioClient.putObject(
                        PutObjectArgs.builder()
                                .bucket(bucket)
                                .stream(inputStream, inputStream.available(), -1)
                                .object("/info/" + fileName)
                                .build()
                );
            }
        } catch (Exception e) {
            log.warn("decoder File Upload error : {} {}", fileName, inputStream);
        }
        return null;
    }


    /**
     * findFile
     * @param objectName
     * @return
     */
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


    public boolean exists(String path) throws IOException {
        try {
            Iterable<Result<Item>> results = minioClient.listObjects(
                    ListObjectsArgs.builder()
                            .bucket(bucket)
                            .prefix(removeLeadingSlash(path))
                            .maxKeys(1)
                            .includeVersions(false)
                            .build());

            for (Result<Item> item : results) {
                return true;
            }
        } catch (Exception e) {
            log.error("", e);
        }
        return false;
    }

    public static String removeLeadingSlash(String input) {
        if (input != null && input.startsWith("/")) {
            return input.substring(1);
        }
        return input;
    }


    /**
     * 파일 복호화
     * @param objectName
     * @param fileName
     * @return
     */
    /**
     * 파일 복호화 및 삭제 예약 InputStream 반환
     */
    public InputStream decryptedInputStream(String objectName, String randomStr, String fileName) throws IOException {
        File file = getTempFile(randomStr, fileName);
        try (InputStream in = minioClient.getObject(GetObjectArgs.builder().bucket(bucket).object(objectName).build());
             FileOutputStream fout = new FileOutputStream(file)
        ) {
            IOUtils.copy(in, fout);
        } catch (Exception e) {
            throw new IOException(e);
        }
        InputStream decrypted = new CryptoCommon().decrypt(new FileInputStream(file));
        return new ObservableInputStream(decrypted, () -> {
         //   log.info("InputStream for {} has been closed!", objectName);
            try {
                Files.deleteIfExists(file.toPath());
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
    }


    /**
     * getFileExtension
     *
     * @param fileName
     * @return
     */
    public static String getFileExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex == -1) {
            return "";
        }
        return "."+fileName.substring(dotIndex + 1);
    }


    public static File getTempFile(String randomStr,String fileName){
       return new File(Common.TMP_PATH + randomStr + getFileExtension(fileName));
    }

}
