package com.xcurenet.common.makeInfo.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.makeInfo.VersionVO;
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

	
	public long getTableCurrentVersion(String tableName) {
		VersionVO versionVo = selectOne("com.xcurenet.sqlmap.mappers.mysql.makeInfo.getTableCurrentVersion", tableName);
		if(versionVo == null) return 0;
		else return Common.nvn(versionVo.getVersion());
	}

	
	public int addVersion(String tableName, long version) {
		Map<String, Object> param = new HashMap<>();
		param.put("TABLENAME", tableName);
		param.put("VERSION", version);
		param.put("ID", "system");
		param.put("COMMENTS", "");
		return insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addVersion", param);
	}

	
	public int addInfoUser() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] User information apply start");
			long version = getTableCurrentVersion("INFO_USER") +1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoUser", version);
			addVersion("INFO_USER", version);

			version = getTableCurrentVersion("INFO_IP") +1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoIp", version);
			addVersion("INFO_IP", version);

			version = getTableCurrentVersion("INFO_EMAILADDR")+1;
			JSONObject param = new JSONObject();
			if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
				param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
				param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
				param.put("encryptSize", Config.getString("private.encrypt.size"));
				param.put("encryptKey", Config.getString("private.encrypt.key"));
			}
			param.put("VERSION", version);
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoEmail", param);
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

			long version = getTableCurrentVersion("INFO_DEVICE")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoDevice", version);
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

			long version = getTableCurrentVersion("INFO_HOLIDAY")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoHoliday", version);
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

			long version = getTableCurrentVersion("INFO_WORKDAY")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoWorkDay", version);
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

			long version = getTableCurrentVersion("INFO_IPRANGE")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoIpRange", version);
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

			long version = getTableCurrentVersion("INFO_KEYWORD")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoKeyword", version);
			addVersion("INFO_KEYWORD", version);

			log.info("[MAKE INFO] Keyword information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	
	public int addInfoRegExp() {
		long version = getTableCurrentVersion("INFO_PRIVATE")+1;
		int result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoRegExp", version);
		addVersion("INFO_PRIVATE", version);
		return result;
	}

	
	public int addInfoNoLog() {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			log.info("[MAKE INFO] NoLogFilter information apply start");

			long version = getTableCurrentVersion("INFO_NOLOG_URL")+1;
			result = insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogUrl", version);
			addVersion("INFO_NOLOG_URL", version);
			save(Common.toJSONArray(selectList("com.xcurenet.sqlmap.mappers.mysql.makeInfo.getInfoNoLogUrl")));

			version = getTableCurrentVersion("INFO_NOLOG_SUBJECT")+1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogSubject", version);
			addVersion("INFO_NOLOG_SUBJECT", version);

			version = getTableCurrentVersion("INFO_NOLOG_SIZE")+1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogSize", version);
			addVersion("INFO_NOLOG_SIZE", version);

			version = getTableCurrentVersion("INFO_NOLOG_ID")+1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogUserId", version);
			addVersion("INFO_NOLOG_ID", version);

			version = getTableCurrentVersion("INFO_NOLOG_DOMAIN")+1;
			insert("com.xcurenet.sqlmap.mappers.mysql.makeInfo.addInfoNoLogDomain", version);
			addVersion("INFO_NOLOG_DOMAIN", version);

			log.info("[MAKE INFO] NoLogFilter information apply end");

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	public void save(JSONArray data){
		String urlContent = data.toString();
		//log.info("NO_LOG_URL File upload\n{}", urlContent);

		File urlFile = new File(Config.URL_PATH);
		Common.mkdirs(urlFile.getParent());
		
		byte[] bytes = urlContent.getBytes();
		ByteArrayInputStream bis = null;
		FileOutputStream fos = null;
		
		try{
			if (urlFile.exists()) {
				File backup = new File(Config.URL_BACKUP_PATH + Common.getCurrentDate() + File.separator + urlFile.getName() + "." + new DateTime().toString("yyyyMMddHHmmss"));
				Common.mkdirs(backup.getParent());
				FileUtils.copyFile(urlFile, backup);
			}
			
			bis = new ByteArrayInputStream(bytes);
			fos = new FileOutputStream(urlFile);
			
			IOUtils.copy(bis, fos);
			fos.flush();
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			IOUtils.closeQuietly(bis);
			IOUtils.closeQuietly(fos);
		}
		
		makeInfo_nologUrl();
	}
	
	private void makeInfo_nologUrl(){
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
}
