package com.xcurenet.emass.message.service;

import com.xcurenet.code.service.CodeVO;
import com.xcurenet.emass.message.vo.emass.mongo.EmassMessage;
import com.xcurenet.emass.message.vo.emass.mongo.fields.CheckedVo_Mgo;
import com.xcurenet.emass.message.vo.emass.mongo.fields.PiVo_Mgo;
import com.xcurenet.emass.message.vo.emass.mongo.fields.RecvVo_Mgo;
import org.apache.commons.mail.EmailException;

import java.util.List;
import java.util.Map;

public interface EmsMessageService {

	public EmsBodyVO getEmassBody(final String msgId, final String firstAdminYn, final String adminType);

	public EmsBodyVO getEmassBodyHash(final String msgId);

	public List<EmsKeywordVO> getEmassKeyword(final String msgId);

	public EmsHeaderVO getEmassHeader(final String msgId);

	public EmassMessage getEmassMessage(final String msgId, final String firstAdminYn, final String adminType);
	
	public EmassMessage getEmassMessageNew(final String adminId, final String msgId, final String firstAdminYn, final String adminType);

	/* recv 리스트 정보 */
	public RecvVo_Mgo getEmassRecvInfo(final String msgId);
	public RecvVo_Mgo getEmassRecvInfo(final String msgId, final String uType);




	public List<EmsAttachVO> getEmassAttachInfoConsent(final String msgId, final String firstAdminYn, final String adminType);
	
	public List<EmsAttachVO> getEmassAttachInfo4Down(final String msgId, final String attachId);

	public List<EmsAttachVO> getEmassAttachInfo4DownHash(final String msgIds, final String attachHash);

	public EmsAttachVO getEmassAttachInfo(final String msgId, final String attachId);

	//public EmsAttachTextVO getEmassAttachText(final String msgId, final String attachId);

	public List<PiVo_Mgo> getEmassPattern(final String msgId);

	public List<EmsPiDetailVO> getEmassPatternDetail(final String msgId, final String piId, final String type, final String attachName);

	public EmsAttachTextVO getEmassAttachTextInfo(final String msgId, final String attachId, final String ocrYn);

	public List<Integer> findKeywordPages(final String msgId, final String attachId, final String ocrYn, final int limit, final String keywords);
	
	public String getEmassAttachText(final String msgId, final String attachId, final String ocrYn, final int offset, final int limit);

	public EmsMessengerAdminXrootMtrVO getEmassMessengerAdminXrootMtr (final String xRootMtr, final String adminId, final String srcip, final String usr_id);

	public void updateEmassMessengerAdminXrootMtr(final String xRootMtr, final String msgId, final String adminId, final String srcip, final String usr_id);
	
	public List<CodeVO> getMessengerList();
	
	public void updateEmsFeedback(final String msgId, final String feedback, final String adminId);
	
	public List<EmsSearchKeywordVO> getSearchKeywordAuto(final String adminId, final String searchKeyword);
	
	public List<EmsSearchKeywordVO> getSearchKeywordList(final String adminId, final String searchKeyword);
	
	public boolean isSearchKeywordExist(final EmsSearchKeywordVO searchKeyword);
	
	public int insertSearchKeywordList(final EmsSearchKeywordVO searchKeyword);
	
	public int deleteSearchKeywordList(final EmsSearchKeywordVO searchKeyword);
	
	public String getIpBusiNm(final String ipBusicd);
	
	public String getIpDeptNm(final String ipDeptcd);
	
	public List<String> getMailAttachId(final String msgId, final String attachHash, final String fileName);
	
	public void sendSecretMail(String mailText) throws EmailException;
	
	public Map<String, List<String>> parseJsonFile(final String filePath);

	public boolean updateEmsInfo(String msgId, String ml_confd_class, String ml_confd_prob, String ml_confd_nprob, String attachId, String attachHash, String features, String fileName);
	
	public int insertSkFeedback(final int radioFeedbackInt, final String feedbackcomment, final String attachId, final String msgId, final String attachName, final String attachHash);
	
	public String getMlFeedbackData(String startTime, String endTime);

	public boolean insertAndUpdateSolrFeedback(String msgId, String feedbackValue);
	
	public String getMlFeedbackUrl(String confId);

	public int updateSkMlFeedback(String msgId, String attachId, int radioFeedbackInt , int attachSecretYnInt);
	
	public EmsMlFeedbackVO getMlFeedbackDate(String msgId, String attachId);
	
	public EmsMlFeedbackVO getMlSecretData(String msgId, String attachId);

	int mlResultChk(String msgId, String attachHash, String fileName, String attachId);
	
	public List<Map<String, Object>> getRecvDomainInfo(String msgId, String inside, String recvsType);

	List<CodeVO> getGenerativeList();

	List<CodeVO> getFileList();

	List<CodeVO> getNoteList();

	/* 개봉 정보 */
	boolean readDoc(String msgId, CheckedVo_Mgo checkedVoMgo);




}
