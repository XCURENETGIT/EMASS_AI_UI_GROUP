package com.xcurenet.emass.analysis.service.impl;

import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.SolrQueryString;
import com.xcurenet.emass.analysis.service.*;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.SolrServerException;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AnalysisRelationServiceImpl extends XcnAbstractDAO implements AnalysisRelationService {

	@Autowired
	private SolrEdcService solrEdcService;


	@Override
	public AnalysisRelationListVO dataRelationList(SearchVO searchVO) throws IOException, SolrServerException {

		SolrQuery sq = new SolrQuery();
		SolrQueryString query = dataRelationQuery(searchVO);

		String field = "attachname_str";
		if (searchVO.getUnit().equals("mailid") || searchVO.getUnit().equals("messenger")) {
			field = "sender_str";
		}

		/* 문서 결과 표시 X */
		sq.setStart(0);
		sq.setRows(1);

		//{result:{type : terms, offset: 0,limit : 100,field : attachname_str,sort:"size desc", facet:{size : "sum(size)"}} }
		sq.setSort("size", ORDER.desc);

		/* main aggregations field */
		sq.setParam("group", true);
		sq.setParam("group.field", field);
		/* sub aggregations field */
		sq.setParam("facet.field", "attachsize");
		sq.setParam("facet.offset", String.valueOf(searchVO.getOffset()));
		sq.setParam("facet.limit", String.valueOf(searchVO.getLimit()));
		sq.setFacetMinCount(1);
		sq.setParam("facet.sum", true);
		sq.setParam("facet.sort", true);

		sq.addFilterQuery("-svc:(X* U*)");
		sq.setQuery(query.toString());

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, searchVO.getAdminId());

		AnalysisRelationListVO list = new AnalysisRelationListVO(edc);
		return list;
	}

	private SolrQueryString dataRelationQuery(SearchVO searchVO) {
		SolrQueryString query = new SolrQueryString();
		query.addRange("ctime_yyyymmdd", searchVO.getStartDate().replaceAll("-", ""), searchVO.getEndDate().replaceAll("-", ""), false)
				.add("subject", searchVO.getTitle(), true, true)
				.add(new String[]{"sender_str", "sname"}, searchVO.getSendUser())
				.add(new String[]{"recvs", "recvs_name", "cc", "cname", "bcc"}, searchVO.getReceiveUser())
				.add(new String[]{"sender_str", "sname", "recvs", "recvs_name", "cc", "cname", "bcc"}, searchVO.getObservePersonnel())
				.add(new String[]{"sender_str", "sname", "recvs", "recvs_name", "cc", "cname", "bcc"}, searchVO.getKeyPersonnel())
				.add("kwds", searchVO.getKeyword());
		switch (searchVO.getUnit()) {
			case "file":
				query.addRange("attachsize", (Common.isEmpty(searchVO.getFileSize()) ? 0 : searchVO.getFileSize() * 1024 * 1024), "*");
				query.add("attachname_str",searchVO.getListData());
				break;
			case "messenger":
				query.add(new String[]{"sender_str", "sname", "recvs", "recvs_name", "cc", "cname", "bcc"}, searchVO.getListData());
				query.add("svc1", "Q");
				break;
			case "mailid":
				query.add(new String[]{"sender_str", "sname", "recvs", "recvs_name", "cc", "cname", "bcc"}, searchVO.getListData());
				query.and().beforeParen().add("svc1", "W", false).or().add("svc1", "M", false).or().add("svc12", "EMM", false).afterParen();
				break;
		}

		query.add(setInterestGroupQuery(searchVO.getInterGroup()));
		return query;
	}

	@Override
	public List<SolrEdcVO> dataDetailList(SearchVO searchVO) throws IOException, SolrServerException {

		SolrQueryString query = dataRelationQuery(searchVO);

		SolrQuery sq = new SolrQuery();
		sq.setQuery(query.toString());
		sq.setRows(Common.MAX_VALUE);
		sq.addFilterQuery("-svc:(X* U*)");
		sq.setFields("msgid", "svc", "srcip", "sport", "dstip", "dport", "ctime", "body_size", "host", "path", "subject", "body_snippet", "sender", "sname", "recvs", "recvs_name", "attached", "attachname", "attachhash");

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, searchVO.getAdminId());

		return edc.getEmass();
	}

//	public static void main(String[] args) throws IOException, SolrServerException {
//		ApplicationContext context = new ClassPathXmlApplicationContext("com/spring/context-*.xml");
//		SolrConnection sc = (SolrConnection) context.getBean("emassSolrClient");
//
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery("+ctime_yyyymmdd:[20171220 TO 20171220] +attachsize:[0 TO *] +attachname_str:sgim_url.zip");
//		sq.setRows(Common.MAX_VALUE);
//		sq.setFields("msgid", "svc", "srcip", "sport", "dstip", "dport", "ctime", "body_size", "host", "path", "subject", "body_snippet", "sender", "sname", "recvs", "recvs_name", "attached", "attachname", "attachhash");
//
//		QueryResponse resp = sc.getSolrServer().query(sq, METHOD.POST);
//		log.info(String.valueOf(resp.getResults().getNumFound()));
//	}

	@Override
	public SolrEdcMessageVO dataSelectList(SearchVO searchVO) throws IOException, SolrServerException {

		log.info(searchVO.toString());

		SolrQueryString query = dataRelationQuery(searchVO);
		String name = Common.nvl(searchVO.getIp());
		if (name.indexOf(":") > -1) name = "\"" + name + "\"";
		query.add(new String[]{"sender_str", "recvs", "srcip", "dstip"}, name);

		SolrQuery sq = new SolrQuery();
		log.info(query.toString());
		sq.setQuery(query.toString());
		//		sq.setFields("msgid", "subject", "kwds_subject", "body", "kwds_body", "attachname_str", "kwds_attachname", "attach", "kwds_attach", "host_str", "path", "srcip", "dstip", "sender_str", "recvs", "to", "bcc", "usr_id");

		sq.setStart(Common.nvz(searchVO.getOffset(), 0));
		sq.setRows(Common.nvz(searchVO.getLimit(), 100));
		sq.addFilterQuery("-svc:(X* U*)");

		SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, searchVO.getAdminId(), "", null);

		return solrVo;
	}


	@Override
	public List<UsageChartVO> selectUsageChart(SearchVO searchVO) throws Exception {
		searchVO.setStartDate(searchVO.getStartDate().replaceAll("-", "") + "00");
		searchVO.setEndDate(searchVO.getEndDate().replaceAll("-", "") + "23");

		List<UsageChartSchedulerVO> dataList = new ArrayList<>();
		List<UsageChartSchedulerVO> dataAverageList = new ArrayList<>();
		UsageChart usageChart = new UsageChart();
		List<UsageChartVO> usageChartList = new ArrayList<>();
		switch (searchVO.getUnit()) {
			case "t":
				dataList = getTime(searchVO);
				dataAverageList = getTimeAverage(searchVO);
				usageChartList = usageChart.timeDataProcessingScheduler(dataList, dataAverageList, searchVO);
				break;
			case "d":
				dataList = getDay(searchVO);
				dataAverageList = getDayAverage(searchVO);
				usageChartList = usageChart.dayDataProcessingScheduler(dataList, dataAverageList, searchVO);
				break;
			case "w":
				dataList = getWeek(searchVO);
				dataAverageList = getWeekAverage(searchVO);
				usageChartList = usageChart.weekDataProcessingScheduler(dataList, dataAverageList, searchVO);
				break;
			case "m":
				dataList = getMonth(searchVO);
				dataAverageList = getMonthAverage(searchVO);
				usageChartList = usageChart.monthDataProcessingScheduler(dataList, dataAverageList, searchVO);
				break;
		}

		return usageChartList;
	}


	@Override
	public AnalysisRelationListVO selectUsageList(SearchVO searchVO) throws Exception {

		log.info(searchVO.toString());
		SolrQueryString query = new SolrQueryString();
		SolrQuery sq = new SolrQuery();
		String date = searchVO.getDate().replaceAll("-", "").replaceAll(" ", "").replaceAll("시", "").replaceAll("Hour", "");

		/* 문서 결과 표시 X */
		sq.setStart(0);
		sq.setRows(1);
		sq.setSort("size", ORDER.desc);

		//시간으로 분류
		switch (searchVO.getUnit()) {
			case "t":
				query.add("ctime_yyyymmdd", date.substring(0, 8));
				query.add("ctime_hh", date.substring(8, 10));
				break;
			case "d":
				query.add("ctime_yyyymmdd", date);
				break;
			case "w":
				Calendar calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, 1);
				calendar.set(Calendar.WEEK_OF_MONTH, Integer.parseInt(date.substring(6, 7)));

				String d = Common.getDateTime(calendar.getTimeInMillis(), "yyyyMMdd");
				UsageChart usageChart = new UsageChart();
				String startDate = usageChart.firstDateOfWeek(d);
				query.addRange("ctime_yyyymmdd", startDate, Common.plusDays(startDate, 6), false);
				break;
			case "m":
				query.add("ctime_yyyymm", date, false);
				break;
		}

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("facet", true);
		sq.setParam("facet.sum", true);
		sq.setParam("facet.offset", "0");
		sq.setParam("facet.limit", "100");
		sq.setFacetMinCount(1);


		switch (searchVO.getItem()) {
			case "fileSize":
				query.add("attached", "Y");
				sq.setParam("group.field", "attachname_str");
				sq.setParam("facet.field", "attachsize");
				sq.setFacetSort("attachcnt");
				sq.setFields("attachname_str");
				break;
			//웹 메일 수
			case "outMail":
				query.add("svc", "W*", true);
				sq.setParam("group.field", "sender_str");
				sq.setParam("facet.field", "size");
				sq.setFacetSort("size");
				sq.setFields("sender_str");
				break;
			//메일수
			case "inMail":
				query.and().beforeParen().add("svc", "M*", false).or().add("svc", "EMM*", false).afterParen();
				sq.setParam("group.field", "sender_str");
				sq.setParam("facet.field", "size");
				sq.setFacetSort("size");
				sq.setFields("sender_str");
				break;
			case "ftp":
				query.add("svc", "F*", true);
				sq.setParam("group.field", "srcip");
				sq.setParam("facet.field", "size");
				sq.setFacetSort("size");
				sq.setFields("srcip");
				break;
			case "totalSize":
				sq.setParam("group.field", "srcip");
				sq.setParam("facet.field", "size");
				sq.setFacetSort("size");
				sq.setFields("srcip");
				break;
		}
		sq.setQuery(String.valueOf(query));

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, searchVO.getAdminId());
		AnalysisRelationListVO list = new AnalysisRelationListVO(edc);
		return list;
	}

	@Override
	public JSONObject selectDetailList(SearchVO searchVO, String chartName) throws Exception {
		SolrQueryString query = new SolrQueryString();
		SolrQuery sq = new SolrQuery();

		String date = searchVO.getDate();

		sq.setRows(0);
		sq.setSort("size", ORDER.desc);

		switch (searchVO.getUnit()) {
			case "t":
				query.add("ctime_yyyymmdd", date.substring(0, 8), false).add("ctime_hh", date.substring(8, 10));

				break;
			case "d":
				query.add("ctime_yyyymmdd", date, false);
				break;
			case "w":
				Calendar calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, 1);
				calendar.set(Calendar.WEEK_OF_MONTH, Integer.parseInt(date.substring(6, 7)));

				String d = Common.getDateTime(calendar.getTimeInMillis(), "yyyyMMdd");
				UsageChart usageChart = new UsageChart();
				String startDate = usageChart.firstDateOfWeek(d);
				query.addRange("ctime_yyyymmdd", startDate, Common.plusDays(startDate, 6), false);

				break;
			case "m":
				query.add("ctime_yyyymm", date, false);

				break;
		}


		switch (searchVO.getItem()) {
			case "fileSize":
				query.add("attached", "Y");
				query.add("attachname_str", searchVO.getKeyword());

				break;
			case "outMail":
				query.and().beforeParen().add("svc", "PM*", false).or().add("svc", "W*", false).afterParen();
				query.add("sender_str", searchVO.getKeyword());

				break;
			case "inMail":
				query.and().beforeParen().add("svc", "PM*", false).or().add("svc", "M*", false).or().add("svc", "EMM*", false).afterParen();
				query.add("sender_str", searchVO.getKeyword());

				break;
			case "ftp":
				query.add("svc", "F*", true);
				query.add("srcip", searchVO.getKeyword());

				break;
			case "totalSize":
				query.add("srcip", searchVO.getKeyword());
				break;
		}

		sq.setQuery(query.toString());

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, searchVO.getAdminId());
		JSONObject json = new JSONObject();
		json.put("list", edc.getEmass());
		json.put("chart", null);
		json.put("total", edc.getNumFound());


		return json;
	}

	@Override
	public String getLastTime() throws Exception {
		String lastTime = selectOne("com.xcurenet.sqlmap.mappers.mysql.analysis.getLastTime");

		if (lastTime == null) {
			SolrQuery sq = new SolrQuery();

			sq.setQuery("*:*");
			sq.setRows(1);
			sq.setFields("ctime");
			sq.setSort("ctime", ORDER.asc);

			SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, null);
			List<SolrEdcVO> solrEdcVO = edc.getEmass();

			if (solrEdcVO.size() > 0) {
				lastTime = solrEdcVO.get(0).getCtime().substring(0, 10);
			} else {
				long time = System.currentTimeMillis();
				DateTimeFormatter date = DateTimeFormat.forPattern("yyyyMMddHH");
				lastTime = Common.plusHour(date.print(time), -2);
			}
		}

		return Common.plusHour(lastTime, 1);
	}

	@Override
	public List<UsageChartSchedulerVO> getTime(SearchVO searchVO) throws SolrServerException {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getTime", searchVO);
	}

	@Override
	public List<UsageChartSchedulerVO> getDay(SearchVO searchVO) throws SolrServerException {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getDay", searchVO);
	}

	@Override
	public List<UsageChartSchedulerVO> getMonth(SearchVO searchVO) throws SolrServerException {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getMonth", searchVO);
	}

	@Override
	public List<UsageChartSchedulerVO> getWeek(SearchVO searchVO) throws SolrServerException {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getWeek", searchVO);
	}

	@Override
	public int insertUsageCompare(List<UsageChartSchedulerVO> list) throws SolrServerException {
		if (list.size() > 0) {
			return insert("com.xcurenet.sqlmap.mappers.mysql.analysis.insertUsageCompare", list);
		} else {
			return 0;
		}
	}

	public List<UsageChartSchedulerVO> getTimeAverage(SearchVO searchVO) throws SolrServerException {
		SearchVO averageSearchVO = copySearchVO(searchVO);
		String startDate = getDate(averageSearchVO.getStartDate());
		int diff = Common.diffOfDate(startDate, getDate(averageSearchVO.getEndDate()));
		averageSearchVO.setStartDate(Common.plusDays(startDate, -70 - diff) + "00");
		averageSearchVO.setEndDate(Common.plusDays(startDate, -1) + "23");
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getTimeAverage", averageSearchVO);
	}

	public List<UsageChartSchedulerVO> getDayAverage(SearchVO searchVO) throws SolrServerException {
		SearchVO averageSearchVO = copySearchVO(searchVO);
		String startDate = getDate(averageSearchVO.getStartDate());
		int diff = Common.diffOfDate(startDate, getDate(averageSearchVO.getEndDate()));
		averageSearchVO.setStartDate(Common.plusDays(startDate, -70 - diff) + "00");
		averageSearchVO.setEndDate(Common.plusDays(startDate, -1) + "23");
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getDayAverage", averageSearchVO);
	}

	public List<UsageChartSchedulerVO> getWeekAverage(SearchVO searchVO) throws SolrServerException {
		SearchVO averageSearchVO = copySearchVO(searchVO);
		String startDate = getDate(averageSearchVO.getStartDate());
		int diff = Common.diffOfDate(startDate, getDate(averageSearchVO.getEndDate())) / 7;
		averageSearchVO.setStartDate(Common.plusWeek(startDate, -10 - diff) + "00");
		averageSearchVO.setEndDate(Common.plusDays(startDate, -1) + "23");
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getWeekAverage", averageSearchVO);
	}

	public List<UsageChartSchedulerVO> getMonthAverage(SearchVO searchVO) throws SolrServerException {
		SearchVO averageSearchVO = copySearchVO(searchVO);
		String startDate = getDate(averageSearchVO.getStartDate());
		int diff = Common.diffOfMonth(startDate.substring(0, 6), getDate(averageSearchVO.getEndDate()).substring(0, 6));
		averageSearchVO.setStartDate(Common.plusMonth(startDate, -10 - diff) + "00");
		averageSearchVO.setEndDate(Common.plusDays(startDate, -1) + "23");
		return selectList("com.xcurenet.sqlmap.mappers.mysql.analysis.getMonthAverage", averageSearchVO);
	}

	@Override
	public AnalysisFreedomListVO freedomView(FreedomSearchVO freedomSearchVO) throws IOException, SolrServerException {
		String[] column = freedomSearchVO.getColumn();
		String[] groupData = freedomSearchVO.getGroupData();

		SolrQuery sq = new SolrQuery();

		//젤 첫번째 애들
		String freddDomQuery = changeQuery(getFreedomQuery(freedomSearchVO));
		sq.setQuery(freddDomQuery);

		// column 중복 제거.
		List<String> columnList = new ArrayList<>();
		for (int i = 0; i < column.length; i++) {
			if (!columnList.contains(column[i])) {
				columnList.add(column[i]);
			}
		}

		/* 문서 결과 표시 X */
		sq.setStart(0);
		sq.setRows(1);

		/* 컬럼 */
		/* Main Aggregations param  */
		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.field", columnList.stream().collect(Collectors.joining(",")));
		sq.setParam("facet.mincount", "0");
		sq.setParam("facet.field", groupData[0]);
		sq.setParam("facet.stats", groupData[0]);
		sq.setParam("facet", true);

		/* 데이터 */
//		for(String group  : groupBy) {
//			if (("sum").equals(group)) sq.setParam("facet.sum", true);
//			if (("avg").equals(group)) sq.setParam("facet.avg", true);
//			if (("min").equals(group)) sq.setParam("facet.min", true);
//			if (("max").equals(group)) sq.setParam("facet.max", true);
//			if (("count").equals(group)) sq.setParam("facet.count", true);
//		}

		sq.setFacetMinCount(1);
		sq.setStart(Common.nvz(0));
		sq.setRows(Common.nvz(1));
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, freedomSearchVO.getAdminId());

		return new AnalysisFreedomListVO(edc, columnList.size());
	}

	public String changeQuery(String freddDomQuery) {
		String result = "";

		//괄호가 있는 경우
		if (freddDomQuery.contains("(")) {
			List<Integer> bracketSttInd = new ArrayList<>();
			List<Integer> bracketEndInd = new ArrayList<>();

			//괄호 index 체크
			for (int i = 0; i < freddDomQuery.length(); i++) {
				char query = freddDomQuery.charAt(i);
				if (Common.isEquals('(', query)) bracketSttInd.add(i);
				else if (Common.isEquals(')', query)) bracketEndInd.add(i);
			}

			if (freddDomQuery.contains("-") && !freddDomQuery.contains("&&")) {
				result = splitQuery(freddDomQuery.replaceAll("[(]", "").replaceAll("[)]", ""));
			} else if (bracketSttInd.size() == 1) {
				result = freddDomQuery;

				String query = freddDomQuery.substring(bracketSttInd.get(0) + 1, bracketEndInd.get(0)); // 괄호안의 내용
				if (query.contains("-") && query.contains("||")) {
					if (bracketSttInd.get(0) == 0) {
						result = splitQuery(query) + freddDomQuery.substring(bracketEndInd.get(0) + 1);
					} else {
						result = freddDomQuery.substring(0, bracketSttInd.get(0)) + splitQuery(query);
					}
				}

			} else if (bracketSttInd.size() > 1) {
				for (int i = 0; i < bracketSttInd.size(); i++) {
					String query = freddDomQuery.substring(bracketSttInd.get(i) + 1, bracketEndInd.get(i));
					String seprator = "";
					if (i != bracketSttInd.size() - 1) {
						seprator = freddDomQuery.substring(bracketEndInd.get(i) + 1, bracketSttInd.get(i + 1));
					}

					query = splitQuery(query);
					if (!query.contains("(")) {
						result += "(" + splitQuery(query) + ")" + seprator;
					} else {
						result += splitQuery(query) + seprator;
					}
				}
			}
		} else { //괄호가 없는 경우
			result = splitQuery(freddDomQuery);
		}

		//IN절인경우 원복
		if (result.contains("<")) result = result.replaceAll("<", "(").replaceAll(">", ")");
		return result;
	}

	private String splitQuery(String freddDomQuery) {
		String result = "";
		String[] querys = freddDomQuery.split("&&");
		for (int i = 0; i < querys.length; i++) {
			String query = querys[i];
			if (query.contains("-") && query.contains("||")) {
				List<String> q = Arrays.asList(query.split("\\|\\|"));
				result += "-(";
				List<String> tmpq = new ArrayList<>();

				for (int j = 0; j < q.size(); j++) {
					String fv = q.get(j).trim();
					if (fv.startsWith("-")) {
						tmpq.add(fv.replace('-', ' '));
					} else if (fv.startsWith("+")) {
						tmpq.add(fv.replace('+', '-'));
					} else {
						tmpq.add("-" + fv);
					}
				}

				result += String.join(" && ", tmpq) + ")";
			} else {
//				result += String.join(" && ", query);
				if (querys.length - 1 == 0 || i == querys.length - 1) result += query;
				else if (i != querys.length - 1) result += query + " && ";
			}
		}
		return result;
	}

	@Override
	public SolrEdcMessageVO selectFreedomMessageList(FreedomSearchVO freedomSearchVO) throws IOException, SolrServerException {

		SolrQueryString query = new SolrQueryString();
		String freddDomQuery = getFreedomQuery(freedomSearchVO);
		freddDomQuery = changeQuery(freddDomQuery).concat(" && ").concat(freedomSearchVO.getQuery());
		query.justAdd(freddDomQuery);

		SolrQuery sq = new SolrQuery();
		log.info(query.toString());
		sq.setQuery(query.toString());

		sq.setStart(Common.nvz(freedomSearchVO.getOffset(), 0));
		sq.setRows(Common.nvz(freedomSearchVO.getLimit(), 100));

		SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, freedomSearchVO.getAdminId(), "", null);

		return solrVo;
	}

	@Override
	public String getFreedomQuery(FreedomSearchVO freedomSearchVO) {

		SolrQueryString query = new SolrQueryString();
		String[] andOr = freedomSearchVO.getAndOr();
		String[] beforePparen = freedomSearchVO.getBeforePparen();
		String[] termsColumn = freedomSearchVO.getTermsColumn();
		String[] compare = freedomSearchVO.getCompare();
		String[] context = freedomSearchVO.getContext();
		String[] sizeNum = freedomSearchVO.getSizeNum();
		String[] startDate = freedomSearchVO.getStartDate();
		String[] endDate = freedomSearchVO.getEndDate();
		String[] serviceCd = freedomSearchVO.getServiceCd();
		String[] afterPparen = freedomSearchVO.getAfterPparen();

		for (int i = 0; i < andOr.length; i++) {

			switch (Common.nvl(andOr[i])) {
				case "and":
					query.and();
					break;
				case "or":
					query.or();
					break;
			}

			if (Common.nvl(beforePparen[i]).equals("(")) {
				query.beforeParen();
			}

			if (Common.nvl(compare[i]).equals("!=")) {
				query.minus();
			}

			String column = Common.nvl(termsColumn[i]);
			if (column.equals("ctime_yyyymmdd")) {
				query.addRange(column, Common.nvl(startDate[i]).replaceAll("-", ""), Common.nvl(endDate[i]).replaceAll("-", ""), false);
			} else if (column.equals("svc")) {
				String service = Common.nvl(serviceCd[i]);
				switch (service.length()) {
					case 1:
						query.add("svc1", service, false);
						break;
					case 3:
						query.beforeParen().add("svc1", (service.length() > 1 ? service.substring(0, 1) : ""), false).and().add("svc2", (service.length() > 1 ? service.substring(1) : ""), false).afterParen();
						break;
					case 4:
						query.add("svc", service, false);
						break;
				}
			} else if (column.equals("size")) {
				int size = 0;
				if (Common.isNotEmpty(sizeNum[i])) {
					try {
						size = Integer.parseInt(sizeNum[i]) * 1024 * 1024;
					} catch (NumberFormatException e) {
						log.warn("데이터 자유 분석 조건에서 용량에 숫자가 아닌 데이터가 들어왔습니다.", e);
					}
				}
				query.addRange(column, size, "*", false, true, true);
			} else {
				String tmpContext = Common.nvl(context[i]);
				if (Common.isNotEmpty(tmpContext)) {
					boolean startIncludeYN = true;
					boolean endIncludeYN = true;
					String start = "*";
					String end = "*";
					switch (compare[i]) {
						case "=":
						case "!=":
							query.add(column, tmpContext, false);
							break;
						case ">":
							startIncludeYN = false;
						case ">=":
							start = tmpContext;
							query.addRange(column, start, end, false, startIncludeYN, endIncludeYN);
							break;
						case "<":
							endIncludeYN = false;
						case "<=":
							end = tmpContext;
							query.addRange(column, start, end, false, startIncludeYN, endIncludeYN);
							break;
						case "IN":
							List<Object> textList = new ArrayList<>(Arrays.asList(tmpContext.split("\\s*,\\s*")));
							query.add(column, textList, false);
							//query.add(column, textList, false);
							break;
					}
				}
			}

			if (afterPparen[i].equals(")")) {
				query.afterParen();
			}
		}

		return query.toString();
	}

	private StringBuilder bucketsSetting(int currCount, List<String> columnList, String[] groupBy, String[] groupData, int asciiForLowerA) {
		StringBuilder sb = new StringBuilder();
		sb.append("{type : terms, limit : ").append(Common.MAX_VALUE).append(",field : ");
		sb.append(columnList.get(currCount++)).append(", facet:{");
		if (columnList.size() > currCount) {
			sb.append(String.valueOf((char) (asciiForLowerA))).append(" : ").append(bucketsSetting(currCount, columnList, groupBy, groupData, asciiForLowerA + 1)).append(", ");
		}
		for (int j = 0; j < groupBy.length; j++) {
			String col = "temp";
			String groupName = "max";
			if (!groupBy[j].equals("count")) {
				col = groupBy[j];
				groupName = groupBy[j];
			}
			sb.append(col).append(":\"").append(groupName).append("(").append(groupData[j]).append(")\"");
			if (j < groupBy.length - 1) {
				sb.append(", ");
			}
		}
		sb.append("}}");

		return sb;
	}

	private String getDate(String date) {
		return date.replaceAll("-", "").substring(0, 8);
	}

	private SearchVO copySearchVO(SearchVO searchVO) {
		SearchVO copySearchVO = new SearchVO();
		copySearchVO.setItem(searchVO.getItem());
		copySearchVO.setStartDate(searchVO.getStartDate());
		copySearchVO.setEndDate(searchVO.getEndDate());
		return copySearchVO;
	}

	private String setInterestGroupQuery(String interGroup) {
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		solrCreateQuery.setInterestUserGroup(interGroup, "N");
		String q = solrCreateQuery.getQueryBuffer().toString();
		solrCreateQuery.setQueryBuffer(new StringBuilder());
		return q;
	}

	@Override
	public Map<String, String> plusHour(String targetDate, int start, int end) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("targetDate", targetDate);
		param.put("start", start);
		param.put("end", end);
		return selectOne("com.xcurenet.sqlmap.mappers.mysql.analysis.plusHour", param);
	}


}
