package com.xcurenet.common.makeInfo.service;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
public class InfoVersionVO {
	private String tableName;
	private long version;
	private String  date;
	private String id;
	private String comments;

}
