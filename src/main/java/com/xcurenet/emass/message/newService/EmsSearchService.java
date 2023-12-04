package com.xcurenet.emass.message.newService;

import com.xcurenet.emass.message.service.MessengerEdcGroupVO;
import com.xcurenet.emass.message.service.impl.parseJsonFile;
import com.xcurenet.emass.message.vo.emass.EmassIntegrated;
import com.xcurenet.emass.message.vo.emass.els.Emass;
import com.xcurenet.emass.message.vo.emass.els.EmassChecked;
import com.xcurenet.emass.message.vo.emass.mongo.fields.CheckedVo_Mgo;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface EmsSearchService {

	 SearchResponse getList(SearchRequest searchRequest) throws IOException;

	 boolean readDoc(String updateDocument, CheckedVo_Mgo checkedVoMgo) throws IOException;

	 EmassIntegrated getEmassMessage(final Map<String,Object> searchParam, final String adminId) throws IOException;

	 EmassIntegrated getEmassMessage(Map<String,Object> searchParam, String adminId, String readYn, String consentNo) throws IOException;

	 MessengerEdcGroupVO getMessengerGroupList(final Map<String,Object> searchParam, final String adminId) throws IOException;

	 MessengerEdcGroupVO getMessengerGroupList(final Map<String,Object> searchParam, final String adminId, final boolean detail) throws IOException;

	//MessengerGroupUserVO getMessengerGroupUserList(final Map<String,Object> searchParam, final String adminId, final boolean detail, final boolean original) throws IOException;

	MessengerEdcGroupVO getMessengerGroupList(Map<String, Object> searchParam, String adminId, boolean detail, boolean original) throws IOException;

	public MessengerEdcGroupUserVO getMessengerGroupUserList(final Map<String,Object> searchParam, final String adminId, final boolean detail, final boolean original) throws IOException;

	 void setFeedback(final String msgId, final String ml_confd_feedback) throws IOException;

	 boolean setSecretInfo(String sourceKey, String securityYn, String doublSecurityPctStr, Map<String, List<parseJsonFile>> sortList) throws IOException;

	 boolean updateSolrFeedbackData(List<parseJsonFile> feedbackList);


	 /* 읽음 관련 메서드 */

	 List<EmassChecked> getCheckedList(final Map<String,Object> searchParam) throws IOException;

	 List<Emass> findReadList(final List<Emass> emass, final String adminId) throws IOException;

	 void setRead(final String msgid,final String userId);

	 boolean setMessengerRead(List<Emass> data, String adminId);

  	 EmassIntegrated getCheckedStatList(Map<String,Object> searchParam) throws IOException;


}