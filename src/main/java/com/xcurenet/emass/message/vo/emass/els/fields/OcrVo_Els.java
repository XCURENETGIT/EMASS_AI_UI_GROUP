package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class OcrVo_Els {
	@JsonProperty("attachCnt")
	private int	attachCnt;  //	ocr 첨부 개수
	@JsonProperty("attach")
	private List attach;  //	ocr 첨부 텍스트 내용
}
