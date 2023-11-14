package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class OcrVo_Els {
    private int	ocr_attach_cnt;	//ocr 첨부 개수
    private String	ocr_attach;	//ocr 첨부 텍스트 내용
}
