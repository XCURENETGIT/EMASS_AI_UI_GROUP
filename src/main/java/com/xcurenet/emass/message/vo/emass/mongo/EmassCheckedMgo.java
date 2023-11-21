package com.xcurenet.emass.message.vo.emass.mongo;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.xcurenet.emass.message.vo.emass.mongo.fields.CheckedVo_Mgo;
import lombok.Data;

import javax.annotation.Nullable;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
/***
 *
 *  개봉(읽음) Vo
 */
public class EmassCheckedMgo {
        List<CheckedVo_Mgo> checked;
}
