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
    @JsonProperty("readDate")
    private Date readDate; //	메시지 개봉 날짜
    @JsonProperty("readDateHH")
    private String	readDateHH; //	메시지 개봉 시간
    @JsonProperty("readDateYYYY")
    private String	readDateYYYY; //	메시지 개봉 년
    @JsonProperty("readDateYYYYMM")
    private String	readDateYYYYMM; //	메시지 개봉 년월
    @JsonProperty("readDateYYYYMMDD")
    private String	readDateYYYYMMDD; //	메시지 개봉 년월일
}
