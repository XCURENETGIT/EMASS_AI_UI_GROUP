package com.xcurenet.common.util.elasticsearch;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.text.ParseException;
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
    public static final String EDC_MESSAGE_INDEX = "ems_edc_message_202312";   //ems_edc_message
    public static final String EDC_MESSAGE_SEARCH_HIST_INDEX = "ems_search_history*";

    /* ELASTIC SEARCH DOCUMENT UPDATE BY QUERY 관련 */
    public static final String READER_CREATE = "ctx._source.reader = new ArrayList()";
    public static final String READER_ADD = "ctx._source.reader.add(params)";


    /*검색타입*/
    public static final String SEARCH_TYPE = "elsSearchType";
    public static final String SEARCH_TYPE_MESSAGE = "message";
    public static final String SEARCH_TYPE_MESSENGER = "messenger";
    public static final String SEARCH_TYPE_MESSENGER_GROUP = "messenger_group";
    public static final String SEARCH_TYPE_MESSENGER_TOTAL = "messenger_total";
    public static final String SEARCH_TYPE_MESSENGER_DETAIL = "messenger_detail";
    public static final String SEARCH_TYPE_MESSENGER_FILE = "messenger_file";
    public static final String SEARCH_TYPE_COLLECTION = "colletion";
    public static final String SEARCH_TYPE_ANALYSIS = "analysis";
    public static final String SEARCH_TYPE_STATISTIC = "statistic";
    public static final String SEARCH_TYPE_ANALYSIS_DETAIL = "analysis_detail";

    /* 쿼리 관련 */
    public static final String ALL_SEARCH = "*:*";
    public static final String NONE_SEARCH = "NOT *:*";
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
    public static final String OR_QUERY  = " ";
    public static final String AND_QUERY = "+";
    public static final String NOT_QUERY = "-";

    /* 필드 관련 */
    public static final String MSGID = "msgid";    //메시지ID
    public static final String LTIME = "ltime";    //로깅타임
    public static final String CTIME = "ctime";    //캡쳐타임
    public static final String SUBJECT = "subject";  //제목
    public static final String ATTACHEXISTCNT = "attachexistcnt";  //첨부 존재 개수
    public static final String ATTACHCNT = "attachCnt";  //첨부파일 개수
    public static final String SIZE = "size";    //사이즈
    public static final String ALLOFUS = "allofus";  //수신자 소속여부
    public static final String DIRECTIONSVC = "directionSvc";  //내/외부 서비스타입
    public static final String DIRECTION = "direction";  //Inbound, Outbound
    public static final String XROOTMTR = "xrootMtr";  //RootMTR (마이싱글)
    public static final String XMSGKEY = "xmsgkey";  //x-msgkey
    public static final String FILEPATH = "filepath";  //파일경로
    public static final String OPINION = "opinion";  //상신의견(EP)
    public static final String XPARENTMTR = "xparentmtr";  //ParentMTR (마이싱글)
    public static final String PASSWORD = "password";  //비밀번호
    public static final String SITEATTR = "siteattr";  //
    public static final String ATTACHED = "attached";  //첨부파일 여부
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


    /* 임시*/
    public static final String PI_PREFIX = "pi_";
    public static final String PI_TOTAL = "pi_total";
    public static final String PI = "pi";
    public static final String PIID = "piID";
    public static final String PISN = "piSN";
    public static final String PICN = "piCN";
    public static final String PIFN = "piFN";
    public static final String PIEC = "piEC";
    public static final String PIEF = "piEF";
    public static final String PIPN = "piPN";
    public static final String PIDN = "piDN";



    public static final String  PI_ID = "pi.id";
    public static final String  PI_TYPE = "pi.type";
    public static final String  PI_ATTACHNM = "pi.attachnm";
    public static final String  PI_KWDS = "pi.kwds";
    public static final String  PI_AMOUNT = "pi.amount";

     // user
    public static final String USER_ID = "user.id"; //	사용자 ID
    public static final String USER_USERID = "user.userId"; //	사용자 아이디(인사연동)
    public static final String USER_ID_KEYWORD = "user.id.keyword"; //	사용자 ID
    public static final String USER_NAME = "user.name"; // 	사용자 이름
    public static final String USER_IPCOCD = "user.ipCoCd"; // 	회사코드(SRC_IP기준)
    public static final String USER_IPCONM = "user.ipCoNm"; // 	회사명(SRC_IP기준)
    public static final String USER_IPBUSINM = "user.ipBusiNm"; // 	사명장명(SRC_IP기준)
    public static final String USER_IPBUSICD = "user.ipBusiCd"; // 	사업장코드(SRC_IP기준)
    public static final String USER_COCD = "user.coCd"; // 	회사코드
    public static final String USER_CONM = "user.coNm"; // 	회사명
    public static final String USER_BUSICD = "user.busiCd"; // 	사업장 코드
    public static final String USER_BUSINM = "user.busiNm"; // 	사업장명
    public static final String USER_SUBORGCD = "user.suborgCd"; // 	총괄코드
    public static final String USER_SUBORGNM = "user.suborgNm"; // 	총괄명
    public static final String USER_DEPTNM = "user.deptNm"; // 	부서명
    public static final String USER_DEPTCD = "user.deptCd"; // 	부서코드
    public static final String USER_JIKGUBNM = "user.jikgubNm"; // 	직급명
    public static final String USER_JIKGUBCD = "user.jikgubCd"; // 	직급코드
    public static final String USER_CEO = "user.ceo"; //	CEO 여부
    public static final String USER_INSIDE = "user.inside"; // 	내부/외부 구분

    // day
    public static final String DAY_WEEK = "day.week";	//몇주차
    public static final String DAY_WORK = "day.work";	//업무시간 여부

    //ocr
    public static final String OCR_ATTACHCNT = "ocr.attachCnt"; //	ocr 첨부 개수
    public static final String OCR_ATTACH = "ocr.attach"; //	ocr 첨부 개수

    //ml
    public static final String ML_MLCONFDCLASS = "ml.mlconfdclass"; //	AiHR 인덱스 값
    public static final String ML_MLCONFDFEEDBACK = "ml.mlconfdfeedback"; //	AiHR 인덱스 피드백
    public static final String ML_MLCONFDPROB = "ml.mlconfdprob"; //	AiHR 인덱스 결과 확률


    // 발신자
    private static final String SENDER_ALIAS = "sender.alias";   //		발신자 별칭
    private static final String SENDER_ID = "sender.id";   //		발신자 ID
    private static final String SENDER_USERID = "sender.userId";   //		발신자 아이디(인사연동)
    private static final String SENDER_NAME = "sender.name";   //		발신자 이름(인사연동)
    private static final String SENDER_EMAIL = "sender.email";   //		발신자 이메일 (인사연동)
    private static final String SENDER_IP = "sender.ip";   //		발신자 아이피
    private static final String SENDER_COCD = "sender.coCd";   //		회사코드
    private static final String SENDER_CONM = "sender.coNm";   //		회사명
    private static final String SENDER_BUSICD = "sender.busiCd";   //		사업장 코드
    private static final String SENDER_BUSINM = "sender.busiNm";   //		사업장명
    private static final String SENDER_SUBORGCD = "sender.suborgCd";   //		총괄코드
    private static final String SENDER_SUBORGNM = "sender.suborgNm";   //		총괄명
    private static final String SENDER_DEPTCD = "sender.deptCd";   //		부서코드
    private static final String SENDER_DEPTNM = "sender.deptNm";   //		부서명
    private static final String SENDER_JIKGUBCD = "sender.jikgubCd";   //		직급코드
    private static final String SENDER_JIKGUBNM = "sender.jikgubNm";   //		직급명
    private static final String SENDER_CEO = "sender.ceo";   //		CEO 여부
    private static final String SENDER_INSIDE = "sender.inside";   //		내부/외부 구분

    /* 수신자 */
    private static final String RECV_TO_ALIAS = "recv.to.alias";    //		수신자 별칭
    private static final String RECV_TO_ID = "recv.to.id"; 	       //	수신자 id
    private static final String RECV_TO_USERID = "recv.to.userId";  //		수신자 아이디 (인사연동)
    private static final String RECV_TO_NAME = "recv.to.name"; 	   //	수신자 이름 (인사연동)
    private static final String RECV_TO_EMAIL = "recv.to.email";    //		수신자 이메일 (인사연동)
    private static final String RECV_TO_IP = "recv.to.ip" ;		   // 수신자 아이피
    private static final String RECV_TO_COCD = "recv.to.coCd"; 	     //	회사코드
    private static final String RECV_TO_CONM = "recv.to.coNm"; 	    //	회사명
    private static final String RECV_TO_BUSICD = "recv.to.busiCd";  // 	사업장 코드
    private static final String RECV_TO_BUSINM = "recv.to.busiNm";  //	사업장명
    private static final String RECV_TO_SUBORGCD = "recv.to.suborgCd";  // 	총괄코드
    private static final String RECV_TO_SUBORGNM = "recv.to.suborgNm";  // 	총괄명
    private static final String RECV_TO_DEPTCD = "recv.to.deptCd";      //  	부서코드
    private static final String RECV_TO_DEPTNM = "recv.to.deptNm";      //  	부서명
    private static final String RECV_TO_JIKGUBCD = "recv.to.jikgubCd";      // 	직급코드
    private static final String RECV_TO_JIKGUBNM = "recv.to.jikgubNm";  // 	직급명
    private static final String RECV_TO_CEO = "recv.to.ceo" ;       //	CEO 여부
    private static final String RECV_TO_INSIDE = "recv.to.inside"; // 	내부/외부 구분

    /* 참조자 */
    private static final String RECV_CC_ALIAS = "recv.cc.alias";    //		참조자 별칭
    private static final String RECV_CC_ID = "recv.cc.id"; 	       //	참조자 id
    private static final String RECV_CC_USERID = "recv.cc.userId";  //		참조자 아이디 (인사연동)
    private static final String RECV_CC_NAME = "recv.cc.name"; 	   //	참조자 이름 (인사연동)
    private static final String RECV_CC_EMAIL = "recv.cc.email";    //		참조자 이메일 (인사연동)
    private static final String RECV_CC_IP = "recv.cc.ip" ;		   // 참조자 아이피
    private static final String RECV_CC_COCD = "recv.cc.coCd"; 	     //	회사코드
    private static final String RECV_CC_CONM = "recv.cc.coNm"; 	    //	회사명
    private static final String RECV_CC_BUSICD = "recv.cc.busiCd";  // 	사업장 코드
    private static final String RECV_CC_BUSINM = "recv.cc.busiNm";  //	사업장명
    private static final String RECV_CC_SUBORGCD = "recv.cc.suborgCd";  // 	총괄코드
    private static final String RECV_CC_SUBORGNM = "recv.cc.suborgNm";  // 	총괄명
    private static final String RECV_CC_DEPTCD = "recv.cc.deptCd";      //  	부서코드
    private static final String RECV_CC_DEPTNM = "recv.cc.deptNm";      //  	부서명
    private static final String RECV_CC_JIKGUBCD = "recv.cc.jikgubCd";      // 	직급코드
    private static final String RECV_CC_JIKGUBNM = "recv.cc.jikgubNm";  // 	직급명
    private static final String RECV_CC_CEO = "recv.cc.ceo" ;       //	CEO 여부
    private static final String RECV_CC_INSIDE = "recv.cc.inside"; // 	내부/외부 구분


    /* 비밀참조자 */
    private static final String RECV_BCC_ALIAS = "recv.bcc.alias";    //		비밀참조자 별칭
    private static final String RECV_BCC_ID = "recv.bcc.id"; 	       //	비밀참조자 id
    private static final String RECV_BCC_USERID = "recv.bcc.userId";  //		비밀참조자 아이디 (인사연동)
    private static final String RECV_BCC_NAME = "recv.bcc.name"; 	   //	비밀참조자 이름 (인사연동)
    private static final String RECV_BCC_EMAIL = "recv.bcc.email";    //		비밀참조자 이메일 (인사연동)
    private static final String RECV_BCC_IP = "recv.bcc.ip" ;		   // 비밀참조자 아이피
    private static final String RECV_BCC_COCD = "recv.bcc.coCd"; 	     //	회사코드
    private static final String RECV_BCC_CONM = "recv.bcc.coNm"; 	    //	회사명
    private static final String RECV_BCC_BUSICD = "recv.bcc.busiCd";  // 	사업장 코드
    private static final String RECV_BCC_BUSINM = "recv.bcc.busiNm";  //	사업장명
    private static final String RECV_BCC_SUBORGCD = "recv.bcc.suborgCd";  // 	총괄코드
    private static final String RECV_BCC_SUBORGNM = "recv.bcc.suborgNm";  // 	총괄명
    private static final String RECV_BCC_DEPTCD = "recv.bcc.deptCd";      //  	부서코드
    private static final String RECV_BCC_DEPTNM = "recv.bcc.deptNm";      //  	부서명
    private static final String RECV_BCC_JIKGUBCD = "recv.bcc.jikgubCd";      // 	직급코드
    private static final String RECV_BCC_JIKGUBNM = "recv.bcc.jikgubNm";  // 	직급명
    private static final String RECV_BCC_CEO = "recv.bcc.ceo";       //	CEO 여부
    private static final String RECV_BCC_INSIDE = "recv.bcc.inside"; // 	내부/외부 구분


    /* 개봉(읽음) 관련*/
    public static final String CHECKED_READID  = "checked.readId";	    //메시지 개봉 운용자 아이디
    public static final String CHECKED_READDATE  = "checked.readDate";  //메시지 개봉 날짜


    /* 기타 */
    public static final String[] RECEIVERS = {"recv.to.name","recv.cc.name","recv.bcc.name","network.dstip"}; // 수신자들
    public static final String[] SENDER = {"sender.name", "network.srcip"}; //발신자
    public static final String TIME_FORMAT = "common.time.";
    public static final String[] CEO = {
            "user.ceo"
            ,"sender.ceo"
            ,"recv.to.ceo"
            ,"recv.cc.ceo"
            ,"recv.bcc.ceo"
    }; // CEO 관련

    /* AUTH_FIELD_MAP */
    public static Map<String,String[]> AUTH_FIELD_MAP = new HashMap<>(){{
            put("COCD",new String[]{USER_COCD,USER_IPCOCD});
            put("BUSICD",new String[]{USER_BUSICD,USER_IPBUSICD});
            put("SERVICECD",new String[]{SERVICE_SVC});
            put("PICD",new String[]{PI_ID});
            put("GROUPCD",new String[]{USER_USERID});
    }};

    public static String COMPANY_RELATED  = "COCD,BUSICD";

    /* 화면 검색시 쓰이는 파라미터 */
    public static final String CTIME_HH = "ctime_hh"; //시간별
    public static final String CTIME_YYYYMM = "ctime_yyyymm"; //월별
    public static final String CTIME_YYYYMMDD = "ctime_yyyymmdd"; //일자별
    public static final String BUSINM = "businm"; //사업장별
    public static final String CONM = "conm"; //회사별
    public static final String DEPTNM = "deptnm"; //부서별
    public static final String DIRECTION_SVC = "direction_svc"; // 수/발신별
    public static final String JIKGUBNM = "jikgubnm"; // 직급별


    public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");


    // Array Fields
    public static String NESTED = "nested_";

    public static String[] ARRAY_FIELD = new String[]{
            "kwdInfo.kwdsAttach",
            "kwdInfo.kwdsAttachNm",
            "kwdInfo.kwds",
            "kwdInfo.kwdsBody",
            "kwdInfo.kwdsSubject",
            "attach.id",
            "attach.ext",
            "attach.hash",
            "attach.space",
            "recv.to.alias",
            "recv.to.id",
            "recv.to.userId",
            "recv.to.email",
            "recv.to.coCd",
            "recv.to.busiCd",
            "recv.to.suborgCd",
            "recv.to.deptCd",
            "recv.to.jikgubCd",
            "recv.to.ceo",
            "recv.to.inside",
            "recv.cc.alias",
            "recv.cc.id",
            "recv.cc.userId",
            "recv.cc.email",
            "recv.cc.coCd",
            "recv.cc.busiCd",
            "recv.cc.suborgCd",
            "recv.cc.deptCd",
            "recv.cc.jikgubCd",
            "recv.cc.ceo",
            "recv.cc.inside",
            "recv.bcc.alias",
            "recv.bcc.id",
            "recv.bcc.userId",
            "recv.bcc.email",
            "recv.bcc.coCd",
            "recv.bcc.busiCd",
            "recv.bcc.suborgCd",
            "recv.bcc.deptCd",
            "recv.bcc.jikgubCd",
            "recv.bcc.ceo",
            "recv.bcc.inside",
            "pi.id",
            "pi.type",
            "pi.kwds",
            "pi.amount",
    };

    public static String KEY_PREFIX = "";


    //"body" 주석
    public static String[] SEARCH_FIELD = new String[]{
            "ltime", "ctime",
            "subject", "attached", "attachExistCnt",
            "attachCnt", "size", "allOfUs",
            "directionSvc", "direction", "xrootMtr", "xmsgKey",
            "xparentMtr", "password", "siteAttr",
            "siteCode", "epmsgType", "epHeader",
            "usrId", "usrIp", "opinion","body.path","body.snippet","body.size",
            "piTotal", "piDRM", "piID","kwd",
            "piEF", "piPN", "piDN",
            "piSN", "piCN","piEC",
            "piFN","service",
            "network","attach","kwdInfo",
            "http","pi","user",
            "day","ocr","ml",
            "sender","recv","checked"
    };

    /* 화면에서의 (검색 영역) 값 엘라스틱 서치 필드로 치환  */

    public static Map<String,String> FIELDS = new HashMap<>();



    /* String -> LocalDateTime */
    public static LocalDateTime stringToLocalDateTime(String dateValue){
        LocalDateTime date = null;
           try {
               date = LocalDateTime.parse(dateValue, java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
           }catch (DateTimeParseException e){
               e.printStackTrace();
           }
        return date;
    }

    /* LocalDateTime -> String */
    public static String localdateTimeToString(LocalDateTime localDateTime){
        String str = null;
        try {
            str = localDateTime.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        }catch (DateTimeParseException e){
            e.printStackTrace();
        }
        return str;
    }

    /* String -> Date */
    public static Date stringToDate(String dateValue){
        Date date = null;
        try {
            date = DATE_FORMAT.parse(dateValue);
        }catch (DateTimeParseException | ParseException e){
            e.printStackTrace();
        }
        return date;
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
