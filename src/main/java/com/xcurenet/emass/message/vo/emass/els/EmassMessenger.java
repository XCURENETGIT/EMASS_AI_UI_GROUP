package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class EmassMessenger {
    private String title;
    private String message;
    private long user_cnt;
    private long msg_cnt;
    private long unread_cnt;
    private String ctime;
    private String msgid;
    private String xrootmtr;
    private String svc;
    private String svc3;
    private boolean attached;
    private String attachhash;
    private String attachname;
    private String attachsize;
    private String deptNm;
    private String jikgubNm;
    private String readYn;
    private String srcip;
    private String usr_id;
    private String user_name;
    private String sender;
    private String body_snippet;
    private String body_text;


}
