package com.xcurenet.emass.reservationAlarm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.reservationAlarm.service.AlarmLogVO;
import com.xcurenet.emass.reservationAlarm.service.AlarmService;
import com.xcurenet.emass.reservationAlarm.service.AlarmVO;

import net.sf.json.JSONObject;

@Service("alarmService")
public class AlarmServiceImpl extends XcnAbstractDAO implements AlarmService {

	@Override
	public List<AlarmVO> getAlarmList(String searchStr) {
		Map<String, String> param = new HashMap<>();
		param.put("searchStr", searchStr);
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}

		return selectList("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getAlarmList", param);
	}
	
	@Override
	public List<AdminVO> getAdminEmailList(String searchStr) {
		Map<String, String> param = new HashMap<>();
		param.put("searchStr", searchStr);
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getAdminEmailList", param);
	}
	
	@Override
	public AlarmVO getNextAlarmSeq() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getNextAlarmSeq");
	}

	@Override
	public int insertAlarm(AlarmVO alarm) {
		int result=0;
		TransactionManager tx = getTransactionManager();
		String encryptUserYN = Config.getString("private.encrypt.useYN");
		String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
		String encryptSize = Config.getString("private.encrypt.size");
		String encryptKey = Config.getString("private.encrypt.key");
		try {
			tx.start();
			if(Common.isEquals(encryptUserYN, "Y")){
				alarm.setEncryptUseYN(encryptUserYN);
				alarm.setEncryptAlgorithm(encryptAlgorithm);
				alarm.setEncryptSize(encryptSize);
				alarm.setEncryptKey(encryptKey);
			}
			result = insert("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.insertAlarm", alarm);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int updateAlarm(AlarmVO alarm) {
		int result=0;
		TransactionManager tx = getTransactionManager();
		String encryptUserYN = Config.getString("private.encrypt.useYN");
		String encryptAlgorithm = Config.getString("private.encrypt.algorithm");
		String encryptSize = Config.getString("private.encrypt.size");
		String encryptKey = Config.getString("private.encrypt.key");
		try {
			tx.start();
			if(Common.isEquals(encryptUserYN, "Y")){
				alarm.setEncryptUseYN(encryptUserYN);
				alarm.setEncryptAlgorithm(encryptAlgorithm);
				alarm.setEncryptSize(encryptSize);
				alarm.setEncryptKey(encryptKey);
			}
			result = update("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.updateAlarm", alarm);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public AlarmVO getAlarm(String alarmSeq) {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		param.put("alarmSeq", alarmSeq);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getAlarm", param);
	}
	
	@Override
	public int deleteAlarm(List<AlarmVO> alarms) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AlarmVO alarm : alarms) {
				delete("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.deleteAlarm", alarm);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public List<AlarmVO> getMailFormList(String searchStr) {
		Map<String, String> param = new HashMap<>();
		param.put("searchStr", searchStr);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getMailFormList", param);
	}
	
	@Override
	public int insertMailForm(AlarmVO alarm) {
		int result=0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = insert("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.insertMailForm", alarm);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public int updateMailForm(AlarmVO alarm) {
		int result=0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = update("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.updateMailForm", alarm);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public int deleteMailForm(List<AlarmVO> alarms) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AlarmVO alarm : alarms) {
				delete("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.deleteMailForm", alarm);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public List<AlarmVO> getNowExecuteList() {
		JSONObject param = new JSONObject();
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getNowExecuteList", param);
	}
	
	@Override
	public int insertAlarmLog(final String alarmSeq, long totalCnt, String query) {
		int result=0;
		Map<String, String> param = new HashMap<>();
		param.put("alarmSeq", alarmSeq);
		param.put("totalCnt", Long.toString(totalCnt));
		param.put("query", query);
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = insert("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.insertAlarmLog", param);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}
	
	@Override
	public List<AlarmLogVO> getAlarmLog(String alarmSeq) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getAlarmLogList", alarmSeq);
	}
	
	@Override
	public List<AlarmLogVO> getAlarmLogQuery(String alarmLogSeq) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.getAlarmLogQuery", alarmLogSeq);
	}
	
	@Override
	public int deleteAlarmLog(List<AlarmLogVO> alarms) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (AlarmLogVO alarm : alarms) {
				delete("com.xcurenet.sqlmap.mappers.mysql.reservationAlarm.deleteAlarmLog", alarm);
			}
			tx.commit();
			result = 1;
		} finally {
			tx.end();
		}
		return result;
	}
}
