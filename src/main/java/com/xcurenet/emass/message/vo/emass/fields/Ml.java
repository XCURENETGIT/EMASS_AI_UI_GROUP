package com.xcurenet.emass.message.vo.emass.fields;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import javax.annotation.Nullable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Nullable
public class Ml {
    private int ml_confd_class;
    private String ml_confd_class_Str;
    private int ml_confd_feedback;
    private String ml_confd_feedback_Str;
    private float ml_confd_prob;
}
