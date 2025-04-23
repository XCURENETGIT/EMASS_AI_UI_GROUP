package com.xcurenet.minio;

import com.xcurenet.common.crypto.CryptoCommon;
import com.xcurenet.common.crypto.CryptoKey;
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
import java.util.UUID;


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


    /***
     *  minIO에서 파일 찾기 (10MB 이하의 파일 읽을시 사용 권장 ex:사진 미리보기) (암호화 사용 모드일 경우 복호화)
     * @param filePath
     * @return
     */
    public byte[] open(String filePath) {
        try (InputStream in = getFile(filePath)) {
            if (in == null) return new byte[0];
            try (InputStream effectiveIn = CryptoKey.isEncrypt ? new CryptoCommon().decrypt(in) : in;
                 ByteArrayOutputStream bout = new ByteArrayOutputStream()) {
                IOUtils.copy(effectiveIn, bout);
                return bout.toByteArray();
            }
        } catch (Exception e) {
            log.error("File open error: {}", e.getMessage(), e);
            return new byte[0];
        }
    }


    /**
     * minIO에서 파일 찾기 (암호화 사용 모드일 경우 복호화)
     * @param filePath
     */
    public InputStream findFile(String filePath) throws IOException {
        InputStream in = getFile(filePath);
        if (in == null) return null;
        if (CryptoKey.isEncrypt) {
            File file = getTempFile();
            try (FileOutputStream out = new FileOutputStream(file)) {
                IOUtils.copy(in, out);
            } finally {
                in.close();
            }
            InputStream decrypted = new CryptoCommon().decrypt(new FileInputStream(file));
            return new ObservableInputStream(decrypted, () -> {
                try {
                    Files.deleteIfExists(file.toPath());
                } catch (IOException e) {
                    log.error("{}",e);
                }
            });
        } else {
            return in;
        }
    }


    /**
     * @param filePath
     * @return
     */
    private InputStream getFile(String filePath) {
        try {
            boolean found = findBucket(bucket);
            if (found) {
                return minioClient.getObject(GetObjectArgs.builder().bucket(bucket).object(filePath).build());
            } else {
                log.warn("bucket not found : {}", filePath);
            }
        } catch (Exception e) {
            log.warn("file found error : {} {}", e.getMessage(), filePath);
        }
        return null;
    }


    public static File getTempFile(){
       return new File(Common.TMP_PATH + Common.nvl(UUID.randomUUID()));
    }

}
