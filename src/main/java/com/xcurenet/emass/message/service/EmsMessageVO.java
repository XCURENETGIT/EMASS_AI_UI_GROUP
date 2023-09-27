package com.xcurenet.emass.message.service;

import java.io.IOException;
import java.util.List;

import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;

import lombok.Data;

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
	private String name;
	private String coCd;
	private String ipCocd;
	private String subOrgCd;
	private String busiCd;
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
	private List<String> attachname;
	private String ocr_attach_cnt;
	private String protocol;
	private String webPrefix;
	
	private String attachStr;
	private String fileNameStr;
	private String subjectStr;
	private String bodyStr;
	
	private List<EmsRecvVO> userList;
	private List<EmsRecvVO> senderList;
	private List<EmsRecvVO> recvsList;
	private List<EmsRecvVO> toList;
	private List<EmsRecvVO> ccList;
	private List<EmsRecvVO> bccList;
	
	private List<EmsAttachVO> files;
	private List<EmsPiVO> patterns;
	
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