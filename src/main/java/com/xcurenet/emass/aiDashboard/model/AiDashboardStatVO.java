package com.xcurenet.emass.aiDashboard.model;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class AiDashboardStatVO {

    //금일 서비스 이용현황
    private long todayCount;
    private long todayAttachCount;

    //금일 개인정보 유출현황
    private long todayPiCount;
    private long todayPiAttachCount;

    //금일 예약어 탐지현황
    private long todayKwdCount;
    private long todayKwdAttachCount;

    //금일 서비스 사용량 top 10
    private TopGroupVO todayTop10Info;

    // 주간 서비스 사용량 top 10
    private TopGroupVO weeklyTop10Info;

    // AI 시간대별 사용 현황
    List<AiTimeStat> aiTimeStats;

    //금일 Ai 서비스 사용 현황 (사용자)
    List<AiUser> todayAiUsers;

    //금일 개인정보 발신 현황 (사용자)
    List<AiUser> todayAiPiUsers;

    //금일 예약어 포함 발신 현황 (사용자)
    List<AiUser> todayAiKwdUsers;

}
