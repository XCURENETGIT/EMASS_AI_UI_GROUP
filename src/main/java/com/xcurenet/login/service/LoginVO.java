package com.xcurenet.login.service;

import lombok.Data;

@Data
public class LoginVO {
	private String userId;
	private String userPw;
	private String userIp;
	private String loginType;
}
