package com.xcurenet.gridfs;

import com.mongodb.client.MongoDatabase;
import com.mongodb.client.gridfs.GridFSBuckets;
import com.xcurenet.common.crypto.CryptoCommon;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.io.IOUtils;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

@Log4j2
@Service
public class GridFs {
	private MongoDatabase database;

	@Autowired
	public GridFs(MongoTemplate mongoTemplate) {
		this.database = mongoTemplate.getDb();
	}

	private final static String BUCKET_NAME = "EMS_BODY_";

	public String readString(final String msgId) throws IOException {
		return IOUtils.toString(read(msgId), StandardCharsets.UTF_8);
	}

	public byte[] readByte(final String msgId) throws IOException {
		return IOUtils.toByteArray(read(msgId));
	}

	public InputStream read(final String msgId) throws IOException {
		String colName = msgId.substring(0, 6);
		return GridFSBuckets.create(database, BUCKET_NAME + colName).openDownloadStream(new ObjectId(msgId));
	}

//	public boolean isEmpty(final String msgId) throws IOException {
//		GridFSBucket gridFSBuckets = GridFSBuckets.create(database), BUCKET_NAME + msgId.substring(0, 6));
//	//	return gridFSBuckets.
//	}

	public byte[] open(String msgId) {
		InputStream in = null;
		try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
			in = read(msgId);
			CryptoCommon crypto = new CryptoCommon();
			if (in != null) {
				IOUtils.copy(crypto.decrypt(in), out);
				return out.toByteArray();
			}
		} catch (Exception e) {
			log.warn("file found error : {} {}", e.getMessage(), msgId);
		} finally {
			IOUtils.closeQuietly(in);
		}
		return new byte[0];
	}

	public InputStream findFile(String msgId) {
		try {
			CryptoCommon crypto = new CryptoCommon();
			return crypto.decrypt(read(msgId));
		} catch (Exception e) {
			log.warn("file found error : {} {}", e.getMessage(), msgId);
		}
		return null;
	}
}
