package com.xcurenet.emass.message.vo.emass.mongo.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class PiVo_Mgo {
   private String	id; // 
   private String	type; //
   private String	attachNm; //
   private List kwds; //
   private int	amount; //
}
