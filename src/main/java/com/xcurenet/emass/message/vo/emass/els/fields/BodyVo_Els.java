package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class BodyVo_Els {
   private 	long    body_size;         //본문 사이즈
//   private 	long   body_imgCnt;        //본문 이미지 개수
//   private 	String body_Charset;   //본문 charset
//   private 	String body_path;         //본문 경로
//   private 	String body_hash;         //본문 hash
   private 	String body_snippet;      //본문 요약
   private 	String body_text;         //본문 내용

}
