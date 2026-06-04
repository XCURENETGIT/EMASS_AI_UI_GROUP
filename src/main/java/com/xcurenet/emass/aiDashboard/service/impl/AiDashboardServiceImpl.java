package com.xcurenet.emass.aiDashboard.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.aiDashboard.model.*;
import com.xcurenet.emass.aiDashboard.service.AiDashboardService;
import com.xcurenet.emass.message.service.FacetVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.pattern.service.PatternVO;
import lombok.extern.log4j.Log4j2;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("AiDashboardService")
@Log4j2
public class AiDashboardServiceImpl implements AiDashboardService {

	@Autowired
	private SolrEdcService solrEdcService;

	private static final Map<String, String> PATTERN_MAP = new HashMap<>();

	static {
		for (PatternVO vo : Config.patternInfo) {
			PATTERN_MAP.put(vo.getCode(), vo.getName());
		}
	}

	/**
	 * Ai 대시보드 전용 엘라스틱 쿼리
	 */
	@Override
	public AiDashboardStatVO getAiDashboardStats(String adminId) throws IOException, SolrServerException {
		AiDashboardStatVO aiDashboardStatVO = new AiDashboardStatVO();
		String todayStr = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE);

		aiDashboardStatVO.setTodayCount(getTodayAiTotalCount(todayStr, adminId));  //전체 발신건수
		aiDashboardStatVO.setTodayAttachCount(getTodayAttachAiTotalCount(todayStr, adminId));  //전체 (첨부파일 포함) 발신건수

		aiDashboardStatVO.setTodayPiCount(getTodayPiAmountExistsCount(todayStr, adminId));  //전체 개인정보 유출 발신건수
		aiDashboardStatVO.setTodayPiAttachCount(getTodayAttachPiAmountExistsCount(todayStr, adminId));  //전체 개인정보 유출 (첨부파일 포함) 발신건수

		aiDashboardStatVO.setTodayKwdCount(getTodayKwdAiTotalCount(todayStr, adminId));  //전체 예약어 탐지 건수
		aiDashboardStatVO.setTodayKwdAttachCount(getTodayKwdAttachAiTotalCount(todayStr, adminId)); //전체 예약어 (첨부파일 포함) 탐지 건수

		aiDashboardStatVO.setTodayTop10Info(getTodayTop10AiStats(todayStr, adminId));     //금일 서비스 사용량 top 10
		aiDashboardStatVO.setWeeklyTop10Info(getWeeklyTop10AiStats(todayStr, adminId));   //일주일 서비스 사용량 top 10
		aiDashboardStatVO.setTodayAiUsers(getTodayTop10UserStats(todayStr, adminId)); // 금일 TOP 10 유져별 AI 현황

		aiDashboardStatVO.setAiTimeStats(getTodayAiSvcTimeStats(todayStr, adminId)); //금일 AI 모델 이용시간대 추이

		aiDashboardStatVO.setTodayAiPiUsers(getTodayTop10PiUserStats(todayStr, adminId)); //금일 top 10 개인정보 발신 현황

		aiDashboardStatVO.setTodayAiKwdUsers(getTodayTop10KwdUserStats(todayStr, adminId));      // 금일 TOP10 예약어 포함 발신 현황
		return aiDashboardStatVO;
	}

	public void setIndexQuery(String todayStr, SolrQuery sq) {
		sq.setQuery(sq.getQuery() + String.format(" +ctime_yyyymmdd:%s +direction_svc:O +svc:I*", todayStr));
		sq.setParam("indics", "edc_w_" + todayStr.substring(0, 6));
	}

	//금일 AI 서비스 이용 현황 - 전체 발신 건수
	public long getTodayAiTotalCount(String todayStr, String adminId) throws SolrServerException, IOException {
		SolrQuery sq = new SolrQuery();
		String query = "";
		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		return edc.getNumFound();
	}

	//금일 AI 서비스 이용 현황 - 첨부 발신 건수
	public long getTodayAttachAiTotalCount(String todayStr, String adminId) throws SolrServerException, IOException {
		SolrQuery sq = new SolrQuery();
		String query = "+attached:Y";
		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		return edc.getNumFound();
	}

	//금일 개인정보 유출 현황 - 전체 건수
	public long getTodayPiAmountExistsCount(String todayStr, String adminId) throws IOException, SolrServerException {
		SolrQuery sq = new SolrQuery();
		String[] privatePatterns = Config.activePrivatePatterns;
		String query = String.format(
				"+(%s)",
				Arrays.stream(privatePatterns)
						.map(p -> String.format("(pi_amount.pi_%s:[1 TO *])", p))
						.collect(Collectors.joining(" "))
		);

		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		return edc.getNumFound();
	}


	//금일 AI 서비스 개인정보 유출(첨부파일 포함)  총 count
	public long getTodayAttachPiAmountExistsCount(String todayStr, String adminId) throws IOException, SolrServerException {
		SolrQuery sq = new SolrQuery();
		String[] privatePatterns = Config.activePrivatePatterns;
		String query = String.format(
				"+attached:Y +(%s)",
				Arrays.stream(privatePatterns)
						.map(p -> String.format("(pi_amount.pi_%s:[1 TO *])", p))
						.collect(Collectors.joining(" "))
		);

		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		return edc.getNumFound();
	}

	//금일 예약어 탐지 현황 - 전체 건수
	public long getTodayKwdAiTotalCount(String todayStr, String adminId) throws SolrServerException, IOException {
		SolrQuery sq = new SolrQuery();
		String query = "+kwd:Y";
		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		return edc.getNumFound();
	}

	//금일 AI 서비스 예약어 탐지 (첨부파일 포함)  총 count
	public long getTodayKwdAttachAiTotalCount(String todayStr, String adminId) throws SolrServerException, IOException {
		SolrQuery sq = new SolrQuery();
		String query = "+attached:Y +kwd:Y ";
		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		return edc.getNumFound();
	}

	/**
	 * 금일 AI 서비스 사용량
	 */
	public TopGroupVO getTodayTop10AiStats(String todayStr, String adminId) throws IOException, SolrServerException {
		TopGroupVO topGroupVO = new TopGroupVO();
		SolrQuery sq = new SolrQuery();
		String query = "";
		sq.setStart(0);
		sq.setRows(0);
		sq.setParam("dashboard_work", "Y");
		sq.setParam("group.field", "svc12");
		sq.setParam("facet.field", "work");
		sq.setQuery(query);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		if (Common.isNotEmpty(edc.getPivotData())) {
			List<AiSvcInfo> allList = new ArrayList<>();
			List<AiSvcInfo> workList = new ArrayList<>();
			List<AiSvcInfo> nonWorkList = new ArrayList<>();

			for (Map<String, Object> row : edc.getPivotData()) {
				String filterKey = Common.nvl(row.get("filterKey"));
				String svc = Common.nvl(row.get("rowKey"));
				String svcNm = Config.getService12Lv2Nm(svc);
				String count = Common.nvl(row.get("total"));

				AiSvcInfo info = new AiSvcInfo();
				info.setSvc(svc);
				info.setSvcName(svcNm);
				info.setSvcCount(count);

				switch (filterKey) {
					case "workAll": allList.add(info); break;
					case "work": workList.add(info); break;
					case "nonWork": nonWorkList.add(info); break;
				}
			}

			topGroupVO.setAll(allList);
			topGroupVO.setWork(workList);
			topGroupVO.setNonWork(nonWorkList);
		}

		return topGroupVO;
	}

	/**
	 * 주간 AI 서비스 사용량
	 */
	public TopGroupVO getWeeklyTop10AiStats(String todayStr, String adminId) throws IOException, SolrServerException {
		TopGroupVO topGroupVO = new TopGroupVO();
		DateTimeFormatter formatter = DateTimeFormatter.BASIC_ISO_DATE;
		LocalDate today = LocalDate.parse(todayStr, formatter);
		String weekAgoStr = today.minusDays(6).format(formatter);
		SolrQuery sq = new SolrQuery();
		String query = String.format("+ctime_yyyymmdd:[%s TO %S] +direction_svc:O +svc:I*", weekAgoStr, todayStr);
		sq.setStart(0);
		sq.setRows(0);
		sq.setParam("dashboard_work", "Y");
		sq.setParam("group.field", "svc12");
		sq.setParam("facet.field", "work");
		sq.setQuery(query);
		String indics;
		if (todayStr.substring(0, 6).equals(weekAgoStr.substring(0, 6))) indics = "edc_w_" + todayStr.substring(0, 6);
		else indics = "edc_w_" + weekAgoStr.substring(0, 6) + ",edc_w_" + todayStr.substring(0, 6);

		sq.setParam("indics", indics);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		if (Common.isNotEmpty(edc.getPivotData())) {
			List<AiSvcInfo> allList = new ArrayList<>();
			List<AiSvcInfo> workList = new ArrayList<>();
			List<AiSvcInfo> nonWorkList = new ArrayList<>();

			for (Map<String, Object> row : edc.getPivotData()) {
				String filterKey = Common.nvl(row.get("filterKey"));
				String svc = Common.nvl(row.get("rowKey"));
				String svcNm = Config.getService12Lv2Nm(svc);
				String count = Common.nvl(row.get("total"));

				AiSvcInfo info = new AiSvcInfo();
				info.setSvc(svc);
				info.setSvcName(svcNm);
				info.setSvcCount(count);

				switch (filterKey) {
					case "workAll": allList.add(info); break;
					case "work": workList.add(info); break;
					case "nonWork": nonWorkList.add(info); break;
				}
			}

			topGroupVO.setAll(allList);
			topGroupVO.setWork(workList);
			topGroupVO.setNonWork(nonWorkList);
		}

		return topGroupVO;
	}

	/**
	 * 금일 AI 서비스 사용 시간대별 차트
	 */
	public List<AiTimeStat> getTodayAiSvcTimeStats(String todayStr, String adminId) throws IOException, SolrServerException {

		List<AiTimeStat> timeStats = new ArrayList<>();
		SolrQuery sq = new SolrQuery();
		String query = "";
		sq.setStart(0);
		sq.setRows(0);
		sq.setFacet(true);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setParam("facet.pivot", "ctime" + "," + "svc12");
		sq.setQuery(query);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		List<String> pivotHeaders = edc.getPivotHeader();

		for (Map<String, Object> map : edc.getPivotData()) {
			if (Common.isEmpty(map)) continue;
			String rowKey = (String) map.get("rowKey");
			for (String pivot : pivotHeaders) {
				if (map.containsKey(pivot)) {
					AiTimeStat vo = new AiTimeStat();
					vo.setDate(rowKey.substring(0, 8));
					vo.setHour(rowKey.substring(8, 10));
					vo.setMinute(rowKey.substring(10, 12));
					vo.setSvc(pivot);
					vo.setSvcName(Config.getService12Lv2Nm(pivot));
					vo.setSvcCount(String.valueOf(map.get(pivot)));

					timeStats.add(vo);
				}
			}
		}
		return timeStats;
	}


	/**
	 * 금일 TOP 10 유저별 AI 현황
	 */
	public List<AiUser> getTodayTop10UserStats(String todayStr, String adminId) throws IOException, SolrServerException {
		List<AiUser> aiUsers = new ArrayList<>();
		SolrQuery sq = new SolrQuery();
		String query = "";
		sq.setRows(0);
		sq.setFacet(true);
		sq.setFacetLimit(10);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setParam("facet.pivot", "sender_str" + "," + "svc12");
		sq.setQuery(query);
		sq.setRows(0);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		List<String> pivotHeaders = edc.getPivotHeader();

		for (Map<String, Object> map : edc.getPivotData()) {
			if (Common.isEmpty(map)) continue;
			String rowKey = (String) map.get("rowKey");
			AiUser vo = new AiUser();
			vo.setUserId(rowKey);
			vo.setUserNm((String) map.get("name2"));
			vo.setDeptNm((String) map.get("deptnm"));
			vo.setJikgubNm((String) map.get("jikgubnm"));
			List<AiSvcInfo> svclist = new ArrayList<>();
			for (String pivot : pivotHeaders) {
				if (map.containsKey(pivot)) {
					AiSvcInfo svcInfo = new AiSvcInfo();
					svcInfo.setSvc(pivot);
					svcInfo.setSvcName(Config.getService12Lv2Nm(pivot));
					svcInfo.setSvcCount(String.valueOf(map.get(pivot)));
					svclist.add(svcInfo);
				}
			}
			vo.setSvcInfos(svclist);
			aiUsers.add(vo);
		}
		return aiUsers;

	}


	/**
	 * 금일 TOP 10 AI 서비스 (예약어 포함 발신)사용 유저
	 */
	public List<AiUser> getTodayTop10KwdUserStats(String todayStr, String adminId) throws IOException, SolrServerException {
		List<AiUser> userList = new ArrayList<>();
		SolrQuery sq = new SolrQuery();

		String query = "+kwd:Y";
		sq.setRows(0);
		sq.setStart(0);
		sq.setFacet(true);
		sq.setFacetLimit(10);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		sq.setParam("facet.pivot", "sender_str" + "," + "kwds");
		sq.setQuery(query);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		List<String> pivotHeaders = edc.getPivotHeader();

		for (Map<String, Object> map : edc.getPivotData()) {
			if (map.isEmpty()) continue;
			String rowKey = (String) map.get("rowKey");
			AiUser vo = new AiUser();
			vo.setUserId(rowKey);
			vo.setUserNm((String) map.get("name2"));
			vo.setDeptNm((String) map.get("deptnm"));
			vo.setJikgubNm((String) map.get("jikgubnm"));
			List<AiKwdInfo> kwdList = new ArrayList<>();
			for (String pivot : pivotHeaders) {
				if (map.containsKey(pivot)) {
					AiKwdInfo kwdInfo = new AiKwdInfo();
					kwdInfo.setKwd(pivot);
					kwdInfo.setKwdName(pivot);
					kwdInfo.setKwdCount(String.valueOf(map.get(pivot)));
					kwdList.add(kwdInfo);
				}
			}
			vo.setKwdInfos(kwdList);
			userList.add(vo);
		}

		return userList;
	}

	/**
	 * 금일 TOP 10 AI 서비스 (개인정보 포함 발신)사용 유저
	 */
	public List<AiUser> getTodayTop10PiUserStats(String todayStr, String adminId) throws IOException, SolrServerException {

		List<AiUser> aiUserList = new ArrayList<>();
		String[] aggsFields = Arrays.stream(Config.activePrivatePatterns)
				.filter(s -> s != null && !s.trim().isEmpty())
				.map(s -> "pi_amount.pi_" + s)
				.toArray(String[]::new);

		SolrQuery sq = new SolrQuery();

		String query = "";

		query += " +(";
		for (String s : aggsFields) {
			query += " (" + s + ":[1 TO *] )";
		}
		query += ")";
		sq.setQuery(query);

		sq.setStart(0);
		sq.setRows(0);
		sq.setFacetSort("count");
		sq.addFacetField(aggsFields);
		sq.setParam("group.field", aggsFields);
		sq.setParam("facet.field", "sender_str");
		sq.setParam("abnlYn", "Y");
		sq.setFacetMinCount(1);
		sq.setFacetLimit(10);
		setIndexQuery(todayStr, sq);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, adminId);
		List<String> pivotHeaders = edc.getPivotHeader();

		for (Map<String, Object> map : edc.getPivotData()) {
			if (map.isEmpty()) continue;
			String rowKey = (String) map.get("rowKey");

			AiUser vo = new AiUser();
			vo.setUserId(rowKey);
			vo.setUserNm((String) map.get("name2"));
			vo.setDeptNm((String) map.get("deptnm"));
			vo.setJikgubNm((String) map.get("jikgubnm"));

			List<AiPiInfo> piList = new ArrayList<>();

			for (String pivot : pivotHeaders) {
				if (!map.containsKey(pivot)) continue;
				String count = String.valueOf(map.get(pivot));
				if (Common.isEquals(count, "0")) continue;

				AiPiInfo piInfo = new AiPiInfo();
				piInfo.setPi(pivot);
				piInfo.setPiCount(count);
				piInfo.setPiName(patterName(pivot));

				piList.add(piInfo);
			}
			vo.setPiInfos(piList);
			aiUserList.add(vo);
		}
		return aiUserList;

	}

	public String patterName(String pi) {
		String code = pi.substring(13);
		return PATTERN_MAP.get(code);
	}

}