package com.xcurenet.pattern.service;

import lombok.Data;
import lombok.ToString;
import org.bouncycastle.cms.PasswordRecipientId;

@ToString
@Data
public class PatternVO {
	private String id;
	private String code;
	private String regex;
	private String name;
}
