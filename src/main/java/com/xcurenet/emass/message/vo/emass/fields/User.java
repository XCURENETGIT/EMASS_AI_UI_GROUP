package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class User {
    private String busicd;
    private String businm;
    private String ceo;
    private String cocd;
    private String conm;
    private String deptcd;
    private String deptnm;
    private String email;
    private String id;
    private String ip;
    private String ip_busicd;
    private String ip_businm;
    private String ip_cocd;
    private String ip_conm;
    private String jikgubcd;
    private String jikgubnm;
    private String key;
    private String name;
    private String suborgcd;
    private String suborgnm;
    private Long week;
    private String work;

}
