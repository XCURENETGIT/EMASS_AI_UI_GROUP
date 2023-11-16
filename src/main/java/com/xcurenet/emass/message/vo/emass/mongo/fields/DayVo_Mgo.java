package com.xcurenet.emass.message.vo.emass.mongo.fields;


import org.springframework.beans.factory.annotation.Value;

public class DayVo_Mgo {
    @Value("week")
    private Long	week;	//몇주차
    @Value("work")
    private String	work;	//업무시간 여부
}
