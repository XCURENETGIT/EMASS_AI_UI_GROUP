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

    private String	_id; //	메시지ID
    private Date ltime; //	로깅타임
    private Date	ctime; //	캡쳐타임
    private String	subject; //	제목
    private int	attach_exist_cnt; //	첨부 존재 개수
    private int	attach_cnt; //	첨부파일 개수
    private long	size; //	사이즈
    private String	allofus; //	수신자 소속여부
    private String	direction_svc; //
    private String	direction; //
    private String	xroot_mtr; //
    private String	xmsg_key; //
    private String	file_path; //	파일경로
    private String	opinion; //
    private String	xparent_mtr; //
    private String	password; //	비밀번호
    private String	site_attr; //
    private boolean	attached; //	첨부파일 여부
    private String	dev_writer; //
    private String	dev_decoder; //
    private String	site_cd; //
    private String	xmsg_attr; //
    private String	ep_header; //
    private int	try_count; //
    private boolean	indexed; //

    private BodyVo_Mgo body;
    private NetworkVo_Mgo network;
    private List<AttachVo_Mgo> attach;
    private KwdVo_Mgo kwd;
    private ServiceVo_Mgo service;
    private HttpVo_Mgo http;
    private PiVo_Mgo pi;
    private UserVo_Mgo user;
    private DayVo_Mgo day;
    private OcrVo_Mgo ocr;
    private MlVo_Mgo ml;
    private MailVo_Mgo mail;


    boolean ConsentFlag; // 동의서 관련
}
