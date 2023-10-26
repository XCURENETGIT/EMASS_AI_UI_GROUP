package com.xcurenet.common.makeInfo.service;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
//@Document(collation = "INFO_VERSION")
public class InfoVersionVO {
	private String tableName;
	private long version;
	private String  date;
	private String id;
	private String comments;

}
