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
import org.apache.commons.collections.map.HashedMap;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import static org.apache.solr.common.params.FacetParams.FACET_QUERY;

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

	private final static String FACET_QUERY = "{result: {type: terms,limit: -1,field: \"user_str\",sort: \"count desc\",facet: {pi_SN:\"sum(pi_SN)\", pi_PN:\"sum(pi_PN)\", pi_DN:\"sum(pi_DN)\", pi_FN:\"sum(pi_FN)\", pi_CN:\"sum(pi_CN)\"}}}";

//	@Override
//	public TodayDataStatusVO getTodayDataStatus(TodayDataStatusVO todayDataStatusVO) throws IOException, SolrServerException {
//		TodayDataStatusVO result = new TodayDataStatusVO();
//
//		String query = String.format("+ctime:[%s TO %s]", todayDataStatusVO.getStartDt(), todayDataStatusVO.getEndDt());
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(query);
//		sq.setRows(0);
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, todayDataStatusVO.getAdminId());
//		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//
//		sq.setQuery(query);
//		sq.setRows(0);
//		sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, todayDataStatusVO.getAdminId()));
//		edc = solrEdcService.getEmassMessage(sq, todayDataStatusVO.getAdminId());
//		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//		return result;
//	}

//	@Override
//	public PatternPrivacyVO getTodayPatternPrivacy(PatternPrivacyVO patternPrivacyVO) throws IOException, SolrServerException {
//		PatternPrivacyVO result = new PatternPrivacyVO();
//
//		String query = String.format("+ctime:[%s TO %s] +(pi_CN:[ 1 TO * ] pi_FN:[ 1 TO * ] pi_SN:[ 1 TO * ] pi_PN:[ 1 TO * ] pi_DN:[ 1 TO * ])", patternPrivacyVO.getStartDt(), patternPrivacyVO.getEndDt());
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(query);
//		sq.setRows(0);
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, patternPrivacyVO.getAdminId());
//		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//
//
//		sq.setQuery(query);
//		sq.setRows(0);
//		sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, patternPrivacyVO.getAdminId()));
//		edc = solrEdcService.getEmassMessage(sq, patternPrivacyVO.getAdminId());
//		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//		return result;
//	}

//	@Override
//	public RiskBehaviorVO getTodayRiskBehavior(RiskBehaviorVO riskBehaviorVO) throws IOException, SolrServerException {
//		RiskBehaviorVO result = new RiskBehaviorVO();
//
//		String query = String.format("+ctime:[%s TO %s] +(pi_EC:[ 1 TO * ] pi_EF:[ 1 TO * ] pi_ID:[ 1 TO * ])", riskBehaviorVO.getStartDt(), riskBehaviorVO.getEndDt());
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(query);
//		sq.setRows(0);
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, riskBehaviorVO.getAdminId());
//		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//
//		sq.setQuery(query);
//		sq.setRows(0);
//		sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, riskBehaviorVO.getAdminId()));
//		edc = solrEdcService.getEmassMessage(sq, riskBehaviorVO.getAdminId());
//		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//		return result;
//	}

//	@Override
//	public KeywordDetectionVO getTodayKeywordDetection(KeywordDetectionVO keywordDetectionVO) throws IOException, SolrServerException {
//		KeywordDetectionVO result = new KeywordDetectionVO();
//
//		String query = String.format("+ctime:[%s TO %s]  +kwd:Y", keywordDetectionVO.getStartDt(), keywordDetectionVO.getEndDt());
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(query);
//		sq.setRows(0);
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, keywordDetectionVO.getAdminId());
//		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//
//		sq.setQuery(query);
//		sq.setRows(0);
//		sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, keywordDetectionVO.getAdminId()));
//		edc = solrEdcService.getEmassMessage(sq, keywordDetectionVO.getAdminId());
//		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//		return result;
//	}

	@Override
	public InterestUserMailVO getInterestUserMail(InterestUserMailVO interestUserMailVO) throws IOException {
		InterestUserMailVO result = new InterestUserMailVO();

		/*SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		solrCreateQuery.setAllInterestUser(interestUserMailVO.getAdminId());
		SolrQuery sq = solrCreateQuery.setQuery();
		String query = sq.getQuery();
		if(Common.isEmpty(query)) {
			return result;
		}
		query += String.format(" +ctime:[%s TO %s]", interestUserMailVO.getStartDt(), interestUserMailVO.getEndDt());
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, interestUserMailVO.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));*/
		return result;
	}

	@Override
	public InterestUserServiceVO getInterestUserService(InterestUserServiceVO interestUserServiceVO) throws IOException {
		InterestUserServiceVO result = new InterestUserServiceVO();
		/*SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		if( Common.isEquals(interestUserServiceVO.getUserSeq(), "all")) solrCreateQuery.setAllInterestUser(interestUserServiceVO.getAdminId());
		else solrCreateQuery.setInterestUser(interestUserServiceVO.getUserSeq());
		SolrQuery sq = solrCreateQuery.setQuery();
		String query = sq.getQuery();
		if(Common.isEmpty(query)) {
			return result;
		}
		query += String.format(" +ctime:[%s TO %s]", interestUserServiceVO.getStartDt(), interestUserServiceVO.getEndDt());
		sq.setQuery(query);
		sq.setRows(0);
		sq.addFacetField("svc1");
		sq.setFacetLimit(-1);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, interestUserServiceVO.getAdminId());
		List<Map<String,Object>> items = new ArrayList<>();
		List<FacetVO> facet = edc.getFacet();
		List<ServiceGroupVO> groups = Config.serviceGroups;
		for (ServiceGroupVO group : groups) {
			Map<String,Object> item = new HashMap<>();
			boolean isAdd = false;
			for (FacetVO vo : facet) {
				if (Common.isEquals(group.getGroupCd(), vo.getName())) {
					item.put("name", Config.getServiceGroupNm(vo.getName()));
					item.put("y", vo.getCount());
					isAdd = true;
					break;
				}
			}
			if (!isAdd) {
				item.put("name", group.getGroupNm());
				item.put("y", 0);
			}
			items.add(item);
		}
		result.setFacet(items);*/
		return result;
	}


//	@Override
//	public ServiceDataLoggingVO getServiceDataLogging(ServiceDataLoggingVO serviceDataLoggingVO) throws IOException, SolrServerException {
//
//		ServiceDataLoggingVO result = new ServiceDataLoggingVO();
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(String.format("+ctime:[%s TO %s]", serviceDataLoggingVO.getStartDt(), serviceDataLoggingVO.getEndDt()));
//		sq.setRows(0);
//		sq.addFacetField("svc1");
//		sq.setFacetLimit(-1);
//		sq.setFacetMinCount(1);
//		sq.setFacetSort("count");
//
//		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, serviceDataLoggingVO.getAdminId());
//		List<List<Object>> items = new ArrayList<>();
//		List<FacetVO> facet = edc.getFacet();
//
//		List<ServiceGroupVO> groups = Config.serviceGroups;
//		for (ServiceGroupVO group : groups) {
//			List<Object> item = new ArrayList<>();
//			boolean isAdd = false;
//			for (FacetVO vo : facet) {
//				if (Common.isEquals(group.getGroupCd(), vo.getName())) {
//					item.add(Config.getServiceGroupNm(vo.getName()));
//					item.add(vo.getCount());
//					isAdd = true;
//					break;
//				}
//			}
//			if (!isAdd) {
//				item.add(group.getGroupNm());
//				item.add(0);
//			}
//			items.add(item);
//		}
//		result.setFacet(items);
//		return result;
//	}


	@Override
	public TodayDataStatusVO getTodayDataStatus(TodayDataStatusVO todayDataStatusVO) throws IOException, SolrServerException {
		TodayDataStatusVO result = new TodayDataStatusVO();
		SolrQuery sq = new SolrQuery();

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

		sq.setQuery("*:*");
		sq.setStart(Common.nvz(0));
		sq.setRows(Common.nvz(1));
		sq.setSort("ctime", SolrQuery.ORDER.desc);
		sq.setFields("msgid", "srcip", "svc", "svc3", "ctime", "name", "sname", "sender", "recvs_name", "recvs", "body_snippet", "attached", "attachname", "xrootmtr", "usr_id");
		sq.setQuery(String.format("+ctime:[%s TO %s]", todayDataStatusVO.getStartDt(), todayDataStatusVO.getEndDt()));

		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, todayDataStatusVO.getAdminId());
		result.setPivotData(edc.getPivotData());

		return result;
	}

	@Override
	public PatternPrivacyVO getAllTodayPatternPrivacy(PatternPrivacyVO vo) throws SolrServerException, IOException {
		PatternPrivacyVO result = new PatternPrivacyVO();
		String query = String.format("+ctime:[%s TO %s] +(pi_EC:[ 1 TO * ] pi_EF:[ 1 TO * ] pi_ID:[ 1 TO * ])", vo.getStartDt(), vo.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setRows(0);
		sq.setFacet(true);
		sq.setFacetMinCount(1);
		sq.setParam("json.facet", FACET_QUERY);
		sq.setQuery(query);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, vo.getAdminId());
//		System.out.println("gg: "+edc);


//		JSONArray jArray = new JSONArray();
//		if(facets != null) {
//			SimpleOrderedMap<Object> map = (SimpleOrderedMap<Object>)facets.get("result");
//			if(map != null) {
//				List<SimpleOrderedMap<Object>> simpleOrderedMapList = (List<SimpleOrderedMap<Object>>)map.get("buckets");
//				for (SimpleOrderedMap<Object> simpleOrderedMap : simpleOrderedMapList) {
//					jArray.add(bucketsSetting(simpleOrderedMap));
//				}
//			}
//		}
//		int pi_total;
//		for (int i = 0; i < jArray.size(); i++) {
//			pi_total = Common.nvz(jArray.getJSONObject(i).get("pi_SN")) +  Common.nvz(jArray.getJSONObject(i).get("pi_PN")) +  Common.nvz(jArray.getJSONObject(i).get("pi_DN"))+ Common.nvz(jArray.getJSONObject(i).get("pi_FN"))+ Common.nvz(jArray.getJSONObject(i).get("pi_CN"));
//			jArray.getJSONObject(i).put("pi_total", pi_total);
//		}
//		System.out.println("jArray: "+jArray);

		return null;
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

		String query = String.format("+ctime:[%s TO %s] +(pi_CN:[ 1 TO * ] pi_FN:[ 1 TO * ] pi_SN:[ 1 TO * ] pi_PN:[ 1 TO * ] pi_DN:[ 1 TO * ])", patternPrivacyVO.getStartDt(), patternPrivacyVO.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, patternPrivacyVO.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		sq.setQuery(query);
		sq.setRows(0);
//	    sq.addFilterQuery(String.format(SolrEdcServiceImpl.JOIN_UNREAD, patternPrivacyVO.getAdminId()));
		edc = solrEdcService.getEmassMessage(sq, patternPrivacyVO.getAdminId());
		result.setUnRead(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		return result;
	}

	@Override
	public RiskBehaviorVO getTodayRiskBehavior(RiskBehaviorVO riskBehaviorVO) throws IOException, SolrServerException {
		RiskBehaviorVO result = new RiskBehaviorVO();

		String query = String.format("+ctime:[%s TO %s] +(pi_EC:[ 1 TO * ] pi_EF:[ 1 TO * ] pi_ID:[ 1 TO * ])", riskBehaviorVO.getStartDt(), riskBehaviorVO.getEndDt());
		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setRows(0);
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, riskBehaviorVO.getAdminId());
		result.setTotal(Config.getBoolean(ABBREVIATION) ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
		;
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
		for (SolrEdcVO solrEdcVO : edc.getEmass()) {
			filesize.add(solrEdcVO.getAttachSizeStr());
			fileType.add(solrEdcVO.getAttachtype().get(0));
		}
		result.setFileSize(filesize);
		result.setFileType(fileType);
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
		sq.addFacetField("userid");
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

				items.add(item);
			}
		}
		result.setFacet(items);
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

		sq.setParam("facet.limit", "-1");
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
					Map<String, Object> transformedEntry = new HashMap<>();
					transformedEntry.put("date", subEntry.getKey());
					long num = (long) parseCount(subEntry.getValue());
					transformedEntry.put("longNum",num);
					transformedEntry.put("longNumStr",Common.convertFileSize(num));
					transformedData.add(transformedEntry);
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

		List<Map<String, Object>> transformedData = new ArrayList<>();

		for (Map<String, Object> entry : result) {
			for (Map.Entry<String, Object> subEntry : entry.entrySet()) {
				String key = subEntry.getKey();
				if (isInteger(key)){
					Map<String, Object> transformedEntry = new HashMap<>();
					transformedEntry.put("date", subEntry.getKey());
					long num = (long) parseCount(subEntry.getValue());
					transformedEntry.put("longNum",num);
					transformedEntry.put("longNumStr",Common.convertFileSize(num));
					transformedData.add(transformedEntry);
				}
			}
		}
		transformedData = transformedData.stream().sorted((o1, o2) -> o1.get("date").toString().compareTo(o2.get("date").toString()) ).collect(Collectors.toList());
		System.out.println(transformedData);

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
