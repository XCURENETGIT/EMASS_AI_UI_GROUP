package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class NetWork {
    private int dport;
    private String protocol;
    private String srcip;
    private String dstip;
    private int sport;
    private String cid;

}
