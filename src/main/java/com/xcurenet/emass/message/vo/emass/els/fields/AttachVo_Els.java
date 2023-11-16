package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class AttachVo_Els {
    @JsonProperty("id")
    private String	id;	//첨부파일 ID
    @JsonProperty("name")
    private String	name;//	첨부파일 이름
    @JsonProperty("text")
    private String	text;//	첨부파일(텍스트) 내용
    @JsonProperty("size")
    private int	size;	//첨부파일 사이즈
    @JsonProperty("ext")
    private String	ext;//	첨부파일 확장자
    @JsonProperty("hash")
    private String	hash;//	첨부파일 해시

}


