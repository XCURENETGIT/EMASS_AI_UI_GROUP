package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class PiVo_Els {
   @JsonProperty("id")
   private String	id;       //패턴 탐지 아이디 (EC, ID, EF, PN, FN, DN…)
   @JsonProperty("type")
   private String	type;     //
   @JsonProperty("attachNm")
   private String	attachNm; //탐지 첨부명
   @JsonProperty("kwds")
   private List kwds;         //탐지 키워드
   @JsonProperty("amount")
   private int	    amount;       //탐지 건수

}
