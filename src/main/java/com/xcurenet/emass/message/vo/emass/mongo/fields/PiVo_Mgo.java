package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class PiVo_Mgo {

   @Value("id")
   private String id;
   @Value("type")
   private String type;
   @Value("attachNm")
   private String attachNm;
   @Value("kwds")
   private List kwds;
   @Value("amount")
   private int amount;

}
