package com.xcurenet.emass.message.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.emass.message.service.DownloadBatchService;
import com.xcurenet.emass.message.service.DownloadBatchVO;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;

@Service("downloadBatchService")
@Slf4j
public class DownloadBatchServiceImpl extends XcnAbstractDAO implements DownloadBatchService {

	public String getMaxDownSeq() {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getMaxDownSeq");
	}
	public int inserDownloadBatch(DownloadBatchVO downloadBatchVO) {
		log.info("" + downloadBatchVO);
		return insert("com.xcurenet.sqlmap.mappers.mysql.emass.insertDownloadBatch", downloadBatchVO);
	}
	
	public DownloadBatchVO getDownloadExist(DownloadBatchVO downloadBatchVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getDownloadDu", downloadBatchVO);
	}

	public int updateDownloadBatch(DownloadBatchVO downloadBatchVO) {
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.updateDownloadBatch", downloadBatchVO);
	}
	@Override
	public String getMaxDownSeqMessenger() {return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getMaxDownSeqMessenger"); }

	public int updateDownloadBatchMessenger(DownloadBatchVO downloadBatchVO) {
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.updateDownloadBatchMessenger", downloadBatchVO);
	}

	@Override
	public int inserDownloadBatchMessenger(DownloadBatchVO vo) {

		log.info("" + vo);
		return insert("com.xcurenet.sqlmap.mappers.mysql.emass.insertDownloadBatchMessenger", vo);
	}


	@Override
	public List<DownloadBatchVO> getDownloadBatchListMessenger(String adminId, int offset, int limit) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("adminId", adminId);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getDownloadBatchListMessenger", param);
	}

	public List<DownloadBatchVO> getExportFileExpireDataMessenger() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getExportFileExpireDataMessenger");
	}

	public List<DownloadBatchVO> getExportFileExpireData() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getExportFileExpireData");
	}

	public List<DownloadBatchVO> getDownloadBatchList(final String adminId, final String exportTypeSel, final String fileExtSel, final String statusSel, final int offset, final int limit) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("exportTypeSel", exportTypeSel);
		param.put("fileExtSel", fileExtSel);
		param.put("statusSel", statusSel);
		param.put("offset", offset);
		param.put("limit", limit);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getDownloadBatchList", param);
	}
	
	public List<DownloadBatchVO> getDownloadBatchIngList(String delay) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getDownloadBatchIngList", delay);
	}
	
	public int shutdownDownloadBatch(String val) {
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.shutdownDownloadBatch", val);
	}


	public int shutdownDownloadBatchMessenger(String val) {
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.shutdownDownloadBatchMessenger", val);
	}

	public int cancelDownFile(String adminId, String statuSel, String downSeq) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("statuSel", statuSel);
		param.put("downSeq", downSeq);
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.cancelDownFile", param);
	}

	public int cancelDownFileMessenger(String adminId, String statuSel, String downSeq) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("statuSel", statuSel);
		param.put("downSeq", downSeq);
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.cancelDownFileMessenger", param);
	}

	public int cancelUnkown(String statuSel, String downSeq) {
		Map<String, String> param = new HashMap<>();
		param.put("statuSel", statuSel);
		param.put("downSeq", downSeq);
		return update("com.xcurenet.sqlmap.mappers.mysql.emass.cancelUnkown", param);
	}
	
	public String chackCancel(DownloadBatchVO downloadBatchVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.chackCancel", downloadBatchVO);
	}


	public String chackCancelMessnger(DownloadBatchVO downloadBatchVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.chackCancelMessnger", downloadBatchVO);
	}

	public int checkDownloadBatchExist(DownloadBatchVO downloadBatchVO) {
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.checkDownloadBatchExist", downloadBatchVO);
	}
	
	public int removeDownInfoData(String adminId, List<String> downList) {
		if(downList.size() == 0) return 0;
		
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("downList", downList);
		return delete("com.xcurenet.sqlmap.mappers.mysql.emass.removeDownInfoData", param);
	}
	
}
