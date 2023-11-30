package com.xcurenet.emass.message.vo.emass.mongo;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.mongo.fields.ComProperties_Mgo;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
/***
 *   App server -> client 표시위한 재가공 Vo
 */
public class EmassMessageResponse {

  private  String	_id; //	메시지ID
  private  String	ltime; //	로깅타임
  private  String	ctime; //	캡쳐타임
  private  String	subject; //	제목
  private  String	attached; //	첨부 존재 유무(Y, N)
  private  int	attachExistCnt; //	첨부 존재 개수
  private  int	attachCnt; //	첨부파일 개수
  private  int	size; //	사이즈
  private  String	allOfUs; //	수신자 소속여부
  private  String	directionSvc; //	서비스타입으로 방향성 구분 (I, O)
  private  String	direction; //	Inbound, Outbound (I, O)
  private  String	xrootMtr; //	원본의 답신/전달 메일에 부여되는 원본 ID
  private  String	xmsgKey; //
  private  String	xparentMtr; //
  private  String	password; //	비밀번호
  private  String	siteAttr; //
  private  String	siteCode; //
  private  String	epMsgType; //
  private  String	epHeader; //
  private  String	usrId; //
  private  String	usrIp; //
  private  String	opinion; //	상신의견(EP)
  private  String	devWriter; //	Writer 장비 호스트명
  private  String	devDecoder; //	디코더 장비 호스트명
  private  String	fileName; //	디코더 처리 파일명
  private  String	svc; //	서비스타입

  private int	body_size; //	본문 사이즈
  private int	body_imgCnt; //	본문 이미지 개수
  private String	body_bodyCharset; //	본문 charset
  private String	body_path; //	본문 경로
  private String	body_textPath; //	본문 텍스트 경로
  private String	body_hash; //	본문 hash

  private String	network_srcIp; //	발신자 IP
  private int	network_srcPort; //	발신자 PORT
  private String	network_dstIp; //	목적지 IP
  private int	network_dstPort; //	목적지 PORT
  private String	network_protocol; //	프토토콜
  private String	network_cid; //	세션ID

  private String	http_path;	//URL PATH
  private String	http_query;	//URL 쿼리
  private String	http_host;	//HOST
  private String	http_header;	//HEADER

  private String	user_id; //	사용자 ID (기존 solr user 필드 값)
  private String	user_userId; //	사용자 ID (인사연동 기준 아이디 기존 solr userid)
  private String	user_name; //	사용자 이름
  private String	user_ipCoCd; //	회사코드(SRC_IP기준)
  private String	user_ipCoNm; //	회사명(SRC_IP기준)
  private String	user_ipBusiCd; //	사업장코드(SRC_IP기준)
  private String	user_ipBusiNm; //	사명장명(SRC_IP기준)
  private String	user_ipDeptCd; //	부서코드 IP기준
  private String	user_ipDeptNm; //	부서명 IP기준
  private String	user_coCd; //	회사코드
  private String	user_coNm; //	회사명
  private String	user_busiCd; //	사업장 코드
  private String	user_busiNm; //	사업장명
  private String	user_suborgCd; //	총괄코드
  private String	user_suborgNm; //	총괄명
  private String	user_deptCd; //	부서코드
  private String	user_deptNm; //	부서명
  private String	user_jikgubCd; //	직급코드
  private String	user_jikgubNm; //	직급명
  private String	user_ceo; //	CEO 여부 (Y/N)
  private String	user_inside; //	내부/외부 구분 (I/O)

  private ComProperties_Mgo sender;  // sender
  private List<ComProperties_Mgo> toList; //수신리스트
  private List<ComProperties_Mgo> ccList; //참조리스트
  private List<ComProperties_Mgo> bccList; //비밀참조리스트


  private boolean consentFlag;


}
