package com.xcurenet.emass.aiDashboard.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AiTimeStat {
    private String date;
    private String hour;
    private String minute;
    private String svc;
    private String svcName;
    private String svcCount;
}
