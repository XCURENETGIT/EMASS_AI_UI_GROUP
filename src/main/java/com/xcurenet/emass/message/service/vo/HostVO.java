package com.xcurenet.emass.message.service.vo;

import lombok.Data;

@Data
public class HostVO {
    private String host;
    private String scheme;
    private int port;
    private String categoryCd;
    private String nationCd;
    private String desc;
    private String processYn;
}
