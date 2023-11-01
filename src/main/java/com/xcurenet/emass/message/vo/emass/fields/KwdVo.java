package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class KwdVo {
   private List     kwdsAttach;   //	예약어(첨부내용)
   private List  	kwdsAttachNm;   //	예약어(첨부파일명)
   private boolean  kwd;   //	kwd	예약어 검출 유무
   private List	    kwds;   //	전체 검출 예약어
   private List  	kwdsBody;   //	예약어(본문)
   private List	    kwdsSubject;   //	에약어(제목)

}
