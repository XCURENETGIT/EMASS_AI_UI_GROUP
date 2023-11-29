package com.xcurenet.emass.message.vo.emass.mongo;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.mongo.fields.*;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;
import java.util.Date;
import java.util.List;


@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
/***
 *  Mongo Db -> App server 받아오기 위한 Vo
 *  Emass
 */
public class EmassMessage {
    
    @Value("_id")
    private String	_id; //	메시지ID
    @Value("ltime")
    private Date ltime; //	로깅타임
    @Value("ctime")
    private Date	ctime; //	캡쳐타임
    @Value("subject")
    private String	subject; //	제목
    @Value("attached")
    private String	attached; //	첨부 존재 유무(Y, N)
    @Value("attachExistCnt")
    private int	attachExistCnt; //	첨부 존재 개수
    @Value("attachCnt")
    private int	attachCnt; //	첨부파일 개수
    @Value("//	사이즈")
    private int	size; //	사이즈
    @Value("allOfUs")
    private String	allOfUs; //	수신자 소속여부
    @Value("directionSvc")
    private String	directionSvc; //	Inbound, Outbound (I/O)
    @Value("direction")
    private String	direction; //	Inbound, Outbound (I/O)
    @Value("xrootMtr")
    private String	xrootMtr; //
    @Value("xmsgKey")
    private String	xmsgKey; //
    @Value("xparentMtr")
    private String	xparentMtr; //
    @Value("password")
    private String	password; //	비밀번호
    @Value("siteAttr")
    private String	siteAttr; //
    @Value("siteCode")
    private String	siteCode; //
    @Value("epMsgType")
    private String	epMsgType; //
    @Value("epHeader")
    private String	epHeader; //
    @Value("usrId")
    private String	usrId; //
    @Value("usrIp")
    private String	usrIp; //
    @Value("opinion")
    private String	opinion; //	상신의견(EP)
    @Value("devWriter")
    private String	devWriter; //	Writer 장비 호스트명
    @Value("devDecoder")
    private String	devDecoder; //	디코더 장비 호스트명
    @Value("fileName")
    private String	fileName; //	디코더 처리 파일명
    @Value("svc")
    private String	svc; //	서비스타입

    @Value("body")
    private BodyVo_Mgo body;
     @Value("network")
    private NetworkVo_Mgo  network;
     @Value("attach")
    private List<AttachVo_Mgo>  attach;
     @Value("kwdInfo")
    private KwdVo_Mgo kwdInfo;
     @Value("http")
    private HttpVo_Mgo  http;
     @Value("pi")
    private List<PiVo_Mgo>  pi;
     @Value("user")
    private UserVo_Mgo  user;
     @Value("day")
    private DayVo_Mgo  day;
     @Value("ocr")
    private OcrVo_Mgo ocr;
     @Value("ml")
    private MlVo_Mgo   ml;
     @Value("sender")
    private ComProperties_Mgo sender;
     @Value("recv")
    private RecvVo_Mgo recv;

    private boolean consentFlag;


}
