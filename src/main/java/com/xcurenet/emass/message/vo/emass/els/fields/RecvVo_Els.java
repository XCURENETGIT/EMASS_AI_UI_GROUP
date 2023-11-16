package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class RecvVo_Els {
    List<ComProperties_Els> to;
    List<ComProperties_Els> cc;
    List<ComProperties_Els> bcc;
}
