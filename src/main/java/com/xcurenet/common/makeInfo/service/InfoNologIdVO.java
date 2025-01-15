package com.xcurenet.common.makeInfo.service;

import com.itextpdf.text.pdf.PRIndirectReference;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Document(collection = "INFO_NOLOG_ID")
public class InfoNologIdVO {

	@Indexed(name = "VERSION_1")
	@Field("VERSION")
	private int VERSION;

	@Field("SERVICECD")
	private String SERVICECD;

	@Field("USERID")
	private String USERID;
}
