package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class Attach {
    private String desc;
    private boolean drm;
    private boolean encrypted;
    private boolean exist;
    private String ext;
    private String filter_type;
    private String flink;
    private String flink_key;
    private String hash;
    private String id;
    private String name;
    private boolean name_exist;
    private String path;
    private long size;
    private String space;
    private String summary;
    private String text;
    private String text_path;
}


