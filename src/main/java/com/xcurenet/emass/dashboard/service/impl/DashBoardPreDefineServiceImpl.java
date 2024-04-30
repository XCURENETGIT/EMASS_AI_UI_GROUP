package com.xcurenet.emass.dashboard.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.device.service.DeviceTrafficStatService;
import com.xcurenet.emass.dashboard.service.*;
import com.xcurenet.emass.message.service.FacetVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.emass.service.service.ServiceGroupVO;
import com.xcurenet.minio.MinioFileAdapter;
import lombok.extern.log4j.Log4j2;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Log4j2
@Service("dashBoardPreDefineService")
public class DashBoardPreDefineServiceImpl implements DashBoardPreDefineService {

	@Resource
	public MinioFileAdapter minioFileAdapter;

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource(name = "deviceTrafficStatService")
	private DeviceTrafficStatService deviceTrafficStatService;


	private static final String ABBREVIATION = "ui.dashboard.abbreviation";

	private final static String FACET_QUERY = "{result: {type: terms,limit: -1,field: \"user_str\",sort: \"count desc\",facet: {pi_amount.pi__SN:\"sum(pi_amount.pi__SN)\", pi_amount.pi__PN:\"sum(pi_amount.pi__PN)\", pi_amount.pi__DN:\"sum(pi_amount.pi__DN)\", pi_amount.pi__FN:\"sum(pi_amount.pi__FN)\", pi_amount.pi__CN:\"sum(pi_amount.pi__CN)\"}}}";


	@Override
	public TodayDataStatusVO getTodayDataStatus(TodayDataStatusVO todayDataStatusVO) throws IOException, SolrServerException {
		TodayDataStatusVO result = new TodayDataStatusVO();
		SolrQuery sq = new SolrQuery();

		List<Integer> rangeValues = Arrays.stream(todayDataStatusVO.getRange().split(","))
				.map(value -> Integer.parseInt(value))  // 수정된 부분
				.collect(Collectors.toList());

		// 결과값 계산
		List<Integer> results = multiply1024ForList(rangeValues);



		sq.addFacetField("attachtype");
		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "attachtype");

		sq.setParam("facet", true);
		sq.setParam("facet.field", "attachsize");
		sq.setParam("facet.ranges", todayDataStatusVO.getRange());

		sq.setParam("facet.limit", "-1");
		sq.setParam("facet.mincount", "1");

		sq.setFacetLimit(-1);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setQuery("+attached:Y");
		sq.setStart(Common.nvz(0));
		sq.setRows(Common.nvz(1));
		sq.setSort("ctime", SolrQuery.ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id");
		sq.setQuery(String.format("+ctime:[%s TO %s]", todayDataStatusVO.getStartDt(), todayDataStatusVO.getEndDt()));

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, todayDataStatusVO.getAdminId());
		result.setPivotData(edc.getPivotData());

		return result;
	}

	private static List<Integer> multiply1024ForList(List<Integer> values) {
		// 리스트에 있는 모든 값에 1024를 곱하는 계산을 수행하도록 하겠습니다.
		return values.stream()
				.map(value -> value * 1024)
				.collect(Collectors.toList());
	}

	@Override
	public TodayNotWorkVO getTodayNotWork(TodayNotWorkVO vo) throws SolrServerException, IOException {
		TodayNotWorkVO result = new TodayNotWorkVO();

		String query = String.format("+ctime:[%s TO %s] +work:R", vo.getStartDt(), vo.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, vo.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		return result;
	}


	@Override
	public PatternPrivacyVO getTodayPatternPrivacy(PatternPrivacyVO patternPrivacyVO) throws IOException, SolrServerException {
		PatternPrivacyVO result = new PatternPrivacyVO();

		String query = String.format("+ctime:[%s TO %s] +(pi_amount.pi_MN:[ 1 TO * ] pi_amount.pi_CN:[ 1 TO * ] pi_amount.pi_AN:[ 1 TO * ] pi_amount.pi_SN:[ 1 TO * ] pi_amount.pi_CRN:[ 1 TO * ] pi_amount.pi_DN:[ 1 TO * ] pi_amount.pi_FN:[ 1 TO * ] pi_amount.pi_PN:[ 1 TO * ] pi_amount.pi_SSN:[ 1 TO * ] pi_amount.pi_BRN:[ 1 TO * ] pi_amount.pi_CPN:[ 1 TO * ] pi_amount.pi_MCN:[ 1 TO * ])"
				, patternPrivacyVO.getStartDt(), patternPrivacyVO.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, patternPrivacyVO.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		sq.setQuery(query);
		sq.setRows(0);
		edc = solrEdcService.getEmassMessage(sq, patternPrivacyVO.getAdminId());
		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		return result;
	}


	@Override
	public TodayPatternVO getTodayPattern(TodayPatternVO vo) throws SolrServerException, IOException {
		TodayPatternVO result = new TodayPatternVO();

		String query = String.format("+ctime:[%s TO %s] +(%s:[ 1 TO * ])", vo.getStartDt(), vo.getEndDt(), vo.getPatternType());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, vo.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));;
		sq.setQuery(query);
		sq.setRows(0);

		return result;
	}



	@Override
	public RiskBehaviorVO getTodayRiskBehavior(RiskBehaviorVO riskBehaviorVO) throws IOException, SolrServerException {
		RiskBehaviorVO result = new RiskBehaviorVO();

		String query = String.format("+ctime:[%s TO %s] +(pi_amount.pi_EC:[ 1 TO * ] pi_amount.pi_EF:[ 1 TO * ] pi_amount.pi_ID:[ 1 TO * ])", riskBehaviorVO.getStartDt(), riskBehaviorVO.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, riskBehaviorVO.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));;
		sq.setQuery(query);
		sq.setRows(0);
//	    sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, riskBehaviorVO.getAdminId()));
		edc = solrEdcService.getEmassMessage(sq, riskBehaviorVO.getAdminId());
		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		return result;
	}

	@Override
	public KeywordDetectionVO getTodayKeywordDetection(KeywordDetectionVO keywordDetectionVO) throws IOException, SolrServerException {
		KeywordDetectionVO result = new KeywordDetectionVO();

		String query = String.format("+ctime:[%s TO %s]  +kwd:Y", keywordDetectionVO.getStartDt(), keywordDetectionVO.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, keywordDetectionVO.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));

		sq.setQuery(query);
		sq.setRows(0);
		edc = solrEdcService.getEmassMessage(sq, keywordDetectionVO.getAdminId());
		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		return result;
	}

	@Override
	public FileTopVO getTodayFileTop(FileTopVO vo) throws SolrServerException, IOException {
		FileTopVO result = new FileTopVO();
		String query = String.format("+ctime:[%s TO %s]  +attached:Y", vo.getStartDt(), vo.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setRows(10);
		sq.setSort("attachsize", SolrQuery.ORDER.desc);
		sq.setQuery(query);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, vo.getAdminId());
		List<String> filesize = new ArrayList<>();
		List<String> fileType = new ArrayList<>();
		List<String> fileName = new ArrayList<>();
		List<String> fileId = new ArrayList<>();

		for (SolrEdcVO solrEdcVO : edc.getEmass()) {
			filesize.add(solrEdcVO.getAttachSizeStr());
			fileType.add(solrEdcVO.getAttachtype().get(0));
			fileName.add(solrEdcVO.getAttachname().get(0));
			fileId.add(solrEdcVO.getMsgid());
		}
		result.setFileSize(filesize);
		result.setFileType(fileType);
		result.setFileName(fileName);
		result.setFileId(fileId);

		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));

		return result;
	}



	@Override
	public FileTopVO getTodayFilePerson(FileTopVO vo) throws SolrServerException, IOException {
		FileTopVO result = new FileTopVO();
		String query = String.format("+ctime:[%s TO %s]  +attached:Y", vo.getStartDt(), vo.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setSort("attachexistcnt", SolrQuery.ORDER.desc);
		sq.setRows(0);
		sq.setFacet(true);
		sq.addFacetField("sender_str");
		sq.setFacetSort("attachexistcnt");
		sq.setFacetLimit(10);
		sq.setFacetMinCount(1);
		sq.setQuery(query);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, vo.getAdminId());
		List<List<Object>> items = new ArrayList<>();
		if (edc.getFacet() == null) result.setFacet(items);
		else {
			for (FacetVO facetVO : edc.getFacet()) {
				List<Object> item = new ArrayList<>();
				item.add(facetVO.getName2());
				item.add(facetVO.getDeptnm());
				item.add(facetVO.getCount());
				item.add(facetVO.getName());
				item.add(facetVO.getUserId());
				item.add(facetVO.getEmail());

				items.add(item);
			}
		}
		result.setFacet(items);
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		return result;
	}

	@Override
	public XcnResponseVO getBodySize(BodySizeVO vo) throws Exception {
		String date = Common.getCurrentDate();
		String startDate = Common.plusDays(date, -7);
		String endDate = Common.plusDays(date, -1);


		SolrQuery sq = new SolrQuery();

		sq.setParam("group", true);
		sq.setParam("group.facet", true);
		sq.setParam("group.ngroups", true);
		sq.setParam("group.field", "ctime_yyyymmdd");

		sq.setParam("facet", true);
		sq.setParam("facet.sum", true);
		sq.setParam("facet.field", "size");

		sq.setParam("facet.limit", "7");
		sq.setParam("facet.mincount", "-1");
		sq.setFacetSort("ctime_yyyymmdd");

		sq.setFacetMinCount(1);
		sq.setQuery("*:*");
		sq.setStart(Common.nvz(0));
		sq.setRows(Common.nvz(1));
		sq.setSort("ctime_yyyymmdd", SolrQuery.ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id");
		sq.setQuery(String.format("+ctime_yyyymmdd:[ %s TO %s ]", startDate, endDate));

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, vo.getAdminId());

		List<Map<String, Object>> result = new ArrayList<>();

		long max = 0;
		if (edc.getPivotData()!= null) {
			for (int i = 0; i < edc.getPivotData().size(); i++) {
				Map<String, Object> item = new HashMap<>();
				item.put("date", edc.getPivotData().get(i).get("rowKey"));
				item.put("total", edc.getPivotData().get(i).get("total"));
				double doubleNum = (double) edc.getPivotData().get(i).get("size");
				long attach = (long) doubleNum;
				item.put("bodySize", attach);
				item.put("bodySizeStr", Common.convertFileSize(attach));
				if (attach > max) {
					max = attach;
				}
				result.add(item);
			}
		}
		result = result.stream().sorted((o1, o2) -> o1.get("date").toString().compareTo(o2.get("date").toString()) ).collect(Collectors.toList());
		return new XcnResponseVO(XcnRspCode.OK, result);
	}

	@Override
	public List<Map<String, Object>> getTrafficSize() throws Exception {
		String date = Common.getCurrentDate();
		String startDate = Common.plusDays(date, -7);
		String endDate = Common.plusDays(date, -1);
		List<Map<String, Object>> result = deviceTrafficStatService.getTrafficStatList_Day(startDate, endDate);

		List<Map<String, Object>> transformedData = new ArrayList<>();

		for (Map<String, Object> entry : result) {
			for (Map.Entry<String, Object> subEntry : entry.entrySet()) {
				String key = subEntry.getKey();
				if (key.matches("\\d{4}-\\d{2}-\\d{2}")) {
					String dateKey = subEntry.getKey();
					long num = (long) parseCount(subEntry.getValue());

					// Check if an entry for this date already exists
					boolean found = false;
					for (Map<String, Object> transformedEntry : transformedData) {
						if (dateKey.equals(transformedEntry.get("date"))) {
							// If entry for the date exists, update the value
							long currentNum = (long) transformedEntry.get("longNum");
							currentNum += num;
							transformedEntry.put("longNum", currentNum);
							transformedEntry.put("longNumStr", Common.convertFileSize(currentNum));
							found = true;
							break;
						}
					}

					// If no entry for this date exists, create a new one
					if (!found) {
						Map<String, Object> transformedEntry = new HashMap<>();
						transformedEntry.put("date", dateKey);
						transformedEntry.put("longNum", num);
						transformedEntry.put("longNumStr", Common.convertFileSize(num));
						transformedData.add(transformedEntry);
					}
				}
			}
		}
		transformedData = transformedData.stream().sorted((o1, o2) -> o1.get("date").toString().compareTo(o2.get("date").toString()) ).collect(Collectors.toList());

		return transformedData;

	} public static boolean isInteger(String strValue) {
		try {
			Integer.parseInt(strValue);
			return true;
		} catch (NumberFormatException ex) {
			return false;
		}
	}

	@Override
	public List<Map<String, Object>> getTodayTrafficSize() throws Exception {
		String date = Common.getCurrentDate();
		List<Map<String, Object>> result = deviceTrafficStatService.getTrafficStatList_Hour(date, date);

		Map<String, Long> dateToLongNumMap = new HashMap<>();

		// 결과를 처리하여 날짜별로 longNum 값을 누적
		for (Map<String, Object> entry : result) {
			for (Map.Entry<String, Object> subEntry : entry.entrySet()) {
				String key = subEntry.getKey();
				if (isInteger(key)){
					String dateKey = subEntry.getKey();
					long num = (long) parseCount(subEntry.getValue());

					// 날짜가 이미 맵에 있는 경우에는 해당 날짜의 longNum에 누적값을 더함
					if (dateToLongNumMap.containsKey(dateKey)) {
						long accumulatedNum = dateToLongNumMap.get(dateKey);
						accumulatedNum += num;
						dateToLongNumMap.put(dateKey, accumulatedNum);
					} else {
						dateToLongNumMap.put(dateKey, num);
					}
				}
			}
		}

		List<Map<String, Object>> transformedData = new ArrayList<>();

		// 변환된 데이터 생성
		for (Map.Entry<String, Long> entry : dateToLongNumMap.entrySet()) {
			Map<String, Object> transformedEntry = new HashMap<>();
			transformedEntry.put("date", entry.getKey());
			transformedEntry.put("longNum", entry.getValue());
			transformedEntry.put("longNumStr", Common.convertFileSize(entry.getValue()));
			transformedData.add(transformedEntry);
		}

		// 날짜 순으로 정렬
		transformedData.sort((o1, o2) -> o1.get("date").toString().compareTo(o2.get("date").toString()));

		return transformedData;
	}




	private static double parseCount(Object value) {
		// Assuming the count is represented as a String like "15467.47/15467.46"
		String[] parts = ((String) value).split("/");
		return Double.parseDouble(parts[0]);
	}



	@Override
	public ServiceDataLoggingVO getServiceDataLogging(ServiceDataLoggingVO serviceDataLoggingVO) throws IOException, SolrServerException {
		ServiceDataLoggingVO result = new ServiceDataLoggingVO();
		SolrQuery sq = new SolrQuery();
		sq.setQuery(String.format("+ctime:[%s TO %s]", serviceDataLoggingVO.getStartDt(), serviceDataLoggingVO.getEndDt()));
		sq.setRows(0);
		sq.addFacetField("svc1");
		sq.setFacetLimit(-1);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, serviceDataLoggingVO.getAdminId());
		List<List<Object>> items = new ArrayList<>();
		List<FacetVO> facet = edc.getFacet();
		if (facet == null) result.setFacet(items);
		else {


			List<ServiceGroupVO> groups = Config.serviceGroups;
			for (ServiceGroupVO group : groups) {
				List<Object> item = new ArrayList<>();
				boolean isAdd = false;
				for (FacetVO vo : facet) {
					if (Common.isEquals(group.getGroupCd(), vo.getName())) {
						item.add(Config.getServiceGroupNm(vo.getName()));
						item.add(vo.getCount());
						isAdd = true;
						break;
					}
				}
				if (!isAdd) {
					item.add(group.getGroupNm());
					item.add(0);
				}
				items.add(item);
			}


		}
		result.setFacet(items);

		return result;
	}

}
