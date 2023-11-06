package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.els.fields.*;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable

/***
 *  elastic search Db -> App server 받아오기 위한 Vo
 *  Emass
 */
public class Emass {

   private String  _id;                    // Id
   private String  ltime;                  //로깅타임
   private String  ctime;                  //캡쳐타임
   private String  subject;                //제목
   private int     attachExistCnt;         //첨부 존재 개수
   private int     attachCnt;              //첨부파일 개수
   private long    size;                   // Document 사이즈
   private String  allofus;                //수신자 소속여부
   private String  directionSvc;           //내/외부 서비스타입
   private String  direction;              //Inbound, Outbound
   private String  xrootMtr;               //RootMTR (마이싱글)
   private String  xmsgKey;                //x-msgkey
   private String  filePath;               //파일경로
   private String  opinion;                //상신의견(EP)
   private String  xparentMtr;             //ParentMTR (마이싱글)
   private String  password;               //비밀번호
   private String  siteAttr;               //
   private boolean attached;               //첨부파일 여부
   private String  ctimeYYYY;              //ctime 연도
   private String  ctimeYYYYmm;            //ctime 연월
   private String  ctimeYYYYmmDD;          //ctime 연월일
   private String  ctimeYYYYmmDDhh;        //ctime 연월일시
   private String  devWriter;              //
   private String  devDecoder;             //
   private String  siteCd;                 //
   private String  xmsgAttr;               //
   private String  epHeader;               //

   private BodyVo_Els body;
   private NetworkVo_Els network;
   private List<AttachVo_Els> attach;
   private KwdVo_Els kwd;
   private ServiceVo_Els service;
   private HttpVo_Els http;
   private PiVo_Els pi;
   private UserVo_Els user;
   private DayVo_Els day;
   private OcrVo_Els ocr;
   private MlVo_Els ml;
   private MailVo_Els mail;

}
