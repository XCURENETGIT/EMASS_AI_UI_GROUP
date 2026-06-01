package com.xcurenet.emass.message.service.vo;

import com.xcurenet.emass.message.service.EmassRecvData;
import com.xcurenet.emass.message.service.EmassUserData;
import lombok.Data;
import lombok.ToString;
import org.joda.time.DateTime;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@ToString
@Document(collection = "EMS_MESSAGE")
public class EmassMessageData {

	@Id
	@Field("_id")
	private String msgId;

	@Field("ltime")
	private DateTime lTime;

	@Field("ctime")
	private DateTime cTime;

	@Field("subject")
	private String subject;

	@Field("attached")
	private String attached;

	@Field("attachExistCnt")
	private int attachExistCnt;

	@Field("attachCnt")
	private int attachCnt;

	@Field("size")
	private long size;

	@Field("allOfUs")
	private String allOfUs;

	@Field("directionSvc")
	private String directionSvc;

	@Field("direction")
	private String direction;

	@Field("xrootMtr")
	private String xRootMtr;

	@Field("xmsgKey")
	private String xMsgKey;

	@Field("xparentMtr")
	private String xParentMtr;

	@Field("password")
	private String password;

	@Field("siteCd")
	private String siteCode;

	@Field("siteAttr")
	private String siteAttr;

	@Field("epmsgType")
	private String epmsgType;

	@Field("epHeader")
	private String epHeader;

	@Field("mailType")
	private String mailType;

	@Field("account")
	private String account;

	@Field("usrId")
	private String usrId;

	@Field("usrIp")
	private String usrIp;

	@Field("opinion")
	private String opinion;

	@Field("devWriter")
	private String devWriter;

	@Field("devDecoder")
	private String devDecoder;

	@Field("fileName")
	private String fileName;

	@Field("svc")
	private String svc;

	@Field("body")
	private EmassBodyData bodyInfo;

	@Field("network")
	private EmassNetworkData networkInfo;

	@Field("attach")
	private List<EmassAttachData> attachInfo;

	@Field("kwdInfo")
	private EmassKeywordData keywordInfo;

	@Field("http")
	private EmassHttpData httpInfo;

	@Field("pi")
	private List<EmassPiData> privateInfo;

	@Field("user")
	private EmassUserData userInfo;

	@Field("day")
	private EmassDayData dayInfo;

	@Field("ocr")
	private EmassOcrData ocrInfo;

	@Field("ml")
	private EmassMLData mlInfo;

	@Field("sender")
	private EmassUserData senderInfo;

	@Field("orgSender")
	private EmassUserData orgSender;

	@Field("recv")
	private EmassRecvData recvInfo;


	@Field("checked")
	private List<EmassCheckedData> checkedInfo;
}
