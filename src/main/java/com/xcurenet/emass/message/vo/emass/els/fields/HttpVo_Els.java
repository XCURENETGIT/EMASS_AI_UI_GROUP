package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class HttpVo_Els {

    @JsonProperty("path")
    private String	path; //	URL PATH
    @JsonProperty("query")
    private String	query; //	URL 쿼리
    @JsonProperty("host")
    private String	host; //	HOST


}
