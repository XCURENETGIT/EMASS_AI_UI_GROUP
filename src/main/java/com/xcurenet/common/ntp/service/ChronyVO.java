package com.xcurenet.common.ntp.service;

import com.itextpdf.text.pdf.PRIndirectReference;
import lombok.Data;

@Data
public class ChronyVO {
	private String status;
	private String ntpServer;
	private String dateTime;
}
