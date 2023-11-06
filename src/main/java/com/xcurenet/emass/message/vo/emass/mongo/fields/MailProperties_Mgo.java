package com.xcurenet.emass.message.vo.emass.mongo.fields;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailProperties_Mgo {
    private String alias;  //별칭
    private String id;	   //ID
    private String name;    // 이름
    private String email;   // MAIL

}