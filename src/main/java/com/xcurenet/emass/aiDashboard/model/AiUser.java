package com.xcurenet.emass.aiDashboard.model;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class AiUser {
    private String srcIp;
    private String userId;
    private String userNm;
    private String deptNm;
    private String jikgubNm;
    List<AiSvcInfo> svcInfos;
    List<AiPiInfo> piInfos;
    private int piTotalCount;
    List<AiKwdInfo> kwdInfos;
    private int kwdTotalCount;

}
