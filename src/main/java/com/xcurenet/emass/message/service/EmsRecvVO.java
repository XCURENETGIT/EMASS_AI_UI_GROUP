package com.xcurenet.emass.message.service;

import lombok.Data;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

@Data
public class EmsRecvVO {
	private String msgId;
	private String recvId;
	private String uType;
	private String eMail;
	private String name;
	private String ip;
	private String coCd;
	private String coNm;
	private String subOrgCd;
	private String subOrgNm;
	private String busiCd;
	private String busiNm;
	private String deptCd;
	private String deptNm;
	private String jikgubCd;
	private String jikgubNm;
	private String inSide;
	private String domain;
	private String viewStr;
	private String formatStr;


	public static Map<String, Object> toMap(EmsRecvVO person) {
		try {
			Field[] fields = person.getClass().getDeclaredFields();
			Map<String, Object> results = new HashMap<>();
			for (Field field : fields) {
				results.put(field.getName(), field.get(person));
			}
			return results;

		} catch (IllegalAccessException | IllegalArgumentException e) {
			return null;
		}
	}
}
