package com.xcurenet.emass.consent.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.consent.service.ConsentSeqVO;
import com.xcurenet.emass.consent.service.ConsentService;
import com.xcurenet.emass.consent.service.ConsentVO;

import lombok.extern.slf4j.Slf4j;

@Service("consentService")
@Slf4j
public class ConsentServiceImpl extends XcnAbstractDAO implements ConsentService {

	private static final String CONSENT_FILE_PATH = "/users/emasslth/consent/";

	@Override
	public List<ConsentVO> getConsentList(final String startDate, final String endDate, final String type, final String consentStatus, final String createNm, final String searchStr, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("type", type);
		param.put("consentStatus", consentStatus);
		param.put("searchStr", createNm);
		param.put("searchStr", searchStr);
		param.put("offset", offset);
		param.put("limit", limit);
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.consent.getConsentList", param);
	}
	
	@Override
	public List<ConsentVO> getConsentSearchList(String type, String searchStr) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("type", type);
		param.put("searchStr", searchStr);
		if(Common.isEquals(Config.getString("private.encrypt.useYN"), "Y")){
			param.put("encryptUseYN", Config.getString("private.encrypt.useYN"));
			param.put("encryptAlgorithm", Config.getString("private.encrypt.algorithm"));
			param.put("encryptSize", Config.getString("private.encrypt.size"));
			param.put("encryptKey", Config.getString("private.encrypt.key"));
		}
		return selectList("com.xcurenet.sqlmap.mappers.mysql.consent.getConsentSearchList", param);
	}

	@Override
	public boolean isConsentExist(ConsentVO consent) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.consent.isConsentExist", consent) > 0;
	}

	@Override
	public int insertConsent(ConsentVO consent) throws Exception {

		fileProcess(consent);

		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			insertUserIp(consent);
			result = insert("com.xcurenet.sqlmap.mappers.mysql.consent.insertConsent", consent);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	private void fileProcess(ConsentVO consent) throws Exception {
		MultipartFile file = consent.getAttach();
		if (file != null && !file.isEmpty()) {
			consent.setFileName(file.getOriginalFilename());
			String extension = "";
			if (consent.getFileName().indexOf(".") > -1) {
				extension = consent.getFileName().substring(consent.getFileName().lastIndexOf("."));
			}
			String path = CONSENT_FILE_PATH + Common.getCurrentDate();
			Common.mkdirs(path);
			File nFile = new File(path + File.separatorChar + Common.getRandomString() + extension);
			file.transferTo(nFile);
			consent.setFilePath(nFile.getAbsolutePath());
			consent.setAttachedYn("Y");
		} else {
			consent.setAttachedYn("N");
		}
		log.info("file upload process {}", consent);
	}

	@Override
	public int updateConsent(ConsentVO consent) throws Exception {

		fileProcess(consent);
		ConsentVO oldVo = selectOne("com.xcurenet.sqlmap.mappers.mysql.consent.getConsentFileInfo", consent);
		log.info("update consent old consent info {}", oldVo);
		if (Common.isEmpty(consent.getFileName()) && Common.isNotEquals(consent.getFileDeleteYn(), "Y")) {
			consent.setFilePath(oldVo.getFilePath());
			consent.setFileName(oldVo.getFileName());
			consent.setAttachedYn(oldVo.getAttachedYn());
		}

		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			deleteUserIp(consent);
			insertUserIp(consent);
			result = update("com.xcurenet.sqlmap.mappers.mysql.consent.updateConsent", consent);
			tx.commit();
		} finally {
			tx.end();
		}

		if (Common.isEquals(consent.getFileDeleteYn(), "Y")) {
			if (oldVo.getFilePath() != null) {
				File oldFile = new File(oldVo.getFilePath());
				if (oldFile.exists() && !oldFile.delete()) oldFile.deleteOnExit();
			}
		}
		return result;
	}

	@Override
	public int deleteConsent(List<ConsentVO> consents) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (ConsentVO consent : consents) {
				result += delete("com.xcurenet.sqlmap.mappers.mysql.consent.deleteConsent", consent);
			}
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public ConsentSeqVO getConsentSeq() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.consent.getConsentSeq");
	}

	@Override
	public int insertUserIp(ConsentVO consent) {
		int result = 0;
		final String no = consent.getNo();
		final String[] userIps = Common.trimAll(Common.nvl(consent.getUserIp())).split(",");
		for (String userIp : userIps) {
			ConsentVO vo = new ConsentVO();
			vo.setNo(no);
			vo.setUserIp(userIp);
			result += insert("com.xcurenet.sqlmap.mappers.mysql.consent.insertUserIp", vo);
		}
		return result;
	}

	@Override
	public int deleteUserIp(ConsentVO consent) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.consent.deleteUserIp", consent);
	}

	@Override
	public int updateApproval(ConsentVO consent) {
		return update("com.xcurenet.sqlmap.mappers.mysql.consent.updateApproval", consent);
	}

	@Override
	public int insertConsentSeq(ConsentSeqVO vo) {
		return insert("com.xcurenet.sqlmap.mappers.mysql.consent.insertConsentSeq", vo);
	}

	@Override
	public int deleteConsentSeq(String date, int no) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("date", date);
		param.put("no", no);
		return delete("com.xcurenet.sqlmap.mappers.mysql.consent.deleteConsentSeq", param);
	}

	@Override
	public ConsentVO getConsentFileInfo(ConsentVO consent) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.consent.getConsentFileInfo", consent);
	}

	@Override
	public String getApprobator(String adminId) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.consent.getApprobator", adminId);
	}

}
