package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class Service {
    private String svc;
    private String svc1;
    private String svc2;
    private String svc3;
    private String svc12;

    private String svcNm;
    private String svcLv1Nm;
    private String svcLv2Nm;



}
