package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.els.fields.*;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.Date;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable

/***
 *  elastic search Db -> App server 받아오기 위한 Vo
 *  Emass
 */
public class Emass {

   private String   _id;                    // doc Id (임시로사용중)
   private String	msgid;	//엘라스틱서치 아이디
   private Date ltime;	//로깅타임
   private Date	    ctime;	//캡쳐타임
   private String	ctime_yyyy;	//ctime 연도
   private String	ctime_yyyymm;//	ctime 연월
   private String	ctime_yyyymmdd;	//ctime 연월일
   private String	ctime_yyyymmddhh;//	ctime 연월일시
   private String	ctime_hh;//	ctime 시간
   private String	subject;//	제목
   private int	    attachexistcnt;	//첨부 존재 개수
   private int	    attachcnt;	//첨부파일 개수
   private long	    size;//	전체사이즈
   private String	allofus;//	수신자 소속여부
   private String	direction_svc;	//내/외부 서비스타입
   private String	direction;	//Inbound, Outbound
   private String	xrootmtr;//	원본의 답신/전달 메일에 부여되는 원본 ID
   private String	xmsgkey;//	메시지 키값
   private String	opinion;//	상신의견(EP)
   private String	xparentmtr;	//ParentMTR (마이싱글)
   private String	password;//	비밀번호
   private String	siteattr;//	DIP 속성이 있을 경우 DIP로 사업장 맵핑
   private String	sitecode;//	사업장 코드 매핑용도
   private boolean	attached;//	첨부파일 여부
   private String	xmsgattr;//	삼성 그룹망 헤더 정보 파싱 필드
   private String	epmsg_type;	//녹스(대외비 구분값)
   private String	epheader;//	서비스타입 유추를 위한 필드
   private long	    pi_total;//	패턴 탐지 전체 건수

   private BodyVo_Els body;        //본문
   private NetworkVo_Els network;  //네트워크
   private List<AttachVo_Els> attach;  //첨부정보
   private KwdVo_Els kwdInfo;   // 예약어 관련
   private ServiceVo_Els service;  // 서비스 관련
   private HttpVo_Els http;      //http
   private PiVo_Els pi;          // 패턴
   private UserVo_Els user;     // 사용자
   private DayVo_Els day;       // 업무시간 관련
   private OcrVo_Els ocr;       //
   private MlVo_Els ml;     //ml
   private MailVo_Els mail; // 메일

}
