package com.xcurenet.emass.statistics.web;

import com.xcurenet.admin.service.AuthorityService;
import com.xcurenet.admin.service.AuthorityVO;
import com.xcurenet.admin.service.impl.AdminServiceImpl;
import com.xcurenet.annotations.AuditMenu;
import com.xcurenet.annotations.AuditOperation;
import com.xcurenet.annotations.AuditParentMenu;
import com.xcurenet.audit.service.Menu;
import com.xcurenet.audit.service.Operation;
import com.xcurenet.audit.service.ParentMenu;
import com.xcurenet.common.util.Common;
import com.xcurenet.common.util.config.Config;
import com.xcurenet.common.util.locale.Prop;
import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.common.vo.XcnRspCode;
import com.xcurenet.emass.message.component.SolrCreateQuery;
import com.xcurenet.emass.message.service.SolrCheckedService;
import com.xcurenet.emass.message.service.SolrEdcMessageVO;
import com.xcurenet.emass.message.service.SolrEdcService;
import com.xcurenet.emass.message.service.SolrEdcVO;
import com.xcurenet.emass.service.service.ServiceTypeVO;
import com.xcurenet.emass.statistics.service.CheckedReadStatService;
import lombok.extern.log4j.Log4j2;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.data.elasticsearch.core.ElasticsearchAggregations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Log4j2
@Controller
@AuditParentMenu(ParentMenu.DATA_STAT)
@AuditMenu(Menu.STAT_USER)
public class SolrEdcStatController {

//	private final static String CHECKED_QUERY = "+{!join from=msgid fromIndex=checked to=msgid}id:%s ";

	@Resource(name = "solrEdcService")
	private SolrEdcService solrEdcService;

	@Resource(name = "solrCheckedService")
	private SolrCheckedService solrCheckedService;

	@Resource(name = "checkedReadStatService")
	private CheckedReadStatService checkedReadStatService;

	@Resource(name = "authorityService")
	private AuthorityService authorityService;

	@Autowired
	private AdminServiceImpl adminServiceImpl;


	@RequestMapping(value = "/getStatList.xcn")
	@Description("통계 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getStatList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String xAxis = Common.nvl(request.getParameter("xAxis"));
		String yAxis = Common.nvl(request.getParameter("yAxis"));
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		//int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		String interGroup = Common.nvl(request.getParameter("interGroup"));
		String serviceTypes = Common.nvl(request.getParameter("serviceType"));
		String attachTypes = Common.nvl(request.getParameter("attachType"));
		String rowKey = Common.nvl(request.getParameter("rowKey"));
		String colKey = Common.nvl(request.getParameter("colKey"));
		String detailQuery = Common.nvl(request.getParameter("detailQuery"));
		String colRowKey = Common.nvl(request.getParameter("colRowKey"));

		String busi = Common.nvl(request.getParameter("busiStr"));
		String dept = Common.nvl(request.getParameter("deptStr"));
		String name = Common.nvl(request.getParameter("userStr"));

		String query = "";
		int rowKeyCnt = rowKey.length();

		SolrQuery sq = new SolrQuery();
		if (!interGroup.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setInterestUserGroup(interGroup, "N");
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}


		if (!serviceTypes.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setService12(serviceTypes.replaceAll("\\|", ","));
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}

		if (!attachTypes.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setAttach("Y", attachTypes);
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}

		if (Common.isEquals(yAxis, "sender_str")) {
			List<String> codes = new ArrayList<>();
			for (ServiceTypeVO service : Config.sendMailTypes) {
				codes.add(service.getServiceCd());
			}

			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setService(Common.join(codes, ","));
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}

		if (yAxis.equals("svc12")) {
			if (!rowKey.isEmpty()) {
				query += " +svc12:" + rowKey;
				yAxis = "svc";
			}
		} else if (yAxis.equals("ml_confd_class")) {
			if (!rowKey.isEmpty()) {
				if (rowKeyCnt != 3) {
					query += " +" + yAxis + ":" + "\"" + rowKey + "\" ";
					yAxis = "svc12";
				} else {
					query += " +" + yAxis + ":" + "\"" + colRowKey + "\" ";
					query += " +svc12:" + rowKey;
					yAxis = "svc";
				}
			}
		} else if (yAxis.equals("ocr_attach_cnt")) {
			query += "  +(attachtype:((tiff) (tif) (png) (gif) (bmp) (jpg) (jpeg) (pcx) (dcx) (jb2) (jfif) (jp2) (jpc) (j2k) (pdf)) attachspace:BODY)  ";

			if (colRowKey.equals("noOCR")) {
				query += " -" + yAxis + ":[1 TO *]";
				if (rowKeyCnt == 3) {
					query += " +svc12:" + rowKey;
					yAxis = "svc";
				} else {
					yAxis = "svc12";
				}
			} else if (colRowKey.equals("detectOCR")) {
				query += " +" + yAxis + ":[1 TO *]";
				if (rowKeyCnt == 3) {
					query += " +svc12:" + rowKey;
					yAxis = "svc";
				} else {
					yAxis = "svc12";
				}
			} else if (colRowKey.equals("totalOCR")) {
				if (rowKeyCnt == 3) {
					query += " +svc12:" + rowKey;
					yAxis = "svc";
				} else {
					yAxis = "svc12";
				}
			}

		} else {
			query += " +" + yAxis + ":*";
		}

		if (!colKey.isEmpty()) {
			query += " +" + xAxis + ":" + "\"" + colKey + "\" ";
		}

		if (Common.isNotEmpty(detailQuery)) {
			query += " " + detailQuery;
		}

		if (!name.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setName(name);
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}
		if (!busi.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setBusicd(busi);
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}
		if (!dept.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setDeptcd(dept);
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}

		query += String.format(" +ctime:[%s TO %s]", startDate, endDate);

		sq.setQuery(query);
		sq.setStart(0);
		sq.setRows(0);
		sq.setFacet(true);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		if (!(yAxis.isEmpty() && xAxis.equals(""))) {
			sq.setParam("facet.pivot", yAxis + "," + xAxis);
			sq.setParam("f." + yAxis + ".facet.limit", Integer.toString(limit));
			sq.setParam("f." + xAxis + ".facet.limit", "-1");
		}
		SolrEdcMessageVO solrStatVo = new SolrEdcMessageVO();

		if (yAxis.equals("ml_confd_class")) solrStatVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
		else solrStatVo = setAlltotal(solrEdcService.getEmassMessage(sq, Common.getAdminId(request)));
		return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getPivotData().size());
	}

	@RequestMapping(value = "/getStatDetailList.xcn")
	@Description("통계 리스트 상세 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getDetailList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String xAxis = Common.nvl(request.getParameter("xAxis"));
		String yAxis = Common.nvl(request.getParameter("yAxis"));
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String rowKey = Common.nvl(request.getParameter("rowKey"));
		String colKey = Common.nvl(request.getParameter("colKey"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		String interGroup = Common.nvl(request.getParameter("interGroup"));
		String serviceTypes = Common.nvl(request.getParameter("serviceType"));
		String attachTypes = Common.nvl(request.getParameter("attachType"));
		String detailQuery = Common.nvl(request.getParameter("detailQuery"));
		String colRowKey = Common.nvl(request.getParameter("colRowKey"));
		String nameStat = Common.nvl(request.getParameter("nameStat"));
		String query = "";

		SolrQuery sq = new SolrQuery();
		int cnt = rowKey.length();

		if (!interGroup.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setInterestUserGroup(interGroup, "N");
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}

		if (!interGroup.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setInterestUserGroup(interGroup, "N");
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}

		if (!serviceTypes.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setService12(serviceTypes.replaceAll("\\|", ","));
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}

		if (!attachTypes.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setAttach("Y", attachTypes);
			sq = solrCreateQuery.setQuery();
			query = sq.getQuery();
		}

		if (!(startDate.isEmpty() && endDate.isEmpty())) {
			query += " +ctime:[" + startDate + " TO " + endDate + "] ";
		}

		if (cnt == 4 && yAxis.equals("svc12")) {
			yAxis = "svc";
		}

		if (yAxis.equals("ml_confd_class")) {
			query += " +" + yAxis + ":" + "\"" + colRowKey + "\" ";
			yAxis = "svc";
		}

		if (Common.isNotEmpty(detailQuery)) {
			query += detailQuery + " ";
		}
		if (colRowKey.length() == 3 && yAxis.equals("svc12")) {
			yAxis = "svc";
		}
		String Yflag = "Y";
		if (!rowKey.isEmpty()) {
			String[] t = rowKey.split(",");
			if (t.length > 0) {
				String values = "";
				for (String value : t) {
					if (value.length() == 3 && nameStat.isEmpty()) {
						Yflag = "N";
					}
					values += "\"" + value + "\" ";
				}
				if (Yflag.equals("N")) {
					yAxis = "svc12";
				}
				query += "+" + yAxis + ":" + "(" + values + ") ";
			} else {
				if (rowKey.contains(",")) {
					rowKey = rowKey.replaceAll(",", "");
					query += "+" + yAxis + ":" + "\"" + rowKey.replaceAll(",", "") + "\" ";
				} else {
					query += "+" + yAxis + ":" + rowKey + " ";
				}

			}
		}

		if (!colKey.isEmpty()) {
			query += "+" + xAxis + ":" + "\"" + colKey + "\" ";
		}

		if (Common.isEquals(yAxis, "sender_str")) {
			List<String> codes = new ArrayList<>();
			for (ServiceTypeVO service : Config.sendMailTypes) {
				codes.add(service.getServiceCd());
			}

			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setService(Common.join(codes, ","));
			sq = solrCreateQuery.setQuery();
			query += sq.getQuery();
		}

		sq.setQuery(query);
		sq.setStart(offset);
		sq.setRows(limit);
		sq.setSort("ctime", SolrQuery.ORDER.desc);

		SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
		return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getNumFound());
	}

	@RequestMapping(value = "/getCheckedStatList.xcn")
	@Description("관리자 열람 통계 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getCheckedStatList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String xAxis = Common.nvl(request.getParameter("xAxis"));
		String yAxis = Common.nvl(request.getParameter("yAxis"));
		String dateType = Common.nvl(request.getParameter("dateType"));
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String adminId = Common.nvl(request.getParameter("adminId"));
		if (Common.isEmpty(adminId)) adminId = "*";
		int limit = Common.nvz(request.getParameter("limit"));
		String query = "";

		SolrQuery sq = new SolrQuery();

		if (adminId == null) adminId = "*";

		if (Common.isEquals(dateType,"date"))query += String.format(" +checked.readTime:[%s TO %s]", startDate, endDate);
		else query +=String.format(" +ctime:[%s TO %s]", startDate, endDate);
		query += String.format("+checked.readId:%s", adminId);


		log.info("query : {}", query);
		query += " +" + yAxis + ":*";

		sq.setQuery(query);
		sq.setStart(0);
		sq.setRows(0);
		sq.setFacet(true);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");

		sq.setParam("facet.pivot", yAxis + "," + xAxis);
		SolrEdcMessageVO solrCheckedStatVo = solrCheckedService.getCheckedStatList(sq);
			appendEmassTotal(solrCheckedStatVo, yAxis, Common.getAdminId(request));
		return new XcnResponseVO(XcnRspCode.OK, solrCheckedStatVo, solrCheckedStatVo.getPivotData().size());
	}

	private void appendEmassTotal(SolrEdcMessageVO solrCheckedStatVo, String yAxis, String adminId) throws IOException, SolrServerException {
		List<String> rowKey = new ArrayList<>();
		List<Map<String, Object>> list = solrCheckedStatVo.getPivotData();
		Map<String, Object> totalItem = new HashMap<>();
		long allTotal = 0;
		if (list.isEmpty()) return;
		for (Map<String, Object> item : list) {
			rowKey.add(Common.nvl(item.get("rowKey")));
		}

		SolrQuery edcSolrQuery = new SolrQuery();
		edcSolrQuery.setQuery(String.format("+%s:(%s)", yAxis, Common.join(rowKey, " ")));
		edcSolrQuery.setStart(0);
		edcSolrQuery.setRows(0);
		edcSolrQuery.setFacet(true);
		edcSolrQuery.setFacetLimit(500);
		edcSolrQuery.setFacetMinCount(1);
		edcSolrQuery.setFacetSort("count");
		edcSolrQuery.setParam("facet.field", yAxis);

		SolrEdcMessageVO edcVo = solrEdcService.getEmassMessage(edcSolrQuery, adminId);
		List<Map<String, Object>> edcAll = edcVo.getFacetData();
		for (Map<String, Object> checkedItem : list) {
			String key = Common.nvl(checkedItem.get("rowKey"));
			allTotal += Common.nvz(checkedItem.get("total"));
			for (String header : solrCheckedStatVo.getPivotHeader()) {
				totalItem.put(Common.nvl(header), Common.nvz(totalItem.get(header)) + Common.nvz(checkedItem.get(header)));
			}
			for (Map<String, Object> edcItem : edcAll) {
				if (edcItem.get(key) == null) continue;
				checkedItem.put("edcTotal", Common.nvn(edcItem.get(key)));
				totalItem.put("edcTotal", Common.nvz(totalItem.get("edcTotal")) + Common.nvz(checkedItem.get("edcTotal")));
			}
		}
		totalItem.put("total", allTotal);
		totalItem.put("NUM", Prop.propFormat("bodyview.total"));
		list.add(totalItem);
	}


	@RequestMapping(value = "/getStatCheckedDetailList.xcn")
	@Description("관리자 열람 통계 리스트 상세 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getCheckedDetailList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String xAxis = Common.nvl(request.getParameter("xAxis"));
		String yAxis = Common.nvl(request.getParameter("yAxis"));
		String rowKey = Common.nvl(request.getParameter("rowKey")).replaceAll("-", "");
		String colKey = Common.nvl(request.getParameter("colKey")).replaceAll("-", "");
		String startDate = Common.nvl(request.getParameter("startDate"));
		String dateType = Common.nvl(request.getParameter("dateType"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		String query = "";
		int cnt = rowKey.length();

		String adminId = Common.nvl(request.getParameter("adminId"));
		if (Common.isEmpty(adminId)) adminId = "*";

		String Yflag = "Y";
		if (!rowKey.isEmpty()) {
			String[] t = rowKey.split(",");
			if (t.length > 0) {
				String values = "";
				for (String value : t) {

					values += "\"" + value + "\" ";
				}
				if (Yflag.equals("N")) {
					yAxis = "svc12";
				}
				query += "+" + yAxis + ":" + "(" + values + ") ";
			} else {
				if (rowKey.contains(",")) {
					rowKey = rowKey.replaceAll(",", "");
					query += "+" + yAxis + ":" + "\"" + rowKey.replaceAll(",", "") + "\" ";
				} else {
					query += "+" + yAxis + ":" + rowKey + " ";
				}

			}
		}

		if (Common.isEquals(dateType,"date"))query += String.format(" +checked.readTime:[%s TO %s]", startDate, endDate);
		else query +=String.format(" +ctime:[%s TO %s]", startDate, endDate);
		query += String.format("+checked.readId:%s", adminId);

		SolrQuery sq = new SolrQuery();
		sq.setQuery(query);
		sq.setStart(offset);
		sq.setRows(limit);
		sq.setSort("ctime", SolrQuery.ORDER.desc);

		SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
		return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getNumFound());

	}

	@RequestMapping(value = "/getOcrStatList.xcn")
	@Description("OCR 통계 리스트 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getOcrStatList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String xAxis = Common.nvl(request.getParameter("xAxis"));
		String yAxis = Common.nvl(request.getParameter("yAxis"));
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String detailQuery = Common.nvl(request.getParameter("detailQuery"));
		String rowKey = Common.nvl(request.getParameter("rowKey"));
		int limit = Common.nvz(request.getParameter("limit"));
		String busi = Common.nvl(request.getParameter("busiStr"));
		String dept = Common.nvl(request.getParameter("deptStr"));
		String name = Common.nvl(request.getParameter("userStr"));

		SolrQuery sq = new SolrQuery();

		if (!name.isEmpty()|| !name.equals(" ")) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setName(name);
			sq = solrCreateQuery.setQuery();
			detailQuery += sq.getQuery();
		}
		if (!busi.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setBusicd(busi);
			sq = solrCreateQuery.setQuery();
			detailQuery += sq.getQuery();
		}
		if (!dept.isEmpty()) {
			SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
			solrCreateQuery.setDeptcd(dept);
			sq = solrCreateQuery.setQuery();
			detailQuery += sq.getQuery();
		}


		SolrEdcMessageVO solrStatVo = getFacetResult(startDate, endDate, detailQuery, xAxis, limit, Common.getAdminId(request), rowKey);
		return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getFacetData().size());
	}

//	@RequestMapping(value = "/getCheckedReadStatList.xcn")
//	@Description("관리자 열람 통계 리스트 조회")
//	//@AuditOperation(Operation.SEARCH)
//	@ResponseBody
//	public XcnResponseVO getCheckedReadStatList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
//		String xAxis = Common.nvl(request.getParameter("xAxis"));
//		String startDate = Common.nvl(request.getParameter("startDate"));
//		String endDate = Common.nvl(request.getParameter("endDate"));
//		return new XcnResponseVO(XcnRspCode.OK, checkedReadStatService.getCheckedReadStatList(xAxis, startDate, endDate, Common.getAdminType(session), Common.getAdminId(session)));
//	}


	@RequestMapping(value = "/getOcrStatDetailList.xcn")
	@Description("OCR 통계 리스트 상세 조회")
	@AuditOperation(Operation.SEARCH)
	@ResponseBody
	public XcnResponseVO getOcrDetailList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String xAxis = Common.nvl(request.getParameter("xAxis"));
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String rowKey = Common.nvl(request.getParameter("rowKey"));
		String colKey = Common.nvl(request.getParameter("colKey"));
		int offset = Common.nvz(request.getParameter("offset"));
		int limit = Common.nvz(request.getParameter("limit"));
		String colRowKey = Common.nvl(request.getParameter("colRowKey"));
		String detailQuery = Common.nvl(request.getParameter("detailQuery"));
		String query = "";

		SolrQuery sq = new SolrQuery();
		if (!(startDate.isEmpty() && endDate.isEmpty())) {
			query += " +ctime:[" + startDate + " TO " + endDate + "] ";
		}

		if (Common.isNotEmpty(detailQuery)) {
			query += " " + detailQuery;
		}

		query += "  +(attachtype:((tiff) (tif) (png) (gif) (bmp) (jpg) (jpeg) (pcx) (dcx) (jb2) (jfif) (jp2) (jpc) (j2k) (pdf)) attachspace:BODY)  ";
		if (colRowKey.equals("detectOCR")) {
			query += "+ocr_attach_cnt:[1 TO *] ";
		} else if (colRowKey.equals("noOCR")) {
			query += "-ocr_attach_cnt:[1 TO *] ";
		}

		String Yflag = "Y";
		if (!rowKey.isEmpty()) {
			String[] t = rowKey.split(",");
			if (t.length > 1) {
				String values = "";
				for (String value : t) {
					if (value.length() == 3) {
						Yflag = "N";
					}
					values += "\"" + value + "\" ";
				}
				if (Yflag.equals("N")) {
					query += "+svc12:" + "(" + values + ") ";
				} else {
					query += "+svc:" + "(" + values + ") ";
				}
			} else {
				query += "+svc:" + "\"" + rowKey.replaceAll(",", "") + "\" ";
			}
		}

		if (!colKey.isEmpty()) {
			query += "+" + xAxis + ":" + "\"" + colKey + "\" ";
		}

		sq.setQuery(query);
		sq.setStart(offset);
		sq.setRows(limit);
		sq.setSort("ctime", SolrQuery.ORDER.desc);

		SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
		return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getNumFound());
	}

	private SolrEdcMessageVO getFacetResult(String startDate, String endDate, String detailQuery, String xAxis, int limit, String adminId, String rowKey) throws SolrServerException, IOException {
		SolrEdcMessageVO ocrFacetVO = new SolrEdcMessageVO();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < 3; i++) {
			Map<String, Object> item = new HashMap<String, Object>();
			item = addFacet(i, list, startDate, endDate, detailQuery, xAxis, limit, adminId, rowKey);
			if (item != null && !item.isEmpty()) result.add(item);
		}
		Collections.sort(list);

		list = list.stream().distinct().collect(Collectors.toList());
		ocrFacetVO.setFacetHeader(list);
		ocrFacetVO.setFacetData(result);

		return ocrFacetVO;
	}

	private Map<String, Object> addFacet(int flag, List<String> list, String startDate, String endDate, String detailQuery, String xAxis, int limit, String adminId, String rowKey) throws SolrServerException, IOException {
		String query = "";
		String ocrQuery = "";
		String noOcrQuery = "";

		query += String.format(" +ctime:[%s TO %s]", startDate, endDate);
		query += " +(attachtype:((tiff) (tif) (png) (gif) (bmp) (jpg) (jpeg) (pcx) (dcx) (jb2) (jfif) (jp2) (jpc) (j2k) (pdf)) attachspace:BODY)";

		if (Common.isNotEmpty(detailQuery)) {
			query += " " + detailQuery;
		}

		ocrQuery = query + " +ocr_attach_cnt:[1 TO *]";
		noOcrQuery = query + " -ocr_attach_cnt:[1 TO *]";
		SolrQuery sq = new SolrQuery();

		if (rowKey.isEmpty()) {
			if (flag == 0) sq.setQuery(query);
			else if (flag == 1) sq.setQuery(ocrQuery);
			else if (flag == 2) sq.setQuery(noOcrQuery);
		} else if (rowKey.equals("noOCR")) {
			sq.setQuery(noOcrQuery);
		} else if (rowKey.equals("detectOCR")) {
			sq.setQuery(ocrQuery);
		}


		sq.setStart(0);
		sq.setRows(0);
		sq.addFacetField(xAxis);
		sq.setFacet(true);
		sq.setFacetLimit(limit);
		sq.setFacetMinCount(1);
		if (!rowKey.isEmpty()) {
			sq.setParam("facet.pivot", "svc12");
		}

		if (flag != 0) {
			sq.setParam("facet.pivot", "svc12");
		}

		sq.setFacetSort(xAxis);
		setAuthoritys(sq, adminId);

		SearchHits<SolrEdcVO> resp = solrEdcService.getList(sq);
		ElasticsearchAggregations elasticSearchAggregations = (ElasticsearchAggregations) resp.getAggregations();
		//main aggregations key 출력
		Aggregations mainAggregations = elasticSearchAggregations.aggregations();
		Map<String, Aggregation> mainAggsMap = mainAggregations.getAsMap();
		String mainKey = mainAggsMap.keySet().stream().collect(Collectors.joining());

		/* main Aggregations 추출 */
		Terms facetPivot = elasticSearchAggregations.aggregations().get(mainKey);
		List<Terms.Bucket> bucketList = (List<Terms.Bucket>) facetPivot.getBuckets();
		Aggregations subAggs = null;

		if (null != bucketList && bucketList.size() >= 1)
			subAggs = bucketList.get(0).getAggregations(); // sub Aggregations 존재 여부

		Map<String, Object> item = new HashMap();
		Long total = 0L;
		if (null == subAggs || subAggs.asList().size() == 0) {
			for (Terms.Bucket bucket : bucketList) {
				if(bucket.getDocCount() > 0) {
					item.put(bucket.getKeyAsString(), bucket.getDocCount());
					total = total + bucket.getDocCount();
					list.add(bucket.getKeyAsString());


					item.put("total", total);
					if (flag == 0) {
						item.put("rowKey", "totalOCR");
						item.put("rowName", Prop.propFormat("stat.ocr.target"));
					} else if (flag == 1) {
						item.put("rowKey", "detectOCR");
						item.put("rowName", Prop.propFormat("stat.ocr.include"));
					} else if (flag == 2) {
						item.put("rowKey", "noOCR");
						item.put("rowName", Prop.propFormat("stat.ocr.notinclude"));
					}
				}
			}

		}
		return item;
	}



	private void setAuthoritys(SolrQuery sq, String adminId) {
		if (Common.isNotEmpty(adminId)) {
			String adminType = adminServiceImpl.getAdmin(adminId).getAdminType();
			String ceoReadYn = Config.getString("ceo.readyn");

			if (Common.isEquals(adminType, "C")) {
				sq.addFilterQuery("+ceo:Y");
			} else if (!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y"))) {
				sq.addFilterQuery("-ceo:Y");
			}

			sq.addFilterQuery("-svc:QEKH");
			JSONObject param = new JSONObject();
			param.put("adminId", adminId);
			param.put("queryType", Config.getString("query.type", "A"));
			List<AuthorityVO> authoritys = authorityService.getAdminAuthority(param);
			for (AuthorityVO authority : authoritys) {
				if (authority.getCnt() > 0) {
					sq.addFilterQuery(authority.getQuery());
				}
			}
			if (log.isInfoEnabled()) {
				StringBuilder sb = new StringBuilder();
				if (sq.getFilterQueries() != null) {
					for (int i = 0; i < sq.getFilterQueries().length; i++) {
						sb.append(sq.getFilterQueries()[i]).append(" ");
					}
				}
			}
		}
	}

	/*
	 * Pivot Data 합계 구한 후 그 결과를
	 * SolrEdcMessageVO 의 Pivot Data 로 추가
	 */
	private SolrEdcMessageVO setAlltotal(SolrEdcMessageVO solrEdcVo) {
		List<Map<String, Object>> resultData = solrEdcVo.getPivotData();
		Map<String, Object> totalItem = new HashMap<>();
		long allTotal = 0;


		for (Map<String, Object> datas : resultData) {
			allTotal += Common.nvz(datas.get("total"));

			for (String header : solrEdcVo.getPivotHeader()) {
				totalItem.put(Common.nvl(header), Common.nvz(totalItem.get(header)) + Common.nvz(datas.get(header)));
			}
		}
		totalItem.put("total", allTotal);
		totalItem.put("NUM", Prop.propFormat("bodyview.total"));
		resultData.add(totalItem);
		solrEdcVo.setPivotData(resultData);


		return solrEdcVo;

	}

	@RequestMapping(value = "/getInfoStatList.xcn")
	@Description("개인정보 유출 관계 분석 조회")
	@ResponseBody
	@AuditOperation(Operation.SEARCH)
	public XcnResponseVO getInfoStatList(final HttpServletRequest request, final HttpSession session) throws IOException, SolrServerException {
		JSONObject param = Common.getParam(request);
		String startDate = Common.nvl(param.get("startDate"));
		String endDate = Common.nvl(param.get("endDate"));
		int piCount = Common.nvz(param.get("piCount"), 1);
		String busi = Common.nvl(param.get("busiStr"));
		String dept = Common.nvl(param.get("deptStr")).replaceAll("\\|", ",");
		String name = Common.nvl(param.get("userStr")).replaceAll("\\|", ",");

		StringBuilder query = new StringBuilder();
		if (!(startDate.isEmpty() && endDate.isEmpty())) query.append(" +ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");


		if (!name.isEmpty()) {
			String[] nameArray = name.split(",");
			query.append(" +userid:((");

			for (int i = 0; i < nameArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(nameArray[i]);
			}

			query.append("))");
		}

		if (!busi.isEmpty()) {
			String[] busiArray = busi.split(",");
			query.append(" +busicd:((");

			for (int i = 0; i < busiArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(busiArray[i]);
			}

			query.append("))");
		}

		if (!dept.isEmpty()) {
			String[] deptArray = dept.split(",");
			query.append(" +deptcd:((");

			for (int i = 0; i < deptArray.length; i++) {
				if (i > 0) {
					query.append(") (");
				}
				query.append(deptArray[i]);
			}

			query.append("))");
		}

		query.append(" -pi_total:0 ");
		query.append(" +( ");
		for (String field : Config.PRIVATE_SVC) {
			query.append(field).append(":[").append(piCount).append(" TO * ] ");
		}
		query.append(" ) ");

		SolrQuery sq = new SolrQuery();

		sq.setQuery(query.toString());
		sq.setStart(0);
		sq.setRows(0);
		sq.set("aggregation.field", "userkey");
		sq.set("aggregation.sub.fields", Config.PRIVATE_SVC);
		sq.set("aggregation.limit", 100);
		sq.setParam("piAnalysisYn", "Y");

		SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
		List<Map<String, Object>> list = solrVo.getPivotData();

		for (Map<String, Object> item : list) {
			double total = 0;
			for (String field : Config.PRIVATE_SVC) {
				total += Common.nvd(item.get(field));
			}
			item.put("pi_total", total);
		}
		return new XcnResponseVO(XcnRspCode.OK, list);
	}


	@RequestMapping(value = "/getInfoNetwork.xcn")
	@Description("개인정보 유출 관계 분석 관계도 조회")
	@ResponseBody
	public XcnResponseVO getInfoNetwork(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
		String userkey = request.getParameter("userkey");
		String startDate = Common.nvl(request.getParameter("startDate"));
		String endDate = Common.nvl(request.getParameter("endDate"));
		String type = Common.nvl(request.getParameter("type"));
		String piCount = Common.nvl(request.getParameter("piCount"));

		StringBuilder query = new StringBuilder();
		query.append(String.format("+userkey:" + userkey));
		if (!(startDate.isEmpty() && endDate.isEmpty())) {
			query.append(" +ctime:[").append(startDate).append(" TO ").append(endDate).append("] ");
		}
		query.append(" -pi_total:0 ");
		if (Common.isEquals(type, "pi_total")) {
			query.append(" +( ");
			for (String field : Config.PRIVATE_SVC) {
				query.append(field).append(":[").append(piCount).append(" TO * ] ");
			}
			query.append(" ) ");
		} else {
			query.append(" +(").append(type).append(":[").append(piCount).append(" TO *]) ");
		}

		SolrQuery sq = new SolrQuery();
		sq.setQuery(query.toString());
		sq.setStart(0);
		sq.setRows(Common.MAX_VALUE);

		SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
		return new XcnResponseVO(XcnRspCode.OK, solrVo.getEmass(), solrVo.getNumFound());
	}
}
