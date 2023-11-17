package com.xcurenet.emass.message.vo.emass.els.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class DayVo_Els {
	@JsonProperty("week")
	private int	week;	//몇주차
	@JsonProperty("work")
	private String	work;	//업무시간 여부
}
