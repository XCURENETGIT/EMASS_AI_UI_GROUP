package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class AttachVo_Els {
   private String	id;   //첨부파일 ID
   private String	name;   //첨부파일 이름
   private String	path;   //첨부파일 경로
   private long	    size;   //첨부파일 사이즈
   private String	filterType;   //첨부파일 필터타입
   private String	ext;   //첨부파일 확장자
   private String	summary;   //첨부파일 요약
   private boolean	exi;   ////	첨부파일 유무
   private String	flin;   ////
   private boolean	encrypt;   ////	첨부파일 암호화 여부
   private boolean	nameExi;   ////	첨부파일 이름 유무
   private String	flinkKe;   ////
   private String	hash;   //첨부파일 해시
   private String	des;   ////
   private boolean	drm;   //첨바파일 DRM 유무
   private String	spac;   ////
   private String	text;   //본문내용
}


