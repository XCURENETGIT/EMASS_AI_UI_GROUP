package com.xcurenet.emass.message.vo.emass.mongo;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.mongo.fields.*;
import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Field;

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
    
    @Field("_id")
    private String	_id; //	메시지ID
    @Field("ltime")
    private Date ltime; //	로깅타임
    @Field("ctime")
    private Date	ctime; //	캡쳐타임
    @Field("subject")
    private String	subject; //	제목
    @Field("attached")
    private String	attached; //	첨부 존재 유무(Y, N)
    @Field("attachExistCnt")
    private int	attachExistCnt; //	첨부 존재 개수
    @Field("attachCnt")
    private int	attachCnt; //	첨부파일 개수
    @Field("//	사이즈")
    private int	size; //	사이즈
    @Field("allOfUs")
    private String	allOfUs; //	수신자 소속여부
    @Field("directionSvc")
    private String	directionSvc; //	Inbound, Outbound (I/O)
    @Field("direction")
    private String	direction; //	Inbound, Outbound (I/O)
    @Field("xrootMtr")
    private String	xrootMtr; //
    @Field("xmsgKey")
    private String	xmsgKey; //
    @Field("xparentMtr")
    private String	xparentMtr; //
    @Field("password")
    private String	password; //	비밀번호
    @Field("siteAttr")
    private String	siteAttr; //
    @Field("siteCode")
    private String	siteCode; //
    @Field("epMsgType")
    private String	epMsgType; //
    @Field("epHeader")
    private String	epHeader; //
    @Field("usrId")
    private String	usrId; //
    @Field("usrIp")
    private String	usrIp; //
    @Field("opinion")
    private String	opinion; //	상신의견(EP)
    @Field("devWriter")
    private String	devWriter; //	Writer 장비 호스트명
    @Field("devDecoder")
    private String	devDecoder; //	디코더 장비 호스트명
    @Field("fileName")
    private String	fileName; //	디코더 처리 파일명
    @Field("svc")
    private String	svc; //	서비스타입

    @Field("body")
    private BodyVo_Mgo body;
     @Field("network")
    private NetworkVo_Mgo  network;
     @Field("attach")
    private List<AttachVo_Mgo>  attach;
     @Field("kwdInfo")
    private KwdVo_Mgo kwdInfo;
     @Field("http")
    private HttpVo_Mgo  http;
     @Field("pi")
    private List<PiVo_Mgo>  pi;
     @Field("user")
    private UserVo_Mgo  user;
     @Field("day")
    private DayVo_Mgo  day;
     @Field("ocr")
    private OcrVo_Mgo ocr;
     @Field("ml")
    private MlVo_Mgo   ml;
     @Field("sender")
    private ComProperties_Mgo sender;
     @Field("recv")
    private RecvVo_Mgo recv;

    private boolean consentFlag;


}
