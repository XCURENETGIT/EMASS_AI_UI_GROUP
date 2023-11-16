package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.els.fields.ComProperties_Els;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class RecvVo_Mgo {
    List<ComProperties_Els> to;
    List<ComProperties_Els> cc;
    List<ComProperties_Els> bcc;
}
