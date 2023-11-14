package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailVo_Els {
    private Mail_Sender_Properties_Els sender;
    private List<Mail_To_Properties_Els> to;
    private List<Mail_Cc_Properties_Els> cc;
    private List<Mail_Bcc_Properties_Els> bcc;
    private List<Mail_Recvs_Properties_Els> recvs;
}
