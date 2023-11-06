package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailVo_Mgo {
    private MailProperties_Mgo sender;
    private List<MailProperties_Mgo> to;
    private List<MailProperties_Mgo> cc;
    private List<MailProperties_Mgo> bcc;
}
