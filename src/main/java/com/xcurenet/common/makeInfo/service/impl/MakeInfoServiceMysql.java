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
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
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
		List<DeviceVO> devices = deviceService.getCollectionDevice();
		for (DeviceVO device : devices) {
			File urlFile = new File(Config.URL_PATH);
			if (!urlFile.exists()) return;

			SFTPUtil ftp = new SFTPUtil();
			try {
				ftp.init(device.getDeviceIp(), device.getSshId(), device.getSshPw(), 22);
				ftp.mkdir(Config.DECODER_CONF_PATH);
				ftp.upload(Config.DECODER_CONF_PATH, urlFile.getName() + ".tmp", urlFile);
				ftp.rename(Common.makeFilepath(Config.DECODER_CONF_PATH, urlFile.getName() + ".tmp"), Common.makeFilepath(Config.DECODER_CONF_PATH, urlFile.getName()));
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				ftp.disconnection();
			}
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
					InfoUserVO infoUserVO = InfoUserVO.builder()
							.USERID((String) obj.get("USERID"))
							.BUSICD((String) obj.get("BUSICD"))
							.BUSINM((String) obj.get("BUSINM"))
							.CEO((String) (obj.get("CEO").equals("Y") ? "Y" : "N"))
							.COCD((String) obj.get("COCD"))
							.CONM((String) obj.get("CONM"))
							.DEPTCD((String) obj.get("DEPTCD"))
							.DEPTNM((String) obj.get("DEPTNM"))
							.JIKGUBCD((String) obj.get("JIKGUBCD"))
							.JIKGUBNM((String) obj.get("JIKGUBNM"))
							.NAME((String) obj.get("NAME"))
							.SUBORGCD((String) obj.get("SUBORGCD"))
							.SUBORGNM((String) obj.get("SUBORGNM"))
							.VERSION((int) obj.get("VERSION"))
							.build();
					mongoUtil.insert(infoUserVO, collectionName);

				} else if (Common.isEquals(collectionName, "INFO_IP")) {
					InfoIpVO infoIpVO = InfoIpVO.builder()
							.IP((String) obj.get("IP"))
							.USERID((String) obj.get("USERID"))
							.VERSION((Integer) obj.get("VERSION"))
							.build();
					mongoUtil.insert(infoIpVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_DEVICE")) {
					InfoDeviceVO infoDeviceVO = InfoDeviceVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.EID((String) obj.get("EID"))
							.NAME((String) obj.get("NAME"))
							.IP((String) obj.get("IP"))
							.build();
					mongoUtil.insert(infoDeviceVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_HOLIDAY")) {
					InfoHolidayVO infoHolidayVO = InfoHolidayVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.COCD((String) obj.get("COCD"))
							.BUSICD((String) obj.get("BUSICD"))
							.DATE((String) obj.get("DATE"))
							.COMMENTS((String) obj.get("COMMENTS"))
							.build();
					mongoUtil.insert(infoHolidayVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_WORKDAY")) {
					InfoWorkdayVO infoWorkdayVO = InfoWorkdayVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.COCD((String) obj.get("COCD"))
							.BUSICD((String) obj.get("BUSICD"))
							.WDAY((String) obj.get("WDAY"))
							.WHOUR((String) obj.get("WHOUR"))
							.build();
					mongoUtil.insert(infoWorkdayVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_IPRANGE")) {
					InfoIprangeVO infoIprangeVO = InfoIprangeVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.BUSICD((String) obj.get("BUSICD"))
							.BUSINM((String) obj.get("BUSINM"))
							.CITY((String) obj.get("CITY"))
							.COCD((String) obj.get("COCD"))
							.CONM((String) obj.get("CONM"))
							.COUNTRY((String) obj.get("COUNTRY"))
							.EIP((String) obj.get("EIP"))
							.INSIDE((String) obj.get("INSIDE"))
							.LATITUDE((String) obj.get("LATITUDE"))
							.LONGITUDE((String) obj.get("LONGITUDE"))
							.SIP((String) obj.get("SIP"))
							.build();
					mongoUtil.insert(infoIprangeVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_IPRANGE_DEPT")) {
					InfoIpRangeDeptVO infoIpRangeDeptVO = InfoIpRangeDeptVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.SIP((String) obj.get("SIP"))
							.EIP((String) obj.get("EIP"))
							.DEPTCD((String) obj.get("DEPTCD"))
							.DEPTNM((String) obj.get("DEPTNM"))
							.COCD((String) obj.get("COCD"))
							.CONM((String) obj.get("CONM"))
							.INSIDE((String) obj.get("INSIDE"))
							.build();
					mongoUtil.insert(infoIpRangeDeptVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_KEYWORD")) {
					InfoKeywordVO infoKeywordVO = InfoKeywordVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.KEYWORD((String) obj.get("KEYWORD"))
							.build();
					mongoUtil.insert(infoKeywordVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_URL")) {
					InfoNologUrlVO infoNologUrlVO = InfoNologUrlVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.URL((String) obj.get("URL"))
							.build();
					mongoUtil.insert(infoNologUrlVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_SUBJECT")) {
					InfoNologSubjectVO infoNologSubjectVO = InfoNologSubjectVO.builder()
							.SUBJECT((String) obj.get("SUBJECT"))
							.SERVICECD((String) obj.get("SERVICECD"))
							.VERSION((int) obj.get("VERSION"))
							.build();
					mongoUtil.insert(infoNologSubjectVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_SIZE")) {
					InfoNologSizeVO infoNologSizeVO = InfoNologSizeVO.builder()
							.SERVICECD((String) obj.get("SERVICECD"))
							.SIZE_CONDITION((String) obj.get("SIZE_CONDITION"))
							.VERSION((int) obj.get("VERSION"))
							.LOWSIZE((int) obj.get("LOWSIZE"))
							.HIGHSIZE((int) obj.get("HIGHSIZE"))
							.build();
					mongoUtil.insert(infoNologSizeVO, collectionName);
				} else if (Common.isEquals(collectionName, "INFO_NOLOG_ID")) {
					InfoNologIdVO infoNologIdVO = InfoNologIdVO.builder()
							.SERVICECD((String) obj.get("SERVICECD"))
							.VERSION((int) obj.get("VERSION"))
							.USERID((String) obj.get("USERID"))
							.build();
					mongoUtil.insert(infoNologIdVO, collectionName);
				}
				else if (Common.isEquals(collectionName, "INFO_NOLOG_DOMAIN")) {
					InfoNologDomainVO infoNologDomainVO = InfoNologDomainVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.SERVICECD((String) obj.get("SERVICECD"))
							.DOMAIN((String) obj.get("DOMAIN"))
							.build();
					mongoUtil.insert(infoNologDomainVO, collectionName);

				} else if (Common.isEquals(collectionName, "INFO_PRIVATE")) {
					InfoPrivateVO infoPrivateVO = InfoPrivateVO.builder()
							.VERSION((int) obj.get("VERSION"))
							.CODE((String) obj.get("CODE"))
							.REGEX((String) obj.get("REGEX"))
							.build();
					mongoUtil.insert(infoPrivateVO, collectionName);

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
				if (collectionName == "INFO_EMAILADDR") {
					InfoEmailaddrVO infoEmailaddrVO = InfoEmailaddrVO.builder()
							.EMAILADDR((String) obj.get("EMAILADDR"))
							.USERID((String) obj.get("USERID"))
							.VERSION((int) obj.get("VERSION"))
							.build();
					mongoUtil.insert(infoEmailaddrVO, collectionName);
				}

			}
			if (data.size() < pageSize) break;
		}
	}

}
