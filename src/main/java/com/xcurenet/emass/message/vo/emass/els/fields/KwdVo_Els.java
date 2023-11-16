package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class KwdVo_Els {

      @JsonProperty("kwdsAttach")
     private List	kwdsAttach; //	예약어(첨부내용)
      @JsonProperty("kwdsAttachNm")
     private List kwdsAttachNm; //	예약어(첨부파일명)
      @JsonProperty("kwd")
     private String	kwd; //	예약어 검출 유무
      @JsonProperty("kwds")
     private List	kwds; //	전체 검출 예약어
      @JsonProperty("kwdsBody")
     private List	kwdsBody; //	예약어(본문)
      @JsonProperty("kwdsSubject")
     private List	kwdsSubject; //	에약어(제목)

}
