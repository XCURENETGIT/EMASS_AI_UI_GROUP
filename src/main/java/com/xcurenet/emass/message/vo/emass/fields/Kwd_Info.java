package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class Kwd_Info {

    private boolean kwd;
    private String kwds_attach;
    private String kwds_attachname;
    private String kwds;
    private String kwds_body;
    private String kwds_subject;

}
