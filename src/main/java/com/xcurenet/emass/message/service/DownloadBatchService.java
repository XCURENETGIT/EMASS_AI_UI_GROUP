package com.xcurenet.emass.message.service;

import java.util.List;

public interface DownloadBatchService {
	public String getMaxDownSeq();

	public int inserDownloadBatch(DownloadBatchVO downloadBatchVO);

	public int updateDownloadBatch(DownloadBatchVO downloadBatchVO);

	public List<DownloadBatchVO> getExportFileExpireData();

	public List<DownloadBatchVO> getDownloadBatchList(final String adminId, final String exportTypeSel, final String fileExtSel, final String statusSel, final int offset, final int limit);
	
	public List<DownloadBatchVO> getDownloadBatchIngList(String delay);
	
	public int shutdownDownloadBatch(String val);
	
	public int cancelDownFile(String adminId, String statuSel, String downSeq);
	
	public int cancelUnkown(String statuSel, String downSeq);
	
	public String chackCancel(DownloadBatchVO downloadBatchVO);
	
	public int checkDownloadBatchExist(DownloadBatchVO downloadBatchVO);
	
	public int removeDownInfoData(String adminId, List<String> downList);
}
