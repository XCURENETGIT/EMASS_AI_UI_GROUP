package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class OcrVo_Mgo {
    private int	attach_cnt; //ocr 첨부 개수
}
