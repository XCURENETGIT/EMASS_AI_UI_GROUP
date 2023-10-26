package com.xcurenet.emass.message.vo.emass.fields;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailProperties {
    private String alias;
    private String id;
    private String name;
    private String email;
    private String mail;
    private String key;
}