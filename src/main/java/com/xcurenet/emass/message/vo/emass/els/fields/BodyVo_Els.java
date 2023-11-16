package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class BodyVo_Els {
    @JsonProperty("size")
   private int	size;	//본문 사이즈
    @JsonProperty("path")
   private String	path;//	본문(원본) 경로
    @JsonProperty("snippet")
   private String	snippet;//	본문 요약
    @JsonProperty("text")
   private String	text;//	본문(텍스트) 내용

}
