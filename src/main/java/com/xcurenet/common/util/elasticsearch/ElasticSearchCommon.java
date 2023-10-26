package com.xcurenet.common.util.elasticsearch;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Getter
public class ElasticSearchCommon {

    public static final String INDEX = "emass";

    private static DateTimeFormatter yyyyMMdd = DateTimeFormat.forPattern("yyyyMMdd");


    public static final String ALL_SEARCH = "*:*";

    public static final String BACKSLASH = "\\";
    public static final String SPACE = " ";
    //private static final String COMMA = ", ";
    public static final String SPECIAL_CHAR = "*";
    public static final String OR_PREFIX = "#";

    public static final String AND_QUERY = "AND";
    public static final String EXCEPT_QUERY = "-";

    public static final String CTIME = "ctime";
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
    public static final String DIRECTION_SVC = "direction_svc";
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


    /* 24시 */
    private static final String TIME_00 = "common.time.00";
    private static final String TIME_01 = "common.time.01";
    private static final String TIME_02 = "common.time.02";
    private static final String TIME_03 = "common.time.03";
    private static final String TIME_04 = "common.time.04";
    private static final String TIME_05 = "common.time.05";
    private static final String TIME_06 = "common.time.06";
    private static final String TIME_07 = "common.time.07";
    private static final String TIME_08 = "common.time.08";
    private static final String TIME_09 = "common.time.09";
    private static final String TIME_10 = "common.time.10";
    private static final String TIME_11 = "common.time.11";
    private static final String TIME_12 = "common.time.12";
    private static final String TIME_13 = "common.time.13";
    private static final String TIME_14 = "common.time.14";
    private static final String TIME_15 = "common.time.15";
    private static final String TIME_16 = "common.time.16";
    private static final String TIME_17 = "common.time.17";
    private static final String TIME_18 = "common.time.18";
    private static final String TIME_19 = "common.time.19";
    private static final String TIME_20 = "common.time.20";
    private static final String TIME_21 = "common.time.21";
    private static final String TIME_22 = "common.time.22";
    private static final String TIME_23 = "common.time.23";
    private static final String TIME_24 = "common.time.24";



    // Date 포맷 지정
    private static final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHH:mm:ss");


    public static String[] SEARCH_FIELD = new String[]{
            "allofus", "attach", "attachcnt",
            "attachexistcnt", "body", "ctime",
            "direction", "direction_svc", "filePath",
            "html", "http", "kwd_info", "ltime",
            "mail", "ml", "msgid", "network",
            "opinion", "opinoion", "password",
            "pi", "service", "size", "subject",
            "user", "xmsgkey", "xparentmtr", "xrootmtr",
    };

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

    public static Map<String,String> YFIELD = new HashMap<>(){{
           put("test","mail.sender.mail.keyword");

    }};


    /* String -> DateFormat */

    public static DateTime getDateFoamat(String dateValue){
            try {
               Date date = simpleDateFormat.parse(dateValue);
            }catch (ParseException e){
                e.printStackTrace();
            }
//        //원하는 데이터 포맷 지정
//        String dateValue = simpleDateFormat.format(dateValue);
//
//        //지정한 포맷으로 변환
//        System.out.println("포맷 지정 후 : " + strNowDate);

        return null;
    }

}
