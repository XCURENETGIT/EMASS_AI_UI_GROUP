package com.xcurenet.emass.message.service;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Data
@JsonInclude(Include.NON_NULL)
public class MessengerGroupVO  implements Comparable<MessengerGroupVO> {
	private String title;

	private String userkey;

	private String message;
	private long user_cnt;
	private long msg_cnt;
	private long unread_cnt;
	private String ctime;
	@Id
	@Field(type = FieldType.Text)
	private String msgid;

	private String xrootmtr;
	private String svc;
	private String svc3;
	private String svc12;
	private String userid;
	private String attached;
	private String attachhash;
	private String attachname;
	private String attachsize;
	private String attachtype;
	private String busiNm;
	private String deptNm;
	private String jikgubNm;
	private String readYn;
	private String srcip;
	private String name;
	private String usr_id;
	private String user;
	private String sender;
	private String body_snippet;
	private String direction_svc;
	private String inside;

	@Override
	public int compareTo(MessengerGroupVO other) {
		return other.getCtime().compareTo(this.getCtime());
	}


}
