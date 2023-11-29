package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class AttachVo_Mgo  {

   @Value("id")
   private String	id; //	첨부파일 ID
   @Value("name")
   private String	name; //	첨부파일 이름
   @Value("path")
   private String	path; //	첨부파일 경로
   @Value("textPath")
   private String	textPath; //	첨부파일 텍스트 경로
   @Value("size")
   private int	    size; //	첨부파일 사이즈
   @Value("filterType")
   private String	filterType; //	첨부파일 필터타입
   @Value("ext")
   private String	ext; //	첨부파일 확장자
   @Value("summary")
   private String	summary; //	첨부파일 요약
   @Value("exist")
   private String	exist; //	첨부파일 유무
   @Value("flink")
   private String	flink; //
   @Value("encrypted")
   private String	encrypted; //	첨부파일 암호화 여부
   @Value("nameExist")
   private String	nameExist; //	첨부파일 이름 유무
   @Value("flinkKey")
   private String	flinkKey; //
   @Value("hash")
   private String	hash; //	첨부파일 해시
   @Value("desc")
   private String	desc; //
   @Value("drm")
   private String	drm; //	첨바파일 DRM 유무
   @Value("space")
   private String	space; //


}


