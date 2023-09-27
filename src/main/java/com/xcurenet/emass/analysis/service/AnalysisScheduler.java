package com.xcurenet.emass.analysis.service;

import java.util.Map;

import org.apache.solr.client.solrj.SolrQuery;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SolrQueryString;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class AnalysisScheduler {

	@Autowired private SolrEdcService solrEdcService;

	@Autowired private AnalysisRelationService analysisRelationService;

	@Scheduled(cron="0 1 */1 * * *")
	public void usageCompareStats() throws Exception {
		log.info("---------------------------------------------------------------");
		log.info("{} - {}", getDateTime(System.currentTimeMillis(), "yyyy-MM-dd HH:mm:ss"), "사용량 증가 비교 분석 통계 실행 Start");
		selectUsageChart();
		log.info("{} - {}", getDateTime(System.currentTimeMillis(), "yyyy-MM-dd HH:mm:ss"), "사용량 증가 비교 분석 통계 실행 End");
		log.info("---------------------------------------------------------------");
	}
	
	private Map<String, String> plusHour(String targetDate, int start, int end) throws Exception {
		return analysisRelationService.plusHour(targetDate, start, end);
	}

	private void selectUsageChart() throws Exception {
		String lastTime = analysisRelationService.getLastTime();
		String currentTime = Common.getCurrentTime("yyyyMMddHH");

		int count = Common.diffOfHours(lastTime, currentTime)-1;
		log.info("AnalysisScheduler total count : {}", count);
		for (int i = 0; i < count; i++) {
			Map<String, String> time = plusHour(lastTime, i, (i + 1));
			String startDate = time.get("startDate") + "0000";
			String endDate = time.get("endDate") + "0000";

			SolrQueryString query = new SolrQueryString();
			query.addRange("ctime", startDate, endDate, false);

			SolrQuery sq = new SolrQuery();

			sq.setQuery(query.toString());
			sq.setRows(Common.MAX_VALUE);
			sq.setFields("sender", "sname", "attachname", "svc", "ctime", "ctime_yyyy", "ctime_yyyymm", "ctime_yyyymmdd", "ctime_hh", "size", "attached", "attachsize");

			SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, null);

			UsageChartScheduler usageChart = new UsageChartScheduler();
			try {
				int insertCount = analysisRelationService.insertUsageCompare(usageChart.getData(edc.getEmass(), lastTime));

				log.info("time : {} ~ {}, searchCount : {}, insertCount : {}", startDate, endDate, edc.getNumFound(), insertCount);
			} catch(Exception e) {
				log.error("UI_USAGE_COMPARE INSERT ERROR", e.getMessage());
			}
		}
	}

	private String getDateTime(long time, String format) {
		if (time == 0) return "-";
		DateTimeFormatter date = DateTimeFormat.forPattern(format);
		return date.print(time);
	}

}
