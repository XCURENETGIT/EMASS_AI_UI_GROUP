package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class OcrVo_Mgo {
    @Value("attachCnt")
    private int	attachCnt;   //	ocr 첨부 개수
    @Value("attachPath")
    private List attachPath;   //ocr 첨부 텍스트 경로 (minio)
}
