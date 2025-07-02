package com.xcurenet.emass.message.service.vo;

import lombok.Data;

@Data
public class HostDescriptionVO {
    private String host;
    private String scheme;
    private String port;
    private String categoryCd;
    private String categoryNm;
    private String nationCd;
    private String description;
    private String type;
    private String processYn;
    private String nationEn;
    private String nationKo;
}