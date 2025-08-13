package com.xcurenet.emass.aiDashboard.model;


import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class AiIncludeInfo {
    private List<AiSvcInfo> svcInfos;
    private long svcCount;
    private long piCount;
    private long attachCount;
    private long kwdCount;
}
