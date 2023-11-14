package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class KwdVo_Els {
   private List	kwds_attach;	// 예약어(첨부내용)
   private List	kwds_attachname;//	예약어(첨부파일명)
   private boolean	kwd;   //	예약어 검출 유무
   private List	kwds;   //	전체 검출 예약어
   private List	kwds_body; //	예약어(본문)
   private List	kwds_subject; //	에약어(제목)

}
