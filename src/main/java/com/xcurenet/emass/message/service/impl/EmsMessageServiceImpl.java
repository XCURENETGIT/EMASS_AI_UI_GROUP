package com.xcurenet.emass.message.service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.image.ImageUtils;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.MongoUtil;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.consent.service.ConsentService;
import com.xcurenet.emass.consent.service.ConsentVO;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.emass.message.service.vo.EmassKeywordData;
import com.xcurenet.emass.message.service.vo.EmassMessageData;
import com.xcurenet.emass.message.web.EmsAttachDownload;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.log4j.Log4j2;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Log4j2
@Service("emsMessageService")
public class EmsMessageServiceImpl extends XcnAbstractDAO implements EmsMessageService {

	@Resource(name = "consentService")
	public ConsentService consentService;

	@Autowired
	public ConfigAdminService configAdminService;

	@Autowired
	public MinioFileAdapter minioFileAdapter;

	@Autowired
	private EmsMessageConvert emsMessageConvert;

	@Autowired
	public Config config;

	@Autowired
	private MongoUtil mongo;

	public EmsAttachTextVO getAttachTextByHash(final String hash) {
		Query query = new Query();
		query.addCriteria(Criteria.where("attachHash").is(hash));
		return mongo.selectOne(query, EmsAttachTextVO.class);
	}

	private EmsMessageVO getEmassMessageData(final String msgId) {
		return emsMessageConvert.convertData(mongo.selectId(msgId, EmassMessageData.class));
	}

	@Override
	public EmsBodyVO getEmassBody(String msgId, String firstAdminYn, String adminType) {
		EmsMessageVO data = getEmassMessageData(msgId);
		EmsBodyVO bodyVo = new EmsBodyVO();
		bodyVo.setMsgId(data.getMsgId());
		bodyVo.setBodyHash(data.getBodyHash());
		bodyVo.setBodyCharset(data.getBodyCharset());
		bodyVo.setBodyPath(data.getBodyPath());
		bodyVo.setBodyType(data.getBodyType());
		bodyVo.setBodyText(data.getBodyText());
		bodyVo.setSubject(data.getSubject());
		bodyVo.setSvc(data.getSvc());
		bodyVo.setSrcIp(data.getSrcIp());
		bodyVo.setDstIp(data.getDstIp());
		bodyVo.setHost(data.getHost());
		bodyVo.setPath(data.getPath());
		bodyVo.setUserId(data.getUserId());
		bodyVo.setName(data.getName());
		bodyVo.setCtime(data.getCtime());
		bodyVo.setEpmsgType(data.getEpmsgType());
		bodyVo.setBody(minioFileAdapter.open(bodyVo.getBodyPath()));
		return bodyVo;
	}

	@Override
	public EmsBodyVO getEmassBodyHash(String msgId) {
		return getEmassBody(msgId, null, null);
	}

	@Override
	public List<EmsKeywordVO> getEmassKeyword(String msgId) {
		EmsMessageVO data = getEmassMessageData(msgId);
		EmassKeywordData keywordVO = data.getKeywordInfo();
		List<EmsKeywordVO> result = new ArrayList<>();
		result.addAll(getKeywordList(msgId, "B", keywordVO.getKwdsBody()));
		result.addAll(getKeywordList(msgId, "S", keywordVO.getKwdsSubject()));
		result.addAll(getKeywordList(msgId, "F", keywordVO.getKwdsAttachNm()));
		result.addAll(getKeywordList(msgId, "A", keywordVO.getKwdsAttach()));
		return result;
	}

	private List<EmsKeywordVO> getKeywordList(final String msgId, final String type, Set<String> kwds) {
		List<EmsKeywordVO> result = new ArrayList<>();
		for (String kwd : kwds) {
			EmsKeywordVO vo = new EmsKeywordVO();
			vo.setMsgId(msgId);
			vo.setType(type);
			vo.setKeyword(kwd);
			result.add(vo);
		}
		return result;
	}

	@Override
	public EmsHeaderVO getEmassHeader(String msgId) {
		EmsMessageVO data = getEmassMessageData(msgId);
		EmsHeaderVO result = new EmsHeaderVO();
		result.setMsgId(data.getMsgId());
		result.setHeaderPath(null);
		if (data.getHeader() != null) result.setHeader(data.getHeader().getBytes());
		return result;
	}

	@Override
	public EmsMessageVO getEmassMessage(String msgId, String firstAdminYn, String adminType) {
		EmsMessageVO data = getEmassMessageData(msgId);
		if (data == null) {
			log.info("[Message Not Found] msgid:{}", msgId);
			return null;
		} else {
			return getConsentMessage(data, firstAdminYn, adminType);
		}
	}

	@Override
	public EmsMessageVO getEmassMessageNew(String adminId, String msgId, String firstAdminYn, String adminType) {
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		if (emsMessageVO == null) {
			log.info("[Message Not Found] msgid:{}", msgId);
			return null;
		} else {
			// 예약어
			if (Common.isEquals(emsMessageVO.getKwd(), "Y")) {
				List<EmsKeywordVO> emsKeywordVOList = this.getEmassKeyword(msgId);
				for (EmsKeywordVO emsKeywordVO : emsKeywordVOList) {
					String type = emsKeywordVO.getType();
					String keyword = emsKeywordVO.getKeyword();
					if (Common.isEquals(type, "A")) {
						if (Common.isEmpty(emsMessageVO.getAttachStr())) emsMessageVO.setAttachStr(keyword);
						else emsMessageVO.setAttachStr(emsMessageVO.getAttachStr() + ", " + keyword);
					} else if (Common.isEquals(type, "F")) {
						if (Common.isEmpty(emsMessageVO.getFileNameStr())) emsMessageVO.setFileNameStr(keyword);
						else emsMessageVO.setFileNameStr(emsMessageVO.getFileNameStr() + ", " + keyword);
					} else if (Common.isEquals(type, "S")) {
						if (Common.isEmpty(emsMessageVO.getSubjectStr())) emsMessageVO.setSubjectStr(keyword);
						else emsMessageVO.setSubjectStr(emsMessageVO.getSubjectStr() + ", " + keyword);
					} else if (Common.isEquals(type, "B")) {
						if (Common.isEmpty(emsMessageVO.getBodyStr())) emsMessageVO.setBodyStr(keyword);
						else emsMessageVO.setBodyStr(emsMessageVO.getBodyStr() + ", " + keyword);
					}
				}
			}
			emsMessageVO.setSubject(EmsReDefined.reSubject(emsMessageVO));

			List<EmsRecvVO> users = emsMessageVO.getFullUsers();
			List<EmsRecvVO> user = new ArrayList<>();
			List<EmsRecvVO> sender = new ArrayList<>();
			List<EmsRecvVO> recvs = new ArrayList<>();
			List<EmsRecvVO> to = new ArrayList<>();
			List<EmsRecvVO> cc = new ArrayList<>();
			List<EmsRecvVO> bcc = new ArrayList<>();

			ConfigAdminVO configAdminVO = configAdminService.getConfAdmin(Config.USER_FORMAT, adminId);
			if (configAdminVO == null || Common.isEmpty(configAdminVO.getVal())) {
				configAdminVO = new ConfigAdminVO();
				configAdminVO.setVal(Config.getString(Config.USER_FORMAT, "#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#"));
			}
			String formatval = configAdminVO.getVal();
			log.info("Message : " + emsMessageVO);
			for (EmsRecvVO emsRecvVO : users) {
				EmsRecvVO u = EmsReDefined.reUserIp(emsRecvVO, Common.nvl(emsMessageVO.getSrcIp()), Common.nvl(emsMessageVO.getDstIp()), Common.nvl(emsMessageVO.getUsrIp()));
				if (Common.isEquals(u.getUType(), "U")) {
					u.setEMail(EmsReDefined.reUserEmail(emsRecvVO, Common.nvl(emsMessageVO.getUser())));
					u.setViewStr(EmsReDefined.reUser(u, formatval));
					user.add(u);
				} else if (Common.isEquals(u.getUType(), "F")) {
					u.setEMail(EmsReDefined.reUserEmail(emsRecvVO, Common.nvl(emsMessageVO.getSender())));
					u.setViewStr(EmsReDefined.reUser(u, formatval));
					sender.add(u);
				} else if (Common.isEquals(u.getUType(), "T")) {
					u.setEMail(EmsReDefined.reUserEmail(emsRecvVO));
					u.setViewStr(EmsReDefined.reUser(u, formatval));
					recvs.add(u);
					to.add(u);
				} else if (Common.isEquals(u.getUType(), "C")) {
					u.setEMail(EmsReDefined.reUserEmail(emsRecvVO));
					u.setViewStr(EmsReDefined.reUser(u, formatval));
					recvs.add(u);
					cc.add(u);
				} else if (Common.isEquals(u.getUType(), "B")) {
					u.setEMail(EmsReDefined.reUserEmail(emsRecvVO));
					u.setViewStr(EmsReDefined.reUser(u, formatval));
					recvs.add(u);
					bcc.add(u);
				}
			}
			emsMessageVO.setUserList(user);
			emsMessageVO.setSenderList(sender);
			emsMessageVO.setRecvsList(recvs);
			emsMessageVO.setToList(to);
			emsMessageVO.setCcList(cc);
			emsMessageVO.setBccList(bcc);

			if (Common.isNotEmpty(emsMessageVO.getIpBusicd()))
				emsMessageVO.setIpBusiNm(Common.nvl(getIpBusiNm(emsMessageVO.getIpBusicd())).isEmpty() ? "unknown" : getIpBusiNm(emsMessageVO.getIpBusicd()));
			else emsMessageVO.setIpBusiNm("");

			if (Common.isNotEmpty(emsMessageVO.getIpDeptcd()))
				emsMessageVO.setIpDeptNm(Common.nvl(getIpDeptNm(emsMessageVO.getIpDeptcd())).isEmpty() ? "unknown" : getIpDeptNm(emsMessageVO.getIpDeptcd()));
			else emsMessageVO.setIpDeptNm("");

			emsMessageVO.setFiles(getEmassAttachInfoConsent(msgId, firstAdminYn, adminType));
			emsMessageVO.setPatterns(this.getEmassPattern(msgId));
			return getConsentMessage(emsMessageVO, firstAdminYn, adminType);
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


	private EmsMessageVO getConsentMessage(EmsMessageVO emsMessageVO, String firstAdminYn, String adminType) {
		boolean consentFlag = Config.getBoolean("consent.menu.enable");
		emsMessageVO.setConsentFlag(true);

		if (!consentFlag || Common.isEquals(firstAdminYn, "Y")) return emsMessageVO;

		if (Common.isNotEquals(firstAdminYn, "Y") && Common.isNotEquals(adminType, "C")) {
			boolean consentRtnFlag = false;
			List<ConsentVO> consentList = consentService.getConsentSearchList("", "");
			for (ConsentVO consent : consentList) {
				if (Common.isEquals(emsMessageVO.getUserId(), consent.getUserId())) {
					consentRtnFlag = true;
					break;
				}
			}
			if (!consentRtnFlag) {
				emsMessageVO = new EmsMessageVO();
				emsMessageVO.setConsentFlag(consentRtnFlag);
			}
		}
		return emsMessageVO;
	}

	@Override
	public List<EmsRecvVO> getEmassUserInfo(String msgId) {
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		return emsMessageVO.getUserList();
	}


	@Override
	public List<EmsRecvVO> getEmassUserInfo(String msgId, String uType) {
		List<EmsRecvVO> result = new ArrayList<>();
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		if (uType.contains("U")) result.addAll(emsMessageVO.getUserList());
		if (uType.contains("F")) result.addAll(emsMessageVO.getSenderList());
		if (uType.contains("T")) result.addAll(emsMessageVO.getToList());
		if (uType.contains("C")) result.addAll(emsMessageVO.getCcList());
		if (uType.contains("B")) result.addAll(emsMessageVO.getBccList());
		return result;
	}

	@Override
	public List<EmsAttachVO> getEmassAttachInfoConsent(String msgId, String firstAdminYn, String adminType) {
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		List<EmsAttachVO> emsAttachVOList = getEmsAttachVOS(emsMessageVO);
		EmsAttachDownload attachDown = new EmsAttachDownload();
		for (EmsAttachVO attachVO : emsAttachVOList) {
			if (Config.isOCR && Common.isNotEmpty(attachVO.getAttachHash())) {
				EmsAttachTextVO ocrVo = getAttachTextByHash(attachVO.getAttachHash());
				if (Common.isNotEmpty(ocrVo)) {
					attachVO.setOcrYn("Y");
					attachVO.setOcrText(ocrVo.getAttachText());
					try {
						attachVO.setOcrImageStr(ImageUtils.imageResize(attachDown.getAttach(attachVO.getAttachPath(), attachVO.getAttachHarPath()), 200));
					} catch (Exception e) {
						log.error("", e);
					}
				}
			}
		}
		return emsAttachVOList;
	}

	@NotNull
	private static List<EmsAttachVO> getEmsAttachVOS(EmsMessageVO emsMessageVO) {
		List<EmsAttachVO> emsAttachVOList = emsMessageVO.getFiles();
		// .merged 파일로 인한 재정렬
		emsAttachVOList.sort((o1, o2) -> {
			String oneAttachId = o1.getAttachId();
			String nextAttachId = o2.getAttachId();
			int re = 0;
			if (oneAttachId.startsWith("/") && nextAttachId.startsWith("/")) {
				re = oneAttachId.substring(oneAttachId.lastIndexOf("/") + 1).compareTo(nextAttachId.substring(nextAttachId.lastIndexOf("/") + 1));
			} else if (oneAttachId.startsWith("/")) {
				re = oneAttachId.substring(oneAttachId.lastIndexOf("/") + 1).compareTo(nextAttachId);
			} else if (nextAttachId.startsWith("/")) {
				re = nextAttachId.substring(oneAttachId.lastIndexOf("/") + 1).compareTo(oneAttachId);
			} else {
				re = oneAttachId.compareTo(nextAttachId);
			}
			return re;
		});
		return emsAttachVOList;
	}

	@Override
	public List<EmsAttachVO> getEmassAttachInfo4Down(String msgId, String attachId) {
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		List<EmsAttachVO> result = new ArrayList<>();
		for (EmsAttachVO vo : emsMessageVO.getFiles()) {
			if (attachId == null || Common.isEquals(attachId, vo.getAttachId())) result.add(vo);
		}
		return result;
	}

	@Override
	public List<EmsAttachVO> getEmassAttachInfo4DownHash(String msgIds, String attachHash) {
		List<EmsAttachVO> result = new ArrayList<>();
		String[] msgIdArr = msgIds.split(",");
		for (String msgId : msgIdArr) {
			EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
			for (EmsAttachVO vo : emsMessageVO.getFiles()) {
				if (attachHash == null || Common.isEquals(attachHash, vo.getAttachHash())) result.add(vo);
			}
		}
		return result;
	}

	@Override
	public EmsAttachVO getEmassAttachInfo(String msgId, String attachId) {
		List<EmsAttachVO> list = getEmassAttachInfo4Down(msgId, attachId);
		if (list != null && !list.isEmpty()) return list.get(0);
		else return null;
	}

	@Override
	public EmsAttachTextVO getEmassAttachTextInfo(String msgId, String attachId, String ocrYn) {
		EmsAttachTextVO vo = new EmsAttachTextVO();
		EmsAttachVO attachInfo = getEmassAttachInfo(msgId, attachId);
		if (attachInfo == null) return vo;

		if (Common.isEquals(ocrYn, "Y")) {
			EmsAttachTextVO ocrText = getAttachTextByHash(attachInfo.getAttachHash());
			if (Common.isNotEmpty(ocrText.getAttachText())) {
				vo.setAttachText(ocrText.getAttachText());
				vo.setAttachTextTotalLine(Common.toArray(vo.getAttachText(), "\n").length);
			} else if (Common.isNotEmpty(vo.getAttachText())) {
				vo.setAttachTextTotalLine(Common.toArray(vo.getAttachText(), "\n").length);
			}
		} else {
			if (Common.isNotEmpty(attachInfo.getAttachPath())) {
				String text = Common.toString(minioFileAdapter.open(attachInfo.getAttachTextPath()), Common.UTF8);
				if (text == null) vo.setAttachTextTotalLine(0);
				vo.setAttachTextTotalLine(Common.toArray(text, "\n").length);
			}
		}
		vo.setAttachExt(attachInfo.getAttachExt());
		vo.setAttachName(attachInfo.getAttachName());
		vo.setAttachPath(attachInfo.getAttachPath());
		vo.setAttachSize(Common.nvl(attachInfo.getAttachSize()));
		return vo;
	}

	@Override
	public List<EmsPiVO> getEmassPattern(String msgId) {
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		List<EmsPiVO> emsPis = emsMessageVO.getPatterns();
		Map<String, PatternVO> pattern = convertMap(selectList("com.xcurenet.sqlmap.mappers.mysql.emass.getPatternAllList", new PatternVO()));
		for (EmsPiVO emsPi : emsPis) {
			PatternVO vo = pattern.get(emsPi.getPiid());
			if (vo != null) emsPi.setPiName(vo.getName());
		}
		return emsPis;
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
		List<EmsPiDetailVO> result = new ArrayList<>();
		EmsMessageVO emsMessageVO = getEmassMessageData(msgId);
		List<EmsPiVO> emsPis = emsMessageVO.getPatterns();
		for (EmsPiVO pi : emsPis) {
			if ((Common.isEmpty(piId) || Common.isEquals(piId, pi.getPiid())) && (Common.isEmpty(type) || Common.isEquals(type, pi.getType())) && (Common.isEmpty(attachName) || Common.isEquals(attachName, pi.getAttachName()))) {
				EmsPiDetailVO vo = new EmsPiDetailVO();
				vo.setAttachName(pi.getAttachName());
				vo.setKwds(pi.getKwds());
				vo.setAmount(pi.getTotal());
				result.add(vo);
			}
		}
		return result;
	}

	@Override
	public List<Integer> findKeywordPages(String msgId, String attachId, String ocrYn, int limit, final String searchkey) {
		EmsAttachVO attachInfo = getEmassAttachInfo(msgId, attachId);

		String text = null;
		if (Common.isEquals(ocrYn, "Y")) {
			EmsAttachTextVO ocrText = getAttachTextByHash(attachInfo.getAttachHash());
			text = ocrText.getAttachText();
		} else {
			if (Common.isNotEmpty(attachInfo.getAttachPath())) {
				text = Common.toString(minioFileAdapter.open(attachInfo.getAttachTextPath()), Common.UTF8);
			}
		}

		Map<Integer, String> result = new HashMap<>();
		if (text == null) return null;
		String[] kwds = Common.toArray(searchkey, " ", false);
		String[] texts = Common.toArray(text, "\n", false);

		for (int i = 0; i < texts.length; i++) {
			for (String s : kwds) {
				int posFound = -1;
				if (s.startsWith("/") && s.endsWith("/")) {
					String kwd = s.replace("/", "");
					Pattern pattern = Pattern.compile(kwd, Pattern.CASE_INSENSITIVE);
					Matcher matcher = pattern.matcher(texts[i]);
					if (matcher.find()) posFound = matcher.start();
				} else {
					if ((!Common.isEmpty(texts[i])) && (!Common.isEmpty(s))) {
						posFound = texts[i].toUpperCase().indexOf(s.toUpperCase());
					}
				}
				if (posFound > -1) {
					int pageNum = (int) Math.ceil(i / (double) limit);
					if (pageNum == 0) pageNum = 1;
					result.put(pageNum, "");
				}
			}
		}
		List<Integer> list = new ArrayList<>(result.keySet());
		list.sort(null);
		return list;
	}

	@Override
	public String getEmassAttachText(String msgId, String attachId, String ocrYn, int offset, int limit) {
		EmsAttachVO attachInfo = getEmassAttachInfo(msgId, attachId);
		if (Common.isEquals(ocrYn, "Y")) {
			EmsAttachTextVO ocrText = getAttachTextByHash(attachInfo.getAttachHash());
			return getPageText(ocrText.getAttachText(), offset, limit);
		} else {
			if (Common.isNotEmpty(attachInfo.getAttachPath())) {
				String text = Common.toString(minioFileAdapter.open(attachInfo.getAttachTextPath()), Common.UTF8);
				if (text == null) return null;
				return getPageText(text, offset, limit);
			}
		}
		return null;
	}

	private String getPageText(String text, int offset, int limit) {
		String[] texts = Common.toArray(text, "\n", false);
		if (texts.length <= offset) return null;
		StringBuilder sb = new StringBuilder();
		int endLine = Math.min((offset + limit), texts.length);
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
	public void updateEmsFeedback(String msgId, String feedback, String adminId) {
		Query query = new Query().addCriteria(Criteria.where("_id").is(msgId));
		Update updateDefinition = new Update().set("ml.mlConfdFeedBack", feedback).set("ml.mlConfdUserId", adminId);
		mongo.upsertEmsMessage(msgId, query, updateDefinition);
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
	public List<Map<String, Object>> getRecvDomainInfo(String msgId, String inside, String recvsType) {
		List<EmsRecvVO> recvs = getEmassUserInfo(msgId);
		for (int i = 0; i < recvs.size(); i++) {
			EmsRecvVO recv = recvs.get(i);
			if (Common.isEquals(inside, recv.getInSide())) {
				String domain = recv.getDomain().substring(recv.getDomain().indexOf("@") + 1, recv.getDomain().length() - 1);
				recv.setDomain(domain);
				recvs.set(i, recv);
			}
		}
		final ObjectMapper objectMapper = new ObjectMapper();
		return objectMapper.convertValue(recvs, new TypeReference<>() {
		});
	}
}
