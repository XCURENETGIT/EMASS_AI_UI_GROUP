package com.xcurenet.emass.message.service.vo;

import lombok.Data;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.ArrayList;
import java.util.Collection;

@Data
@ToString
public class EmassOcrData {

	@Field("ocrAttachCnt")
	private int ocrAttachCnt;

	@Field("ocrAttachTextPath")
	private Collection<String> ocrAttachTextPath = new ArrayList<>();
}
