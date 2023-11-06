package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class BodyVo_Els {
   private 	long    size;         //본문 사이즈
   private 	long   imgCnt;        //본문 이미지 개수
   private 	String bodyCharset;   //본문 charset
   private 	String  path;         //본문 경로
   private 	String  hash;         //본문 hash
   private 	String  snippet;      //본문 요약
   private 	String  text;         //본문 내용

}
