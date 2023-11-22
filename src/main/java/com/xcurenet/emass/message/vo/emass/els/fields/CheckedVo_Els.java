package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.Date;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class CheckedVo_Els {
    @JsonProperty("readId")
    private String	readId; //	메시지 개봉 운용자 아이디
    @JsonProperty("readTime")
    private Date readTime; //	메시지 개봉 날짜
}
