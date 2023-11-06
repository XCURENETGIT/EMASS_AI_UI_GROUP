package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailVo_Els {
    private MailProperties_Els sender;
    private List<MailProperties_Els> to;
    private List<MailProperties_Els> cc;
    private List<MailProperties_Els> bcc;
}
