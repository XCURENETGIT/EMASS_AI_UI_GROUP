package com.xcurenet.emass.message.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jcraft.jsch.JSchException;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.ftp.SFTPUtil;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.consent.service.ConsentService;
import com.xcurenet.emass.consent.service.ConsentVO;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.emass.message.vo.emass.mongo.EmassMessage;
import com.xcurenet.emass.message.vo.emass.mongo.fields.CheckedVo_Mgo;
import com.xcurenet.emass.message.vo.emass.mongo.fields.PiVo_Mgo;
import com.xcurenet.emass.message.vo.emass.mongo.fields.RecvVo_Mgo;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.mail.EmailException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service("emsMessageService")
@Slf4j
public class EmsMessageServiceImpl extends XcnAbstractDAO implements EmsMessageService {


	@Resource(name = "consentService")
	public ConsentService consentService;

	@Autowired
	MongoUtil mongoUtil;


	ObjectMapper objectMapper = new ObjectMapper();

	public String MESSAGE_SCHEME = "EMS_MESSAGE";

	@Override
	public EmsBodyVO getEmassBody(String msgId, String firstAdminYn, String adminType) {
		EmsBodyVO bodyVo = mongoUtil.selectId(msgId,EmsBodyVO.class,MESSAGE_SCHEME);
		return bodyVo;
	}

//	@Override
//	public EmsBodyVO getEmassBody(String msgId, String firstAdminYn, String adminType) {

/*
		Query query= new Query(Criteria.where("_id").is(msgId));
		EmsBodyVO bodyVo = new EmsBodyVO();

		if (Common.isEquals(Config.getString("body.samsung.tables"), "Y")) {
			if (Integer.valueOf(msgId.substring(4, 6)) > 6) bodyVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassBodySm", msgId);
			else bodyVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassBodySm", msgId);
		} else bodyVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassBodySm", msgId);


		if (Common.isEquals(bodyVo.getBodyType(), "T")) {
			bodyVo.setBody(Common.nvl(bodyVo.getBodyText()).getBytes());
		} else {
			if (bodyVo.getBodyPath() == null) return bodyVo;
			bodyVo.setBody(Common.decryptAfterDecompression(bodyVo.getBodyPath()));
		}
		return bodyVo;*/

//		return null;
//	}

	@Override
	public EmsBodyVO getEmassBodyHash(String msgId) {
		EmsBodyVO bodyVo = new EmsBodyVO();
		Query query= new Query(Criteria.where("_id").is(msgId));

		if (Common.isEquals(Config.getString("body.samsung.tables"), "Y")) {
			if (Integer.valueOf(msgId.substring(4, 6)) > 6) bodyVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassBodyHashSm", msgId);
			else bodyVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassBodyHash", msgId);
		} else bodyVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassBodyHash", msgId);

		return bodyVo;
	}

	@Override
	public List<EmsKeywordVO> getEmassKeyword(String msgId) {
		List<EmsKeywordVO> keywordVo = new ArrayList<>();
		Query query = new Query(Criteria.where("_id").is(msgId));

		if (Common.isEquals(Config.getString("body.samsung.tables"), "Y")) {
			if (Integer.valueOf(msgId.substring(4, 6)) > 6) keywordVo = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassKeywordSm", msgId);
			else keywordVo = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassKeyword", msgId);
		} else keywordVo = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassKeyword", msgId);

		return keywordVo;
	}

	@Override
	public EmsHeaderVO getEmassHeader(String msgId) {

		EmsHeaderVO headerVo =mongoUtil.selectId(msgId,EmsHeaderVO.class,MESSAGE_SCHEME);

		if (headerVo == null || headerVo.getHeaderPath() == null) return null;
		headerVo.setHeader(Common.decryptAfterDecompression(headerVo.getHeaderPath()));
		return headerVo;
	}

	@Override
	public EmassMessage getEmassMessage(String msgId, String firstAdminYn, String adminType) {
		Map<String, Object> param = new HashMap<>();
		param.put("infoFeedbackConf", Config.getBoolean("info.feedback.used"));
		param.put("msgId", msgId);
		EmassMessage emassMessage = mongoUtil.selectId(msgId,EmassMessage.class,MESSAGE_SCHEME);
		if (emassMessage == null) {
			log.info("[Message Not Found] msgid:{}", msgId);
			return null;
		} else {
			return getConsentMessage(emassMessage, firstAdminYn, adminType);
		}
	}

	@Override
	public EmassMessage getEmassMessageNew(String adminId, String msgId, String firstAdminYn, String adminType) {
		Map<String, Object> param = new HashMap<>();
		param.put("infoFeedbackConf", Config.getBoolean("info.feedback.used"));
		param.put("msgId", msgId);

		EmassMessage emassMessage = mongoUtil.selectId(msgId, EmassMessage.class,MESSAGE_SCHEME);

		/* response Data mapping */
		if (emassMessage == null) {
			log.info("[Message Not Found] msgid:{}", msgId);
			return null;
		} else {
			return getConsentMessage(emassMessage, firstAdminYn, adminType);
		}


	}


	@Override
	public String getIpBusiNm(String ipBusicd) {
		Map<String, Object> param = new HashMap<>();
		param.put("ipBusicd", ipBusicd);
		String str = selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getIpBusiNm", param);
		if (Common.isNotEmpty(str)) {
			return str;
		} else {
			Map<String, Object> param2 = new HashMap<>();
			param2.put("ipBusicd", "C00-00");
			return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getIpBusiNm", param2);
		}
	}

	@Override
	public String getIpDeptNm(String ipDeptcd) {
		Map<String, Object> param = new HashMap<>();
		param.put("ipDeptcd", ipDeptcd);
		String str = selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getIpDeptNm", param);
		if (Common.isNotEmpty(str)) {
			return str;
		} else {
			Map<String, Object> param2 = new HashMap<>();
			param2.put("ipDeptcd", "C00-00");
			return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getIpDeptNm", param2);
		}
	}

	private boolean isConsent(String msgId, String firstAdminYn, String adminType) {
		boolean consentFlag = Config.getBoolean("consent.menu.enable");
		if (!consentFlag || Common.isEquals(firstAdminYn, "Y")) return true;

	/*	Map<String, Object> param = new HashMap<>();
		param.put("infoFeedbackConf", Config.getBoolean("info.feedback.used"));
		param.put("infoHynixConf", Config.getBoolean("info.hynix.used"));
		param.put("msgId", msgId);*/

		EmassMessage emassMessage = getConsentMessage(mongoUtil.selectId(msgId,EmassMessage.class,MESSAGE_SCHEME), firstAdminYn, adminType);
		return emassMessage.isConsentFlag();
	}

	private EmassMessage getConsentMessage(EmassMessage emassMessage, String firstAdminYn, String adminType) {
		boolean consentFlag = Config.getBoolean("consent.menu.enable");
		emassMessage.setConsentFlag(true);

		if (!consentFlag || Common.isEquals(firstAdminYn, "Y")) return emassMessage;

		if (consentFlag && Common.isNotEquals(firstAdminYn, "Y") && Common.isNotEquals(adminType, "C")) {
			boolean consentRtnFlag = false;
			List<ConsentVO> consentList = consentService.getConsentSearchList("", "");
			for (int i = 0; i < consentList.size(); i++) {
				ConsentVO consent = consentList.get(i);
				if (Common.isEquals(emassMessage.getUser().getId(), consent.getUserId())) {
					consentRtnFlag = true;
					break;
				}
			}
			if (!consentRtnFlag) {
				emassMessage = new EmassMessage();
				emassMessage.setConsentFlag(consentRtnFlag);
			}
		}
		return emassMessage;
	}

	@Override
	public RecvVo_Mgo getEmassRecvInfo(String msgId) {
		RecvVo_Mgo recvList = mongoUtil.selectId(msgId,RecvVo_Mgo.class,MESSAGE_SCHEME);
		return recvList;
	}

	@Override
	public RecvVo_Mgo getEmassRecvInfo(String msgId,String uType) {
//		Query query = new Query(Criteria.where("_id").is(msgId));
////		if(uType!=null && uType!=""){
////			query.addCriteria(Criteria.where("UTYPE").in(uType));
////		}
//		return mongoUtil.selectList(query,RecvVo_Mgo.class,MESSAGE_SCHEME);
		return null;
	}




	@Override
	public List<EmsAttachVO> getEmassAttachInfoConsent(String msgId, String firstAdminYn, String adminType) {
/*
		Map<String, String> param2 = new HashMap<>();
		Query query= new Query();
		String[] msgIds = Common.toArray(msgId, ",");
		if (msgIds.length == 1) {query.addCriteria(Criteria.where("_id").is(msgId));}
		else {query.addCriteria(Criteria.where("_id").is(msgIds));}

		String infoHynix = Config.getString("info.hynix.used");
		EmassMessage emsMessageVO = mongoUtil.selectOne(query,EmassMessage.class,MESSAGE_SCHEME);

		String attachId = "";
		int ml_confd_class, mlFeedbackYN;
		double ml_confd_prob;
		String mlFeedbackComment, mlFeedbackTimeStr, ml_confd_classStr, mlFeedbackYNStr, features;

		List<AttachVo_Mgo> emsAttachVOList = emsMessageVO.getAttach();
//		MlVo_Mgo MlVo = emsMessageVO.getMl();
//		// .merged 파일로 인한 재정렬
//		Collections.sort(emsAttachVOList, new Comparator<MlVo_Mgo>() {
//			public int compare(EmsAttachVO o1, EmsAttachVO o2) {
//				String oneAttachId = o1.getAttachId();
//				String nextAttachId = o2.getAttachId();
//				int re = 0;
//				if (oneAttachId.startsWith("/") && nextAttachId.startsWith("/")) {
//					re = oneAttachId.substring(oneAttachId.lastIndexOf("/") + 1).compareTo(nextAttachId.substring(nextAttachId.lastIndexOf("/") + 1));
//				} else if (oneAttachId.startsWith("/")) {
//					re = oneAttachId.substring(oneAttachId.lastIndexOf("/") + 1).compareTo(nextAttachId);
//				} else if (nextAttachId.startsWith("/")) {
//					re = nextAttachId.substring(oneAttachId.lastIndexOf("/") + 1).compareTo(oneAttachId);
//				} else {
//					re = oneAttachId.compareTo(nextAttachId);
//				}
//
//				return re;
//			}
//		});

		EmsAttachDownload attachDown = new EmsAttachDownload();
		for (int i = 0; i < emsAttachVOList.size(); i++) {
			EmsMlFeedbackVO emsResultVO = null;
			EmsMlFeedbackVO emsFeedbackVO = null;
			AttachVo_Mgo emsAttachVO = emsAttachVOList.get(i);

			if (Common.isEquals(infoHynix, "true")) {
				attachId = emsAttachVO.getId();
				param2.put("msgId", msgId);
				param2.put("attachId", attachId);

				emsResultVO = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlSecretData", param2);
				emsFeedbackVO = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlFeedbackDate", param2);

				if (emsResultVO != null) {
					ml_confd_class = emsResultVO.getMlSecurityYN();
					// int형 string으로 변환
					ml_confd_classStr = Integer.toString(ml_confd_class);
					ml_confd_prob = emsResultVO.getMl_confd_prob();
					features = emsResultVO.getFeatures();

					emsAttachVO.setMl_confd_class(ml_confd_class);
					emsAttachVO.setMl_confd_prob(ml_confd_prob);
					emsAttachVO.setFeatures(features);

					if (emsFeedbackVO != null) { // 피드백을 했을때

						mlFeedbackComment = emsFeedbackVO.getMlFeedbackComment();
						mlFeedbackYN = emsFeedbackVO.getMlFeedbackYN();
						mlFeedbackTimeStr = emsFeedbackVO.getMlFeedbackTimeStr();

						// int형 string으로 변환
						mlFeedbackYNStr = Integer.toString(mlFeedbackYN);

						emsAttachVO.setMlFeedbackYN(mlFeedbackYN);
						emsAttachVO.setMlFeedbackTimeStr(mlFeedbackTimeStr);
						emsAttachVO.setMlFeedbackComment(mlFeedbackComment);

					} else { // 피드백을 하지 않았을 때
						mlFeedbackTimeStr = "";
						mlFeedbackComment = "";
						mlFeedbackYN = -1;

						emsAttachVO.setMlFeedbackYN(mlFeedbackYN);
						emsAttachVO.setMlFeedbackTimeStr(mlFeedbackTimeStr);
						emsAttachVO.setMlFeedbackComment(mlFeedbackComment);
					}

				} else {
					ml_confd_class = -1;
					// int형 string으로 변환
					ml_confd_classStr = Integer.toString(ml_confd_class);
					ml_confd_prob = -1.0;
					features = "";

					emsAttachVO.setMl_confd_class(ml_confd_class);
					emsAttachVO.setMl_confd_prob(ml_confd_prob);
					emsAttachVO.setFeatures(features);

				}
			}

			Map<String, String> hashParam = new HashMap<>();
			String attachHash = Common.nvl(emsAttachVO);
			hashParam.put("attachHash", attachHash);

//			if(Common.isEmpty(emsAttachVO.getAttachTextPath()) && Common.isEmpty(emsAttachVO.getAttachTextHarPath()) && Common.isNotEmpty(attachHash)) {
//				EmsAttachTextVO vo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachTextByHash", hashParam);
//				if( vo == null ) {
//					emsAttachVO.setAttachTextPath("");
//					emsAttachVO.setAttachTextHarPath("");
//				} else {
//					emsAttachVO.setAttachTextPath(Common.nvl(vo.getAttachTextPath()));
//					emsAttachVO.setAttachTextHarPath(Common.nvl(vo.getAttachTextHarPath()));
//				}
//			}

			if (Config.isOCR && Common.isNotEmpty(attachHash)) {
				if (msgIds.length == 1) hashParam.put("msgId", msgId);
				else hashParam.put("msgIds", msgId);
				EmsAttachTextVO ocrVo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachOcrText", hashParam);

				if (Common.isNotEmpty(ocrVo)) {
					emsAttachVO.setOcrYn("Y");
					emsAttachVO.setOcrText(ocrVo.getAttachText());
					try {
						emsAttachVO.setOcrImageStr(ImageUtils.imageResize(attachDown.getAttach(emsAttachVO.getAttachPath(), emsAttachVO.getAttachHarPath()), 200));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}


		for (int j = 0; j < msgIds.length; j++) {
			if (!isConsent(msgIds[j], firstAdminYn, adminType)) {
				for (int i = 0; i < emsAttachVOList.size(); i++) {
					EmsAttachVO emsAttachVO = emsAttachVOList.get(i);
					emsAttachVO.setConsentFlag(false);
				}
			}
		}

		if (Common.isEquals(infoHynix, "true")) {
			Collections.sort(emsAttachVOList);
		}
*/

		return null;
	}

/*
	@Override
	public List<EmsAttachVO> getEmassAttachInfo4Down(String msgId, String attachId) {
	Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);

		EmsMessageVO emsMessageVO= mongoUtil.selectId(msgId,EmsMessageVO.class,MESSAGE_SCHEME);

		List<EmsAttachVO>list= emsMessageVO.getAttachInfo();


		return list;

	}*/

	@Override
	public List<EmsAttachVO> getEmassAttachInfo4DownHash(String msgIds, String attachHash) {
		Map<String, String> param = new HashMap<>();
		StringBuffer query = new StringBuffer();
		String[] msgIdArr = msgIds.split(",");
		query.append("(");
		for (int i = 0; i < msgIdArr.length; i++) {
			String msgId = msgIdArr[i].replace("'", "");
			query.append("'").append(msgId).append("'");
			if (i != msgIdArr.length - 1) query.append(", ");
		}
		query.append(")");

		param.put("msgIds", msgIds);
		param.put("attachHash", attachHash);
		param.put("query", query.toString());
		return selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachInfo4DownHash", param);
	}



/*
	@Override
	public EmsAttachVO getEmassAttachInfo(String msgId, String attachId) {
		*/
/*Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);

		return selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachInfo", param);*//*

		EmsAttachVO emsAttachVO= new EmsAttachVO();

		EmsMessageVO emsMessageVO =mongoUtil.selectId(msgId,EmsMessageVO.class,MESSAGE_SCHEME);


		List<EmsAttachVO>lists =emsMessageVO.getAttachInfo();

		for(int i=0; i<lists.size(); i++){
			if(lists.get(i).getAttachId().equals(attachId)){

				emsAttachVO=lists.get(i);
			}
		}
		return emsAttachVO;

	}
*/

/*	//내일 할 부분
	@Override
	public EmsAttachTextVO getEmassAttachTextInfo(String msgId, String attachId, String ocrYn) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);*/

/*		EmsAttachTextVO vo = null;
		if (Common.isEquals(ocrYn, "Y")) {

			EmsMessageVO emsMessageVO= mongoUtil.selectId(msgId,EmsMessageVO.class,MESSAGE_SCHEME);

			List<EmsAttachVO>list= emsMessageVO.getAttachInfo();
			EmsAttachVO msg= new EmsAttachVO();

			for(int i=0; i<list.size(); i++){
				if(list.get(i).getAttachId().equals(attachId)) {
					msg = list.get(i);
				}
			}
			vo.setAttachName(msg.getAttachName());
			vo.setAttachPath(msg.getAttachPath());
			vo.setAttachSize(String.valueOf(msg.getAttachSize()));
			vo.setAttachTextPath(msg.getAttachTextPath());
			vo.setAttachExt(msg.getAttachExt());

			if (vo == null) return null;
			if (Common.isNotEmpty(vo.getAttachText())) {
				vo.setAttachTextTotalLine(Common.toArray(vo.getAttachText(), "\n").length);
			}
		} else {
			EmsMessageVO emsMessageVO= mongoUtil.selectId(msgId,EmsMessageVO.class,MESSAGE_SCHEME);

			List<EmsAttachVO>list= emsMessageVO.getAttachInfo();
			EmsAttachVO msg= new EmsAttachVO();

			for(int i=0; i<list.size(); i++){
				if(list.get(i).getAttachId().equals(attachId)) {
					msg = list.get(i);
				}
			}
			vo.setAttachName(msg.getAttachName());
			vo.setAttachPath(msg.getAttachPath());
			vo.setAttachSize(String.valueOf(msg.getAttachSize()));
			vo.setAttachTextPath(msg.getAttachTextPath());
			vo.setAttachExt(msg.getAttachExt());

			if (vo == null) return null;
			if (Common.isNotEmpty(vo.getAttachPath())) {
				String text = Common.toString(Common.toByteArrayGzip(vo.getAttachTextPath(), null), Common.UTF8);
				if (text == null) vo.setAttachTextTotalLine(0);
				vo.setAttachTextTotalLine(Common.toArray(text, "\n").length);
			}
		}
		return vo;
	}
	*/


	@Override
	public List<PiVo_Mgo> getEmassPattern(String msgId) {
		EmassMessage emsMessageVO = mongoUtil.selectId(msgId,EmassMessage.class,MESSAGE_SCHEME);
		List<PiVo_Mgo> list = emsMessageVO.getPi();
		return list;
	}

	private Map<String, PatternVO> convertMap(List<PatternVO> list) {
		Map<String, PatternVO> map = new HashMap<>();
		for (PatternVO animal : list) {
			map.put(animal.getCode(), animal);
		}
		return map;
	}

	@Override
	public List<EmsPiDetailVO> getEmassPatternDetail(String msgId, String piId, String type, String attachName) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("piId", piId);
		param.put("type", type);
		param.put("attachName", attachName);
		return selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassPatternDetail", param);
	}

	@Override
	public EmsAttachTextVO getEmassAttachTextInfo(String msgId, String attachId, String ocrYn) {
		return null;
	}

	@Override
	public List<Integer> findKeywordPages(String msgId, String attachId, String ocrYn, int limit, final String searchkey) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);

		EmsAttachVO attachInfo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachInfo", param);
		param.put("attachHash", attachInfo.getAttachHash());

		String text = null;
		EmsAttachTextVO vo = null;
		if (Common.isEquals(ocrYn, "Y")) {
			vo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachOcrText", param);
			text = vo.getAttachText();
		} else {
			if (attachInfo != null && Common.isNotEmpty(attachInfo.getAttachPath())) {
				text = Common.toString(Common.toByteArrayGzip(attachInfo.getAttachTextPath(), attachInfo.getAttachTextHarPath()), Common.UTF8);
			}
		}

		Map<Integer, String> result = new HashMap<>();
		if (text == null) return null;

		String[] kwds = Common.toArray(searchkey, " ", false);
		String[] texts = Common.toArray(text, "\n", false);

		for (int i = 0; i < texts.length; i++) {
			for (int j = 0; j < kwds.length; j++) {
				int posFound = -1;
				if (kwds[j].startsWith("/") && kwds[j].endsWith("/")) {
					String kwd = kwds[j].replace("/", "");
					Pattern pattern = Pattern.compile(kwd, Pattern.CASE_INSENSITIVE);
					Matcher matcher = pattern.matcher(texts[i]);
					if (matcher.find()) posFound = matcher.start();
				} else {
					if ((!Common.isEmpty(texts[i])) && (!Common.isEmpty(kwds[j]))) {
						posFound = texts[i].toUpperCase().indexOf(kwds[j].toUpperCase());
					}
				}
				if (posFound > -1) {
					int pageNum = (int) Math.ceil(i / (double) limit);
					if (pageNum == 0) pageNum = 1;
					result.put(pageNum, "");
				}
			}
		}
		List<Integer> list = new ArrayList<>();
		Iterator<Integer> iter = result.keySet().iterator();
		while (iter.hasNext()) {
			int key = iter.next();
			list.add(key);
		}
		list.sort(null);
		return list;
	}

	@Override
	public String getEmassAttachText(String msgId, String attachId, String ocrYn, int offset, int limit) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);

		EmsAttachVO attachInfo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachInfo", param);
		param.put("attachHash", attachInfo.getAttachHash());

		EmsAttachTextVO vo = null;
		if (Common.isEquals(ocrYn, "Y")) {
			vo = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getEmassAttachOcrText", param);
			return getPageText(vo.getAttachText(), offset, limit);
		} else {
			if (Common.isNotEmpty(attachInfo.getAttachPath())) {
				String text = Common.toString(Common.toByteArrayGzip(attachInfo.getAttachTextPath(), attachInfo.getAttachTextHarPath()), Common.UTF8);
				if (text == null) return null;
				return getPageText(text, offset, limit);
			}
		}
		return null;
	}

	private String getPageText(String text, int offset, int limit) {
		String[] texts = Common.toArray(text, "\n", false);
		if (texts.length <= offset) return null;
		StringBuffer sb = new StringBuffer();
		int endLine = ((offset + limit) > texts.length) ? texts.length : (offset + limit);
		for (int i = offset; i < endLine; i++) {
			sb.append(texts[i]).append("\n");
		}
		return sb.toString();
	}

	@Override
	public EmsMessengerAdminXrootMtrVO getEmassMessengerAdminXrootMtr(String xRootMtr, String adminId, String srcip, String usr_id) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("xRootMtr", xRootMtr);
		param.put("srcip", srcip);
		param.put("usr_id", usr_id);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.getEmassMessengerAdminXrootMtr", param);
	}

	@Override
	public void updateEmassMessengerAdminXrootMtr(String xRootMtr, String msgId, String adminId, String srcip, String usr_id) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("xRootMtr", xRootMtr);
		param.put("msgId", msgId);
		param.put("srcip", srcip);
		param.put("usr_id", usr_id);
		update("com.xcurenet.sqlmap.mappers.mysql.emass.updateEmassMessengerAdminXrootMtr", param);
	}

	@Override
	public List<CodeVO> getMessengerList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getMessengerList");
	}

	@Override
	public List<CodeVO> getGenerativeList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getGenerativeList");
	}

	@Override
	public List<CodeVO> getFileList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getFileList");
	}


	@Override
	public List<CodeVO> getNoteList() {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getNoteList");
	}



	@Override
	public boolean readDoc(String msgId, CheckedVo_Mgo checkedVoMgo) {
		 return mongoUtil.readDoc(msgId,checkedVoMgo,MESSAGE_SCHEME);
	}


	@Override
	public void updateEmsFeedback(String msgId, String feedback, String adminId) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("feedback", feedback);
		param.put("adminId", adminId);
		update("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.updateEmsFeedback", param);
	}

	@Override
	public boolean updateEmsInfo(String msgId, String ml_confd_class, String ml_confd_prob, String ml_confd_nprob, String attachId, String attachHash, String features, String fileName) {
		boolean result = false;
		Map<String, Object> param = new HashMap<>();
		int ml_confd_class_value = 0;
		double ml_confd_prob_value = Double.parseDouble(ml_confd_prob);
		double ml_confd_nprob_value = Double.parseDouble(ml_confd_nprob);
		try {
			if (ml_confd_class.equals("Y")) {
				ml_confd_class_value = 1;
			}
			param.put("msgId", msgId);
			param.put("ml_confd_class", ml_confd_class_value);
			param.put("ml_confd_prob", ml_confd_prob_value);
			param.put("ml_confd_nprob", ml_confd_nprob_value);
			param.put("attachId", attachId);
			param.put("attachHash", attachHash);
			param.put("features", features);
			param.put("attachName", fileName);

			log.info("msgId : " + msgId);
			log.info("attachId : " + attachId);

			update("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.updateEmsInfo", param);
			result = true;
		} catch (Exception e) {
			result = false;
		}
		return result;

	}

	@Override
	public List<EmsSearchKeywordVO> getSearchKeywordAuto(String adminId, String searchKeyword) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("searchKeyword", searchKeyword);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getSearchKeywordAuto", param);
	}

	@Override
	public List<EmsSearchKeywordVO> getSearchKeywordList(String adminId, String searchKeyword) {
		Map<String, String> param = new HashMap<>();
		param.put("adminId", adminId);
		param.put("searchKeyword", searchKeyword);
		return selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getSearchKeywordList", param);
	}

	@Override
	public boolean isSearchKeywordExist(EmsSearchKeywordVO searchKeyword) {
		return (int) selectOne("com.xcurenet.sqlmap.mappers.mysql.emass.isSearchKeywordExist", searchKeyword) > 0;
	}

	@Override
	public int insertSearchKeywordList(EmsSearchKeywordVO searchKeyword) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = insert("com.xcurenet.sqlmap.mappers.mysql.emass.insertSearchKeywordList", searchKeyword);

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteSearchKeywordList(EmsSearchKeywordVO searchKeyword) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = delete("com.xcurenet.sqlmap.mappers.mysql.emass.deleteSearchKeywordList", searchKeyword);
			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public void sendSecretMail(String mailText) throws EmailException {
		String filePath = "/users/emasslth/alarm_mail/mailTo.txt";

		String str = "";
		String g1 = "";
		String[] ArraysStr = {};
		List<String> list = new ArrayList<>();

		String charSet = "UTF-8";

		Scanner sc;

		log.info("비밀문서 메일 전송 시작");

		Properties props = System.getProperties();
		props.put("mail.transport.protocol", "smtp");
		props.put("mail.smtp.host", Config.getInt("mail.smtp.host"));
		props.put("mail.smtp.port", Config.getInt("mail.smtp.port"));
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.auth", "true");

		Session session = Session.getDefaultInstance(props);
		MimeMessage msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress(Config.getString("system.mail.addr")));
			msg.setSubject("비밀문서 외부발송 탐지 내역", charSet);

			try {
				sc = new Scanner(new File(filePath));
				while (sc.hasNext()) {
					str = sc.nextLine();
					System.out.println(str);
				}
				ArraysStr = str.split(",");
				int size = ArraysStr.length;
				InternetAddress[] toAddr = new InternetAddress[size];
				for (int i = 0; i < ArraysStr.length; i++) {
					list.add(ArraysStr[i]);
				}

				for (int i = 0; i < ArraysStr.length; i++) {
					g1 = list.get(i);
					toAddr[i] = new InternetAddress(g1);
					System.out.println("To : " + g1);

				}
				msg.setRecipients(Message.RecipientType.TO, toAddr);
				log.info("메일 발송이 완료되었습니다.");
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			msg.setContent(mailText, "text/html; charset=utf-8");

		} catch (AddressException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (MessagingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			Transport transport = session.getTransport();
			transport.connect(Config.getString("mail.smtp.host"), Config.getInt("mail.smtp.port"), Config.getString("mail.smtp.id"), Config.getString("mail.smtp.password"));
			transport.sendMessage(msg, msg.getAllRecipients());
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}



/*
	@Override
	public Map<String, List<String>> parseJsonFile(String filePath) {

		try {
			Reader reader = new FileReader(filePath);
			JSONParser parser = new JSONParser();

			Object obj = parser.parse(reader);
			JSONArray jsonArr = (JSONArray) obj;

			String decisionDate, fileName, lastUpdated, processId, securityYn, sha256, sourceKey, features = "";
			String attachId = null;
			Double securityPct;
			Double doublSecurityPct;
			double changedoublSecurityPct;
			int intSecurityPct, count;

			Double doubleSecurityNPct;
			double changedoubleSecurityNPct;
			int intSecurityNPct;

			String securityPctStr;
			String doublSecurityPctStr;
			String doubleSecurityNPctStr;

			int attachSize;
			Double seqDouble;
			Long seqLong;

			// 메일 템플릿에서 사용할 list에 넣을 변수
			String msgIdY = "";
			String attachNameY = "";
			String securityYnY = "";
			String securityPctYStr = "";
			Double securityPctY;
			int intSecurityPctY;

			int jsonArrSize = jsonArr.size();
			Map<String, List<String>> param = new HashMap<>();
			List<parseJsonFile> sumList = new ArrayList<>(); // 전체 값 넣기(파일 이름 안넣음), solr update용
			List<parseJsonFile> bodyList = new ArrayList<>(); // 전체값(메일템플릿, 파이링름 있는 전체값)
			Map<String, List<parseJsonFile>> sortList = new HashMap<>(); // msgId로 그룹화시킨것, solrupdate용
			Map<String, List<parseJsonFile>> groupSecurityYnList = new HashMap<>(); // 비밀여부를 긱준으로 그룹화시킨것
			List<parseJsonFile> sortSecurityYList = new ArrayList<>();

			List<String> attachIdList = new ArrayList<String>();
			List<String> msgIdList = new ArrayList<String>();
			List<String> attachNameList = new ArrayList<String>();
			List<String> securityYnList = new ArrayList<String>();
			List<String> securityPctList = new ArrayList<String>();

			if (jsonArrSize > 0) {
				for (int i = 0; i < jsonArrSize; i++) {
					int j = i + 1;
					JSONObject jsonObj = (JSONObject) jsonArr.get(i);
					decisionDate = (String) jsonObj.get("decisionDate");

					fileName = (String) jsonObj.get("fileName");
					lastUpdated = (String) jsonObj.get("lastUpdated");
					processId = (String) jsonObj.get("processId");
					features = (String) jsonObj.get("features");
					doublSecurityPct = (double) jsonObj.get("securityPct");

					// 소수점 3째자리수에서 반올림
					changedoublSecurityPct = (double) Math.round(doublSecurityPct * 100) / 100;
					doublSecurityPctStr = String.valueOf(changedoublSecurityPct);
					doubleSecurityNPct = (double) jsonObj.get("securityNPct");
					changedoubleSecurityNPct = (double) Math.round(doubleSecurityNPct * 100) / 100;
					doubleSecurityNPctStr = String.valueOf(changedoubleSecurityNPct);

					intSecurityPct = (int) Math.floor(changedoublSecurityPct * 100);
					securityPctStr = Integer.toString(intSecurityPct);
					securityYn = (String) jsonObj.get("securityYn");
					sha256 = (String) jsonObj.get("sha256");
					sourceKey = (String) jsonObj.get("sourceKey");
					attachIdList = getMailAttachId(sourceKey, sha256, fileName);
					attachId = attachIdList.get(0);
					if (attachIdList.size() > 1) {
						for (int k = 0; k < attachIdList.size(); k++) {
							attachId = attachIdList.get(k);
							count = mlResultChk(sourceKey, sha256, fileName, attachId);
							if (count == 0) {
								attachId = attachIdList.get(k);
								break;

							} else {
								continue;
							}
						}
					}

					seqLong = (Long) jsonObj.get("seq");
					int seqInt = seqLong.intValue();

					// fileName없는 solr update용 전체 리스트
					sumList.add(new parseJsonFile(sourceKey, securityYn, changedoublSecurityPct));
					sortList = groupingByMsgId(sumList);
					bodyList.add(new parseJsonFile(sourceKey, fileName, securityYn, changedoublSecurityPct));

					// Solr Update 메소드로 전달
					boolean a = solrEdcService.setSecretInfo(sourceKey, securityYn, doublSecurityPctStr, sortList);
					// pheonix Insert 메소드로 전달
					boolean b = updateEmsInfo(sourceKey, securityYn, doublSecurityPctStr, doubleSecurityNPctStr, attachId, sha256, features, fileName);
				}

				// 메일 본문 템플릿에 들어갈 내용
				Collections.sort(bodyList); // 큰순서로 sorting 후 bodyList

				groupSecurityYnList = groupingBySecurityYn(bodyList); // 비밀여부로 그룹화 시킨 값

				sortSecurityYList = groupSecurityYnList.get("Y"); // Y인 값들만 sortSecurityYList 모음
				if (sortSecurityYList.size() > 0) {
					Collections.sort(sortSecurityYList); // sortSecurityYList 큰순으로 sort
					for (int j = 0; j < sortSecurityYList.size(); j++) {

						msgIdY = sortSecurityYList.get(j).getMsgId();
						attachNameY = sortSecurityYList.get(j).getAttachName();
						securityYnY = sortSecurityYList.get(j).getSecurityYn();
						securityPctY = sortSecurityYList.get(j).getSecurityPct();
						intSecurityPctY = (int) Math.floor(securityPctY * 100);
						securityPctYStr = String.valueOf(intSecurityPctY);

						msgIdList.add(msgIdY);
						attachNameList.add(attachNameY);
						securityYnList.add(securityYnY);
						securityPctList.add(securityPctYStr);
					}

					param.put("msgIdList", msgIdList);
					param.put("attachNameList", attachNameList);
					param.put("securityYnList", securityYnList);
					param.put("securityPctList", securityPctList);
				} else {
					param = null;
				}

			}
			return param;
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return null;
	}
*/

	private Map<String, List<parseJsonFile>> groupingByMsgId(List<parseJsonFile> sumList) {
		return sumList.stream().collect(Collectors.groupingBy(parseJsonFile::getMsgId));
	}

	private Map<String, List<parseJsonFile>> groupingBySecurityYn(List<parseJsonFile> bodyList) {
		return bodyList.stream().collect(Collectors.groupingBy(parseJsonFile::getSecurityYn));
	}

	@Override
	public List<String> getMailAttachId(String msgId, String attachHash, String fileName) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachHash", attachHash);
		param.put("attachName", fileName);
		return selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMailAttachId", param);
	}

	@Override
	public int mlResultChk(String msgId, String attachHash, String fileName, String attachId) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachHash", attachHash);
		param.put("attachName", fileName);
		param.put("attachId", attachId);
		return selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.mlResultChk", param);
	}

	@Override
	public int insertSkFeedback(int radioFeedback, String feedbackcomment, String attachId, String msgId, String attachName, String attachHash) {
		// 피드백 입력 라디오 버튼 : 1) 분류 맞음 2) 결정 보류 3) 비밀 4) 대외비
		// ㄴ value : 2 / 9 / 1 / 0
		Map<String, Object> param = new HashMap<>();
		param.put("feedbackcomment", feedbackcomment);
		param.put("attachId", attachId);
		param.put("msgId", msgId);
		param.put("radioFeedback", radioFeedback);
		param.put("attachName", attachName);
		param.put("attachHash", attachHash);

		return update("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.insertSkFeedback", param);
	}

	@Override
	public String getMlFeedbackData(String startTime, String endTime) {
		String msgId, attachId, attachName, attachHash = "";
		String mlFeedbackComment = "";
		Date mlFeedbackTime = null;
		int mlSecurityYN, mlFeedbackYN = -1;

		JSONArray jsonArray = new JSONArray();

		Map<String, String> param = new HashMap<>();
		param.put("startTime", startTime);
		param.put("endTime", endTime);

		List<EmsMlFeedbackVO> mlFeedbackVO = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlFeedback", param);
		log.info("Feedback Data Count : {} ", mlFeedbackVO.size());
		log.info("Feedback List : {} ", mlFeedbackVO);

		for (EmsMlFeedbackVO feedbackVo : mlFeedbackVO) {
			msgId = feedbackVo.getMsgId();
			attachId = feedbackVo.getAttachId();
			attachName = feedbackVo.getAttachName();
			attachHash = feedbackVo.getAttachHash();
			mlFeedbackYN = feedbackVo.getMlFeedbackYN();
			mlFeedbackTime = feedbackVo.getMlFeedbackTime();
			mlFeedbackComment = feedbackVo.getMlFeedbackComment();

			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("msgId", msgId);
			map.put("attachId", attachId);
			map.put("attachName", attachName);
			map.put("attachHash", attachHash);
			map.put("mlFeedbackYN", mlFeedbackYN);
			map.put("mlFeedbackTime", mlFeedbackTime.toString());
			map.put("mlFeedbackComment", mlFeedbackComment);

			JSONObject jsonObject = new JSONObject(map);
			jsonArray.add(jsonObject);
			log.info("msgid : {}, attachId : {}, attachName : {}, attachHash : {}, mlFeedbackYN : {}, mlFeedbackTime : {}, mlFeedbackComment : {}", msgId, attachId, attachName, attachHash, mlFeedbackYN, mlFeedbackTime, mlFeedbackComment);
		}
		log.info(jsonArray.toJSONString());
		log.info(jsonArray.toString());
		String filePath = makeFeedbackJsonFile(jsonArray);

		return filePath;
	}



	private String makeFeedbackJsonFile(JSONArray jsonArray) {
		log.info("Feedback JSON ARRAY SIZE : {}", jsonArray.size());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
		java.util.Date now = new java.util.Date();
		String nowTime = sdf.format(now);

		String filePath = selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", "ml.feedback.jsonMakePath");
		String fileName = nowTime + "_feedback.json";
		log.info("Write JSON File Start : {}", filePath + fileName);
		log.info("Write JSON File Success : {}", filePath + fileName);

		SFTPUtil util = new SFTPUtil();
		String mlFeedbackSftpHost = selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", "ml.feedback.ip");
		String mlFeedbackSftpUser = selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", "ml.feedback.user");
		String mlFeedbackSftpPw = selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", "ml.feedback.pw");
		int mlFeedbackSftpPort = Integer.parseInt(selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", "ml.feedback.port"));

		try {
			util.init("10.173.51.93", "root", "root99", 22);
		} catch (JSchException e) {
			log.error(e.getMessage());
		}

		File jsonFile = new File(filePath + fileName);
		String sftpFilePath = selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", "ml.feedback.jsonUploadPath");
		log.info("SFTP File Path : {}", sftpFilePath);

		try {
			util.upload(sftpFilePath, jsonFile);
			log.info("SFTP Feedback JSON File Upload Success : {}", sftpFilePath + jsonFile.getName());

			jsonFile.delete();
			log.info("Remove Org Feedback JSON File Success : {}", jsonFile.getPath());
		} catch (Exception e) {
			log.info(e.getMessage());
		}

		String feedbackJsonFilePath = sftpFilePath + fileName;

		return feedbackJsonFilePath;

	}

	@Override
	public String getMlFeedbackUrl(String confId) {

		return selectOne("com.xcurenet.sqlmap.mappers.mysql.config.getMlFeedbackInfo", confId);
	}

/*	@Override
	public boolean insertAndUpdateSolrFeedback(String msgId, String feedbackValue) {
		log.info("Solr Feedback Process Start");

		String attachName = "";
		Date mlFeedbackDate = null;
		Double mlFeedbackProb;
		int mlSecurityYn = -1;
		int ml_confd_feedback; // db 저장된 피드백 라디오 버튼 값
		int mlFeedbackValue = -1; // solr - ml_confd_feedback 넣을 데이터
		boolean checkPending = false;
		List<parseJsonFile> feedbackList = new ArrayList<>();

		// EMS_MLFEEDBACK 테이블 조회
		List<EmsMlFeedbackDataVO> mlFeedbackList = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlFeedbackData", msgId);
		log.info("get MlFeedback Data : {}" + mlFeedbackList);
		List<Integer> mlConfdFeedbackList = new ArrayList<Integer>();

		for (EmsMlFeedbackDataVO feedbackvo : mlFeedbackList) {
			ml_confd_feedback = feedbackvo.getMl_confd_feedback();
			mlConfdFeedbackList.add(ml_confd_feedback);
		}

		if (mlConfdFeedbackList.contains(9)) {
			mlFeedbackValue = 9;
		} else if (mlConfdFeedbackList.contains(2) || mlConfdFeedbackList.contains(1) || mlConfdFeedbackList.contains(0)) {
			mlFeedbackValue = 1;
		} else {
			mlFeedbackValue = 0;
		}

		List<EmsMlFeedbackVO> mlResultList = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlResultData", msgId);
		log.info("get MlResult Data : {}", mlResultList);

		for (EmsMlFeedbackVO feedbackVo : mlResultList) {
			attachName = feedbackVo.getAttachName();
			mlSecurityYn = feedbackVo.getMlSecurityYN();
			mlFeedbackProb = feedbackVo.getMl_confd_prob();
			mlFeedbackDate = feedbackVo.getMlFeedbackTime();

			feedbackList.add(new parseJsonFile(msgId, attachName, Integer.toString(mlSecurityYn), Integer.toString(mlFeedbackValue), mlFeedbackProb, mlFeedbackDate));
		}

		boolean updateCheck = solrEdcService.updateSolrFeedbackData(feedbackList);

		return updateCheck;
	}*/

	@Override
	public int updateSkMlFeedback(String msgId, String attachId, int radioFeedbackInt, int attachSecretYnInt) {
		Map<String, Object> param = new HashMap<>();

		// 2(분류 맞음) ,9(결정보류) , 1(비밀문서), 0(대외비 문서)
		if ((radioFeedbackInt == 1)) {
			attachSecretYnInt = 1;
		} else if ((radioFeedbackInt == 0)) {
			attachSecretYnInt = 0;
		}

		param.put("msgId", msgId);
		param.put("attachId", attachId);
		param.put("attachSecretYnInt", attachSecretYnInt);

		return update("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.updateSkMlFeedback", param);
	}

	@Override
	public EmsMlFeedbackVO getMlFeedbackDate(String msgId, String attachId) {
		EmsMlFeedbackVO emsFeedbackVO = null;
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);
		emsFeedbackVO = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlFeedbackDate", param);
		return emsFeedbackVO;
	}

	@Override
	public EmsMlFeedbackVO getMlSecretData(String msgId, String attachId) {
		EmsMlFeedbackVO emsResultVO = null;
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("attachId", attachId);
		emsResultVO = selectOne("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getMlSecretData", param);
		return emsResultVO;
	}

	@Override
	public List<Map<String, Object>> getRecvDomainInfo(String msgId, String inside, String recvsType) {
		Map<String, String> param = new HashMap<>();
		param.put("msgId", msgId);
		param.put("inside", inside);
		param.put("recvsType", recvsType);
		List<Map<String, Object>> result = selectList("com.xcurenet.sqlmap.mappers." + Config.DBMS_NAME + ".emass.getRecvDomainInfo", param);
		return result;
	}



	@Override
	public List<EmsAttachVO> getEmassAttachInfo4Down(String msgId, String attachId) {
		return null;
	}

	@Override
	public boolean insertAndUpdateSolrFeedback(String msgId, String feedbackValue) {
		return false;
	}

	@Override
	public Map<String, List<String>> parseJsonFile(String filePath) {
		return null;
	}

	@Override
	public EmsAttachVO getEmassAttachInfo(String msgId, String attachId) {
		return null;
	}


}
