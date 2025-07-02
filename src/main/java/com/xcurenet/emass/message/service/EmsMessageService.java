package com.xcurenet.emass.message.service;

import com.xcurenet.code.service.CodeVO;
import com.xcurenet.emass.message.service.vo.HostDescriptionVO;
import com.xcurenet.searchWord.service.RelationKeywordVO;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface EmsMessageService {

	public EmsBodyVO getEmassBody(final String msgId, final String firstAdminYn, final String adminType);

	public EmsBodyVO getEmassBodyHash(final String msgId);

	public List<EmsKeywordVO> getEmassKeyword(final String msgId);

	public EmsHeaderVO getEmassHeader(final String msgId);

	public EmsMessageVO getEmassMessage(final String msgId, final String firstAdminYn, final String adminType);

	public EmsMessageVO getEmassMessageNew(final String adminId, final String msgId, final String firstAdminYn, final String adminType);

	public List<EmsRecvVO> getEmassUserInfo(final String msgId);
	public List<EmsRecvVO> getEmassUserAllInfo(final String msgId);

	public List<EmsRecvVO> getEmassUserInfo(final String msgId, final String uType);

	public List<EmsAttachVO> getEmassAttachInfoConsent(final String msgId, final String firstAdminYn, final String adminType);

	public List<EmsAttachVO> getEmassAttachInfo4Down(final String msgId, final String attachId);

	public List<EmsAttachVO> getEmassAttachInfo4DownHash(final String msgIds, final String attachHash);

	public EmsAttachVO getEmassAttachInfo(final String msgId, final String attachId);

	public List<EmsPiVO> getEmassPattern(final String msgId);

	public List<EmsPiDetailVO> getEmassPatternDetail(final String msgId, final String piId, final String type, final String attachName);

	public EmsAttachTextVO getEmassAttachTextInfo(final String msgId, final String attachId, final String ocrYn);

	public List<Integer> findKeywordPages(final String msgId, final String attachId, final String ocrYn, final int limit, final String keywords);

	public String getEmassAttachText(final String msgId, final String attachId, final String ocrYn, final int offset, final int limit);

	public EmsMessengerAdminXrootMtrVO getEmassMessengerAdminXrootMtr (final String xRootMtr, final String adminId, final String srcip, final String usr_id);
	public EmsMessengerAdminXrootMtrVO getEmassGenerativeAdminXrootMtr (final String userid, final String adminId, final String srcip, final String usr_id,final String type);

	public void updateEmassMessengerAdminXrootMtr(final String xRootMtr, final String msgId, final String adminId, final String srcip, final String usr_id);

	public void updateEmassGenerativeAdminUserid(final String userid, final String msgId, final String adminId, final String srcip,final String type);

	public List<CodeVO> getMessengerList();

	public boolean updateEmsFeedback(final String msgId, final String feedback, final String adminId);

	public List<EmsSearchKeywordVO> getSearchKeywordAuto(final String adminId, final String searchKeyword);

	public List<EmsSearchKeywordVO> getSearchKeywordList(final String adminId, final String searchKeyword);

	public boolean isSearchKeywordExist(final EmsSearchKeywordVO searchKeyword);

	public int insertSearchKeywordList(final EmsSearchKeywordVO searchKeyword);

	public int deleteSearchKeywordList(final EmsSearchKeywordVO searchKeyword);

	public String getIpBusiNm(final String ipBusicd);

	public String getIpDeptNm(final String ipDeptcd);

	public List<Map<String, Object>> getRecvDomainInfo(String msgId, String inside, String recvsType);

	public List<CodeVO> getGenerativeList();

	public List<CodeVO> getNoteList();
	public List<CodeVO> getFileServiceList();

	List<RelationKeywordVO>  getRelationKeywordList(String searchKeyword);

	boolean beforeConsentCheck(final String msgId, final String firstAdminYn, final String adminType,final String consentUserId);

	List<String> getMsgIds(String msgId,String xRootMtr);

	public EmsMessageVO highlightCheck(EmsMessageVO emass,Map<String,Object> regexpHighlight);


	public boolean isHostExist(String host);

	public int insertHost(HostDescriptionVO hostDescriptionVO);

	public int updateHost(final HostDescriptionVO hostDescriptionVO);

	public List<String> keywordSeparation(String keyword);

	public List<String> getLastPiText(List<String> kwds, String piid);

}
