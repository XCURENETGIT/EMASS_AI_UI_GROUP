package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class RecvVo_Mgo {
    List<ComProperties_Mgo> to;
    List<ComProperties_Mgo> cc;
    List<ComProperties_Mgo> bcc;
}
