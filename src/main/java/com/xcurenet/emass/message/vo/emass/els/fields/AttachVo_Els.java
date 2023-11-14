package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class AttachVo_Els {
//   private String	attachid;   //첨부파일 ID
   private String	attachname;   //첨부파일 이름
//   private String	attachpath;   //첨부파일 경로
   private long	    attachsize;   //첨부파일 사이즈
//   private String	attachfilterType;   //첨부파일 필터타입
   private String	attachtype;   //첨부파일 확장자
//   private String	attachsummary;   //첨부파일 요약
//   private boolean	attachexi;   ////	첨부파일 유무
//   private String	attachflin;   ////
//   private boolean	attachencrypt;   ////	첨부파일 암호화 여부
   private boolean	attachnameexist;   ////	첨부파일 이름 유무
//   private String	attachflinkKe;   ////
   private String	attachhash;   //첨부파일 해시
//   private String	attachdes;   ////
//   private boolean	attachdrm;   //첨바파일 DRM 유무
   private String	attachspace;   ////
   private String	attach;   //첨부파일(텍스트)내용
}


