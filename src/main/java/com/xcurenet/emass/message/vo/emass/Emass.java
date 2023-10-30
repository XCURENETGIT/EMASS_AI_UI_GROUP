package com.xcurenet.emass.message.vo.emass;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.fields.*;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable

/***
 *  elastic search Db -> App server 받아오기 위한 Vo
 */
public class Emass {

    private String allofus;
    private String allofusStr;

    private List<Attach> attach;
    private String attachSizeStr;
    private int attachcnt;
    private int attachexistcnt;
    private Body body;
    private String ctime;
    private String direction;
    private String direction_svc;
    private String filePath;
    private Html html;
    private Http http;
    private Kwd_Info kwd_info;
    private String ltime;
    private Mail mail;
    private Ml ml;
    private String msgid;
    private NetWork network;
    private String opinion;
    private String opinoion;
    private String password;
    private Pi pi;
    private Service service;
    private long size;
    private String sizeStr;
    private String subject;
    private User user;
    private String xmsgkey;
    private String xparentmtr;
    private String xrootmtr;

    public String interestUserYn = "N";
    public String interestGroupColor;
    public String consentNo;
    public String readYn;

    /* optional */
//    private String body_snippet;
//    private String ocr_attach_cnt;


}
