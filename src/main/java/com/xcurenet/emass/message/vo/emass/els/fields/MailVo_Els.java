package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.boot.autoconfigure.mail.MailProperties;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MailVo_Els {
    private Mail_Sender_Properties_Els sender;
    private List<MailProperties> to;
    private List<MailProperties> cc;
    private List<MailProperties> bcc;
    private List<Mail_Recvs_Properties_Els> recvs;
}
