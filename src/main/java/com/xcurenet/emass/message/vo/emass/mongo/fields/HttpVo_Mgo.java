package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class HttpVo_Mgo {

    private String	path;	//URL PATH
    private String	query;	//URL 쿼리
    private String	host;	//HOST
    private String	header;	//HEADER


}
