package com.xcurenet.emass.message.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.emass.message.service.*;
import com.xcurenet.emass.message.service.vo.EmassAttachData;
import com.xcurenet.emass.message.service.vo.EmassMessageData;
import com.xcurenet.emass.message.service.vo.EmassPiData;
import com.xcurenet.user.service.UserService;
import com.xcurenet.user.service.UserVO;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class EmsMessageConvert {

	@Autowired
	public UserService userService;
	/*util mongo convert */
	public EmsMessageVO convertData(EmassMessageData data) {
		if(null == data) {data = new EmassMessageData();} // null err방지
		EmsMessageVO vo = new EmsMessageVO();
		vo.setMsgId(data.getMsgId());
		if (data.getNetworkInfo() != null) {
			vo.setCId(data.getNetworkInfo().getCid());
			vo.setSrcIp(data.getNetworkInfo().getSrcIp());
			vo.setSPort(data.getNetworkInfo().getSPort());
			vo.setDstIp(data.getNetworkInfo().getDstIp());
			vo.setdPort(data.getNetworkInfo().getDPort());
			vo.setProtocol(data.getNetworkInfo().getProtocol());
		}
		vo.setSvc(data.getSvc());

		DateTime ltime = data.getLTime();
		DateTime ctime = data.getCTime();

//		/* GMT 를 사용하는 서버시간대의 경우 */
//		if("GMT+09:00".equals(TimeZone.getDefault().getID())){
		if(!Common.isEmpty(ltime)) ltime = ltime.minusHours(9);
		if(!Common.isEmpty(ctime)) ctime = ctime.minusHours(9);
//		}

		vo.setLtime(Common.yyyy_MM_dd_HH_mm_ss.print(ltime));
		vo.setCtime(Common.yyyy_MM_dd_HH_mm_ss.print(ctime));
		vo.setSize(data.getSize());
		if (data.getBodyInfo() != null) {
			vo.setBodySize(data.getBodyInfo().getBodySize());
			vo.setBodyHash(data.getBodyInfo().getBodyHash());
//			vo.setBody_snippet(data.getBodyInfo().getBody_snippet());
			vo.setBodyCharset(data.getBodyInfo().getBodyCharset());
			vo.setBodyPath(data.getBodyInfo().getBodyPath());
			vo.setBodyTextPath(data.getBodyInfo().getBodyTextPath());
			vo.setBodyImgCnt(Common.nvz(data.getBodyInfo().getBodyImageCnt()));
			vo.setBodyType(Common.nvl(data.getBodyInfo().getBodyType()));

		}
		if (data.getOrgSender() != null){
			vo.setOrgSenderList(getUserInfo(data.getOrgSender(), data.getMsgId(),"OF"));
		}
		vo.setUsrIp(data.getUsrIp());
		vo.setUsrId(data.getUsrId());
		vo.setPassword(data.getPassword());
		vo.setSubject(data.getSubject());
		vo.setXMsgKey(data.getXMsgKey());
		vo.setXRootMtr(data.getXRootMtr());
		vo.setXParentMtr(data.getXParentMtr());
		if(data.getHttpInfo() != null ) {
			vo.setHost(data.getHttpInfo().getHost());
			vo.setPath(data.getHttpInfo().getPath());
			vo.setQuery(data.getHttpInfo().getQuery());
			vo.setHeader(data.getHttpInfo().getHeader());
		}
		if (data.getSenderInfo() != null) {
			vo.setSender(data.getSenderInfo().getId());
			vo.setSenderList(getUserInfo(data.getSenderInfo(), data.getMsgId(), "F"));
		}
		vo.setOpinion(data.getOpinion());
		vo.setDevWriter(data.getDevWriter());
		vo.setDevDecoder(data.getDevDecoder());
		vo.setSiteAttr(data.getSiteAttr());
		vo.setSiteCode(data.getSiteCode());

		if(data.getUserInfo() != null) {
			data.getUserInfo().setEmail(data.getUserInfo().getEmail());
			data.getUserInfo().setIp(data.getUserInfo().getIp());
			vo.setUser(data.getUserInfo().getId());
			vo.setUserId(data.getUserInfo().getUserId());
			vo.setName(data.getUserInfo().getName());
			vo.setCoCd(data.getUserInfo().getCoCd());
			vo.setIpCocd(data.getUserInfo().getIpCoCd());
			vo.setSubOrgCd(data.getUserInfo().getSuborgCd());
			vo.setBusiCd(data.getUserInfo().getBusiCd());
			vo.setBusiNm(data.getUserInfo().getBusiNm());
			vo.setIpBusicd(data.getUserInfo().getIpBusiCd());
			vo.setIpBusiNm(data.getUserInfo().getIpBusiNm());
			vo.setIpDeptcd(data.getUserInfo().getIpDeptCd());
			vo.setIpDeptNm(data.getUserInfo().getIpDeptNm());
			vo.setIpDeptcd(data.getUserInfo().getDeptCd());
			vo.setJikgubCd(data.getUserInfo().getJikgubCd());
			vo.setInSide(data.getUserInfo().getInside());
			vo.setCeo(data.getUserInfo().getCeo());
			vo.setUserList(getUserInfo(data.getUserInfo(), data.getMsgId(), "U"));
		}

		vo.setAllOfUs(data.getAllOfUs());
		vo.setAttached(data.getAttached());
		vo.setDirection(data.getDirection());
		if(data.getKeywordInfo() != null ) vo.setKwd(data.getKeywordInfo().getKwd());
		//if (data.getPrivateInfo() != null) vo.setPi(data.getPrivateInfo().toString()); // TO DO...
		if (data.getDayInfo() != null ) vo.setWork(data.getDayInfo().getWork());
		vo.setAttachCnt(data.getAttachCnt());
		vo.setMailType(data.getMailType());
		vo.setFileName(data.getFileName());

		if(data.getAttachInfo() != null)  vo.setAttachname(data.getAttachInfo().stream().map(EmassAttachData::getAttachName).collect(Collectors.toCollection(ArrayList::new)));
		if (data.getOcrInfo() != null) vo.setOcr_attach_cnt(Common.nvl(data.getOcrInfo().getOcrAttachCnt(), "0"));

		//vo.setWebPrefix();
		//vo.setAttachStr();
		//vo.setFileNameStr();
		//vo.setSubjectStr();
		//vo.setBodyStr();


		if (data.getRecvInfo() != null && data.getRecvInfo().getTo() != null) {
			vo.setToList(getRecvInfo(data.getRecvInfo().getTo(), data.getMsgId(), "T"));
		}
		if (data.getRecvInfo() != null && data.getRecvInfo().getCc() != null) {
			vo.setCcList(getRecvInfo(data.getRecvInfo().getCc(), data.getMsgId(), "C"));
		}
		if (data.getRecvInfo() != null && data.getRecvInfo().getBcc() != null) {
			vo.setBccList(getRecvInfo(data.getRecvInfo().getBcc(), data.getMsgId(), "B"));
		}

		List<EmsRecvVO> recvs = new ArrayList<>();
		if (vo.getToList() != null) recvs.addAll(vo.getToList());
		if (vo.getCcList() != null) recvs.addAll(vo.getCcList());
		if (vo.getBccList() != null) recvs.addAll(vo.getBccList());
		vo.setRecvsList(recvs);

		if (data.getAttachInfo() != null && !data.getAttachInfo().isEmpty()) {
			vo.setFiles(getAttachInfo(data));
		}
		if (data.getPrivateInfo() != null && !data.getPrivateInfo().isEmpty()) {
			vo.setPatterns(getPIInfo(data));
		}
		if (data.getMlInfo() != null) {
			vo.setMl_confd_class(Common.nvz(data.getMlInfo().getMlConfdClass()));
			vo.setMl_confd_prob(Common.nvd(data.getMlInfo().getMlConfdProb()));
			vo.setMl_confd_userid(Common.nvl(data.getMlInfo().getMlConfdUserId()));
			vo.setMl_confd_feedback(Common.nvz(data.getMlInfo().getMlConfdFeedBack()));
		}



		vo.setEpmsgType(data.getEpmsgType());
		vo.setKeywordInfo(data.getKeywordInfo());
		return vo;
	}

	/* 사용자 정보 */
	public EmsMessageVO getUserInfoData(EmassMessageData data) {
		if(null == data) {data = new EmassMessageData();} // null err방지
		EmsMessageVO vo = new EmsMessageVO();
		if(data.getUserInfo() != null) {

			data.getUserInfo().setEmail(data.getUserInfo().getEmail());
			data.getUserInfo().setIp(data.getUserInfo().getIp());
			vo.setUser(data.getUserInfo().getId());
			vo.setUserId(data.getUserInfo().getUserId());
			vo.setName(data.getUserInfo().getName());
			vo.setCoCd(data.getUserInfo().getCoCd());
			vo.setIpCocd(data.getUserInfo().getIpCoCd());
			vo.setSubOrgCd(data.getUserInfo().getSuborgCd());
			vo.setBusiCd(data.getUserInfo().getBusiCd());
			vo.setBusiNm(data.getUserInfo().getBusiNm());
			vo.setIpBusicd(data.getUserInfo().getIpBusiCd());
			vo.setIpBusiNm(data.getUserInfo().getIpBusiNm());
			vo.setIpDeptcd(data.getUserInfo().getIpDeptCd());
			vo.setIpDeptNm(data.getUserInfo().getIpDeptNm());
			vo.setIpDeptcd(data.getUserInfo().getDeptCd());
			vo.setJikgubCd(data.getUserInfo().getJikgubCd());
			vo.setInSide(data.getUserInfo().getInside());
			vo.setCeo(data.getUserInfo().getCeo());
			vo.setUserList(getUserInfo(data.getUserInfo(), data.getMsgId(), "U"));

		}
		return vo;
	}

	private List<EmsPiVO> getPIInfo(EmassMessageData data) {
		List<EmsPiVO> result = new ArrayList<>();
		for (EmassPiData pi : data.getPrivateInfo()) {
			EmsPiVO vo = new EmsPiVO();
			vo.setType(pi.getType());
			vo.setAttachName(pi.getAttachName());
			vo.setPiid(pi.getPiId());
			vo.setKwds(String.join(",", pi.getKwds()));
			vo.setTotal(pi.getAmount());
			result.add(vo);
		}
		return result;
	}

	private List<EmsAttachVO> getAttachInfo(EmassMessageData data) {
		List<EmsAttachVO> result = new ArrayList<>();
		for (EmassAttachData attach : data.getAttachInfo()) {
			EmsAttachVO vo = new EmsAttachVO();
			vo.setMsgId(data.getMsgId());
			vo.setAttachId(attach.getAttachId());
			vo.setAttachName(attach.getAttachName());
			vo.setAttachNameExist(attach.getAttachNameExist());
			vo.setAttachPath(attach.getAttachPath());
			vo.setAttachHarPath(null);
			vo.setAttachSize(attach.getAttachSize());
			vo.setAttachExt(attach.getAttachExt());
			vo.setDrm(attach.getDrm());
			vo.setAttachDesc(attach.getAttachDesc());
			vo.setAttachHash(attach.getAttachHash());
			vo.setEncrypted(attach.getEncrypted() ? "Y" : "N");
			vo.setFilterType(attach.getFilterType());
			vo.setFLink(attach.getFLink());
			vo.setFLinkKey(attach.getFLinkKey());
			vo.setAttachTextPath(attach.getAttachTextPath());
			vo.setAttachTextHarPath(null);
			vo.setAttachSpace(attach.getAttachSpace());
			vo.setOcrYn(attach.getIsOcr());

			vo.setConsentFlag(false);
			vo.setSubject(data.getSubject());
			vo.setSvc(data.getSvc());
			vo.setSrcIp(data.getNetworkInfo().getSrcIp());
			vo.setDstIp(data.getNetworkInfo().getDstIp());
			vo.setHost(data.getHttpInfo().getHost());
			vo.setPath(data.getHttpInfo().getPath());
			vo.setUserId(data.getUserInfo().getUserId());
			vo.setName(data.getUserInfo().getName());
			vo.setCtime(Common.yyyyMMddHHmmss.print(data.getCTime()));
			result.add(vo);
		}
		return result;
	}


	private List<EmsRecvVO> getRecvInfo(List<EmassMailPropertiesData> recvs, final String msgId, final String uType) {
		List<EmsRecvVO> result = new ArrayList<>();
		for (EmassMailPropertiesData recv : recvs) {
			EmsRecvVO vo = new EmsRecvVO();
			vo.setMsgId(msgId);
			vo.setRecvId(recv.getId());
			vo.setUType(uType);
			vo.setEMail(recv.getEmail());
			vo.setName(recv.getName());
			vo.setIp(recv.getIp());
			vo.setCoCd(recv.getCoCd());
			vo.setCoNm(recv.getCoNm());
			vo.setSubOrgCd(recv.getSuborgCd());
			vo.setSubOrgNm(recv.getSuborgNm());
			vo.setBusiCd(recv.getBusiCd());
			vo.setBusiNm(recv.getBusiNm());
			vo.setDeptCd(recv.getDeptCd());
			vo.setDeptNm(recv.getDeptNm());
			vo.setJikgubCd(recv.getJikgubCd());
			vo.setJikgubNm(recv.getJikgubNm());
			vo.setInSide(recv.getInside());
			vo.setSabun(recv.getSabun());
			result.add(vo);
		}
		return result;
	}

	private List<EmsRecvVO> getUserInfo(EmassUserData data, final String msgId, final String uType) {
		List<EmsRecvVO> result = new ArrayList<>();
		EmsRecvVO vo = new EmsRecvVO();
		vo.setMsgId(msgId);
		vo.setRecvId(data.getId());
		vo.setUType(uType);
		vo.setName(data.getName());
		vo.setIp(data.getIp());
		vo.setCoCd(data.getCoCd());
		vo.setCoNm(data.getCoNm());
		vo.setSubOrgCd(data.getSuborgCd());
		vo.setSubOrgNm(data.getSuborgNm());
		vo.setBusiCd(data.getBusiCd());
		vo.setBusiNm(data.getBusiNm());
		vo.setDeptCd(data.getDeptCd());
		vo.setDeptNm(data.getDeptNm());
		vo.setJikgubCd(data.getJikgubCd());
		vo.setJikgubNm(data.getJikgubNm());
		vo.setInSide(data.getInside());
		vo.setEMail(data.getEmail());
		vo.setSabun(data.getSabun());


		result.add(vo);
		return result;
	}

}
