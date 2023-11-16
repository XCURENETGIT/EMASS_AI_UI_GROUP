package com.xcurenet.emass.message.vo.emass.els;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class EmassMessenger {
    @JsonProperty("title")
    private String title;
    @JsonProperty("message")
    private String message;
    @JsonProperty("user_cnt")
    private long user_cnt;
    @JsonProperty("msg_cnt")
    private long msg_cnt;
    @JsonProperty("unread_cnt")
    private long unread_cnt;
    @JsonProperty("ctime")
    private String ctime;
    @JsonProperty("msgid")
    private String msgid;
    @JsonProperty("xrootmtr")
    private String xrootmtr;
    @JsonProperty("svc")
    private String svc;
    @JsonProperty("svc3")
    private String svc3;
    @JsonProperty("attached")
    private String attached;
    @JsonProperty("attachhash")
    private String attachhash;
    @JsonProperty("attachname")
    private String attachname;
    @JsonProperty("attachsize")
    private String attachsize;
    @JsonProperty("deptNm")
    private String deptNm;
    @JsonProperty("jikgubNm")
    private String jikgubNm;
    @JsonProperty("readYn")
    private String readYn;
    @JsonProperty("srcip")
    private String srcip;
    @JsonProperty("usr_id")
    private String usr_id;
    @JsonProperty("user_name")
    private String user_name;
    @JsonProperty("sender")
    private String sender;
    @JsonProperty("body_snippet")
    private String body_snippet;
    @JsonProperty("body_text")
    private String body_text;


}
