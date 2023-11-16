package com.xcurenet.common.util.elasticsearch;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Getter
public class ElasticSearchCommon {

    /* EMASS INDEX */
    public static final String EDC_MESSAGE_INDEX = "ems_edc_message_202311";
    public static final String EDC_MESSAGE_SEARCH_HIST_INDEX = "ems_search_history*";

    /* ELASTIC SEARCH DOCUMENT UPDATE BY QUERY 관련 */
    public static final String READER_CREATE = "ctx._source.reader = new ArrayList()";
    public static final String READER_ADD = "ctx._source.reader.add(params)";





    /*검색타입*/
    public static final String SEARCH_TYPE = "elsSearchType";
    public static final String SEARCH_TYPE_MESSAGE = "message";
    public static final String SEARCH_TYPE_MESSENGER = "messenger";
    public static final String SEARCH_TYPE_COLLECTION = "colletion";
    public static final String SEARCH_TYPE_ANALYSIS = "analysis";
    public static final String SEARCH_TYPE_STATISTIC = "statistic";

    /* 쿼리 관련 */
    public static final String ALL_SEARCH = "*:*";
    public static final String OPEN_PARENTHESES = "(";
    public static final String CLOSE_PARENTHESES = ")";
    public static final String OPEN_BRACKET = "[";
    public static final String CLOSE_BRACKET = "]";
    public static final String BACKSLASH = "\\";
    public static final String QUOTES = "\"";
    public static final String SPACE = " ";
    public static final String COMMA = ",";
    public static final String PERIOD = ".";
    public static final String COLON = ":";
    public static final String SPECIAL_CHAR = "*";
    public static final String OR_QUERY  = "OR";
    public static final String AND_QUERY = "AND";
    public static final String NOT_QUERY = "NOT";

    /* 필드 관련 */
    public static final String _ID = "_id";    //메시지ID
    public static final String LTIME = "ltime";    //로깅타임
    public static final String CTIME = "ctime";    //캡쳐타임
    public static final String SUBJECT = "subject";  //제목
    public static final String ATTACHEXISTCNT = "attachexistcnt";  //첨부 존재 개수
    public static final String ATTACHCNT = "attachcnt";  //첨부파일 개수
    public static final String SIZE = "size";    //사이즈
    public static final String ALLOFUS = "allofus";  //수신자 소속여부
    public static final String DIRECTIONSVC = "directionsvc";  //내/외부 서비스타입
    public static final String DIRECTION = "direction";  //Inbound, Outbound
    public static final String XROOTMTR = "xrootmtr";  //RootMTR (마이싱글)
    public static final String XMSGKEY = "xmsgkey";  //x-msgkey
    public static final String FILEPATH = "filepath";  //파일경로
    public static final String OPINION = "opinion";  //상신의견(EP)
    public static final String XPARENTMTR = "xparentmtr";  //ParentMTR (마이싱글)
    public static final String PASSWORD = "password";  //비밀번호
    public static final String SITEATTR = "siteattr";  //
    public static final String ATTACHED = "attached";  //첨부파일 여부
    public static final String CTIMEYYYY = "ctimeyyyy";  //ctime 연도
    public static final String CTIMEYYYYMM = "ctimeyyyymm";  //ctime 연월
    public static final String CTIMEYYYYMMDD = "ctimeyyyymmdd";  //ctime 연월일
    public static final String CTIMEYYYYMMDDHH = "ctimeyyyymmddhh";  //ctime 연월일시
    public static final String DEVWRITER = "devwriter";  //
    public static final String DEVDECODER = "devdecoder";  //
    public static final String SITECD = "sitecd";  //
    public static final String XMSGATTR = "xmsgattr";  //
    public static final String EPHEADER = "epheader";  //
    public static final String READER = "reader.user_id";  // 읽음 여부 관련

    //body
    public static final String BODY_SIZE = "body.size";     //본문 사이즈
    public static final String BODY_IMGCNT = "body.imgCnt";   //본문 이미지 개수
    public static final String BODY_BODYCHARSET = "body.bodyCharset";   //본문 charset
    public static final String BODY_PATH = "body.path";     //본문 경로
    public static final String BODY_HASH = "body.hash";     //본문 hash
    public static final String BODY_SNIPPET = "body.snippet";   //본문 요약
    public static final String BODY_TEXT = "body.text";     //본문 내용

    //network
    public static final  String NETWORK_SRCIP = "network.srcip";    //	발신자 IP
    public static final  String NETWORK_SRCPORT = "network.srcport";    //	발신자 PORT
    public static final  String NETWORK_DSTIP = "network.dstip";    //	목적지 IP
    public static final  String NETWORK_DSTPORT = "network.dstport";    //	목적지 PORT
    public static final  String NETWORK_PROTOCOL = "network.protocol";    //	프토토콜
    public static final  String NETWORK_CID = "network.cid";    //	세션ID

    //attach
    public static final String  ATTACH_ID = "attach.id";   //	첨부파일 ID
    public static final String  ATTACH_NAME = "attach.name";   //	첨부파일 이름
    public static final String  ATTACH_PATH = "attach.path";   //	첨부파일 경로
    public static final String  ATTACH_SIZE = "attach.size";   //	첨부파일 사이즈
    public static final String  ATTACH_FILTERTYPE = "attach.filtertype";   //	첨부파일 필터타입
    public static final String  ATTACH_EXT = "attach.ext";   //	첨부파일 확장자
    public static final String  ATTACH_SUMMARY = "attach.summary";   //	첨부파일 요약
    public static final String  ATTACH_EXIST = "attach.exist";   //	첨부파일 유무
    public static final String  ATTACH_FLINK = "attach.flink";   //
    public static final String  ATTACH_ENCRYPTED = "attach.encrypted";   //	첨부파일 암호화 여부
    public static final String  ATTACH_NAMEEXIST = "attach.nameexist";   //	첨부파일 이름 유무
    public static final String  ATTACH_FLINKKEY = "attach.flinkkey";   //
    public static final String  ATTACH_HASH = "attach.hash";   //	첨부파일 해시
    public static final String  ATTACH_DESC = "attach.desc";   //
    public static final String  ATTACH_DRM = "attach.drm";   //	첨부파일 DRM 유무
    public static final String  ATTACH_SPACE = "attach.space";   //
    public static final String  ATTACH_TEXT = "attach.text";   //	첨부파일 내용


    // kwd
    public static final String KWD_KWDSATTACH = "kwd.kwdsattach"; //	예약어(첨부내용)
    public static final String KWD_KWDSATTACHNM = "kwd.kwdsattachnm"; //	예약어(첨부파일명)
    public static final String KWD_KWD = "kwd.kwd"; //	예약어 검출 유무
    public static final String KWD_KWDS = "kwd.kwds"; //	전체 검출 예약어
    public static final String KWD_KWDSBODY = "kwd.kwdsbody"; //	예약어(본문)
    public static final String KWD_KWDSSUBJECT = "kwd.kwdssubject"; //	에약어(제목)

    // service
    public static final String  SERVICE_SVC =  "service.svc";     //	서비스타입
    public static final String  SERVICE_SVC1 =  "service.svc1";     //	서비스타입 대분류
    public static final String  SERVICE_SVC12 = "service.svc12";    //서비스타입 대중분류
    public static final String  SERVICE_SVC2 = "service.svc2";      //	서비스타입 중분류
    public static final String  SERVICE_SVC3 = "service.svc3";      //	서비스타입 소분류


    // http
    public static final String  HTTP_PATH = "http.path"; //	URL PATH
    public static final String  HTTP_QUERY = "http.query"; //	URL 쿼리
    public static final String  HTTP_HOST = "http.host"; //	HOST
    public static final String  HTTP_HEADER = "http.header"; //	HEADER

    // pi
    public static final String  PI_ID = "pi.id";
    public static final String  PI_TYPE = "pi.type";
    public static final String  PI_ATTACHNM = "pi.attachnm";
    public static final String  PI_KWDS = "pi.kwds";
    public static final String  PI_AMOUNT = "pi.amount";

     // user
    public static final String USER_ID = "user.id"; //	사용자 ID
    public static final String USER_NAME = "user.name"; // 	사용자 이름
    public static final String USER_IPCOCD = "user.ipcocd"; // 	회사코드(SRC_IP기준)
    public static final String USER_IPCONM = "user.ipconm"; // 	회사명(SRC_IP기준)
    public static final String USER_IPBUSINM = "user.ipbusinm"; // 	사명장명(SRC_IP기준)
    public static final String USER_IPBUSICD = "user.ipbusicd"; // 	사업장코드(SRC_IP기준)
    public static final String USER_COCD = "user.cocd"; // 	회사코드
    public static final String USER_CONM = "user.conm"; // 	회사명
    public static final String USER_BUSICD = "user.busicd"; // 	사업장 코드
    public static final String USER_BUSINM = "user.businm"; // 	사업장명
    public static final String USER_SUBORGCD = "user.suborgcd"; // 	총괄코드
    public static final String USER_SUBORGNM = "user.suborgnm"; // 	총괄명
    public static final String USER_DEPTNM = "user.deptnm"; // 	부서명
    public static final String USER_DEPTCD = "user.deptcd"; // 	부서코드
    public static final String USER_JIKGUBNM = "user.jikgubnm"; // 	직급명
    public static final String USER_JIKGUBCD = "user.jikgubcd"; // 	직급코드
    public static final String USER_CEO = "user.ceo"; //	CEO 여부
    public static final String USER_INSIDE = "user.inside"; // 	내부/외부 구분

    // day
    public static final String DAY_WEEK = "day.week";	//몇주차
    public static final String DAY_WORK = "day.work";	//업무시간 여부
    //ocr
    public static final String OCR_ATTACHCNT = "ocr.attachcnt"; //	ocr 첨부 개수
    public static final String OCR_ATTACH = "ocr.attach"; //	ocr 첨부 개수

    //ml
    public static final String ML_MLCONFDCLASS = "ml.mlconfdclass"; //	AiHR 인덱스 값
    public static final String ML_MLCONFDFEEDBACK = "ml.mlconfdfeedback"; //	AiHR 인덱스 피드백
    public static final String ML_MLCONFDPROB = "ml.mlconfdprob"; //	AiHR 인덱스 결과 확률

    // mail
    public static final String  MAIL_SENDER_ALIAS = "mail.sender.alias"; //	발신자 별칭
    public static final String  MAIL_SENDER_ID = "mail.sender.id"; //	발신자 ID
    public static final String  MAIL_SENDER_NAME = "mail.sender.name"; //	발신자 이름
    public static final String  MAIL_SENDER_EMAIL = "mail.sender.email"; //	발신자 MAIL
    
    public static final String  MAIL_TO_ALIAS = "mail.to.alias"; //	수신자 별칭
    public static final String  MAIL_TO_ID = "mail.to.id"; //	수신자 id
    public static final String  MAIL_TO_NAME = "mail.to.name"; //	수신자 이름
    public static final String  MAIL_TO_EMAIL = "mail.to.email"; //	수신자 이메일

    public static final String  MAIL_CC_ALIAS = "mail.cc.alias"; // 	참조 별칭
    public static final String  MAIL_CC_ID = "mail.cc.id";	 // 참조 id
    public static final String  MAIL_CC_NAME = "mail.cc.name";	 // 참조 이름
    public static final String  MAIL_CC_EMAIL = "mail.cc.email"; // 참조 이메일

    public static final String  MAIL_BCC_ALIAS = "mail.bcc.alias";	 //숨긴참조 별칭
    public static final String  MAIL_BCC_ID = "mail.bcc.id"; //	숨긴참조 id
    public static final String  MAIL_BCC_NAME = "mail.bcc.name"; //	숨긴참조 이름
    public static final String  MAIL_BCC_EMAIL = "mail.bcc.email";	 //숨긴참조 이메일


    /* 기타 */
    public static final String[] RECEIVERS = {"mail.to.name","mail.cc.name","mail.bcc.name","network.dstip"}; // 수신자들
    public static final String[] SENDER = {"mail.sender.name", "network.srcip"}; //발신자
    public static final String TIME_FORMAT = "common.time.";


    /* 임시*/
    public static final String PI_PREFIX = "pi_";
    public static final String PI_TOTAL = "pi_total";
    public static final String PI = "pi.codes.code";

    public static final String CTIME_HH = "ctime_hh"; //시간별
    public static final String CTIME_YYYYMM = "ctime_yyyymm"; //월별
    public static final String CTIME_YYYYMMDD = "ctime_yyyymmdd"; //일자별
    public static final String BUSINM = "businm"; //사업장별
    public static final String CONM = "conm"; //회사별
    public static final String DEPTNM = "deptnm"; //부서별
    public static final String DIRECTION_SVC = "direction_svc"; // 수/발신별
    public static final String JIKGUBNM = "jikgubnm"; // 직급별


    public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");

    //body

    public static String[] SEARCH_FIELD = new String[]{
            "ltime"	,"ctime", "ctimeYYYY","ctimeYYYYMM",
            "ctimeYYYYMMDD","ctimeYYYYMMDDHH", "ctimeHH",
            "subject","attachExistCnt", "attachCnt",
            "size", "allOfUs", "directionSvc"	, "direction",
            "xrootMtr","xmsgKey","opinion","xparentMtr",
            "password","siteAttr","siteCode","attached",
            "epmsgType","epHeader","piTotal",
            "body","network","attach","kwdInfo","service","http","pi",
            "user","day","ocr","ml","mail"
    };

    /* 화면에서의 (검색 영역) 값 엘라스틱 서치 필드로 치환 */
    public static Map<String,String> XFIELD = new HashMap<>(){{
        put("ctime_hh", "ctime");
        put("ctime_yyyymmdd", "ctime");
        put("ctime_yyyymm", "ctime");
        put("businm", "user.businm");
        put("conm", "user.conm");
        put("deptnm", "user.deptnm");
        put("direction_svc", "direction_svc");
        put("jikgubnm", "user.jikgubnm");
    }};


    /* String -> LocalDateTime */
    public static LocalDateTime stringToDate(String dateValue){
        LocalDateTime date = null;
           try {
               date = LocalDateTime.parse(dateValue, java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
           }catch (DateTimeParseException e){
               e.printStackTrace();
           }
        return date;
    }

    /* LocalDateTime -> String */
    public static String dateToString(LocalDateTime localDateTime){
        String str = null;
        try {
            str = localDateTime.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        }catch (DateTimeParseException e){
            e.printStackTrace();
        }
        return str;
    }

    /* Date -> String */
    public static String dateToString(Date date){
        String str = null;
        try {
            str = DATE_FORMAT.format(date);
        }catch (DateTimeParseException e){
            e.printStackTrace();
        }
        return str;
    }



}
