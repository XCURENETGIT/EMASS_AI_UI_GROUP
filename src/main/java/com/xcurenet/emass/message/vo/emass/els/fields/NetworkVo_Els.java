package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class NetworkVo_Els {
       private String	  srcip;  //	발신자 IP
       private int	      sport;  //	발신자 PORT
       private String	  dstip;  //	목적지 IP
       private int	      dport;  //	목적지 PORT
       private String	  protocol;  //	프토토콜
       private String	  cId;  //	세션ID
}
