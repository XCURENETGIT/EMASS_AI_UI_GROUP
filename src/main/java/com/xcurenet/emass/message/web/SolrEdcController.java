package com.xcurenet.emass.message.web;

import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.config.service.ConfigAdminVO;
import com.xcurenet.emass.adminFolder.service.AdminFolderMessageVO;
import com.xcurenet.emass.adminFolder.service.AdminFolderService;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.FacetVO;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.emass.searchLog.service.SearchLogService;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.SortClause;
import org.springframework.context.annotation.Description;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Scope("prototype")
@Controller
@AuditParentMenu(ParentMenu.DATA_MONITOR)
@AuditMenu(Menu.MESSAGE_INFO)
public class SolrEdcController {

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource(name = "searchLogService")
	private SearchLogService searchLogService;

	@Resource(name = "adminFolderService")
	private AdminFolderService adminFolderService;

	@Resource(name = "configAdminService")
	private ConfigAdminService configAdminService;

	@RequestMapping(value = "/auto.xcn")
	@Description("EDC Solr 메시지 검색")
	@ResponseBody
	public XcnResponseVO auto(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		String[] searchFields = Common.toArray(Common.nvl(param.get("searchField")), " ");

		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		solrCreateQuery.setDateQuery("", Common.nvl(param.get("startDt")), Common.nvl(param.get("endDt")));

//		System.out.println( "searchFields[i]:" + solrCreateQuery.getPeriodQueryBuffer().toString() );

		SolrQuery sq = new SolrQuery();
		sq.setQuery(solrCreateQuery.getPeriodQueryBuffer().toString());
		sq.setRows(0);
		sq.setFacet(true);
		sq.setFacetLimit(10);
		sq.setFacetMinCount(1);
		sq.setFacetSort("score");
		sq.addFacetField(searchFields);
		sq.setFacetPrefix(Common.nvl(param.get("query")));
		SolrEdcMessageVO edc = solrEdcService.getEmassMessage(sq, null);

		List<FacetVO> facet = edc.getFacet();
		return new XcnResponseVO(XcnRspCode.OK, facet, facet.size());
	}

	@RequestMapping(value = "/getListByRootMtr.xcn")
	@Description("EDC Solr 메시지 검색")
	@ResponseBody
	public XcnResponseVO getListByRootMtr(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery("+xmsgkey : " + Common.nvl(param.get("xrootmtr")));
		sq.setStart(0);
		sq.setRows(1);
		sq.setFields("msgid", "body_size");

		SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, solrVo.getEmass());
	}

	@RequestMapping(value = "/getList.xcn")
	@Description("EDC Solr 메시지 검색")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getList(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);

		JSONObject data = Common.toJSONObject(param.get("data"));
		String pageType = Common.nvl(param.get("pageType"));



		if(Common.isNotEmpty(data.get("folderSeq"))) {
			String folder_seq = Common.nvl(data.get("folderSeq"));
			//String folder_name = Common.nvl(data.get("folderName"));
			int offset = Common.nvz(param.get("offset"), 0);
			int limit = Common.nvz(param.get("limit"), 0);
			AdminFolderMessageVO msg = new AdminFolderMessageVO();
			msg.setFolderSeq(folder_seq);
			msg.setOffset(offset);
			msg.setLimit(limit);
			SolrEdcMessageVO rtnSolrVo = new SolrEdcMessageVO();
			List<SolrEdcVO> emass = new ArrayList<>();

			int queryBreak = 1000;
			int total = adminFolderService.getUserFolderMessageTotal(msg);
			List<AdminFolderMessageVO> msgs = adminFolderService.getUserFolderMessage(msg);

			JSONArray conditions = Common.toJSONArray(data.get("conditions"));
			String sort = Common.nvl(conditions.getJSONObject(0).get("sort"));

			String svc1 = Common.nvl(conditions.getJSONObject(0).get("svc1")); //서비스 그룹
			String svc1_not = Common.nvl(conditions.getJSONObject(0).get("svc1_not")); //서비스 제외 그룹


			StringBuffer query = new StringBuffer();
			for( int i=0; i<msgs.size(); i++) {
				AdminFolderMessageVO fmsg = msgs.get(i);
				query.append("("+Common.nvl(fmsg.getMsgId())+")").append(" ");

				if((i % queryBreak == (queryBreak-1) && i>0) || msgs.size() == (i+1)) {

					SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
					solrCreateQuery.setSort(sort).setSvc1(svc1, svc1_not);
					SolrQuery sq = solrCreateQuery.createQuery("+_id : ("+query.toString() + ")");
					sq.setStart(0);
					sq.setRows(queryBreak);
					sq.setSort(SortClause.desc("ctime"));

					SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(session) );
					List<SolrEdcVO> userList = solrVo.getEmass();
					if(userList == null) {

					}else {
						for (int j = 0; j < userList.size(); j++) {
							SolrEdcVO userobj = userList.get(j);
							for (int k = 0; k < msgs.size(); k++) {
								AdminFolderMessageVO usermsgObj = msgs.get(k);
								if( Common.isEmpty(usermsgObj.getConsentNo())) continue;
								if ( Common.isEquals(userobj.getMsgid(), usermsgObj.getMsgId())) {
									userobj.setConsentNo(usermsgObj.getConsentNo());
									userList.set(j, userobj);
									break;
								}
							}
						}
						emass.addAll(userList);
					}
					query = new StringBuffer();
				}


			}

			rtnSolrVo.setEmass(emass);
			rtnSolrVo.setNumFound(emass.size());

			return new XcnResponseVO(XcnRspCode.OK, rtnSolrVo, total);

		}else {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			String adminId = Common.getAdminId(session);
			SolrQuery sq = solrCreateQuery.createQuery(data, Common.getAdminId(session), Common.nvl(data.get("searchTime")));
			sq.setStart(Common.nvz(param.get("offset"), 0));
			sq.setRows(Common.nvz(param.get("limit"), 100));

			if(Common.isEmpty(data.get("searchTime"))) {
				sq.setFacet(true);
				if(Common.isEmpty(pageType) || Common.isEquals(pageType, "M")) sq.addFacetField("svc1");
				else if(Common.isEquals(pageType, "U")) sq.addFacetField("svc12");
				sq.setFacetMinCount(1);
			}
			ConfigAdminVO overlapInfo = configAdminService.getConfAdmin("message.overlap.use", adminId);
			String overlap = (!Common.isEmpty(overlapInfo)) ? overlapInfo.getVal() : "N";

			SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, adminId, solrCreateQuery.getFinalReadYn(), solrCreateQuery.getConsentNo());

			log.info("데이터 중복처리 사용?  : " + overlap);
			if(Common.isEquals(Common.nvl(param.get("overlap")), "Y") && Common.isEquals(overlap, "Y")) {
				solrVo = solrEdcService.setOverlap(solrVo);
			}

			if(Config.getBoolean("consent.menu.enable") && Common.isEquals(Common.nvz(param.get("offset"), 0), 0)) {
				searchLogService.insertSearchLog(param);
			}
			return new XcnResponseVO(XcnRspCode.OK, solrVo, solrVo.getNumFound());
		}
	}

	@RequestMapping(value = "/getListRecommend.xcn")
	@Description("EDC Solr 유사문서 추천 검색")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getListRecommend(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);

		JSONObject data = Common.toJSONObject(param.get("data"));
		String pageType = Common.nvl(param.get("pageType"));
		if(Common.isNotEmpty(data.get("folderSeq"))) {
			String folder_seq = Common.nvl(data.get("folderSeq"));
			//String folder_name = Common.nvl(data.get("folderName"));
			int offset = Common.nvz(param.get("offset"), 0);
			int limit = Common.nvz(param.get("limit"), 0);
			AdminFolderMessageVO msg = new AdminFolderMessageVO();
			msg.setFolderSeq(folder_seq);
			msg.setOffset(offset);
			msg.setLimit(limit);
			SolrEdcMessageVO rtnSolrVo = new SolrEdcMessageVO();
			List<SolrEdcVO> emass = new ArrayList<>();

			int queryBreak = 1000;
			int total = adminFolderService.getUserFolderMessageTotal(msg);
			List<AdminFolderMessageVO> msgs = adminFolderService.getUserFolderMessage(msg);

			JSONArray conditions = Common.toJSONArray(data.get("conditions"));
			String sort = Common.nvl(conditions.getJSONObject(0).get("sort"));

			String svc1 = Common.nvl(conditions.getJSONObject(0).get("svc1")); //서비스 그룹
			String svc1_not = Common.nvl(conditions.getJSONObject(0).get("svc1_not")); //서비스 제외 그룹

			StringBuffer query = new StringBuffer();
			for( int i=0; i<msgs.size(); i++) {
				AdminFolderMessageVO fmsg = msgs.get(i);
				query.append("("+Common.nvl(fmsg.getMsgId())+")").append(" ");

				if((i % queryBreak == (queryBreak-1) && i>0) || msgs.size() == (i+1)) {

					SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
					solrCreateQuery.setSort(sort).setSvc1(svc1, svc1_not);
					SolrQuery sq = solrCreateQuery.createQuery("+_id : ("+query.toString() + ")");
					sq.setStart(0);
					sq.setRows(queryBreak);
					sq.setSort(SortClause.desc("ctime"));

					SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(session) );
					List<SolrEdcVO> userList = solrVo.getEmass();
					if(userList == null) {

					}else {
						for (int j = 0; j < userList.size(); j++) {
							SolrEdcVO userobj = userList.get(j);
							for (int k = 0; k < msgs.size(); k++) {
								AdminFolderMessageVO usermsgObj = msgs.get(k);
								if( Common.isEmpty(usermsgObj.getConsentNo())) continue;
								if ( Common.isEquals(userobj.getMsgid(), usermsgObj.getMsgId())) {
									userobj.setConsentNo(usermsgObj.getConsentNo());
									userList.set(j, userobj);
									break;
								}
							}
						}
						emass.addAll(userList);
					}
					query = new StringBuffer();
				}


			}

			rtnSolrVo.setEmass(emass);
			rtnSolrVo.setNumFound(emass.size());

			return new XcnResponseVO(XcnRspCode.OK, rtnSolrVo, total);



		}else {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			SolrQuery sq = solrCreateQuery.createQuery(data, Common.getAdminId(session), Common.nvl(data.get("searchTime")));
			sq.setStart(Common.nvz(param.get("offset"), 0));
			sq.setRows(Common.nvz(param.get("limit"), 100));

			if(Common.isEmpty(data.get("searchTime"))) {
				sq.setFacet(true);
				if(Common.isEmpty(pageType) || Common.isEquals(pageType, "M")) sq.addFacetField("svc1");
				else if(Common.isEquals(pageType, "U")) sq.addFacetField("svc12");
				sq.setFacetMinCount(1);
			}

			SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(session), solrCreateQuery.getFinalReadYn(), solrCreateQuery.getConsentNo());

			if(Config.getBoolean("consent.menu.enable") && Common.isEquals(Common.nvz(param.get("offset"), 0), 0)) {
				searchLogService.insertSearchLog(param);
			}

			return new XcnResponseVO(XcnRspCode.OK, solrVo, solrVo.getNumFound());
		}
	}



	@RequestMapping(value = "/getSolrHighlightStr.xcn")
	@Description("solr 하일라이팅 검색어 생성")
	@ResponseBody
	public XcnResponseVO getSolrHighlightStr(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		Map<String,String> map = new HashMap<>();
		map.put("val", getSolrHighlightStr(param.getString("val")));
		return new XcnResponseVO(XcnRspCode.OK, map);
	}

	public String getSolrHighlightStr(String val) {
		if(val == null) return "";
		return Common.keyValue(val, "");

	}

	@RequestMapping(value = "/getQuery.xcn")
	@Description("EDC Solr 메시지 검색")
	@ResponseBody
	public XcnResponseVO getQuery(final HttpServletRequest request, final HttpSession session) throws Exception {
		JSONObject param = Common.getParam(request);
		SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
		SolrQuery sq = solrCreateQuery.createQuery(Common.toJSONObject(param.get("data")), Common.getAdminId(session));
		return new XcnResponseVO(XcnRspCode.OK, sq.getQuery());
	}
}
