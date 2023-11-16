package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class KwdVo_Mgo {
   @Value("kwdsAttach")
   private List kwdsAttach; //	예약어(첨부내용)
   @Value("kwdsAttachNm")
   private List	kwdsAttachNm; //	예약어(첨부파일명)
   @Value("kwd")
   private String	kwd; //	예약어 검출 유무
   @Value("kwds")
   private List	kwds; //	전체 검출 예약어
   @Value("kwdsBody")
   private List	kwdsBody; //	예약어(본문)
   @Value("kwdsSubject")
   private List	kwdsSubject; //	에약어(제목)

}
