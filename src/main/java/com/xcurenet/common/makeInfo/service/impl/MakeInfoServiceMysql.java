package com.xcurenet.common.makeInfo.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.xcurenet.common.makeInfo.service.*;
import com.xcurenet.common.util.MongoUtil;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.device.service.DeviceService;
import com.xcurenet.device.service.DeviceVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Slf4j
@Service
public class MakeInfoServiceMysql extends XcnAbstractDAO {

	@Autowired
	public DeviceService deviceService;

	@Autowired
	MongoUtil mongoUtil;


	public long getTableCurrentVersion(String tableName) {
		InfoVersionVO info = mongoUtil.selectTableVersion(tableName);
		if (info == null) return 0;
		System.out.println(info);
		return info.getVersion();
	}


	public int addVersion(String tableName, long version) {
		mongoUtil.updateVersion("INFO_VERSION", tableName, version + 1);
		return 1;

	}




	public int addInfoUser() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			Map<String, Long> map = new HashMap<>();
			log.info("[MAKE INFO] User information apply start");
			long version = getTableCurrentVersion("INFO_USER") + 1;
			System.out.println("INFO_USER" + version);
			appendData(version, "getInfoUser", "addInfoUser", "INFO_USER");
			addVersion("INFO_USER", version);


			version = getTableCurrentVersion("INFO_IP") + 1;
			appendData(version, "getInfoIp", "addInfoIp", "INFO_IP");
			addVersion("INFO_IP", version);


			version = getTableCurrentVersion("INFO_EMAILADDR") + 1;
			JSONObject param = new JSONObject();
			if (Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")) {
				param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
				param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
				param.put("encryptSize", Config.getString("private.encrypt.size"));
				param.put("encryptKey", Config.getString("private.encrypt.key"));
			}
			param.put("VERSION", version);
			appendData( param, "getInfoEmailAddr", "addInfoEmailAddr","INFO_EMAILADDR" );
			addVersion("INFO_EMAILADDR", version);

			addInfoRegExp();
			log.info("[MAKE INFO] User information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	public int updateAdminUserGroupList() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = delete("com.xcurenet.sqlmap.mappers.mysql.user.updateAdminUserGroupList", "");
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	public int addInfoDevice() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			log.info("[MAKE INFO] Device information apply start");

			long version = getTableCurrentVersion("INFO_DEVICE") + 1;
			appendData( version, "getInfoDevice", "addInfoDevice","INFO_DEVICE");
			addVersion("INFO_DEVICE", version);

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
			appendData( version, "getInfoHoliDay", "addInfoHoliDay","INFO_HOLIDAY");
			addVersion("INFO_HOLIDAY", version);

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
			appendData( version, "getInfoWorkDay", "addInfoWorkDay","INFO_WORKDAY" );
			addVersion("INFO_WORKDAY", version);

			log.info("[MAKE INFO] WorkDay information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}


	public int addInfoIpRange() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] Busi IpRange information apply start");

			long version = getTableCurrentVersion("INFO_IPRANGE") + 1;
			appendData( version, "getInfoIpRange", "addInfoIpRange","INFO_IPRANGE" );
			addVersion("INFO_IPRANGE", version);

			log.info("[MAKE INFO] Busi IpRange information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	public int addInfoIpRangeDept() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] Dept IpRange information apply start");

			long version = getTableCurrentVersion("INFO_IPRANGE_DEPT")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoIpRangeDept", version);
			addVersion("INFO_IPRANGE_DEPT", version);

			log.info("[MAKE INFO] Dept IpRange information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}



	public int addInfoKeyword() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] Keyword information apply start");

			long version = getTableCurrentVersion("INFO_KEYWORD") + 1;
			appendData( version, "getInfoKeyword", "addInfoKeyword","INFO_KEYWORD" );
			addVersion("INFO_KEYWORD", version);

			log.info("[MAKE INFO] Keyword information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}


	public int addInfoRegExp() {
		long version = getTableCurrentVersion("INFO_PRIVATE") + 1;
		Map<String, Long> map = new HashMap<>();
		map.put("VERSION", version);
		int result = mongoUtil.insert(map, "INFO_PRIVATE").size();
		//int result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoRegExp", version);
		addVersion("INFO_PRIVATE", version);
		return result;
	}


	public int addInfoNoLog() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] NoLogFilter information apply start");

			long version = getTableCurrentVersion("INFO_NOLOG_URL") + 1;
			appendData( version, "getInfoNoLogUrl", "addInfoNoLogUrl","INFO_NOLOG_URL" );
			addVersion("INFO_NOLOG_URL", version);
			save(Common.toJSONArray(selectList("com.xcurenet.sqlmap.mappers.mysql.makeInfo.getInfoNoLogUrl")));

			version = getTableCurrentVersion("INFO_NOLOG_SUBJECT") + 1;
			appendData( version, "getInfoNoLogSubject", "addInfoNoLogSubject","INFO_NOLOG_SUBJECT" );
			addVersion("INFO_NOLOG_SUBJECT", version);

			version = getTableCurrentVersion("INFO_NOLOG_SIZE") + 1;
			appendData( version, "getInfoNoLogSize", "addInfoNoLogSize","INFO_NOLOG_SIZE" );

			//insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogSize", version);
			addVersion("INFO_NOLOG_SIZE", version);

			version = getTableCurrentVersion("INFO_NOLOG_ID") + 1;
			appendData( version, "getInfoNoLogId", "addInfoNoLogId" ,"INFO_NOLOG_ID");
			addVersion("INFO_NOLOG_ID", version);

			version = getTableCurrentVersion("INFO_NOLOG_DOMAIN") + 1;
			appendData( version, "getInfoNoLogDomain", "addInfoNoLogDomain","INFO_NOLOG_DOMAIN" );
			addVersion("INFO_NOLOG_DOMAIN", version);

			log.info("[MAKE INFO] NoLogFilter information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
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
				ftp.upload(Config.DECODER_CONF_PATH, urlFile);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				ftp.disconnection();
			}
		}
	}



	public void appendData(Long currentVersion, String select, String insert, String collectionName) {
		long pageSize = 10000;
		JSONObject param = new JSONObject();
		param.put("pageSize", pageSize);

		long offset = 0;
		while (true) {
			param.put("offset", offset);
			//JSONArray data = DBUtils.getList ( select, param );

			//mysql 쿼리를 해야돼서 selectListMySQL을 사용, 쿼리문은 phoenix 쪽에 있으므로 mappers.phoenix.makeInfo로 함

			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
			if (data.size() == 0) break;
			offset += data.size();

			try {
				long version = Common.nvn(currentVersion) + 1;
				//sql = DBUtils.getSqlSession ( DBType.PHOENIX, true );
				for (int i = 0; i < data.size(); i++) {
					JSONObject obj = data.getJSONObject(i);
					obj.put("VERSION", version);

					if (collectionName == "INFO_USER"){
						InfoUserVO infoUserVO = InfoUserVO.builder()
								.USERID((String) obj.get("USERID"))
								.BUSICD((String) obj.get("BUSICD"))
								.BUSINM((String) obj.get("BUSINM"))
								.CEO((String) (obj.get("CEO") == "N"? "true" : "false"))
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

					}else if (collectionName == "INFO_IP"){
						InfoIpVO infoIpVO = InfoIpVO.builder()
								.IP((String) obj.get("IP"))
								.USERID((String) obj.get("USERID"))
								.VERSION((Integer) obj.get("VERSION"))
								.build();
						mongoUtil.insert(infoIpVO, collectionName);
					}else if (collectionName == "INFO_DEVICE"){
						InfoDeviceVO infoDeviceVO = InfoDeviceVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.EID((String) obj.get("EID"))
								.NAME((String) obj.get("NAME"))
								.IP((String) obj.get("IP"))
								.build();
						mongoUtil.insert(infoDeviceVO, collectionName);
					}else if (collectionName == "INFO_HOLIDAY"){
						InfoHolidayVO infoHolidayVO = InfoHolidayVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.COCD((String) obj.get("COCD"))
								.BUSICD((String) obj.get("BUSICD"))
								.DATE((String) obj.get("DATE"))
								.COMMENTS((String) obj.get("COMMENTS"))
								.build();
						mongoUtil.insert(infoHolidayVO, collectionName);
					}else if (collectionName == "INFO_WORKDAY"){
						InfoWorkdayVO infoWorkdayVO = InfoWorkdayVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.COCD((String) obj.get("COCD"))
								.BUSICD((String) obj.get("BUSICD"))
								.WDAY((String) obj.get("WDAY"))
								.WHOUR((String) obj.get("WHOUR"))
								.build();
						mongoUtil.insert(infoWorkdayVO, collectionName);
					}else if (collectionName == "INFO_IPRANGE"){
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
								.SLP((String) obj.get("SLP"))
								.build();
						mongoUtil.insert(infoIprangeVO, collectionName);
					}else if (collectionName == "INFO_KEYWORD"){
						InfoKeywordVO infoKeywordVO = InfoKeywordVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.KEYWORD((String) obj.get("KEYWORD"))
								.build();
						mongoUtil.insert(infoKeywordVO, collectionName);
					}else if (collectionName == "INFO_NOLOG_URL"){
						InfoNologUrlVO infoNologUrlVO = InfoNologUrlVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.URL((String) obj.get("URL"))
								.build();
						mongoUtil.insert(infoNologUrlVO, collectionName);
					}else if (collectionName == "INFO_NOLOG_SUBJECT"){
						InfoNologSubjectVO infoNologSubjectVO = InfoNologSubjectVO.builder()
								.SUBJECT((String ) obj.get("SUBJECT"))
								.SERVICECD((String) obj.get("SERVICECD"))
								.VERSION((int) obj.get("VERSION"))
								.build();
						mongoUtil.insert(infoNologSubjectVO, collectionName);
					}else if (collectionName == "INFO_NOLOG_SIZE"){
						InfoNologSizeVO infoNologSizeVO = InfoNologSizeVO.builder()
								.SERVICECD((String) obj.get("SERVICECD"))
								.SIZE_CONDITION((String) obj.get("SIZE_CONDITION"))
								.VERSION((int) obj.get("VERSION"))
								.LOWSIZE((int) obj.get("LOWSIZE"))
								.HIGHSIZE((int) obj.get("HIGHSIZE"))
								.build();
						mongoUtil.insert(infoNologSizeVO, collectionName);
					}else if (collectionName == "INFO_NOLOG_ID"){
						InfoNologIdVO infoNologIdVO = InfoNologIdVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.SERVICECD((String) obj.get("SERVICECD"))
								.USERID((String) obj.get("USERID"))
								.build();
						mongoUtil.insert(infoNologIdVO, collectionName);
					}else if (collectionName == "INFO_NOLOG_DOMAIN"){
						InfoNologDomainVO infoNologDomainVO = InfoNologDomainVO.builder()
								.VERSION((int) obj.get("VERSION"))
								.SERVICECD((String) obj.get("SERVICECD"))
								.DOMAIN((String) obj.get("DOMAIN"))
								.build();

					}

				}
				if (data.size() < pageSize) break;
			} finally {
				//if ( sql != null ) try{ sql.commit ( ); }catch (Exception e2) { }
				//if ( sql != null ) try{ sql.close ( ); }catch (Exception e2) { }
			}
		}
	}

	public void appendData ( JSONObject param, String select, String insert, String collectionName )
	{
		long pageSize = 10000;
		param.put ( "pageSize", pageSize );

		long offset = 0;
		while ( true )
		{
			param.put ( "offset", offset );
			//JSONArray data = DBUtils.getList ( select, param );

			//mysql 쿼리를 해야돼서 selectListMySQL을 사용, 쿼리문은 phoenix 쪽에 있으므로 mappers.phoenix.makeInfo로 함

			JSONArray data = Common.toJSONArray(selectListMySQL("com.xcurenet.sqlmap.mappers.mysql.makeInfo." + select, param));
			if ( data.size ( ) == 0 ) break;
			offset += data.size ( );

			try
			{
				long version = Common.nvn ( param.get("currentVersion") ) + 1;
				for ( int i = 0 ; i < data.size ( ) ; i++ )
				{
					JSONObject obj = data.getJSONObject ( i );
					obj.put ( "VERSION", version );
					if (collectionName == "INFO_EMAILADDR"){
						InfoEmailaddrVO infoEmailaddrVO = InfoEmailaddrVO.builder()
								.EMAILADDR((String) obj.get("EMAILADDR"))
								.USERID((String) obj.get("USERID"))
								.VERSION((int) obj.get("VERSION"))
								.build();
						mongoUtil.insert(infoEmailaddrVO, collectionName);
					}

				}
				if ( data.size ( ) < pageSize ) break;
			}
			finally
			{
			}
		}
	}






}
