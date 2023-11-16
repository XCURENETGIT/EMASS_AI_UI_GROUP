package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MlVo_Els {
    @JsonProperty("mlConfdClass")
   private int	mlConfdClass;	//AiHR 인덱스 값
    @JsonProperty("mlConfdFeedback")
   private int	mlConfdFeedback;//	AiHR 인덱스 피드백
    @JsonProperty("mlConfdProb")
   private float	mlConfdProb;//	AiHR 인덱스 결과 확률

}
