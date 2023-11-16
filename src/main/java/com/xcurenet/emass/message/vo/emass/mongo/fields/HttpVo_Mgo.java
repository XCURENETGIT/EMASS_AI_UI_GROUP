package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class HttpVo_Mgo {
     @Value("path")
    private String	path; //	URL PATH
     @Value("query")
    private String	query; //	URL 쿼리
     @Value("host")
    private String	host; //	HOST
     @Value("header")
     private String	header; //	HEADER
}
