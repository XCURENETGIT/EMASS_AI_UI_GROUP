package com.xcurenet.emass.message.vo.emass.els;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.els.fields.MailProperties_Els;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
/***
 *   App server -> client 표시위한 재가공 Vo
 */
public class EmassResponse {

    private String  _id;                    // ID (doc id)
    private String  msgid;                  // msgid
    private String  ltime;                  //로깅타임
    private String  ctime;                  //캡쳐타임
    private String  subject;                //제목
    private int     attachExistCnt;         //첨부 존재 개수
    private int     attachCnt;              //첨부파일 개수
    private long    size;                   // Document 사이즈
    private String  size_Str;                // Document 사이즈 Str
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
    private String  epmsg_type;                         //녹스(대외비 구분값)
    private String  epHeader;               //

    /* ------ body -------*/
    private long	body_size;  //	본문 사이즈
    private String	body_sizeStr;  //	본문 사이즈 Str
    private long	body_imgCnt;  //	본문 이미지 개수
    private String	body_bodyCharset;  //	본문 charset
    private String	body_path;  //	본문 경로
    private String	body_hash;  //	본문 hash
    private String	body_snippet;  //	본문 요약
    private String	body_text;  //	본문 내용


    /* ------ netWork -------*/
    private String	 network_srcIp; //	발신자 IP
    private int	 network_srcPort; //	발신자 PORT
    private String	 network_dstIp; //	목적지 IP
    private int	 network_dstPort; //	목적지 PORT
    private String	 network_protocol; //	프토토콜
    private String	 network_cId; //	세션ID

    /* ------ attach -------*/
    private String	attach_id;	   //첨부파일 ID
    private String	attach_name;   //	첨부파일 이름
    private String	attach_path;   //	첨부파일 경로
    private long	attach_size;   //	첨부파일 사이즈
    private String	attach_filterType;	   //첨부파일 필터타입
    private String	attach_ext;   //	첨부파일 확장자
    private String	attach_summary;   //	첨부파일 요약
    private boolean	attach_exist;   //	첨부파일 유무
    private String	attach_flink;    //
    private boolean	attach_encrypted;   //	첨부파일 암호화 여부
    private boolean	attach_nameExist;   //	첨부파일 이름 유무
    private String	attach_flinkKey;    //
    private String	attach_hash;   //	첨부파일 해시
    private String	attach_desc;    //
    private boolean	attach_drm;   //	첨바파일 DRM 유무
    private String	attach_space;    //
    private String	attach_text;   //	본문내용

    private String	attach_sizeStr;   //	첨부파일 사이즈 Str

    /* ------ kwd -------*/
    private List	kwd_kwdsAttach; //	예약어(첨부내용)
    private List	kwd_kwdsAttachNm; 	//예약어(첨부파일명)
    private boolean	kwd_kwd; //	예약어 검출 유무
    private List	kwd_kwds; 	//전체 검출 예약어
    private List	kwd_kwdsBody; 	//예약어(본문)
    private List	kwd_kwdsSubject; //	에약어(제목)

    /* ------ service -------*/
    private String	service_svc;  //서비스타입
    private String	service_svc1;  //서비스타입 대분류
    private String	service_svc12;  //서비스타입 대중분류
    private String	service_svc2;  //서비스타입 중분류
    private String	service_svc3;  //서비스타입 소분류

    private String	service_svc_Nm;  //서비스명


    /* ------ http -------*/
    private String	http_path;  //URL PATH
    private String	http_query;  //URL 쿼리
    private String	http_host;  //HOST
    private String	http_header;  //HEADER


    /* ------ pi -------*/
//    private String	pi_id; //
//    private String	pi_type; //
//    private String	pi_attachNm; //
      private List pi_kwds; //
      private String pi; //
//    private int	pi_amount; //


    /* ------ user -------*/
    private String	user_id;	//사용자 ID
    private String	user_name;//	사용자 이름
    private String	user_ipCoCd;	//회사코드(SRC_IP기준)
    private String	user_ipCoNm;	//회사명(SRC_IP기준)
    private String	user_ipBusiNm;//	사명장명(SRC_IP기준)
    private String	user_ipBusiCd;//	사업장코드(SRC_IP기준)
    private String	user_coCd;//	회사코드
    private String	user_coNm;//	회사명
    private String	user_busiCd;	//사업장 코드
    private String	user_busiNm;	//사업장명
    private String	user_suborgCd;//	총괄코드
    private String	user_suborgNm;//	총괄명
    private String	user_deptNm;	//부서명
    private String	user_deptCd;	//부서코드
    private String	user_jikgubNm;//	직급명
    private String	user_jikgubCd;//	직급코드
    private String	user_ceo;  //	CEO 여부
    private boolean	user_inside;	//내부/외부 구분

   /* ------ day -------*/
    private int	day_week;	//몇주차
    private boolean	day_work;	//업무시간 여부

    /* ------ ocr -------*/
    private int	ocr_attachCnt;	//첨부 개수
    private String	ocr_attach;	//첨부 개수

    /* ------ ml -------*/
    private String	ml_mlConfdClass;	 //인덱스 값
    private String	ml_mlConfdFeedback;	 //인덱스 피드백
    private float	ml_mlConfdProb;	 //인덱스 결과 확률

    /* ------ sender mail -------*/
    private String	sender_mail_name; //	발신자 이름
    private String	sender_mail_email; //	발신자 MAIL

    private List<MailProperties_Els> to;
    private List<MailProperties_Els> cc;
    private List<MailProperties_Els> bcc;
    private List<String> recvs;


}
