package com.xcurenet.emass.keyword.service;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.joda.time.DateTime;
import org.springframework.data.mongodb.core.index.Indexed;

import java.util.List;

@Data
public class KeywordsNewVO {

	private String host;

	private String keyword;

	private List<String> keywords;

	private String url;

	@Indexed
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private DateTime ctime;


	private String deptnm;

	private String deptcd;

	private String busicd;

	private String user;

	private String userId;

	private String name;

	private String busiNm;

	private String IpBusiCd;

	private String IpBusiNm;

	private String sentence;

	private String msgId;

	private String detected;


}
