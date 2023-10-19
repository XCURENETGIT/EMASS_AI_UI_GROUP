package com.xcurenet.emass.message.service;

import java.io.IOException;
import java.util.List;

import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
public class EmsMessageVO {

	@Id
	@Field(name = "_id")
	private String msgId;
	@Field(name = "CID")
	private String cId;
	@Field(name = "SRCIP")
	private String srcIp;
	@Field(name = "SPORT")
	private int sPort;
	@Field(name = "DSTIP")
	private String dstIp;
	@Field(name = "DPORT")
	private int dPort;
	@Field(name = "SVC")
	private String svc;
	@Field(name = "SVCNM")
	private String svcNm;
	@Field(name = "LTIME")
	private String ltime;
	@Field(name = "CTIME")
	private String ctime;
	@Field(name = "SIZE")
	private long size;
	@Field(name = "BODYSIZE")
	private long bodySize;
	@Field(name = "USRIP")
	private String usrIp;
	@Field(name = "USRID")
	private String usrId;
	@Field(name = "PASSWORD")
	private String password;
	@Field(name = "USER")
	private String user;
	@Field(name = "SUBJECT")
	private String subject;
	@Field(name = "XMSGKEY")
	private String xMsgKey;
	@Field(name = "XROOTMTR")
	private String xRootMtr;
	@Field(name = "XPARENTMTR")
	private String xParentMtr;
	@Field(name = "HOST")
	private String host;
	@Field(name = "PATH")
	private String path;
	@Field(name = "QUERY")
	private String query;
	@Field(name = "SENDER")
	private String sender;
	@Field(name = "OPRTIOM")
	private String opinion;
	@Field(name = "DEVWRITER")
	private String devWriter;
	@Field(name = "DEVDECODER")
	private String devDecoder;
	@Field(name = "SITEATTR")
	private String siteAttr;
	@Field(name = "SITECODE")
	private String siteCode;
	@Field(name = "USERID")
	private String userId;
	@Field(name = "NAME")
	private String name;
	@Field(name = "COCD")
	private String coCd;
	@Field(name = "IP_COCD")
	private String ipCocd;
	@Field(name = "SUBORGCD")
	private String subOrgCd;
	@Field(name = "BUSICD")
	private String busiCd;
	@Field(name = "IP_BUSICD")
	private String ipBusicd;
	@Field(name = "IPBUSINM")
	private String ipBusiNm;
	@Field(name = "IP_DEPTCD")
	private String ipDeptcd;
	@Field(name = "IPDEPTNM")
	private String ipDeptNm;
	@Field(name = "DEPTCD")
	private String deptCd;
	@Field(name = "JIKGUBCD")
	private String jikgubCd;
	@Field(name = "ALLOFUS")
	private String allOfUs;
	@Field(name = "ATTACHED")
	private String attached;
	@Field(name = "DIRECTION")
	private String direction;
	@Field(name = "KWD")
	private String kwd;
	@Field(name = "INSIDE")
	private String inSide;
	@Field(name = "PI")
	private String pi;
	@Field(name = "WORK")
	private String work;
	@Field(name = "ATTATCHNT")
	private int attachCnt;
	@Field(name = "CHECKLIST")
	private String checkList;
	@Field(name = "MAILTYPE")
	private String mailType;
	@Field(name = "FILENAME")
	private String fileName;
	@Field(name = "CEO")
	private String ceo;
	private boolean consentFlag;
	@Field(name = "BODYSNIPPET")
	private String body_snippet;
	@Field(name = "ATTACHNAME")
	private List<String> attachname;
	private String ocr_attach_cnt;
	@Field(name = "PROTOCOL")
	private String protocol;
	private String webPrefix;
	private String attachStr;
	private String fileNameStr;
	private String subjectStr;
	private String bodyStr;

	@Field(name = "RECV_INFO")
	private List<EmsRecvVO> recv_info;

	@Field(name = "ATTACH_INFO")
	private List<EmsAttachVO> attachInfo;

	private List<EmsRecvVO> userList;
	private List<EmsRecvVO> senderList;
	private List<EmsRecvVO> recvsList;
	private List<EmsRecvVO> toList;
	private List<EmsRecvVO> ccList;
	private List<EmsRecvVO> bccList;
	
	private List<EmsAttachVO> files;
	private List<EmsPiVO> patterns;

	@Field(name = "PRIVATE_INFO")
	private List<EmsPiVO> privateInfo;


	private int ml_confd_class;
	private int ml_confd_feedback;
	private double ml_confd_prob;
	private String ml_confd_userid;
	
	private String epmsgType;

	public void setSrcIp(String srcIp) {
		if (Common.isNotEmpty(srcIp)) {
			try {
				this.srcIp = new IP(srcIp).toCanonicalAddr();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void setDstIp(String dstIp) {
		if (Common.isNotEmpty(dstIp)) {
			try {
				this.dstIp = new IP(dstIp).toCanonicalAddr();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void setUsrIp(String usrIp) {
		if (Common.isNotEmpty(usrIp)) {
			try {
				this.usrIp = new IP(usrIp).toCanonicalAddr();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void setSvc(String svc) {
		if(Common.isNotEmpty(svc)) {
			this.svcNm = Config.getServiceNm(svc);
			this.svc = svc;
		}
	}
}