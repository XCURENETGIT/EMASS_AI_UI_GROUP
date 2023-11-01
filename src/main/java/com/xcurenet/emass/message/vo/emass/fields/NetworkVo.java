package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class NetworkVo {
       private String	  srcIp;  //	발신자 IP
       private int	      srcPort;  //	발신자 PORT
       private String	  dstIp;  //	목적지 IP
       private int	      dstPort;  //	목적지 PORT
       private String	  protocol;  //	프토토콜
       private String	  cId;  //	세션ID
}
