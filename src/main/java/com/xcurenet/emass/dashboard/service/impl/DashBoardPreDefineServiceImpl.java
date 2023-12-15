package com.xcurenet.emass.dashboard.service.impl;

import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.emass.dashboard.service.*;
import com.xcurenet.emass.message.service.FacetVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.impl.SolrEdcServiceImpl;
import com.xcurenet.emass.service.service.ServiceGroupVO;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service("dashBoardPreDefineService")
public class DashBoardPreDefineServiceImpl implements DashBoardPreDefineService {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	private static final String ABBREVIATION = "ui.dashboard.abbreviation";

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
    public TodayDataStatusVO getTodayDataStatus(TodayDataStatusVO todayDataStatusVO) throws IOException {
        return null;
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
	    result.setFacet(items);
	    return result;
    }

}
