package com.xcurenet.emass.message.service;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.ToString;
import org.joda.time.DateTime;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Data
@ToString
@Document(collection = "EMS_CHECKED")
public class SolrCheckedVO {

	@Id
	@Field("_id")
	private String msgId;

	@Field("checked")
	private List<SolrCheckedAttr> checked;

	@Data
	@ToString
	public static class SolrCheckedAttr {
		@Field("readId")
		private String readId; //메시지 개봉 운용자 아이디

		@Field("readTime")
		@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
		private DateTime readTime; //메시지 개봉일
	}
}
