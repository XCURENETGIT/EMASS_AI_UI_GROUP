package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class NetworkVo_Mgo {

    @Value("srcIp")
    private String	srcIp;  //	발신자 IP
    @Value("srcPort")
    private int	srcPort;	  //발신자 PORT
    @Value("dstIp")
    private String	dstIp;  //	목적지 IP
    @Value("dstPort")
    private int	dstPort;	  //목적지 PORT
    @Value("protocol")
    private String	protocol;  //	프토토콜
    @Value("cid")
    private String	cid;  //	세션ID

}

