package com.xcurenet.emass.customDashboard.service.impl;

import com.xcurenet.admin.service.AdminService;
import com.xcurenet.admin.service.AdminVO;
import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.common.dao.TransactionManager;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.customDashboard.service.*;
import com.xcurenet.emass.message.service.SolrEdcService;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service("customDashBoardService")
public class CustomDashBoardServiceImpl extends XcnAbstractDAO implements CustomDashBoardService {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;
	@Resource(name = "authorityService")
	private AuthorityService authorityService;

	@Resource(name = "adminService")
	private AdminService adminService;

	@Override
	public List<CustomDashboardMenuVO> getDashBoardMenuList(final CustomDashboardMenuVO customDashboardMenuVo) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getDashBoardMenuList", customDashboardMenuVo);
	}

	@Override
	public int saveDashBoardMenu(CustomDashboardMenuVO customDashboardMenuVo) {
		if( Common.isEmpty(customDashboardMenuVo.getMenuKey())) {
			customDashboardMenuVo.setMenuKey(Common.nvl(selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getDashBoardMenuMaxMenuKey")));
		}
		return insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardMenu", customDashboardMenuVo);
	}

	@Override
	public int deleteDashBoardMenu(List<CustomDashboardMenuVO> customDashboardMenuVos) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (CustomDashboardMenuVO customDashboardMenuVo : customDashboardMenuVos) {
				result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardMenu", customDashboardMenuVo);
				result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardPositionMenu", customDashboardMenuVo);
			}

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int changeDashBoardDefaultMenu(CustomDashboardMenuVO customDashboardMenuVo) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			CustomDashboardMenuVO vo = new CustomDashboardMenuVO();
			vo.setAdminId(customDashboardMenuVo.getAdminId());
			vo.setDefaultMenu("N");
			update("com.xcurenet.sqlmap.mappers.mysql.customDashboard.changeDashBoardDefaultMenu", vo);

			customDashboardMenuVo.setDefaultMenu("Y");
			result = update("com.xcurenet.sqlmap.mappers.mysql.customDashboard.changeDashBoardDefaultMenu", customDashboardMenuVo);

			tx.commit();
		} finally {
			tx.end();
		}
		return result;

	}

	@Override
	public List<CustomDashboardVO> getDashBoardContentList(CustomDashboardVO customDashboardVo) throws Exception {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getDashBoardContentList", customDashboardVo);
	}

	@Override
	public List<CustomDashboardVO> getDefaultDashBoardContentList() throws Exception {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getDefaultDashBoardContentList");
	}

	@Override
	public int saveDashBoardContent(CustomDashboardVO customDashboardVo) {
		if( Common.isEmpty(customDashboardVo.getDashKey())) {
			customDashboardVo.setDashKey(Common.nvl(selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContentMaxDashKey")));
		} else if(Common.isNotEmpty(customDashboardVo.getAdminIds())){
			String orgDashKey = customDashboardVo.getDashKey();
			String orgAdminId = customDashboardVo.getAdminId();
			batchUpdate(customDashboardVo);
			customDashboardVo.setDashKey(orgDashKey);
			customDashboardVo.setAdminId(orgAdminId);
		}

		return insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContent", customDashboardVo);
	}

	@Override
	public int deleteDashBoardContent(List<CustomDashboardVO> customDashboardVos) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			for (CustomDashboardVO customDashboardVo : customDashboardVos) {
				result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardContent", customDashboardVo);
				result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardPosition", customDashboardVo);
			}

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int insertDashboardShare(List<String> dashKey, List<String> adminId) {
		Map<String, Object> params = new HashMap<>();
		CustomDashboardVO customDashboardVo = new CustomDashboardVO();
		int result = 0;

		for(int i=0; i<dashKey.size(); i++) {
			customDashboardVo.setDashKey(dashKey.get(i));
			customDashboardVo.setAdminId("sysadmin");
			customDashboardVo = selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getDashBoardContentList", customDashboardVo);

			for(int j=0; j<adminId.size(); j++) {

				String admin = adminId.get(j);

				if(isShareExist(admin, dashKey.get(i), "") == 0) {
					customDashboardVo.setAdminId(admin);
					String newDashKey = Common.nvl(selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContentMaxDashKey"));

					customDashboardVo.setDashKey(newDashKey);
					insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContent", customDashboardVo);

					params.put("dashKey", newDashKey);
					params.put("adminId", admin);
					params.put("pdashKey", dashKey.get(i));
					result = insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.insertDashboardShare", params);
				}
			}
		}

		return result;
	}

	@Override
	public void deleteDashBoardContentBatch(CustomDashboardVO deleteData, String adminId) {
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			List<String> shareAdminId = Common.toList(deleteData.getAdminIds(), ",");
			for(String id : shareAdminId) {
				CustomDashboardVO tmpVo = new CustomDashboardVO();
				tmpVo.setDashKey(deleteData.getDashKey());
				tmpVo.setAdminId(id);

				String dashKey = selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getShareDashKey", tmpVo);
				tmpVo.setDashKey(dashKey);
				delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardContent", tmpVo);
				delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardPosition", tmpVo);
				delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashboardShare", tmpVo);
			}

			tx.commit();
		} finally {
			tx.end();
		}
	}

	@Override
	public int deleteDashBoardaAdminShare(List<String> dashKey, List<String> oldAdmin) {
		Map<String, Object> params = new HashMap<>();
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			for(int i=0; i<dashKey.size(); i++) {

				CustomDashboardVO customDashboardVo = new CustomDashboardVO();

				for(int j=0; j<oldAdmin.size(); j++) {

					String admin = oldAdmin.get(j);
					params.put("adminId", admin);
					params.put("pdashKey", dashKey.get(i));

					customDashboardVo.setDashKey(dashKey.get(i));
					customDashboardVo.setAdminId(admin);

					String adminDashKey = selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getShareDashKey", customDashboardVo);

					customDashboardVo.setDashKey(adminDashKey);
					customDashboardVo.setAdminId(admin);

					result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardContent", customDashboardVo);
					result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardPosition", customDashboardVo);
					result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoardaAdminShare", params);
				}
			}

			tx.commit();
		} finally {
			tx.end();
		}

		return result;
	}

	@Override
	public int deleteDashboardShare(String adminId, String pdashKey, String dashKey) {

		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			Map<String, Object> param = new HashMap<>();
			param.put("adminId", adminId);
			if(Common.isNotEmpty(pdashKey)) param.put("pdashKey", pdashKey);
			if(Common.isNotEmpty(dashKey)) param.put("dashKey", dashKey);

			result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashboardShare", param);

			tx.commit();
		} finally {
			tx.end();
		}

		return result;
	}

	@Override
	public int deleteAdminShare(String pdashKey) {

		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();

			Map<String, Object> param = new HashMap<>();
			param.put("pdashKey", pdashKey);

			result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteAdminShare", param);

			tx.commit();
		} finally {
			tx.end();
		}

		return result;
	}

	@Override
	public List<AdminVO> getShareAdmin(List<String> dashKey) {
		Map<String, Object> params = new HashMap<>();
		params.put("pdashKey", dashKey);
		params.put("total", dashKey.size());
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getShareAdmin", params);
	}

	@Override
	public List<CustomDashboardVO> getDashBoardList(CustomDashboardVO customDashboardVo) throws Exception {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getDashBoardList", customDashboardVo);
	}

	@Override
	public int saveDashBoard(List<CustomDashboardVO> customDashboardVos) {
		int result = 0;
		TransactionManager tx = getTransactionManager();
		try {
			tx.start();
			result = delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoard", customDashboardVos.get(0));
			for (CustomDashboardVO customDashboardVo : customDashboardVos) {
				if(Common.isEmpty(customDashboardVo.getDashKey())) {
					String id = customDashboardVo.getId();
					String dashKey = id.substring(id.indexOf("_")+1, id.length());
					customDashboardVo.setDashKey(dashKey);
				}
				result = insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoard", customDashboardVo);
			}

			tx.commit();
		} finally {
			tx.end();
		}
		return result;
	}

	@Override
	public int deleteDashBoard(CustomDashboardVO customDashboardVo) {
		return delete("com.xcurenet.sqlmap.mappers.mysql.customDashboard.deleteDashBoard", customDashboardVo);
	}


    @Override
	public int isShareExist(String adminId, String pdashKey, String dashKey) {
		Map<String, Object> param = new HashMap<>();
		param.put("adminId", adminId);
		if(Common.isNotEmpty(pdashKey)) param.put("pdashKey", pdashKey);
		if(Common.isNotEmpty(dashKey)) param.put("dashKey", dashKey);

		return selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.isShareExist", param);
	}

	private void batchUpdate(CustomDashboardVO customDashboardVo) {
		List<String> adminId = Common.toList(customDashboardVo.getAdminIds(), ",");
		String orgDashKey = customDashboardVo.getDashKey();
		CustomDashboardVO shareDashboardVo = customDashboardVo;
		for(int i=0; i<adminId.size(); i++) {
			shareDashboardVo.setDashKey(orgDashKey);
			shareDashboardVo.setAdminId(adminId.get(i));
			String dashKey = selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getShareDashKey", shareDashboardVo);
			shareDashboardVo.setDashKey(dashKey);
			insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContent", shareDashboardVo);
		}
	}

	public static void main(String[] args) throws  IOException {
//		CustomDashBoardServiceImpl ss = new CustomDashBoardServiceImpl();
//		SolrQuery sq = new SolrQuery();
//		//sq.setQuery("+ctime_yyyymmdd:[" + dateFormat.format(cal.getTime()) + " TO " + date + "]");
//		sq.setQuery("+ctime_yyyymmdd:[20201031 TO 20201106]");
//		//sq.setQuery("*:*");
//		sq.setRows(0);
//		sq.setGetFieldStatistics(true);
//		sq.addGetFieldStatistics("attachsize");
//		sq.addStatsFieldFacets("attachsize","ctime_yyyymmdd");
//		sq.addFacetField("ctime_yyyymmdd");
//		sq.setFacetLimit(7);
//		sq.setFacetSort("ctime_yyyymmdd");
//		sq.setFacetMinCount(1);
//
//		SolrClient solrclient = new HttpSolrClient.Builder("http://15.1.3.191:8983/solr/edc").build();
//		QueryResponse res = solrclient.query(sq);
//
//		List<Map<String, String>> result = new ArrayList<>();
//		List<FacetField> loggingCounts = res.getFacetFields();
//		for(FacetField field : loggingCounts) {
//			List<Count> values = field.getValues();
//			for(Count count : values) {
//				Map<String, String> item = ss.findItem(result, count.getName());
//				item.put("logging", Common.makeMoneyType(count.getCount()));
//				if (item.get("date") == null) {
//					item.put("date", count.getName());
//					result.add(item);
//				}
//			}
//		}
//
//		Map<String, FieldStatsInfo> stats = res.getFieldStatsInfo();
//		List<FieldStatsInfo> statsInfo = stats.get("attachsize").getFacets().get("ctime_yyyymmdd");
//		for(FieldStatsInfo info : statsInfo) {
//			Map<String, String> item = ss.findItem(result, info.getName());
//			item.put("attach", Common.convertFileSize(Math.round((Double) info.getSum())));
//			if (item.get("date") == null) {
//				item.put("date", info.getName());
//				result.add(item);
//			}
//		}
	}

	private Map<String, String> findItem(List<Map<String, String>> result, String date) {
		for(Map<String, String> item : result) {
			if(Common.isEquals(item.get("date"), date)) return item;
		}
		return new HashMap<>();
	}

//	@Override
//	public XcnResponseVO getLoggingData(final HttpServletRequest request, final HttpSession session) throws Exception {
//		JSONObject param = Common.getParam(request);
//		String systemArch = Common.nvl(param.get("systemArch"));
//		String date = Common.nvl(param.get("date")).replace("-", "");
//		String startDate = Common.plusDays(date, -7);
//		String endDate = Common.plusDays(date, -1);
//
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery(String.format("+ctime_yyyymmdd:[ %s TO %s ]", startDate, endDate));
//		sq.setRows(0);
//		sq.setGetFieldStatistics(true);
//		sq.addGetFieldStatistics("attachsize");
//		sq.addStatsFieldFacets("attachsize","ctime_yyyymmdd");
//		sq.addFacetField("ctime_yyyymmdd");
//		sq.setFacetLimit(7);
//		sq.setFacetSort("ctime_yyyymmdd");
//		sq.setFacetMinCount(1);
//
//		setAuthoritys(sq, systemArch, session);
//
//		log.info("query : {}", sq.getQuery());
//
//		QueryResponse res = solrEdcService.getSolrServer().query(sq);
//		List<Map<String, String>> result = new ArrayList<>();
//		List<FacetField> loggingCounts = res.getFacetFields();
//		for(FacetField field : loggingCounts) {
//			List<Count> values = field.getValues();
//			for(Count count : values) {
//				Map<String, String> item = findItem(result, count.getName());
//				item.put("logging", count.getCount() + "");
//				if (item.get("date") == null) {
//					item.put("date", count.getName());
//					result.add(item);
//				}
//			}
//		}
//
//		param.put("startDate", startDate);
//		param.put("endDate", endDate);
//		List<Object> objs = selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getHdfsDirSize", param);
////		System.out.println("objs: " + objs);
//
//		for(Object obj : objs) {
//			JSONObject json = Common.toJSONObject(obj);
//			Map<String, String> item = findItem(result, json.getString("date"));
//			item.put("attach", json.getString("total"));
//			if (item.get("date") == null) {
//				item.put("date", json.getString("date"));
//				result.add(item);
//			}
//		}
//		return new XcnResponseVO(XcnRspCode.OK, result);
//	}

	@Override
	public List<HdfsVO> getHdfsData(final HttpServletRequest request, final HttpSession session) {
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getHdfsData");
	}

//	@Override
//	public XcnResponseVO getDashBoardContentData(CustomDashboardVO customDashboardVo) {
//		CustomDashboardResultVO result = new CustomDashboardResultVO();
//
//		JSONObject condition = Common.toJSONObject(customDashboardVo.getDashCondition());
//		JSONArray conditions = new JSONArray();
//		conditions.add(condition);
//		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
//		try {
//			SolrQuery sq = solrCreateQuery.makeQuery(conditions, customDashboardVo.getAdminId()).setQuery();
//
//			if( Common.isNotEquals(customDashboardVo.getDashType(), "L") ) {
//				sq.setRows(0);
//			}else {
//				sq.setRows(13);
//			}
//			if( Common.isEquals(customDashboardVo.getDashType(), "C") ) {
//
//				sq.addFacetField(customDashboardVo.getDashChartX());
//				sq.setFacetLimit(-1);
//				sq.setFacetMinCount(1);
//				sq.setFacetSort("count");
//			}else if( Common.isEquals(customDashboardVo.getDashType(), "D") ) {
//				sq.setFacet(true);
//				sq.setParam("facet.query", "+{!join from=msgid fromIndex=checked to=msgid}id:"+customDashboardVo.getAdminId());
//			}
//
//			SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, customDashboardVo.getAdminId());
//			if( Common.isEquals(customDashboardVo.getDashType(), "S") ) {
//				result.setRightValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(edc.getNumFound()) : Common.numberFormatter(edc.getNumFound()));
//			}
//			else if( Common.isEquals(customDashboardVo.getDashType(), "D") ) {
//				long totalCnt = edc.getNumFound();
//				long readCnt = edc.getFacetQueryData();
//				long unreadCnt = totalCnt - readCnt;
//
//				if( Common.isOrEquals("unread", customDashboardVo.getDashMultiLeft(), customDashboardVo.getDashMultiLeft())){
//					sq.setParam("facet.query", "-{!join from=msgid fromIndex=checked to=msgid}id:"+customDashboardVo.getAdminId());
//				}
//
//				if(Common.isEquals(customDashboardVo.getDashMultiLeft(), "read")) {
//					result.setLeftValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(readCnt) : Common.numberFormatter(readCnt));
//				}else if(Common.isEquals(customDashboardVo.getDashMultiLeft(), "unread")) {
//					result.setLeftValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(unreadCnt) : Common.numberFormatter(unreadCnt));
//				}else if(Common.isEquals(customDashboardVo.getDashMultiLeft(), "total")) {
//					result.setLeftValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(totalCnt) : Common.numberFormatter(totalCnt));
//				}
//				if(Common.isEquals(customDashboardVo.getDashMultiRight(), "read")) {
//					result.setRightValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(readCnt) : Common.numberFormatter(readCnt));
//				}else if(Common.isEquals(customDashboardVo.getDashMultiRight(), "unread")) {
//					result.setRightValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(unreadCnt) : Common.numberFormatter(unreadCnt));
//				}else if(Common.isEquals(customDashboardVo.getDashMultiRight(), "total")) {
//					result.setRightValue(Config.getBoolean("ui.dashboard.abbreviation") ? Common.formatNum(totalCnt) : Common.numberFormatter(totalCnt));
//				}
//			}else if( Common.isEquals(customDashboardVo.getDashType(), "C") ) {
//				result = getChartData(edc, result, customDashboardVo.getDashChart());
//			}
//			else if( Common.isEquals(customDashboardVo.getDashType(), "L") ) result.setEdc(edc);
//
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//		return new XcnResponseVO(XcnRspCode.OK, result);
//	}

//	private CustomDashboardResultVO getChartData(SolrEdcMessageVO edc, CustomDashboardResultVO result, String dashChart) {
//		if(edc == null) return null;
//		List<FacetVO> facet = edc.getFacet();
//		List<Map<String,Object>> items = new ArrayList<>();
//
//		List<ServiceGroupVO> groups = Config.serviceGroups;
//		int index = 0;
//		for (ServiceGroupVO group : groups) {
//			Map<String,Object> item = new HashMap<>();
//			boolean isAdd = false;
//			for (FacetVO vo : facet) {
//				if (Common.isEquals(group.getGroupCd(), vo.getName())) {
//					item.put("name", Config.getServiceGroupNm(vo.getName()));
//					item.put("y", vo.getCount() == 0 ? (Common.isEquals(dashChart, "P") ? 0 : null) : vo.getCount());
//					item.put("color", Config.colors[index++]);
//					isAdd = true;
//					break;
//				}
//			}
//			if (!isAdd) {
//				item.put("name", group.getGroupNm());
//				item.put("color", Config.colors[index++]);
//				item.put("y", Common.isEquals(dashChart, "P") ? 0 : null);
//			}
//			items.add(item);
//		}
//		result.setChartData(items);
//
//		return result;
//	}

	@Override
	public int insertDashBoardDefaultData(CustomDashboardVO customDashboardVo) {
		insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardContentDefault", customDashboardVo);
		insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveDashBoardPositionDefault", customDashboardVo);
		return 0;
	}

	@Override
	public int insertHDFSInfo(Map<String, String> param) {
		insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.insertHDFSInfo", param);
		return 0;
	}

	@Override
	public int insertHDFSDirSize(Map<String, String> param) {
		insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.insertHDFSDirSize", param);
		return 0;
	}

	@Override
	public int saveLoggingData(final HttpServletRequest request, final HttpSession session) {
		Map<String,String> param = new HashMap<>();
		param.put("adminId", Common.getAdminId(session));
		param.put("useYn", Common.nvl(request.getParameter("useYn")));
		insert("com.xcurenet.sqlmap.mappers.mysql.customDashboard.saveLoggingData", param);
		return 0;
	}

	@Override
	public String getLoggingDataSetting(final HttpSession session) throws Exception {
		Map<String,String> param = new HashMap<>();
		param.put("adminId", Common.getAdminId(session));
		String rs = Common.nvl(selectOne("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getLoggingDataSetting", param));
		if(rs.isEmpty()) rs = "N";
		return rs;
	}

	@Override
	public XcnResponseVO getLoggingData(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		long now = System.currentTimeMillis();
		String systemArch = Common.nvl(param.get("systemArch"));
		String date = Common.nvl(param.get("date")).replace("-", "");
		if (date == "") date = Common.getCurrentDate();
		System.out.println(date);

		String startDate = Common.plusDays(date, -7);
		String endDate = Common.plusDays(date, -1);

		SolrQuery sq = new SolrQuery();
		sq.setQuery(String.format("+ctime_yyyymmdd:[ %s TO %s ]", startDate, endDate));
		sq.setRows(0);
		sq.setGetFieldStatistics(true);
		sq.addGetFieldStatistics("attachsize");
		sq.addStatsFieldFacets("attachsize","ctime_yyyymmdd");
		sq.addFacetField("ctime_yyyymmdd");
		sq.setFacetLimit(7);
		sq.setFacetSort("ctime_yyyymmdd");
		sq.setFacetMinCount(1);

		setAuthoritys(sq, systemArch, session);

		log.info("query : {}", sq.getQuery());

		QueryResponse res = solrEdcService.getSolrServer().query(sq);
		List<Map<String, String>> result = new ArrayList<>();
		List<FacetField> loggingCounts = res.getFacetFields();
		for(FacetField field : loggingCounts) {
			List<FacetField.Count> values = field.getValues();
			for(FacetField.Count count : values) {
				Map<String, String> item = findItem(result, count.getName());
				item.put("logging", count.getCount() + "");
				if (item.get("date") == null) {
					item.put("date", count.getName());
					result.add(item);
				}
			}
		}

		param.put("startDate", startDate);
		param.put("endDate", endDate);
		List<Object> objs = selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getHdfsDirSize", param);
//		System.out.println("objs: " + objs);

		for(Object obj : objs) {
			JSONObject json = Common.toJSONObject(obj);
			Map<String, String> item = findItem(result, json.getString("date"));
			item.put("attach", json.getString("total"));
			if (item.get("date") == null) {
				item.put("date", json.getString("date"));
				result.add(item);
			}
		}
		return new XcnResponseVO(XcnRspCode.OK, result);
	}

    @Override
	public List<FileDataVO> getFileSizeData(final HttpServletRequest request, final HttpSession session) throws Exception {
		String date = Common.nvl(request.getParameter("date"));
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getFileSizeData",date);
	}

	@Override
	public List<FileDataVO> getFileCount(final HttpServletRequest request, final HttpSession session) throws Exception {
		String date = Common.nvl(request.getParameter("date"));
		return selectList("com.xcurenet.sqlmap.mappers.mysql.customDashboard.getFileCount",date);
	}

	@Override
	public int checkMonitorDB() {
		return Common.nvz(selectOne("com.xcurenet.sqlmap.mappers.mysql.menu.checkMonitoring"));
	}

	private void setAuthoritys(SolrQuery sq, String systemArch, HttpSession session) {
//		String adminId = Common.getAdminId(session);
//		String adminType = Common.getAdminType(session);
//
//		if(Common.isEmpty(adminId)) return;
//
//		if(Common.isEquals(systemArch, "multiple") && Common.isOrEquals(adminType, "M", "C")) {
//			String ceoReadYn = Config.getString("ceo.readyn");
//			JSONObject param = new JSONObject();
//
//			if(Common.isEquals(adminType, "C")) {
//				sq.addFilterQuery("+ceo:Y");
//			}else if(!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y")) ) {
//				sq.addFilterQuery("-ceo:Y");
//			}
//
//			sq.addFilterQuery("-svc:QEKH");
//
//			param.put("adminId", adminId);
//			param.put("queryType", Config.getString("query.type", "A"));
//			List<AuthorityVO> authoritys = authorityService.getAdminAuthority(param);
//			for (AuthorityVO authority : authoritys) {
//				if (authority.getCnt() > 0) {
//					sq.addFilterQuery(authority.getQuery());
//				}
//			}
//
//			if (log.isInfoEnabled()) {
//				StringBuffer _sb = new StringBuffer();
//				if (sq.getFilterQueries() != null) {
//					for (int i = 0; i < sq.getFilterQueries().length; i++) {
//						_sb.append(sq.getFilterQueries()[i]).append(" ");
//					}
//				}
//				log.info("filterQuery : {}", _sb);
//			}
//		}
	}

    @Override
    public XcnResponseVO getDashBoardContentData(CustomDashboardVO customDashboardVo) {
        return null;
    }

}
