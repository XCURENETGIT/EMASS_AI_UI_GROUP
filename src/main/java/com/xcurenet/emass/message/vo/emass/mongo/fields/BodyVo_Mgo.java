package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class BodyVo_Mgo {

   @Value("size")
   private int	size;   //	본문 사이즈
   @Value("imgCnt")
   private int	imgCnt;   //	본문 이미지 개수
   @Value("bodyCharset")
   private String	bodyCharset;   //	본문 charset
   @Value("path")
   private String	path;   //	본문 경로
   @Value("textPath")
   private String	textPath;   //	본문 텍스트 경로
   @Value("hash")
   private String	hash;   //	본문 hash

}
