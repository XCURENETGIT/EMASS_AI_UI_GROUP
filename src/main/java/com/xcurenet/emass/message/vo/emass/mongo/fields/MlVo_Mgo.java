package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class MlVo_Mgo {
   @Value("mlConfdClass")
   private int	mlConfdClass;
   @Value("mlConfdClassOrg")
   private int	mlConfdClassOrg;
   @Value("mlConfdFeedback")
   private int	mlConfdFeedback;
   @Value("mlConfdUserId")
   private String	mlConfdUserId;
   @Value("mlConfdProb")
   private float	mlConfdProb;

}

