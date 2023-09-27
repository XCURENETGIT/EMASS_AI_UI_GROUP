package com.xcurenet.emass.message.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.xcurenet.common.types.IP;
import com.xcurenet.common.util.Common;

import lombok.Data;

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

	public void setIp(String ip) {
		List<String> ipArr = new ArrayList<>();
		String[] ips = Common.toArray(ip, ",");
		for (String ipa : ips) {
			try {
				ipArr.add(new IP(ipa.trim()).toCanonicalAddr());
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		this.ip = Common.join(ipArr, ", ");
	}
}
