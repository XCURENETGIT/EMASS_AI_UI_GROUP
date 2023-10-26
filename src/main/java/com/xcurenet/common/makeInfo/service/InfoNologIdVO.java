package com.xcurenet.common.makeInfo.service;

import com.itextpdf.text.pdf.PRIndirectReference;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InfoNologIdVO {
	private int VERSION;
	private String SERVICECD;
	private String USERID;
}
