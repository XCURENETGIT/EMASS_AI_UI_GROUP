package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class ServiceVo_Els {
    @JsonProperty("svc")
    private String svc;  //	서비스타입
    @JsonProperty("svc1")
    private String svc1;  //	서비스타입 대분류
    @JsonProperty("svc12")
    private String svc12;  //	서비스타입 대중분류
    @JsonProperty("svc2")
    private String svc2;  //	서비스타입 중분류
    @JsonProperty("svc3")
    private String svc3;  //	서비스타입 소분류
}