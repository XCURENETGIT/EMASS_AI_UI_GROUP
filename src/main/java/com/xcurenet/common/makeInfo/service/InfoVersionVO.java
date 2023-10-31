package com.xcurenet.common.makeInfo.service;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Builder
public class InfoVersionVO {
	private String TABLENAME;
	private long VERSION;
	private String  DATA;
	private String ID;
	private String COMMENTS;

}
