package com.xcurenet.emass.message.vo.emass.els.fields;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class Mail_Sender_Properties_Els {
    private String	sname;  //	발신자 이름
    private String	sender;	//발신자 MAIL
}