package com.xcurenet.emass.message.vo.emass.mongo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class TestMessage {
    private String _id;

//    private long SIZE;
//    private String USR_IP;
//    private String USR_ID;
//    private String PASSWORD;
//    private String USER;
//    private String SUBJECT;
//    private int BODYSIZE;
//    private String XMSGKEY;
//    private String XROOTMTR;
//    private String XPARENTMTR;
//    private String HOST;
//    private String PATH;
//    private String QUERY;
//    private String SENDER;
//    private String OPINION;
//    private String DEV_WRITER;
//    private String DEV_DECODER;
//    private String SITEATTR;
//    private String SITECODE;
//    private String USERID;
//    private String NAME;
//    private String COCD;
//    private String IP_COCD;
//    private String SUBORGCD;
//    private String BUSICD;
//    private String IP_BUSICD;
//    private String DEPTCD;
//    private String JIKGUBCD;
//    private String CEO;
//    private String ALLOFUS;
//    private String ATTACHED;
//    private String DIRECTION;
//    private String KWD;
//    private String INSIDE;
//    private String WORK;
//    private int    ATTACHCNT;
//    private String FILENAME;
//    private String PROTOCOL;
//    private int ML_CONFD_CLASS;
//    private int ML_CONFD_CLASS_ORG;
//    private int ML_CONFD_FEEDBACK;
//    private String ML_CONFD_USERID;
//    private double ML_CONFD_PROB;
//    private int    ATTACHEXISTCNT;
//    private String EPMSG_TYPE;
//    private int    BODYIMAGECNT;
//    private String BODYCHARSET;
//    private String HEADER;
//    private String BODY_PATH;
//    private List<RECV_INFO_PROPERTIES> RECV_INFO;
//    private List<KEYWORD_INFO_PROPERTIES> KEYWORD_INFO;
//    private List<PRIVATE_INFO_PROPERTIES> PRIVATE_INFO;
//    private List<ATTACH_INFO_PROPERTIES> ATTACH_INFO;

}
