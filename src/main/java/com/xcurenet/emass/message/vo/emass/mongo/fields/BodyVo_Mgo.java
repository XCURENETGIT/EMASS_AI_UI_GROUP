package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class BodyVo_Mgo {
   private long	size; //	본문 사이즈
   private int	img_cnt; //	본문 이미지 개수
   private String	body_charset; //	본문 charset
   private String	path; //	본문 경로
   private String	text_path; //	본문 텍스트 경로
   private String	hash; //	본문 hash
   private String	snippet; //	본문 요약

}
