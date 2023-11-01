package com.xcurenet.common.util.elasticsearch;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Getter
public class ElasticSearchCommon {

    /* EMASS INDEX */
    public static final String INDEX = "emass";

    /*검색타입*/
    public static final String SEARCH_TYPE_MESSAGE = "message";
    public static final String SEARCH_TYPE_STATISTIC = "statistic";

    /* 쿼리 관련 */
    public static final String ALL_SEARCH = "*:*";
    public static final String OPEN_BRACKET = "(";
    public static final String CLOSE_BRACKET = ")";
    public static final String BACKSLASH = "\\";
    public static final String QUOTES = "\"";
    public static final String SPACE = " ";
    public static final String COMMA = ",";
    public static final String SPECIAL_CHAR = "*";
    public static final String OR_PREFIX = "#";
    public static final String AND_QUERY = "AND";
    public static final String EXCEPT_QUERY = "-";


    /* 검색 영역 */
    public static final String CTIME = "ctime"; // 시간
    public static final String CTIME_HH = "ctime_hh"; //시간별
    public static final String CTIME_YYYYMM = "ctime_yyyymm"; //월별
    public static final String CTIME_YYYYMMDD = "ctime_yyyymmdd"; //일자별
    public static final String BUSINM = "businm"; //사업장별
    public static final String CONM = "conm"; //회사별
    public static final String DEPTNM = "deptnm"; //부서별
    public static final String DIRECTION_SVC = "direction_svc"; // 수/발신별
    public static final String JIKGUBNM = "jikgubnm"; // 직급별


    public static final String INFOTYPE = "ml_confd_class";
    public static final String FEEDBACK = "ml_confd_feedback";
    public static final String PROB = "ml_confd_prob";
    public static final String SKINFOTYPE = "ml_confd_class";
    public static final String SKFEEDBACK = "ml_confd_feedback";
    public static final String SKPROB = "ml_confd_prob";

    public static final String SERVICE = "service.svc";
    public static final String SERVICE_GROUP = "service.svc1";
    public static final String SERVICE_TYPE = "service.svc2";
    public static final String SERVICE_3 = "service.svc3";
    public static final String SERVICE_12 = "service.svc12";


    public static final String BUSICD = "busicd";
    public static final String IP_BUSICD = "ip_busicd";
    public static final String DEPTCD = "deptcd";
    public static final String IP_DEPTCD = "ip_deptcd";
    public static final String EPMSG_TYPE = "epmsg_type";
    public static final String[] SENDER = {"sender_str", "sname", "srcip"};
    public static final String SENDER_UPPER = "sender_str";
    public static final String[] SENDER_NOTUPPER = {"sender", "sname", "srcip"};
    public static final String[] RECEIVER = {"recvs", "recvs_name", "dstip"};
    public static final String[] RECEIVER_NOTUPPER = {"to", "tname", "cc", "cname", "bcc", "bname", "recvs_name", "dstip"};
    public static final String RECEIVER_UPPER = "recvs";
    public static final String TO = "to";
    public static final String TNAME = "tname";
    public static final String CC = "cc";
    public static final String CNAME = "cname";
    public static final String BCC = "bcc";
    public static final String BNAME = "bname";
    public static final String RECV_JIKGUBCD = "recvs_poid";
    public static final String HOST = "host";
    public static final String HOST_STR = "host_str";
    public static final String ATTACH_YN = "attached";
    public static final String ATTACHNAME = "attachname";
    public static final String ATTACHTYPE = "attachtype";
    public static final String KEYWORD_YN = "kwd";
    public static final String KEYWORD = "kwds";
    public static final String PI_TOTAL = "pi_total";
    public static final String PI = "pi";
    public static final String USER_ID = "user.id";
    public static final String USER_STR = "user_str";
    public static final String WORK = "work";
    public static final String DRM = "pi_DRM";
    public static final String ATTACH_EXIST_CNT = "attachexistcnt";
    public static final String SCT = "pi_sct";
    public static final String ALLOFUS = "allofus";
    public static final String LTIME = "ltime";
    public static final String ATTACH_SPACE = "attachspace";
    public static final String OCR_ATTACH_CNT = "ocr_attach_cnt";

    public static final String SIZE = "size";
    public static final String BODY_SIZE = "body_size";
    public static final String ATTACH_SIZE = "attachsize";

    public static final String JOIN_READ = " +{!join from=msgid fromIndex=checked to=msgid}id:%s";
    public static final String JOIN_UNREAD = " -{!join from=msgid fromIndex=checked to=msgid}id:%s";

    private static final String OCR_FIELD = " ocr_attach";




    public static final String TIME_FORMAT = "common.time.";


    //body
    public static String[] SEARCH_FIELD = new String[]{
            "allofus", "attach", "attachcnt",
            "attachexistcnt", "ctime",
            "direction", "direction_svc", "filePath",
            "html", "http", "kwd_info", "ltime",
            "mail", "ml", "msgid", "network",
            "opinion", "opinoion", "password",
            "pi", "service", "size", "subject",
            "user", "xmsgkey", "xparentmtr", "xrootmtr",
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


}
