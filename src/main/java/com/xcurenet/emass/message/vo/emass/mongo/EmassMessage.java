package com.xcurenet.emass.message.vo.emass.mongo;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.mongo.fields.*;
import lombok.Data;

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

    private String	_id;//	메시지ID
    private Date ltime;	//로깅타임
    private Date	ctime;	//캡쳐타임
    private String	subject;//	제목
    private int	attachExistCnt;	//첨부 존재 개수
    private int	attachCnt;	//첨부파일 개수
    private long	size;//	사이즈
    private String	allofus;//	수신자 소속여부
    private String	directionSvc;//	내/외부 서비스타입
    private String	direction;	//Inbound, Outbound
    private String	xroot_mtr;	//RootMTR (마이싱글)
    private String	xmsgKey;//	x-msgkey
    private String	filePath;//	파일경로
    private String	opinion;//	상신의견(EP)
    private String	xparentMtr;	//ParentMTR (마이싱글)
    private String	password;//	비밀번호
    private String	siteAttr;  //
    private boolean	attached;//	첨부파일 여부
    private String	devWriter;  //
    private String	devDecoder;  //
    private String	siteCd;  //
    private String	xmsgAttr;  //
    private String	epHeader;  //
    private int	tryCount;  //
    private boolean	indexed;  //

    private BodyVo_Mgo body;
    private NetworkVo_Mgo network;
    private List<AttachVo_Mgo> attach;
    private ServiceVo_Mgo service;
    private HttpVo_Mgo http;
    private PiVo_Mgo pi;
    private UserVo_Mgo user;
    private DayVo_Mgo day;
    private OcrVo_Mgo ocr;
    private MlVo_Mgo ml;
    private MailVo_Mgo mail;


}
