/***
 *
 * 삭제 예정
 *
 */
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
import com.xcurenet.emass.service.service.ServiceTypeVO;
import com.xcurenet.emass.statistics.service.CheckedReadStatService;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.FacetField.Count;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Description;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Controller
@AuditParentMenu(ParentMenu.DATA_ANALYSIS)
@AuditMenu(Menu.STAT_USER)
public class SolrEdcStatController {

    private final static String CHECKED_QUERY = "+{!join from=msgid fromIndex=checked to=msgid}id:%s ";

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
        String query = "";
        int rowKeyCnt = rowKey.length();

        SolrQuery sq = new SolrQuery();

        if(!interGroup.equals("")) {
            SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
            solrCreateQuery.setInterestUserGroup(interGroup, "N");
            sq = solrCreateQuery.setQuery();
            query = sq.getQuery();
        }

        if(!serviceTypes.equals("")) {
            SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
            solrCreateQuery.setService12(serviceTypes.replaceAll("\\|", ","));
            sq = solrCreateQuery.setQuery();
            query = sq.getQuery();
        }

        if(!attachTypes.equals("")) {
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

        if(yAxis.equals("svc12")) {
            if(!rowKey.equals("")) {
                query += " +svc12:"+rowKey;
                yAxis = "svc";
            }
        }else if(yAxis.equals("ml_confd_class")) {
            if(!rowKey.equals("")) {
                if(rowKeyCnt!= 3) {
                    query += " +"+yAxis+":"+"\""+rowKey+"\" " ;
                    yAxis = "svc12";
                }else {
                    query += " +"+yAxis+":"+"\""+colRowKey+"\" ";
                    query += " +svc12:"+rowKey;
                    yAxis = "svc";
                }
            }
        }else if(yAxis.equals("ocr_attach_cnt")) {
            query += " +(attachtype:(tiff tif png gif bmp jpg jpeg pcx dcx jb2 jfif jp2 jpc j2k pdf) attachspace:BODY)";
            if(colRowKey.equals("noOCR")) {
                query += " -"+yAxis+":[1 TO *]";
                if(rowKeyCnt == 3) {
                    query += " +svc12:"+rowKey;
                    yAxis = "svc";
                }else {
                    yAxis ="svc12";
                }
            }else if(colRowKey.equals("detectOCR")) {
                query += " +"+yAxis+":[1 TO *]" ;
                if(rowKeyCnt == 3) {
                    query += " +svc12:"+rowKey;
                    yAxis = "svc";
                }else {
                    yAxis ="svc12";
                }
            }else if(colRowKey.equals("totalOCR")){
                if(rowKeyCnt == 3) {
                    query += " +svc12:"+rowKey;
                    yAxis = "svc";
                }else {
                    yAxis ="svc12";
                }
            }

        }else {
            query += " +"+ yAxis+":*";
        }

        if(!colKey.equals("")) {
            query += " +"+xAxis+":"+"\""+colKey+"\" ";
        }

        if(Common.isNotEmpty(detailQuery)) {
            query += " " + detailQuery;
        }

        query += String.format(" +ctime:[%s TO %s]", startDate, endDate);

        sq.setQuery(query);
        sq.setStart(0);
        sq.setRows(0);
//		sq.addFacetField(yAxis);
        sq.setFacet(true);
//		sq.setFacetLimit(limit);
        sq.setFacetMinCount(1);
        sq.setFacetSort("count");
        if(!(yAxis.equals("") && xAxis.equals(""))) {
            sq.setParam("facet.pivot", yAxis+","+xAxis);
            sq.setParam("f."+yAxis+".facet.limit", Integer.toString(limit));
            sq.setParam("f."+xAxis+".facet.limit", "-1");
        }
        SolrEdcMessageVO solrStatVo = new SolrEdcMessageVO();

        if(yAxis.equals("ml_confd_class") && rowKey.equals("")) solrStatVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request));
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
        String nameStat=Common.nvl(request.getParameter("nameStat"));
        String query = "";

        SolrQuery sq = new SolrQuery();
        int cnt = rowKey.length();

        if(!interGroup.equals("")) {
            SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
            solrCreateQuery.setInterestUserGroup(interGroup, "N");
            sq = solrCreateQuery.setQuery();
            query = sq.getQuery();
        }

        if(!serviceTypes.equals("")) {
            SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
            solrCreateQuery.setService12(serviceTypes.replaceAll("\\|", ","));
            sq = solrCreateQuery.setQuery();
            query = sq.getQuery();
        }

        if(!attachTypes.equals("")) {
            SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
            solrCreateQuery.setAttach("Y", attachTypes);
            sq = solrCreateQuery.setQuery();
            query = sq.getQuery();
        }

        if(!(startDate.equals("") && endDate.equals(""))) {
            query += " +ctime:["+startDate+" TO "+endDate+"] ";
        }

        if(cnt== 4 && yAxis.equals("svc12")) {
            yAxis ="svc";
        }

        if(yAxis.equals("ml_confd_class") ) {
            query += " +"+yAxis+":"+"\""+colRowKey+"\" ";
            yAxis ="svc";
        }

        if(Common.isNotEmpty(detailQuery)) {
            query += detailQuery + " ";
        }
        if(colRowKey.length() == 3 && yAxis.equals("svc12")) {
            yAxis ="svc";
        }
        String Yflag ="Y";
        if(!rowKey.equals("")) {
            String[] t = rowKey.split(",");
            if(t.length > 0) {
                String values = "";
                for(String value : t) {
                    if(value.length() == 3 && nameStat.isEmpty() ) {
                        Yflag="N";
                    }
                    values += "\""+value+"\" ";
                }
                if(Yflag.equals("N")) {
                    yAxis ="svc12";
                }
                query += "+"+yAxis+":"+"("+values+") ";
            }
            else {
                if(rowKey.contains(",")) {
                    rowKey = rowKey.replaceAll("," , "");
                    query += "+"+yAxis+":"+"\""+rowKey.replaceAll("," , "")+"\" ";
                }else {
                    query += "+"+yAxis+":"+rowKey+" ";
                }

            }
        }

        if(!colKey.equals("")) {
            query += "+"+xAxis+":"+"\""+colKey+"\" ";
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
		/*sq.addFacetField(yAxis);
		sq.setFacetLimit(limit);
		sq.setFacetMinCount(1);
		sq.setFacetSort("count");
		if(!(yAxis.equals("") && xAxis.equals(""))) {
			sq.setParam("facet.pivot", yAxis+","+xAxis);
		}*/

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
        query += String.format(CHECKED_QUERY, adminId);
        query += String.format(" +id:%s", adminId);
        query += String.format(" +ctime:[%s TO %s]", startDate, endDate);
        query += " +date_hh:*";

        log.info("query : {}", query);

        sq.setQuery(query);
        sq.setStart(0);
        sq.setRows(0);
        sq.setFacet(true);
        sq.setFacetLimit(limit);
        sq.setFacetMinCount(1);
        sq.setFacetSort("count");
        sq.setParam("facet.pivot", yAxis + "," + xAxis);

        SolrEdcMessageVO solrCheckedStatVo = solrCheckedService.getCheckedStatList(sq);
//		solrCheckedStatVo = setAlltotal(solrCheckedStatVo);
        appendEmassTotal(solrCheckedStatVo, yAxis, Common.getAdminId(request));
        return new XcnResponseVO(XcnRspCode.OK, solrCheckedStatVo, solrCheckedStatVo.getPivotData().size());
    }


    private void appendEmassTotal(SolrEdcMessageVO solrCheckedStatVo, String yAxis, String adminId) throws IOException, SolrServerException {
        List<String> rowKey = new ArrayList<>();
        List<Map<String, Object>> list = solrCheckedStatVo.getPivotData();
        Map<String, Object> totalItem = new HashMap<>();
        long allTotal = 0;
        if (list.size() == 0) return;
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
            for(String header : solrCheckedStatVo.getPivotHeader()) {
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
        String rowKey = Common.nvl(request.getParameter("rowKey")).replaceAll("-", "");
        String colKey = Common.nvl(request.getParameter("colKey")).replaceAll("-", "");
        String startDate =Common.nvl(request.getParameter("startDate"));
        String endDate = Common.nvl(request.getParameter("endDate"));
        int offset = Common.nvz(request.getParameter("offset"));
        int limit = Common.nvz(request.getParameter("limit"));

        String adminId = Common.nvl(request.getParameter("adminId"));
        if (Common.isEmpty(adminId)) adminId = "*";

        StringBuilder solrquery = new StringBuilder();
        solrquery.append(String.format(" +{!join from=msgid fromIndex=checked to=msgid}id:%s ", adminId));
        String[] t = rowKey.split(",");
        if(t.length > 1) {
            String values = "";
            for(String value : t) {
                values += "\""+value.replaceAll("시", "")+"\" ";
            }
            solrquery.append(String.format(" +ctime%s:(%s) ", xAxis, values));
        } else solrquery.append(String.format(" +ctime%s:%s ", xAxis, rowKey.replaceAll("시", "")));

        solrquery.append(String.format(" +ctime:[%s TO %s] ", startDate, endDate));

        if(Common.isNotEmpty(colKey)) {
            solrquery.append(String.format(" +{!join from=msgid fromIndex=checked to=msgid}date%s:%s ", xAxis, colKey));
        }
        solrquery.append(" +{!join from=msgid fromIndex=checked to=msgid}date_hh:* ");

        SolrQuery sq = new SolrQuery();
        sq.setQuery(solrquery.toString());

        sq.setStart(offset);
        sq.setRows(limit);
        sq.setSort("ctime", SolrQuery.ORDER.desc);
//		sq.setFacetLimit(limit);
//		sq.setFacetMinCount(1);
//		sq.setFacetSort("count");

        SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, adminId, "", null);
        return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getNumFound());
    }

    @RequestMapping(value = "/getCheckedReadStatList.xcn")
    @Description("관리자 열람 통계 리스트 조회")
    //@AuditOperation(Operation.SEARCH)
    @ResponseBody
    public XcnResponseVO getCheckedReadStatList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {

        String xAxis = Common.nvl(request.getParameter("xAxis"));
        String startDate = Common.nvl(request.getParameter("startDate"));
        String endDate = Common.nvl(request.getParameter("endDate"));
        return new XcnResponseVO(XcnRspCode.OK, checkedReadStatService.getCheckedReadStatList(xAxis, startDate, endDate, Common.getAdminType(session), Common.getAdminId(session) ));
    }

    @RequestMapping(value = "/getOcrStatList.xcn")
    @Description("OCR 통계 리스트 조회")
    @AuditOperation(Operation.SEARCH)
    @ResponseBody
    public XcnResponseVO getOcrStatList(final HttpServletRequest request, final HttpSession session) throws SolrServerException, IOException {
        String xAxis = Common.nvl(request.getParameter("xAxis"));
        String startDate = Common.nvl(request.getParameter("startDate"));
        String endDate = Common.nvl(request.getParameter("endDate"));
        String detailQuery = Common.nvl(request.getParameter("detailQuery"));
        String rowKey = Common.nvl(request.getParameter("rowKey"));
        int limit = Common.nvz(request.getParameter("limit"));

        SolrEdcMessageVO solrStatVo = getFacetResult(startDate, endDate, detailQuery, xAxis, limit, Common.getAdminId(request), rowKey);
        return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getFacetData().size());
    }

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

        if(!(startDate.equals("") && endDate.equals(""))) {
            query += " +ctime:["+startDate+" TO "+endDate+"] ";
        }

        if(Common.isNotEmpty(detailQuery)) {
            query += " " + detailQuery;
        }

        query += " +(attachtype:(tiff tif png gif bmp jpg jpeg pcx dcx jb2 jfif jp2 jpc j2k pdf) attachspace:BODY) ";

        if(colRowKey.equals("detectOCR")) {
            query += "+ocr_attach_cnt:[1 TO *] ";
        }else if(colRowKey.equals("noOCR")) {
            query += "-ocr_attach_cnt:[1 TO *] ";
        }

//		if(rowKey.contains(",")) {
//			String[] t = rowKey.split(",");
//			if(t.length > 1) {
//				String values = "";
//				for(String value : t) {
//					values += "\""+value+"\" ";
//				}
//				query += "+svc:"+"("+values+") ";
//			}
//			else query += "+svc:"+"\""+rowKey.replaceAll("," , "")+"\" ";
//		} else {
//			query += "+svc:"+"\""+rowKey+"\" ";
//		}

        String Yflag ="Y";
        if(!rowKey.equals("")) {
            String[] t = rowKey.split(",");
            if(t.length > 1) {
                String values = "";
                for(String value : t) {
                    if(value.length() == 3) {
                        Yflag="N";
                    }
                    values += "\""+value+"\" ";
                }
                if(Yflag.equals("N")) {
                    query += "+svc12:"+"("+values+") ";
                } else {
                    query += "+svc:"+"("+values+") ";
                }
            }
            else {
                if(Yflag.equals("N")) {
                    query += "+svc12:"+"\""+rowKey.replaceAll("," , "")+"\" ";
                } else {
                    query += "+svc:"+"\""+rowKey.replaceAll("," , "")+"\" ";
                }
            }
        }

        if(!colKey.equals("")) {
            query += "+"+xAxis+":"+"\""+colKey+"\" ";
        }

        sq.setQuery(query);
        sq.setStart(offset);
        sq.setRows(limit);
        sq.setSort("ctime", SolrQuery.ORDER.desc);

        SolrEdcMessageVO solrStatVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(request), "", null);
        return new XcnResponseVO(XcnRspCode.OK, solrStatVo, solrStatVo.getNumFound());
    }

    private SolrEdcMessageVO getFacetResult( String startDate, String endDate, String detailQuery, String xAxis, int limit, String adminId ,String rowKey) throws SolrServerException, IOException {
        SolrEdcMessageVO ocrFacetVO = new SolrEdcMessageVO();
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        List<String> list = new ArrayList<String>();
        for (int i = 0; i < 3; i++) {
            Map<String, Object> item = new HashMap<String, Object>();
            item = addFacet(i, list, startDate, endDate, detailQuery, xAxis, limit, adminId , rowKey);
            if( item.size() > 0 ) result.add(item);
        }

        Collections.sort(list);
		/*Collections.sort(result, new Comparator<Map<String, Object>>() {
			@Override
			public int compare(Map<String, Object> first, Map<String, Object> second) {
				return ((String) first.get("rowKey")).compareTo((String) second.get("rowKey"));
			}
		});*/

        list = list.stream().distinct().collect(Collectors.toList());
        ocrFacetVO.setFacetHeader(list);
        ocrFacetVO.setFacetData(result);

        return ocrFacetVO;
    }

    private Map<String, Object> addFacet(int flag, List<String> list, String startDate, String endDate, String detailQuery, String xAxis, int limit, String adminId ,String rowKey) throws SolrServerException, IOException {
        String query = "";
        String ocrQuery = "";
        String noOcrQuery = "";

        query += String.format(" +ctime:[%s TO %s]", startDate, endDate);
        query += " +(attachtype:(tiff tif png gif bmp jpg jpeg pcx dcx jb2 jfif jp2 jpc j2k pdf) attachspace:BODY)";

        if(Common.isNotEmpty(detailQuery)) {
            query += " " + detailQuery;
        }

        ocrQuery = query + " +ocr_attach_cnt:[1 TO *]";
        noOcrQuery = query + " -ocr_attach_cnt:[1 TO *]";
        SolrQuery sq = new SolrQuery();


        if(rowKey.equals("")) {
            if ( flag == 0) sq.setQuery(query);
            else if ( flag == 1) sq.setQuery(ocrQuery);
            else if ( flag == 2) sq.setQuery(noOcrQuery);
        }else if(rowKey.equals("noOCR")) {
            sq.setQuery(noOcrQuery);
        }else if(rowKey.equals("detectOCR")) {
            sq.setQuery(ocrQuery);
        }


        sq.setStart(0);
        sq.setRows(0);
        sq.addFacetField(xAxis);
        sq.setFacet(true);
        sq.setFacetLimit(limit);
        sq.setFacetMinCount(1);
        if( !rowKey.equals("")) {
            sq.setParam("facet.pivot", "svc12");
        }

        if( flag != 0 ){
            sq.setParam("facet.pivot", "svc12");
        }

        sq.setFacetSort(xAxis);
        setAuthoritys(sq, adminId);

        QueryResponse resp = solrEdcService.getList(sq);

        List<FacetField> fields = resp.getFacetFields();
        Map<String, Object> item = new HashMap<String, Object>();
        if ( resp.getResults().getNumFound() > 0 ) {
            if (fields != null && fields.size() > 0) {
                FacetField field = fields.get(0);

                List<Count> values = field.getValues();

                if (values != null) {
                    for (Count count : values) {
                        item.put(count.getName(), count.getCount());
                        list.add(count.getName());
                    }
                    item.put("total", resp.getResults().getNumFound());
                    if ( flag == 0) {
                        item.put("rowKey", "totalOCR");
                        item.put("rowName", Prop.propFormat("stat.ocr.target"));
                    }
                    else if ( flag == 1) {
                        item.put("rowKey", "detectOCR");
                        item.put("rowName", Prop.propFormat("stat.ocr.include"));
                    }
                    else if ( flag == 2) {
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

            if(Common.isEquals(adminType, "C")){
                sq.addFilterQuery("+ceo:Y");
            }else if(!(Common.isEquals(ceoReadYn, "Y") && Common.isEquals(Common.nvl(Config.getFirstAdminYn(adminId), "N"), "Y")) ) {
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
                StringBuffer _sb = new StringBuffer();
                if (sq.getFilterQueries() != null) {
                    for (int i = 0; i < sq.getFilterQueries().length; i++) {
                        _sb.append(sq.getFilterQueries()[i]).append(" ");
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

        for(Map<String, Object> datas : resultData) {
            allTotal += Common.nvz(datas.get("total"));

            for(String header : solrEdcVo.getPivotHeader()) {
                totalItem.put(Common.nvl(header), Common.nvz(totalItem.get(header)) + Common.nvz(datas.get(header)));
            }
        }

        totalItem.put("total", allTotal);
        totalItem.put("NUM", Prop.propFormat("bodyview.total"));
        resultData.add(totalItem);
        solrEdcVo.setPivotData(resultData);
        return solrEdcVo;
    }

    public static void main(String[] args) throws SolrServerException, IOException {
        ApplicationContext context = new ClassPathXmlApplicationContext("com/spring/context-*.xml");


        String query = "";
        SolrQuery sq = new SolrQuery();
        query += String.format(CHECKED_QUERY, "sysadmin");
        query += String.format(" +%s:[%s TO %s]", "ctime", "20110108000000", "20190108000000");
        query += "+date_hh:*";

        log.info("query : {}", query);

        sq.setQuery(query);
        sq.setStart(0);
        sq.setRows(0);
        sq.setFacet(true);
        sq.setFacetLimit(500);
        sq.setFacetMinCount(1);
        sq.setFacetSort("count");
        sq.setParam("facet.pivot", "ctime_yyyymmdd" + "," + "date_yyyymmdd");

        SolrCheckedService sc = (SolrCheckedService) context.getBean("solrCheckedService");
        SolrEdcMessageVO solrCheckedStatVo = sc.getCheckedStatList(sq);

        List<String> rowKey = new ArrayList<>();
        List<Map<String, Object>> list = solrCheckedStatVo.getPivotData();
        for (Map<String, Object> item : list) {
            rowKey.add(Common.nvl(item.get("rowKey")));
        }

        String edcQuery = "ctime_yyyymmdd";
        SolrQuery edcSolrQuery = new SolrQuery();
        edcSolrQuery.setQuery(String.format("+%s:(%s)", edcQuery, Common.join(rowKey, " ")));
        edcSolrQuery.setStart(0);
        edcSolrQuery.setRows(0);
        edcSolrQuery.setFacet(true);
        edcSolrQuery.setFacetLimit(500);
        edcSolrQuery.setFacetMinCount(1);
        edcSolrQuery.setFacetSort("count");
        edcSolrQuery.setParam("facet.field", edcQuery);

        SolrEdcService edc = (SolrEdcService) context.getBean("solrEdcService");
        SolrEdcMessageVO edcVo = edc.getEmassMessage(edcSolrQuery, "sysadmin");
        List<Map<String, Object>> edcAll = edcVo.getFacetData();
        for (Map<String, Object> checkedItem : list) {
            String key = Common.nvl(checkedItem.get("rowKey"));
            for (Map<String, Object> edcItem : edcAll) {
                if(edcItem.get(key)==null) continue;
                checkedItem.put("edcTotal", Common.nvn(edcItem.get(key)));
            }
        }



        System.out.println();

        System.out.println(solrCheckedStatVo);

//		Locale locale = Locale.KOREAN;
//		System.out.println(context.getMessage("title.sample.description", new String[] {""}, locale));
//		String message = Prop.propFormat("title.sample.description", locale, "[Message]", "java");
//		System.out.println(message);
//
//		SolrConnection sc = (SolrConnection) context.getBean("emassSolrClient");
//		SolrQuery sq = new SolrQuery();
//		sq.setQuery("svc:*");
//		sq.setRows(55);
//		sq.setFacet(true);
//		sq.setFacetLimit(3);
//		sq.setFacetMinCount(1);
//		sq.setFacetSort("count");
//		sq.setParam("facet.pivot", "srcip,ctime_yyyymmdd");
//		QueryResponse resp = sc.getSolrServer().query(sq, METHOD.POST);
//
//		Map<String, Object> keys = new HashMap<String, Object>();
//		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
//		NamedList<List<PivotField>> facetPivot = resp.getFacetPivot();
//		if (facetPivot != null && facetPivot.size() > 0) {
//			List<PivotField> yFields = facetPivot.getVal(0);
//			for (PivotField yPivotField : yFields) {
//				Map<String, Object> item = new HashMap<String, Object>();
//				item.put("rowKey", yPivotField.getValue());
//				item.put("total", yPivotField.getCount());
//				List<PivotField> xFields = yPivotField.getPivot();
//				for (PivotField xPivotField : xFields) {
//					item.put(Common.nvl(xPivotField.getValue()), xPivotField.getCount());
//					keys.put(Common.nvl(xPivotField.getValue()), 0);
//				}
//				result.add(item);
//			}
//		}
//
//		List<String> list = new ArrayList<String>(keys.keySet());
//		Collections.sort(list);
//		System.out.println(list);
//		System.out.println(result);
//
//		SolrEdcService edc = (SolrEdcService) context.getBean("solrEdcService");
//		SolrEdcMessageVO msg = edc.getEmassMessage(sq, "sysadmin");
//		System.out.println(msg.getNumFound());
//		List<SolrEdcVO> emass = msg.getEmass();
//		for (SolrEdcVO solr : emass) {
//			System.out.println(solr.subject);
//		}

        ((ConfigurableApplicationContext) context).close();
        System.exit(1);
    }
}
