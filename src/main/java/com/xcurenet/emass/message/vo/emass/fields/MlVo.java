package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MlVo {
   private String	mlConfdClass;	  //AiHR 인덱스 값
   private String	mlConfdFeedback; //	AiHR 인덱스 피드백
   private float	mlConfdProb;     //	AiHR 인덱스 결과 확률
}
