package com.xcurenet.emass.message.newService;

import com.xcurenet.common.util.elasticsearch.ElsSearchResponse;
import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.service.MessengerGroupUserVO;
import com.xcurenet.emass.message.service.impl.parseJsonFile;
import com.xcurenet.emass.message.vo.message.EdcMessage;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface EmsSearchService {

     ElsSearchResponse getList(Map<String,String> searchParam) throws IOException;

     EdcMessage getEmassMessage(final Map<String,String> searchParam, final String adminId) throws IOException;

     EdcMessage getEmassMessage(Map<String,String>  searchParam, String adminId, String readYn, String consentNo) throws IOException;

	 MessengerEdcGroupVO getMessengerGroupList(final Map<String,String> searchParam, final String adminId) throws IOException;

	 MessengerEdcGroupVO getMessengerGroupList(final Map<String,String> searchParam, final String adminId, final boolean detail) throws IOException;

	 MessengerEdcGroupVO getMessengerGroupList(final Map<String,String> searchParam, final String adminId, final boolean detail, final boolean original) throws IOException;

	 MessengerGroupUserVO getMessengerGroupUserList(final Map<String,String> searchParam, final String adminId) throws IOException;

	 void setFeedback(final String msgId, final String ml_confd_feedback) throws IOException;

	 boolean setSecretInfo(String sourceKey, String securityYn, String doublSecurityPctStr, Map<String, List<parseJsonFile>> sortList) throws IOException;

	 boolean updateSolrFeedbackData(List<parseJsonFile> feedbackList);


}