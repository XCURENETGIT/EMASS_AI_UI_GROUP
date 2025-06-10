package com.xcurenet.common.makeInfo.service.impl;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.makeInfo.service.*;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.lucene.util.InfoStream;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class MakeInfoServiceMysql extends XcnAbstractDAO {

	@Autowired
	public DeviceService deviceService;

	@Autowired
	MongoUtil mongoUtil;

	@Autowired
	public MinioFileAdapter minioFileAdapter;


	public long getTableCurrentVersion(String tableName) {
		Query query = new Query();
		query.addCriteria(Criteria.where("TABLENAME").is(tableName));
		InfoVersionVO info = mongoUtil.selectOne(query, InfoVersionVO.class, "INFO_VERSION");
		if (info == null) {
			InfoVersionVO infoVersionVO = InfoVersionVO.builder()
					.TABLENAME(tableName)
					.build();
			mongoUtil.insert(infoVersionVO, "INFO_VERSION");
			return 0;
		}
		return info.getVERSION();
	}


	public int addVersion(String tableName, long version) {
		mongoUtil.updateVersion("INFO_VERSION", tableName, version);
		return 1;

	}

	public void addInfoUser() {
		Map<String, Long> map = new HashMap<>();
		log.info("[MAKE INFO] User information apply start");
		long version = getTableCurrentVersion("INFO_USER") + 1;
		LocalDateTime localDateTime = LocalDateTime.now();
		appendData("getInfoUser", "INFO_USER", version);
		addVersion("INFO_USER", version);
		mongoUtil.updateDate("INFO_USER", localDateTime);


		version = getTableCurrentVersion("INFO_IP") + 1;
		appendData("getInfoIp", "INFO_IP", version);
		addVersion("INFO_IP", version);
		mongoUtil.updateDate("INFO_IP", localDateTime);

		version = getTableCurrentVersion("INFO_ACCOUNT") + 1;
		appendData("getInfoAccount", "INFO_ACCOUNT", version);
		addVersion("INFO_ACCOUNT", version);
		mongoUtil.updateDate("INFO_ACCOUNT", localDateTime);


		version = getTableCurrentVersion("INFO_EMAILADDR") + 1;
		JSONObject param = new JSONObject();
		if (Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")) {
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		param.put("VERSION", version);
		appendData(param, "getInfoEmailAddr", "INFO_EMAILADDR", version);
		addVersion("INFO_EMAILADDR", version);
		mongoUtil.updateDate("INFO_EMAILADDR", localDateTime);

		addInfoRegExp();
		log.info("[MAKE INFO] User information apply end");
	}

	public int updateAdminUserGroupList() {
		int result = 0;
		result = delete("com.xcurenet.sqlmap.mappers.mysql.user.updateAdminUserGroupList", "");


		return result;
	}

	public int addInfoDevice() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			log.info("[MAKE INFO] Device information apply start");

			long version = getTableCurrentVersion("INFO_DEVICE") + 1;
			LocalDateTime localDateTime = LocalDateTime.now();
			appendData("getInfoDevice", "INFO_DEVICE", version);
			addVersion("INFO_DEVICE", version);
			mongoUtil.updateDate("INFO_DEVICE", localDateTime);

			log.info("[MAKE INFO] Device information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}


	public int addInfoHoliday() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			log.info("[MAKE INFO] Holiday information apply start");

			long version = getTableCurrentVersion("INFO_HOLIDAY") + 1;
			LocalDateTime localDateTime = LocalDateTime.now();

			appendData("getInfoHoliDay", "INFO_HOLIDAY", version);
			addVersion("INFO_HOLIDAY", version);
			mongoUtil.updateDate("INFO_HOLIDAY", localDateTime);

			log.info("[MAKE INFO] Holiday information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}


	public int addInfoWorkDay() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] WorkDay information apply start");

			long version = getTableCurrentVersion("INFO_WORKDAY") + 1;
			LocalDateTime localDateTime = LocalDateTime.now();

			appendData("getInfoWorkDay", "INFO_WORKDAY", version);
			addVersion("INFO_WORKDAY", version);
			mongoUtil.updateDate("INFO_WORKDAY", localDateTime);

			log.info("[MAKE INFO] WorkDay information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	public int addInfoDomainNoLog() {
		int result = 0;
		log.info("[MAKE INFO] NoLogDomainFilter information apply start");
		LocalDateTime localDateTime = LocalDateTime.now();

		long version = getTableCurrentVersion("INFO_NOLOG_DOMAIN") + 1;
		appendData("getInfoNoLogDomain", "INFO_NOLOG_DOMAIN", version);
		addVersion("INFO_NOLOG_DOMAIN", version);
		mongoUtil.updateDate("INFO_NOLOG_DOMAIN", localDateTime);

		log.info("[MAKE INFO] NoLogDomainFilter information apply end");
		return result;

	}

	public int addInfoSubjectNoLog() {
		int result = 0;
		log.info("[MAKE INFO] NoLogSubjectFilter information apply start");
		LocalDateTime localDateTime = LocalDateTime.now();

		long version = getTableCurrentVersion("INFO_NOLOG_SUBJECT") + 1;
		appendData("getInfoNoLogSubject", "INFO_NOLOG_SUBJECT", version);
		addVersion("INFO_NOLOG_SUBJECT", version);
		mongoUtil.updateDate("INFO_NOLOG_SUBJECT", localDateTime);

		log.info("[MAKE INFO] NoLogSubjectFilter information apply end");
		return result;

	}

	public int addInfoSizeNoLog() {
		int result = 0;
		log.info("[MAKE INFO] NoLogSizeFilter information apply start");
		LocalDateTime localDateTime = LocalDateTime.now();

		long version = getTableCurrentVersion("INFO_NOLOG_SIZE") + 1;
		appendData("getInfoNoLogSize", "INFO_NOLOG_SIZE", version);
		addVersion("INFO_NOLOG_SIZE", version);
		mongoUtil.updateDate("INFO_NOLOG_SIZE", localDateTime);

		log.info("[MAKE INFO] NoLogSizeFilter information apply end");
		return result;

	}

	public int addInfoUrlNoLog() {
		int result = 0;
		log.info("[MAKE INFO] NoLogUrlFilter information apply start");
		LocalDateTime localDateTime = LocalDateTime.now();

		long version = getTableCurrentVersion("INFO_NOLOG_URL") + 1;
		appendData("getInfoNoLogUrl", "INFO_NOLOG_URL", version);
		addVersion("INFO_NOLOG_URL", version);
		mongoUtil.updateDate("INFO_NOLOG_URL", localDateTime);
		save(Common.toJSONArray(selectList("com.xcurenet.sqlmap.mappers.mysql.makeInfo.getInfoNoLogUrl")));

		log.info("[MAKE INFO] NoLogUrlFilter information apply end");
		return result;

	}

	public int addInfoIdNoLog() {
		int result = 0;
		log.info("[MAKE INFO] NoLogIdFilter information apply start");
		LocalDateTime localDateTime = LocalDateTime.now();

		long version = getTableCurrentVersion("INFO_NOLOG_ID") + 1;
		appendData("getInfoNoLogId", "INFO_NOLOG_ID", version);
		addVersion("INFO_NOLOG_ID", version);
		mongoUtil.updateDate("INFO_NOLOG_ID", localDateTime);

		log.info("[MAKE INFO] NoLogIdFilter information apply end");
		return result;

	}

	public int addInfoIpRange() {
		int result = 0;
		log.info("[MAKE INFO] Busi IpRange information apply start");

		long version = getTableCurrentVersion("INFO_IPRANGE") + 1;
		LocalDateTime localDateTime = LocalDateTime.now();
		appendData("getInfoIpRange", "INFO_IPRANGE", version);
		addVersion("INFO_IPRANGE", version);
		mongoUtil.updateDate("INFO_IPRANGE", localDateTime);

		log.info("[MAKE INFO] Busi IpRange information apply end");
		return result;
	}

	public int addInfoIpRangeDept() {
		int result = 0;
		log.info("[MAKE INFO] Dept IpRange information apply start");

		LocalDateTime localDateTime = LocalDateTime.now();
		long version = getTableCurrentVersion("INFO_IPRANGE_DEPT") + 1;
		appendData("getInfoIpRangeDept", "INFO_IPRANGE_DEPT", version);
		addVersion("INFO_IPRANGE_DEPT", version);
		mongoUtil.updateDate("INFO_IPRANGE_DEPT", localDateTime);

		log.info("[MAKE INFO] Dept IpRange information apply end");
		return result;
	}


	public int addInfoKeyword() {
		int result = 0;
		log.info("[MAKE INFO] Keyword information apply start");

		long version = getTableCurrentVersion("INFO_KEYWORD") + 1;
		LocalDateTime localDateTime = LocalDateTime.now();
		appendData("getInfoKeyword", "INFO_KEYWORD", version);
		addVersion("INFO_KEYWORD", version);
		mongoUtil.updateDate("INFO_KEYWORD", localDateTime);

		log.info("[MAKE INFO] Keyword information apply end");

		return result;
	}


	public int addInfoRegExp() {
		int result = 0;
		log.info("[MAKE INFO] private information apply start");

		long version = getTableCurrentVersion("INFO_PRIVATE") + 1;
		LocalDateTime localDateTime = LocalDateTime.now();
		appendData("getInfoRegExp", "INFO_PRIVATE", version);
		addVersion("INFO_PRIVATE", version);

		mongoUtil.updateDate("INFO_PRIVATE", localDateTime);
		log.info("[MAKE INFO] private information apply end");
		return result;
	}

	public int addInfoPatternExcept() {
		int result = 0;
		log.info("[MAKE INFO] PatternExcept information apply start");
		LocalDateTime localDateTime = LocalDateTime.now();

		long version = getTableCurrentVersion("INFO_PATTERN_EXCEPT") + 1;
		appendData("getInfoExceptPattern", "INFO_PATTERN_EXCEPT", version);
		addVersion("INFO_PATTERN_EXCEPT", version);
		mongoUtil.updateDate("INFO_PATTERN_EXCEPT", localDateTime);

		log.info("[MAKE INFO] PatternExcept information apply end");
		return result;

	}

	public int addInfoKeywordCore() {
		int result = 0;
		log.info("[MAKE INFO] KeywordCore information apply start");

		long version = getTableCurrentVersion("INFO_KEYWORD_CORE") + 1;
		LocalDateTime localDateTime = LocalDateTime.now();

		appendData("getInfoKeywordCore", "INFO_KEYWORD_CORE", version);
		addVersion("INFO_KEYWORD_CORE", version);
		mongoUtil.updateDate("INFO_KEYWORD_CORE", localDateTime);

		log.info("[MAKE INFO] KeywordCore information apply end");

		return result;
	}


	public void save(JSONArray data) {
		String urlContent = data.toString();
		//log.info("NO_LOG_URL File upload\n{}", urlContent);

		File urlFile = new File(Config.URL_PATH);
		Common.mkdirs(urlFile.getParent());

		byte[] bytes = urlContent.getBytes();
		ByteArrayInputStream bis = null;
		FileOutputStream fos = null;

		try {
			if (urlFile.exists()) {
				File backup = new File(Config.URL_BACKUP_PATH + Common.getCurrentDate() + File.separator + urlFile.getName() + "." + new DateTime().toString("yyyyMMddHHmmss"));
				Common.mkdirs(backup.getParent());
				FileUtils.copyFile(urlFile, backup);
			}

			bis = new ByteArrayInputStream(bytes);
			fos = new FileOutputStream(urlFile);

			IOUtils.copy(bis, fos);
			fos.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(bis);
			IOUtils.closeQuietly(fos);
		}

		makeInfo_nologUrl();
	}

	private void makeInfo_nologUrl() {
		File urlFile = new File(Config.URL_PATH);
		if (!urlFile.exists()) return;
		try {
			InputStream inputStream = new FileInputStream(urlFile);
			String fileName = urlFile.getName();
			minioFileAdapter.decoderFileUpload(inputStream, fileName);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	public void appendData(String select, String collectionName, long version) {
		long pageSize = 10000;
		JSONObject param = new JSONObject();
		param.put("pageSize", pageSize);

		long offset = 0;
		while (true) {
			param.put("offset", offset);

			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
			if (data.size() == 0) break;
			offset += data.size();
			for (int i = 0; i < data.size(); i++) {
				JSONObject obj = data.getJSONObject(i);
				obj.put("VERSION", version);

				if (Common.isEquals(collectionName, "INFO_USER")) {
					InfoUserVO infoUserVO = new InfoUserVO();
					infoUserVO.setVERSION(obj.getInt("VERSION"));
					infoUserVO.setUSERID(obj.getString("USERID"));
					infoUserVO.setNAME(obj.getString("NAME"));
					infoUserVO.setCOCD(obj.optString("COCD"));
					infoUserVO.setCONM(obj.optString("CONM"));
					infoUserVO.setSUBORGCD(obj.optString("SUBORGCD"));
					infoUserVO.setSUBORGNM(obj.optString("SUBORGNM"));
					infoUserVO.setBUSICD(obj.optString("BUSICD"));
					infoUserVO.setBUSINM(obj.optString("BUSINM"));
					infoUserVO.setDEPTCD(obj.optString("DEPTCD"));
					infoUserVO.setDEPTNM(obj.optString("DEPTNM"));
					infoUserVO.setJIKGUBCD(obj.optString("JIKGUBCD"));
					infoUserVO.setJIKGUBNM(obj.optString("JIKGUBNM"));
					infoUserVO.setCEO(obj.optString("CEO").equals("Y") ? "Y" : "N");
					infoUserVO.setSABUN(obj.optString("SABUN"));
					mongoUtil.insert(infoUserVO);
				} else if (Common.isEquals(collectionName, "INFO_IP")) {
					InfoIpVO infoIpVO = new InfoIpVO();
					infoIpVO.setVERSION(obj.getInt("VERSION"));
					infoIpVO.setIP(obj.getString("IP"));
					infoIpVO.setUSERID(obj.getString("USERID"));
					mongoUtil.insert(infoIpVO);
				} else if (Common.isEquals(collectionName, "INFO_DEVICE")) {
					InfoDeviceVO infoDeviceVO = new InfoDeviceVO();
					infoDeviceVO.setVERSION(obj.getInt("VERSION"));
					infoDeviceVO.setEID(obj.getString("EID"));
					infoDeviceVO.setNAME(obj.getString("NAME"));
					infoDeviceVO.setIP(obj.getString("IP"));
					mongoUtil.insert(infoDeviceVO);
				} else if (Common.isEquals(collectionName, "INFO_HOLIDAY")) {
					InfoHolidayVO infoHolidayVO = new InfoHolidayVO();
					infoHolidayVO.setVERSION(obj.getInt("VERSION"));
					infoHolidayVO.setCOCD(obj.getString("COCD"));
					infoHolidayVO.setBUSICD(obj.getString("BUSICD"));
					infoHolidayVO.setDATE(obj.getString("DATE"));
					infoHolidayVO.setCOMMENTS(obj.getString("COMMENTS"));
					mongoUtil.insert(infoHolidayVO);
				} else if (Common.isEquals(collectionName, "INFO_PATTERN_EXCEPT")) {
					InfoPatternExpectVO infoPatternExpectVO = new InfoPatternExpectVO();
					infoPatternExpectVO.setVERSION(obj.getInt("VERSION"));
					infoPatternExpectVO.setPATTERN(obj.getString("PATTERN"));
					infoPatternExpectVO.setPRIVATETYPE(obj.getString("PRIVATETYPE"));
					mongoUtil.insert(infoPatternExpectVO);
				} else if (Common.isEquals(collectionName, "INFO_WORKDAY")) {
					InfoWorkdayVO infoWorkdayVO = new InfoWorkdayVO();
					infoWorkdayVO.setVERSION(obj.getInt("VERSION"));
					infoWorkdayVO.setCOCD(obj.getString("COCD"));
					infoWorkdayVO.setBUSICD(obj.getString("BUSICD"));
					infoWorkdayVO.setWDAY(obj.getString("WDAY"));
					infoWorkdayVO.setWHOUR(obj.getString("WHOUR"));
					mongoUtil.insert(infoWorkdayVO);
				} else if (Common.isEquals(collectionName, "INFO_IPRANGE")) {
					InfoIprangeVO infoIprangeVO = new InfoIprangeVO();
					infoIprangeVO.setVERSION(obj.getInt("VERSION"));
					infoIprangeVO.setBUSICD(obj.getString("BUSICD"));
					infoIprangeVO.setBUSINM(obj.getString("BUSINM"));
					infoIprangeVO.setCOCD(obj.getString("COCD"));
					infoIprangeVO.setCONM(obj.getString("CONM"));
					infoIprangeVO.setEIP(obj.getString("EIP"));
					infoIprangeVO.setINSIDE(obj.getString("INSIDE"));
					infoIprangeVO.setSIP(obj.getString("SIP"));
					infoIprangeVO.setCOUNTRY(obj.getString("COUNTRY"));
					mongoUtil.insert(infoIprangeVO);
				} else if (Common.isEquals(collectionName, "INFO_IPRANGE_DEPT")) {
					InfoIpRangeDeptVO infoIpRangeDeptVO = new InfoIpRangeDeptVO();
					infoIpRangeDeptVO.setVERSION(obj.getInt("VERSION"));
					infoIpRangeDeptVO.setSIP(obj.getString("SIP"));
					infoIpRangeDeptVO.setEIP(obj.getString("EIP"));
					infoIpRangeDeptVO.setDEPTCD(obj.getString("DEPTCD"));
					infoIpRangeDeptVO.setDEPTNM(obj.getString("DEPTNM"));
					infoIpRangeDeptVO.setCOCD(obj.getString("COCD"));
					infoIpRangeDeptVO.setCONM(obj.getString("CONM"));
					infoIpRangeDeptVO.setINSIDE(obj.getString("INSIDE"));
					mongoUtil.insert(infoIpRangeDeptVO);
				} else if (Common.isEquals(collectionName, "INFO_KEYWORD_CORE")) {
					InfoKeywordCoreVO infoKeywordCoreVO = new InfoKeywordCoreVO();
					infoKeywordCoreVO.setVERSION(obj.getInt("VERSION"));
					infoKeywordCoreVO.setKEYWORD(obj.getString("KEYWORD"));
					infoKeywordCoreVO.setCATEGORY(obj.getString("CATEGORY"));
					mongoUtil.insert(infoKeywordCoreVO);
				} else if (Common.isEquals(collectionName, "INFO_KEYWORD")) {
					InfoKeywordVO infoKeywordVO = new InfoKeywordVO();
					infoKeywordVO.setVERSION(obj.getInt("VERSION"));
					infoKeywordVO.setKEYWORD(obj.getString("KEYWORD"));
					mongoUtil.insert(infoKeywordVO);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_URL")) {
					InfoNologUrlVO infoNologUrlVO = new InfoNologUrlVO();
					infoNologUrlVO.setVERSION(obj.getInt("VERSION"));
					infoNologUrlVO.setURL(obj.getString("URL"));
					mongoUtil.insert(infoNologUrlVO);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_SUBJECT")) {
					InfoNologSubjectVO infoNologSubjectVO = new InfoNologSubjectVO();
					infoNologSubjectVO.setSUBJECT(obj.getString("SUBJECT"));
					infoNologSubjectVO.setSERVICECD(obj.getString("SERVICECD"));
					infoNologSubjectVO.setVERSION(obj.getInt("VERSION"));
					mongoUtil.insert(infoNologSubjectVO);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_SIZE")) {
					InfoNologSizeVO infoNologSizeVO = new InfoNologSizeVO();
					infoNologSizeVO.setSERVICECD(obj.getString("SERVICECD"));
					infoNologSizeVO.setSIZE_CONDITION(obj.getString("SIZE_CONDITION"));
					infoNologSizeVO.setVERSION(obj.getInt("VERSION"));
					infoNologSizeVO.setLOWSIZE(obj.getInt("LOWSIZE"));
					infoNologSizeVO.setHIGHSIZE(obj.getInt("HIGHSIZE"));
					mongoUtil.insert(infoNologSizeVO);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_ID")) {
					InfoNologIdVO infoNologIdVO = new InfoNologIdVO();
					infoNologIdVO.setSERVICECD(obj.getString("SERVICECD"));
					infoNologIdVO.setVERSION(obj.getInt("VERSION"));
					infoNologIdVO.setUSERID(obj.getString("USERID"));
					mongoUtil.insert(infoNologIdVO);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_DOMAIN")) {
					InfoNologDomainVO infoNologDomainVO = new InfoNologDomainVO();
					infoNologDomainVO.setVERSION(obj.getInt("VERSION"));
					infoNologDomainVO.setSERVICECD(obj.getString("SERVICECD"));
					infoNologDomainVO.setDOMAIN(obj.getString("DOMAIN"));
					mongoUtil.insert(infoNologDomainVO);
				} else if (Common.isEquals(collectionName, "INFO_PRIVATE")) {
					InfoPrivateVO infoPrivateVO = new InfoPrivateVO();
					infoPrivateVO.setVERSION(obj.getInt("VERSION"));
					infoPrivateVO.setCODE(obj.getString("CODE"));
					infoPrivateVO.setREGEX(obj.optString("REGEX"));
					infoPrivateVO.setENABLE(obj.optString("ENABLE"));
					mongoUtil.insert(infoPrivateVO);
				} else if (Common.isEquals(collectionName, "INFO_ACCOUNT")) {
					InfoAccountVO infoAccountVO = new InfoAccountVO();
					infoAccountVO.setVERSION(obj.getInt("VERSION"));
					infoAccountVO.setUSERID(obj.getString("USERID"));
					infoAccountVO.setSERVICECD(obj.getString("SERVICECD"));
					infoAccountVO.setACCOUNT(obj.getString("ACCOUNT"));
					mongoUtil.insert(infoAccountVO);
				}
			}
			if (data.size() < pageSize) break;

		}
	}

	public void appendData(JSONObject param, String select, String collectionName, long version) {
		long pageSize = 10000;
		param.put("pageSize", pageSize);

		long offset = 0;
		while (true) {
			param.put("offset", offset);
			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
			if (data.size() == 0) break;
			offset += data.size();
			for (int i = 0; i < data.size(); i++) {
				JSONObject obj = data.getJSONObject(i);
				obj.put("VERSION", version);
				if (Common.isEquals(collectionName, "INFO_EMAILADDR")) {
					InfoEmailaddrVO infoEmailaddrVO = new InfoEmailaddrVO();
					infoEmailaddrVO.setVERSION(obj.getInt("VERSION"));
					infoEmailaddrVO.setEMAILADDR(obj.getString("EMAILADDR"));
					infoEmailaddrVO.setUSERID(obj.getString("USERID"));
					mongoUtil.insert(infoEmailaddrVO);
				}

			}
			if (data.size() < pageSize) break;
		}
	}

	public int addInfoNoLog() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] NoLogFilter information apply start");

			long version = getTableCurrentVersion("INFO_NOLOG_URL") + 1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogUrl", version);
			addVersion("INFO_NOLOG_URL", version);
			save(Common.toJSONArray(selectList("com.xcurenet.sqlmap.mappers.mysql.makeInfo.getInfoNoLogUrl")));

			version = getTableCurrentVersion("INFO_NOLOG_SUBJECT") + 1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogSubject", version);
			addVersion("INFO_NOLOG_SUBJECT", version);

			version = getTableCurrentVersion("INFO_NOLOG_SIZE") + 1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogSize", version);
			addVersion("INFO_NOLOG_SIZE", version);

			version = getTableCurrentVersion("INFO_NOLOG_ID") + 1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogUserId", version);
			addVersion("INFO_NOLOG_ID", version);

			version = getTableCurrentVersion("INFO_NOLOG_DOMAIN") + 1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogDomain", version);
			addVersion("INFO_NOLOG_DOMAIN", version);

			log.info("[MAKE INFO] NoLogFilter information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}



}
