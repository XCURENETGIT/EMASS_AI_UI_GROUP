package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailVo_Els {
    @JsonProperty("to")
    private List<ComProperties_Els> to;
    @JsonProperty("cc")
    private List<ComProperties_Els> cc;
    @JsonProperty("bcc")
    private List<ComProperties_Els> bcc;
    @JsonProperty("recvs")
    private List<String> recvs;
}
