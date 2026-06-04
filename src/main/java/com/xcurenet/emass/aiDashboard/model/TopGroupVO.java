package com.xcurenet.emass.aiDashboard.model;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TopGroupVO {

    private List<AiSvcInfo> all;      // 전체
    private List<AiSvcInfo> work;     // 업무시간
    private List<AiSvcInfo> nonWork;  // 비업무시간

}
