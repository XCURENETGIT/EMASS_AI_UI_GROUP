package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MlVo_Els {
   private String	ml_confd_class;  //	AiHR 인덱스 값
   private String	ml_confd_feedback;  //	AiHR 인덱스 피드백
   private float	ml_confd_prob;  //	AiHR 인덱스 결과 확률
}
