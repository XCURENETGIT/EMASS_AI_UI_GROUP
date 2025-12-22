package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.message.service.vo.EmassKeywordData;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class EmsMessageVO {
	private String msgId;
	private String cId;
	private String srcIp;
	private int sPort;
	private String dstIp;
	private int dPort;
	private String svc;
	private String svcNm;
	private String ltime;
	private String ctime;
	private long size;
	private long bodySize;
	private String bodyHash;
	private String bodyCharset;
	private String bodyPath;
	private String bodyTextPath;
	private String bodyType;
	private String bodyText;
	private int bodyImgCnt;


	private String usrIp;
	private String usrId;
	private String password;
	private String user;
	private String subject;
	private String xMsgKey;
	private String xRootMtr;
	private String xParentMtr;
	private String host;
	private String path;
	private String query;
	private String sender;
	private String opinion;
	private String devWriter;
	private String devDecoder;
	private String siteAttr;
	private String siteCode;
	private String userId;
	private String userkey;
	private String name;
	private String coCd;
	private String ipCocd;
	private String subOrgCd;
	private String busiCd;
	private String busiNm;
	private String ipBusicd;
	private String ipBusiNm;
	private String ipDeptcd;
	private String ipDeptNm;
	private String deptCd;
	private String jikgubCd;
	private String allOfUs;
	private String attached;
	private String direction;
	private String kwd;
	private String inSide;
	private String pi;
	private String work;
	private int attachCnt;
	private String checkList;
	private String mailType;
	private String fileName;
	private String ceo;
	private boolean consentFlag;
	private String body_snippet;
	private List<String> attachname = new ArrayList<>();
	private String ocr_attach_cnt;
	private String protocol;
	private String webPrefix;
	private String attachStr;
	private String fileNameStr;
	private String subjectStr;
	private String bodyStr;
	private List<EmsRecvVO> userList = new ArrayList<>();
	private List<EmsRecvVO> senderList = new ArrayList<>();
	private List<EmsRecvVO> recvsList = new ArrayList<>();
	private List<EmsRecvVO> toList = new ArrayList<>();
	private List<EmsRecvVO> ccList = new ArrayList<>();
	private List<EmsRecvVO> bccList = new ArrayList<>();
	private List<EmsRecvVO> orgSenderList = new ArrayList<>();

	private List<EmsAttachVO> files = new ArrayList<>();
	private List<EmsPiVO> patterns = new ArrayList<>();
	private int ml_confd_class;
	private int ml_confd_feedback;
	private double ml_confd_prob;
	private String ml_confd_userid;
	private String epmsgType;
	private EmassKeywordData keywordInfo;
	private String header;

	
	/*오리지널 제목 존재 여부*/
	private boolean subjectIsEmpty;


	public void setSvc(String svc) {
		if (Common.isNotEmpty(svc)) {
			this.svcNm = Config.getServiceNm(svc);
			this.svc = svc;
		}
	}

	public void setdPort(int dPort) {
		this.dPort = dPort;
		if(Common.isNotEquals(this.webPrefix, "https://") && dPort == 443) this.webPrefix = "https://";
	}
	public void setProtocol(String protocol) {
		this.protocol = protocol;
		if(Common.isNotEquals(this.webPrefix, "https://")) {
			if(Common.isEquals(protocol, "h2")) this.webPrefix = "https://";
			else this.webPrefix = "http://";
		}
	}

	public void setWebPrefix(String webPrefix) {
		this.webPrefix = webPrefix;
	}
	public String getWebPrefix() {
		return Common.isEmpty(this.webPrefix) ? "http://" : this.webPrefix;
	}

	@JsonIgnore
	public List<EmsRecvVO> getFullUsers() {
		List<EmsRecvVO> result = new ArrayList<>();
		result.addAll(userList);
		result.addAll(senderList);
		result.addAll(toList);
		result.addAll(ccList);
		result.addAll(bccList);
		result.addAll(orgSenderList);
		return result;
	}


}