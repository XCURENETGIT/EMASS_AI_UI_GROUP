package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import lombok.Data;

@Data
@JsonInclude(Include.NON_NULL)
public class MessengerGroupVO {
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
	private String attached;
	private String attachhash;
	private String attachname;
	private String attachsize;
	private String deptNm;
	private String jikgubNm;
	private String readYn;
	private String srcip;
	private String name;
	private String usr_id;
	private String user;
	private String sender;
}
